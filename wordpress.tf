# Wordpress instances Terraform definition

variable "login_server" {}
variable "repository" {}

resource "aws_ecs_cluster" "wordpress" {
    name = "wordpress"
}

resource "aws_ecs_task_definition" "wordpress" {
    family = "wordpress"
    container_definitions = <<EOT
        [
            {
                "name": "wordpress",
                "image": "${var.login_server}/${var.repository}:0.2",
                "memory": 512,
                "memoryReservation": 128,
                "essential": true,
                "environment": [{
                  "DB_HOST": "${aws_db_instance.wordpress.address}"
                }],
            }
        ] 
EOT
}

resource "aws_ecs_service" "wordpress" {
    name = "wordpress"
    cluster = "wordpress"
    desired_count = 1
    # Revision is automatically generated, so it should be dynamically read
    task_definition = "wordpress:${aws_ecs_task_definition.wordpress.revision}"
}

resource "aws_db_instance" "wordpress" {
  allocated_storage    = 5
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.6.27"
  instance_class       = "db.t2.micro"
  name                 = "wordpress"
  username             = "wordpress"
  password             = "w0rdpr3ss"
  parameter_group_name = "default.mysql5.6"
}
