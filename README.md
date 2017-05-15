# Terraform, Packer, ansible, ECS

This repository contains everything about my discovery of these advanced cloud
tools.

## Context

This exercise is motivated by a recruitment test for a startup company.

The idea is to use Terraform, Packer and Ansible to automatically generate a
single Wordpress container on an Amazon ECS cluster, using an RDS database.

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
* *ECS*, for *EC2 Container Service*, is a Docker containers service run on top
  of *Elastic Compute Cloud*.

## How to use this repository

### Prerequisite

Before being able to use this repository content, you need some stuff...

Steps prefixed with "[x]" may be automatically installed with the
`initialize.sh` script, along with some initialization steps (AWS auth, etc).
Stuff installed with this script may then be used after using `source locally`.

* Open an account on Amazon Web Services (https://aws.amazon.com/)
* [x] Install Terraform (packages are available on
  https://www.terraform.io/downloads.html)
* [x] Install Packer (packages are available on
  https://www.packer.io/downloads.html)
* [x] Create authentication.tf from authentication.tf.sample, with your
  AWS authentication tokens

## Prospective evolutions

XXX (HA/automation/improvement)

## Putting it in production

XXX

## Difficulties and miscellaneous stuff

* Independently of this exercise, I have started it when AWS had a problem with
  new accounts creation: I could not try this stuff at first because I was
  unable to use these tools
