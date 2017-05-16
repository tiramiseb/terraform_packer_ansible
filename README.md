# Terraform, Packer, ansible, ECS

This repository contains everything about my discovery of these advanced cloud
tools.

## Context

This exercise is motivated by a recruitment test for a startup company.

The idea is to use Terraform, Packer and Ansible to automatically generate a
single Wordpress container on an Amazon ECS cluster, using an RDS database.

I tried to do something simple and avoid fancy stuff. May howtos or docs use
fancy features to show how interesting it is, but my goal is to make something
that "just works", hence the over-simplification.

### Previous knowledge

I hope explanations in this document allow people to understand this stuff
easily, with basic Linux administration knowlege.

As for me, I already knew:

* Wordpress: I know what it is for... for this exercise, it is not really
  relevant, apart from the fact I know how to install it.
* Amazon Web Services: I already use this easy-to-use service in a professional
  environment.
* Docker: I do not work daily with it, but I already experimented it (I didn't
  like it regarding how I worked at that moment, but it is perfect for the
  needs of automation addressed here).
* Ansible: I tried in for 2 or 3 months in 2015, abandoned it in favor of
  SaltStack for professional reasons (I worked with long-running server, most
  important part was not to define how servers had to be installed but how they
  must be maintained in a correct state, from this point of view SaltStack
  seems better to me; moreover, with more than 50 servers, Ansible is way
  slower than SaltStack, which itself feels too slow in my opinion).

I also knew concepts which are common between tools. Ansible can be compared
to SaltStack, Terraform can be compared to SaltCloud...

## Components and their interactions

### List of components

* *Amazon Web Services* is a public cloud service, run by Amazon.
* *EC2 Compute Cloud* is a virtual server hosting service, based on the
  Xen technology (however, knowing Amazon use Xen is not important).
* *Docker* is a containerization software, allowing to run multiple services
  as separate OSes, reducing incompatibilities risks.
* *ECS*, for *EC2 Container Service*, is a Docker containers service run on top
  of *Elastic Compute Cloud*: EC2 servers management is done by AWS tools,
  without any human intervention.
* *ECR*, for *EC2 Container Repositories*, is a Docker images repository
  managed by AWS.
* *Terraform* is a piece of software that creates infrastructures based on
  configuration files; once given access to a cloud service (or event to local
  services, eg. a VMware infrastructure or a Docker server), it can create
  everything needed to make an infrastructure work.
* *Packer* is a platform-agnostic tool allowing to create system images
  automatically, from a single configuration file.
* *Ansible* is a IT automation tool, allowing to describe in configuration
  files how to install a server.

### How components interact for images preparation

When executing the `packer build` command:

* Packer executes Docker to create an image [builder]
* Packer installs Ansible on the freshly-created image [provisioner]
* Packer executes Ansible with the playbook locally in the image [provisioner]
* Ansible installs Wordpress and everything needed to make it work
* Packer transfers the image in an EC2 Containers Repository [post-processor]

### How components interact for infrastructure deployment

When executing the `terraform apply command`, Terraform creates all resources
described in the `*.tf` files, while taking care of the dependencies between
them:

* the RDS database
* the IAM role ans stuff for the EC2 instance
* the EC2 instance
* the ECS cluster
* the ECS Wordpress task, which points to the previously uploaded image
* the SG to allow access to the servers
* the ECS Wordpress service itself, thus starting a container.

### Files in this repository

* `initialize.sh` is a script making it easier to initialize this project
* `locally` is a file to be sources in order to easily use this project
* `wordpress.packer` is the Packer configuration to create a Docker image for
  the Wordpress server
* `wordpress.playbook` is the Ansible playbook, describing the installation
* `templates` contains configuration files (or templates) used by Ansible
* `wordpress.tf` is the infrastructure definition for Terraform
* `authentication.tf` is the authentication configuration for Terraform

## How to use this repository

### Prerequisite

Before being able to use this repository content, you need some stuff...

Steps prefixed with "!" may be automatically done with the `initialize.sh`
script, along with some initialization steps (AWS auth, etc). This script has
been tested on Ubuntu 17.04 and works only on Debian-based servers (including
Ubuntu), with sudo activated (it must install Docker).

* Open an account on Amazon Web Services (https://aws.amazon.com/), create a
  user and activate API access (user management is done with the IAM service).
* Create an EC2 Container Repository (see the ECS service).
* ! Install Terraform (packages are available on
  https://www.terraform.io/downloads.html).
* ! Install Packer (packages are available on
  https://www.packer.io/downloads.html).
* ! Create authentication.tf from authentication.tf.template, with your
  AWS authentication tokens.
* ! Create locally from locally.template, with your AWS authentication tokens
  and stuff.

After these steps, to use what has been installed, you need to:

```
$ source locally
```

Then, the AWS credentials (and stuff) and the PATH are correctly present in
the environment.

### Check the image preparation

To check Packer is able to generate an image, the needed command is:

```
packer validate wordpress.packer
```

### Generate the image

To generate and upload the Wordpress server image:

```
packer build wordpress.packer
```

### See what would be deployed

You can see what would be deployed by executing:

```
terraform plan
```

However, this command does not check the whole configuration, a plan success
does not mean a deployment will succeed too.

### Deploy the infrastructure

To deploy this configuration, use:

```
terraform apply
```

That's all folks! (and that's why cloud computing and automated deployment is
so great)

### Remove everything

If you want to remove everything created by Terraform, you may use:

```
terraform destroy
```

## Putting it in production

This example shows very simple stuff, insufficient for production usage... The
following basic evolutions could be done:

* Docker usage is really basic, honestly I'm really not satisfied about how I
  have configured it and I would make it again from scratch if I needed to put
  that in production. I would separate this in two containers, one for nginx
  and one for PHP-FPM.
* Use templates instead of copying files, in order to make stuff more generic
  and allow re-using playbooks. Also, split the playbook into roles.
* Do not use a single admin IAM role.
* Improve global security (active users, files authorizations, better password,
  VPC, security groups, etc) - current setup is really not secure and must not
  be used in production.
* Install HTTPS support on the webserver, if it is not run behind a reverse
  proxy.
* Separate the RDS admin authorization from the wordpress DB details.
* Centralize logs (in a syslog server, for instance).
* Install a monitoring solution, in order to check everything is working
  correctly.
* If local files may be modified (eg. media files upload), either use an
  external storage solution (AWS EFS) or provide a way to backup and/or
  synchronize these files.

## Prospective evolutions

There are many ways to improve this stuff:

* First, use ELB for load balancing and therefore high availability.
* Use a Multi-AZ database.
* Use more variables to make more stuff generic.
* Automate the monitoring configuration (either automatic discovery of services
  or definition in Terraform or Packer).
* Rely on Auto Scaling for cluster instances, so that new instances are
  launched whenever it is needed.
* Probably many other possibilities...

Of course, some of these evolutions may be needed when putting in production,
depending on the criticality of the service.

## Difficulties and miscellaneous notes

Independently of this exercise itself, I have started when AWS had a problem
with new accounts creation: I could not try this stuff at first because I was
unable to use these tools. It was fixed a few hours later but that points out
the problems that may occur when relying on a single provider. Moreover, pushes
to ECR were painfully slow: 300kB/s.

The Ansible configuration is inspired from the wordpress-nginx example
(https://github.com/ansible/ansible-examples/tree/master/wordpress-nginx).

The IAM instance role and EC2 stuff has been copied from
https://github.com/hashicorp/terraform/issues/5660.

Of course, while preparing the Ansible configuration, I worked locally and
created a simple Docker image in a tarfile, instead of commiting it and pushing
it to ECR...

The fact that I need to manage the EC2 instance for ECS is disconcerting, I
thought that this part was completely transparent and automatic. It makes ECS
less sexy than I first thought.

I had a hard time finding how to make Packer-generated images use resources
defined later with Terraform. At the end, I decided to use environment
variables so the image can be reused with different databases. Anyway, that's
how Docker is used most of the time...

Time spent from nothing to an existing Terraform+Packer+Ansible+Docker
Wordpress mini-infrastructure (roughly):

* 2017-05-14: 1h
* 2017-05-15: 6h
* 2017-05-16: 5h
