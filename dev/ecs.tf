# This resource block deploys a VPC in AWS with the mentioned CIDR block
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# This resource block creates a security group within the VPC. It also sets up the ingress and egress rules mentioned in the block 
resource "aws_security_group" "my_webserver" {
  name   = "Dynamic Security Group"
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Dynamic SecurityGroup"
    Owner = "Admin"
  }
}

data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/amzn2-ami-ecs-hvm-2.0.20181112-x86_64-ebs"
}

resource "aws_instance" "ecs" {
  ami           = var.ami
  instance_type = lookup(var.ec2_size, var.env)
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.my_webserver.id]
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                sudo sysctl -w net.ipv4.conf.all.route_localnet=1
                echo 'ECS_CLUSTER=${aws_ecs_cluster.main.name}' >> /etc/ecs/ecs.config
                EOF

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "staging" ? var.prod_onwer : var.noprod_owner
  }
}


resource "aws_ecs_cluster" "main" {
  name = "example"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = file("task-execution-assume-role.json")
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "task" {
  family                = "example"
  cpu                   = "256"
  memory                = "512"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn         = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = <<DEFINITION
  [
    {
      "name": "web",
      "image": "httpd:2.4",
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ]
    }
  ]
DEFINITION
}

resource "aws_ecs_service" "example" {
 name          = "example"
 cluster   = aws_ecs_cluster.main.id
 launch_type   = "FARGATE"
 desired_count = 1
 platform_version = "1.4.0"

 task_definition  = aws_ecs_task_definition.task.arn

 network_configuration {
   subnets          = [aws_subnet.main.id]
   assign_public_ip = true
   security_groups  = [aws_security_group.my_webserver.id]
 }
  
 depends_on = [
   aws_iam_role_policy_attachment.ecs_task_execution_role_policy 
 ]
}