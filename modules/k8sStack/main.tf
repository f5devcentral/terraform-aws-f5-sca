/* ## F5 Networks Secure Cloud Migration and Securty Zone Template for AWS ####################################################################################################################################################################################
Version 1.4
March 2020


This Template is provided as is and without warranty or support.  It is intended for demonstration or reference purposes. While all attempts are made to ensure it functions as desired it is not a supported by F5 Networks.  This template can be used 
to quickly deploy a Security VPC - aka DMZ, in-front of the your application VPC(S).  Additional VPCs can be added to the template by adding CIDR variables, VPC resource blocks, VPC specific route tables 
and TransitGateway edits. Limits to VPCs that can be added are =to the limits of transit gateway.

It is built to run in a region with three zones to use and will place services in 1a and 1c.  Modifications to other zones can be done.

F5 Application Services will be deployed into the security VPC but if one wished they could also be deployed inside of the Application VPCs. 

*/
###############################################################################################################################################################################################################################################################
#### Deploy Fargate Containers and Service Discovery Service ###################################################################################################################################################################################################
#  This stack is for EXAMPLE only and deploys a KNOWN VULNERABLE APPLICATION.  DO NOT USE IN ENVIRONMENTS WHERE SECURITY IS A CONCERN!!!!!!
#  F5 can control ingress to Faregate services and leverage the DNS Name service to locate the items.  Note you will have to decrease the default time on the NODE (not pool) for DNS discovery to work efficiently.  You will need to use the DNS name 
#  juiceshop.my-project.local for your node.
#
#
################################################################################################################################################################################################################################################################


resource "aws_security_group" "demo_tasks" {
  name        = "demo-ecs-tasks"
  description = "allow inbound access to Fargate Instances"
  vpc_id      = "${module.core.container-test.id}"

  ingress {
    protocol    = "tcp"
    from_port   = "${var.app_port}"
    to_port     = "${var.app_port}"
    cidr_blocks = ["${module.core.cidr-1}", "${module.core.cidr-2}", "${module.cidr-3}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_service_discovery_private_dns_namespace" "example" {
  name        = "my-project.local"
  description = "example"
  vpc         = "${module.core.security-vpc}"
}

resource "aws_service_discovery_service" "example" {
  name = "juiceshop"

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
    subnets         = ["${module.core.app_subnet_application_region-az-1}", "${module.core.app_subnet_application_region-az-2}"] #Edits required here
  }

  service_registries {
    registry_arn = "${aws_service_discovery_service.example.arn}"
  }
}

