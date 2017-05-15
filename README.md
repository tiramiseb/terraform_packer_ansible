# Terraform, Packer, ansible, ECS

This repository contains everything about my discovery of these advanced cloud
tools.

## Context

This exercise is motivated by a recruitment test for a startup company.

The idea is to use Terraform, Packer and Ansible to automatically generate a
single Wordpress container on an Amazon ECS cluster, using an RDS database.

I tried to do something simple and avoid fancy stuff. May howtos or docs use
fancy features to show how interesting it is, but my goal is to make something
that "just works".

### Previous knowledge

I hope explanations in this document allow people to understand this stuff
easily, with basic Linux administration knowlege.

As for me, I already knew:

* Wordpress: I know what a server like that one can do
* Amazon Web Services: I already use this easy-to-user service
* Docker: I do not work daily with that, but I already experimented it
* Ansible: I tried in for 2 or 3 months in 2015, abandoned it for SaltStack
  for professional reasons

## Components and their interactions

* *Amazon Web Services* is a public cloud service, run by Amazon.
* *EC2 Compute Cloud* is a virtual server hosting service, based on the
  Xen technology (however, knowing Amazon use Xen is not important).
* *Docker* is a containerization software, allowing to run multiple services
  as separate OSes, reducing incompatibilities risks.
* *ECS*, for *EC2 Container Service*, is a Docker containers service run on top
  of *Elastic Compute Cloud*: EC2 servers management is done by AWS tools,
  without any human intervention.
* *Terraform* is a piece of software that creates infrastructures based on
  configuration files; once given access to a cloud service (or event to local
  services, eg. a VMware infrastructure or a Docker server), it can create
  everything needed to make an infrastructure work.
* *Packer* is a platform-agnostic tool allowing to create system images
  automatically, from a single configuration file.

## How to use this repository

### Prerequisite

Before being able to use this repository content, you need some stuff...

Steps prefixed with "[x]" may be automatically installed with the
`initialize.sh` script, along with some initialization steps (AWS auth, etc).
Stuff installed with this script may then be used after using `source locally`.

* Open an account on Amazon Web Services (https://aws.amazon.com/), create a
  user and activate API access (user management is done with the IAM service)
* [x] Install Terraform (packages are available on
  https://www.terraform.io/downloads.html)
* [x] Install Packer (packages are available on
  https://www.packer.io/downloads.html)
* [x] Create authentication.tf from authentication.tf.sample, with your
  AWS authentication tokens

### See what would be done

You can see what would be done by executing:

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

## Prospective evolutions

XXX (HA/automation/improvement)

## Putting it in production

XXX

## Difficulties and miscellaneous stuff

* Independently of this exercise, I have started it when AWS had a problem with
  new accounts creation: I could not try this stuff at first because I was
  unable to use these tools
* Terraform official documentation is illogical, args description does not
  correspond to the example shown above them: I had to scramble around in order
  to create a working configuration

Time spent (roughly):

2017-05-14: 1h
2017-05-15: 1h
