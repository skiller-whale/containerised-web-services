#################################
# Exercise 1 - Preparing the VPC
#################################

# This will apply some pre-written terraform to create a correctly configured VPC with public and private subnets.
# The details are out of scope of this exercise.
module "vpc" {
  source = "./vpc"
}

##########################################
# Exercise 2 - Elastic Container Registry
##########################################

# resource "aws_ecr_repository" "whale_repository" {
#   name = "whale"

#   # Ignore: This is just to speed up destruction of the repository for the purposes of these exercises.
#   force_delete = true
# }

############################################
# Exercise 3 - ECS Cluster, Service and Task
############################################

# resource "aws_ecs_cluster" "cluster" {
#   name = "apps"
# }

# resource "aws_cloudwatch_log_group" "whale_logs" {
#   name              = "/fargate/apps/whale" #fargate/cluster_name/service_name
#   retention_in_days = 1 # Lower than you'd have in production
# }

# # Get the current region so we can write logs to it.
# data "aws_region" "current" {}
# resource "aws_ecs_task_definition" "app" {
#   family                   = "whale-app"
#   network_mode             = "awsvpc" # This is the only option if we're using Fargate.
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = 256
#   memory                   = 512
#   execution_role_arn       = aws_iam_role.execution_role.arn

#   container_definitions = jsonencode([
#     {
#       name = "whale",
#       image = aws_ecr_repository.whale_repository.repository_url, # The location of the image we want the container to use.
#       essential = true,
#       portMappings = [
#         {
#           containerPort = 80
#         }
#       ],
#       logConfiguration = {
#         logDriver = "awslogs",
#         options = {
#           awslogs-group = "/fargate/apps/whale",
#           awslogs-region = data.aws_region.current.name,
#           awslogs-stream-prefix = "whale"
#         }
#       }
#     }
#   ])
# }

# resource "aws_ecs_service" "whale_service" {
#   name            = "whale-service"
#   cluster         = aws_ecs_cluster.cluster.id
#   task_definition = aws_ecs_task_definition.app.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     security_groups  = [aws_security_group.ecs_tasks.id]
#     subnets          = module.vpc.public_subnet_ids
#     assign_public_ip = true
#   }

#   # Ignore: These are just to speed up deployment and replacement of new tasks for the purposes of these exercises.
#   deployment_minimum_healthy_percent = 0
#   deployment_maximum_percent         = 200
#   force_new_deployment               = true
# }

# resource "aws_iam_role" "execution_role" {
#   assume_role_policy = jsonencode(
#   {
#       Version = "2012-10-17"
#       Statement = [
#         {
#           Action = "sts:AssumeRole"
#           Effect = "Allow"
#           Principal = {
#             Service = "ecs-tasks.amazonaws.com"
#           }
#         }
#       ]
#     }
#   )

#   managed_policy_arns = [
#     # Grants access to pull images from ECR, and create a log group and write logs to Cloudwatch
#     "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
#   ]
# }

# # We'll get to exactly what this is in the next slide
# resource "aws_security_group" "ecs_tasks" {
#   name        = "tf-ecs-tasks"
#   description = "Configure inbound and outbound network access for the tasks."
#   vpc_id      = module.vpc.vpc_id
# }

##########################################
# Exercise 4 - ECS Security Groups and IAM
##########################################

# # The tasks need access out to the internet so they can pull from the ECR repo.
# resource "aws_vpc_security_group_egress_rule" "ecs_tasks" {
#   # The security group we attach the rule to
#   security_group_id = aws_security_group.ecs_tasks.id

#   ip_protocol      = -1 # All protocols and port ranges
#   cidr_ipv4      = "0.0.0.0/0"
# }

# # You want access in to the tasks from the internet, so you can use the app.
# resource "aws_vpc_security_group_ingress_rule" "ecs_tasks_http" {
#   security_group_id = aws_security_group.ecs_tasks.id

#   from_port = 80
#   to_port   = 80
#   ip_protocol  = "tcp"

#   # Where you're allowing access from - to start with, we'll allow access from anywhere so you can browse to the service.
#   cidr_ipv4 = "0.0.0.0/0"
# }

#####################################
# Exercise 5 - Elastic Load Balancer
#####################################

# resource "aws_lb" "whale_load_balancer" {
#   name               = "whale-lb"
#   load_balancer_type = "application"
#   subnets            = module.vpc.public_subnet_ids
#   security_groups    = [aws_security_group.load_balancer.id]
# }

# resource "aws_lb_target_group" "whale_target_group" {
#   name     = "whale-tasks-tg"
#   port     = 80
#   protocol = "HTTP"
#   target_type = "ip" # This needs to be IP, not instance, because we're using Fargate.
#   vpc_id   = module.vpc.vpc_id

#   # Ignore: These are just to speed up destruction/update of the target group for the purpose of these exercises.
#   deregistration_delay = 1
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # The listener links the load balancer to the target group.
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.whale_load_balancer.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_lb_target_group.whale_target_group.arn
#     type             = "forward"
#   }
# }

# resource "aws_security_group" "load_balancer" {
#   vpc_id      = module.vpc.vpc_id
# }

# # You want access in to the LB from the internet.
# resource "aws_vpc_security_group_ingress_rule" "lb_http" {
#   security_group_id = aws_security_group.load_balancer.id

#   from_port = 80
#   to_port   = 80
#   ip_protocol  = "tcp"

#   cidr_ipv4 = "0.0.0.0/0"
# }

# # You want access out from the LB to the ECS tasks, so it can forward the traffic to the tasks.
# resource "aws_vpc_security_group_egress_rule" "lb_http" {
#   security_group_id = aws_security_group.load_balancer.id

#   from_port = 80
#   to_port   = 80
#   ip_protocol  = "tcp"

#   referenced_security_group_id = aws_security_group.ecs_tasks.id
# }
