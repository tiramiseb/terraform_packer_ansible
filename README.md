# Terraform, Packer, ansible, ECS

This repository contains everything about my discovery of these advanced cloud
tools.

## Context

This exercise is motivated by a recruitment test for a startup company.

The idea is to use Terraform, Packer and Ansible to automatically generate a
single Wordpress container on an Amazon ECS cluster, using an RDS database.

## Components and their interactions

* *Amazon Web Services* is a public cloud service, run by Amazon.
* *EC2 Compute Cloud* is a virtual server hosting service, based on the
  Xen technology (however, knowing Amazon use Xen is not important).
* *ECS*, for *EC2 Container Service*, is a Docler containers service run on top
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

XXX
