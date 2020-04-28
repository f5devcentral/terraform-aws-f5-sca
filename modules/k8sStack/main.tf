#/
Need VPC for K8S
Need VPC for Security


/#

/*
#### Deploy Fargate Containers and Service Discovery Service ###################################################################################################################################################################################################
#
#  F5 can control ingress to Faregate services and leverage the DNS Name service to locate the items.  Note you will have to decrease the default time on the NODE (not pool) for DNS discovery to work efficiently.  You will need to use the DNS name 
#  example.my-project.local for your node.
#
################################################################################################################################################################################################################################################################
*/

resource "aws_service_discovery_private_dns_namespace" "example" {
  name        = "example.my-project.local"
  description = "example"
  vpc         = "${aws_vpc.security-test.id}"
}

resource "aws_service_discovery_service" "example" {
  name = "example"

  dns_config {
    namespace_id = "${aws_service_discovery_private_dns_namespace.example.id}"

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_cluster" "example-ecs-cluster" {
  name = "example-ecs-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"

  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.fargate_cpu},
    "image": "${var.app_image}",
    "memory": ${var.fargate_memory},
    "name": "app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port}
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "main" {
  name            = "example-ecs-service"
  cluster         = "${aws_ecs_cluster.example-ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.app_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.demo_tasks.id}"]
    subnets         = ["${aws_subnet.app_subnet_dmz_1_region-az-1.id}", "${aws_subnet.app_subnet_dmz_1_region-az-2.id}"] #Edits required here
  }

  service_registries {
    registry_arn = "${aws_service_discovery_service.example.arn}"
  }
}

