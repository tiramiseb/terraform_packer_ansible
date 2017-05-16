# Wordpress insotances Terraform definition

variable "login_server" {}
variable "repository" {}

# RDS database
resource "aws_db_instance" "wordpress" {
    identifier = "wordpress"
    allocated_storage = 5
    storage_type = "gp2"
    engine = "mysql"
    instance_class = "db.t2.micro"
    name = "wordpress"
    username = "wordpress"
    password = "w0rdpr3ss"
    parameter_group_name = "default.mysql5.6"
}

# IAM stuff to allow an EC2 instance to be part of an ECS cluster
resource "aws_iam_role" "ecs_wordpress" {
    name = "ecs_wordpress"
    assume_role_policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOT
}
resource "aws_iam_role_policy" "ecs_wordpress" { 
  name = "ecs_instance_role"
  role = "${aws_iam_role.ecs_wordpress.id}"
  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:CreateCluster",
                "ecs:DeregisterContainerInstance",
                "ecs:DiscoverPollEndpoint",
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:StartTelemetrySession",
                "ecs:Submit*",
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecs:StartTask"
            ],
            "Resource": "*"
        }
    ]
}
EOT
}
resource "aws_iam_instance_profile" "wordpress" {
  name = "wordpress_profile"
  role = "ecs_wordpress"
}

# EC2 instance used by the cluster
resource "aws_instance" "wordpress_ecs" {
    # ECS-optimized AMI
    ami = "ami-95f8d2f3"
    instance_type = "t2.micro"
    key_name = "deployer"
    iam_instance_profile = "wordpress_profile"
    user_data = <<EOT
#!/bin/bash
echo ECS_CLUSTER="wordpress" >> /etc/ecs/ecs.config
EOT
}

# ECS cluster where tasks will be run
resource "aws_ecs_cluster" "wordpress" {
    name = "wordpress"
}

# ECS wordpress task
resource "aws_ecs_task_definition" "wordpress" {
    family = "wordpress"
    container_definitions = <<EOT
        [
            {
                "name": "wordpress",
                "image": "${var.login_server}/${var.repository}:0.3",
                "memory": 512,
                "memoryReservation": 128,
                "essential": true,
                "portMappings": [
                    {
                        "containerPort": 80,
                        "hostPort": 80
                    }
                ],
                "environment": [{
                  "name": "DB_HOST", "value": "${aws_db_instance.wordpress.address}"
                }]
            }
        ] 
EOT
}

# Allow any connection to the EC2 instance
data "aws_vpc" "default" {
    default = true
}
resource "aws_default_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the ECS service
resource "aws_ecs_service" "wordpress" {
    name = "wordpress"
    cluster = "wordpress"
    desired_count = 1
    # Revision is automatically generated, so it should be dynamically read
    task_definition = "wordpress:${aws_ecs_task_definition.wordpress.revision}"
}
