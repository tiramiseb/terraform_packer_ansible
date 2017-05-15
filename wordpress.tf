# Wordpress instances Terraform definition

resource "aws_ecs_cluster" "wordpress" {
    name = "wordpress"
}

resource "aws_ecs_task_definition" "wordpress" {
    family = "wordpress"
    container_definitions = <<EOT
        [
            {
                "name": "wordpress",
                "image": "ubuntu:latest",
                "memory": 512,
                "memoryReservation": 128,
                "essential": true
            }
        ] 
EOT
}

resource "aws_ecs_service" "wordpress" {
    name = "wordpress"
    cluster = "wordpress"
    # Revision is automatically generated, so it should be dynamically read
    task_definition = "wordpress:${aws_ecs_task_definition.wordpress.revision}"
}
