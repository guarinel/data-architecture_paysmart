# CLUSTER
resource "aws_ecs_cluster" "kad-ecs" {
  name = var.ecs_cluster_name

  lifecycle {
    create_before_destroy = true
  }
}

# INSTANCE PROFILE 
resource "aws_iam_role" "kad-ecs-instance" {
  name               = "${var.ecs_cluster_name}-instance"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "kad-ecs-instance" {
  name   = "${var.ecs_cluster_name}-instance"
  policy = <<EOF
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
        "ecs:StartTask",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ],
      "Resource": "*"
    },
		{
			"Effect": "Allow",
			"Action": [
				"ec2:CreateNetworkInterface",
				"ec2:DescribeNetworkInterfaces",
				"ec2:DetachNetworkInterface",
				"ec2:DeleteNetworkInterface",
				"ec2:AttachNetworkInterface",
				"ec2:DescribeInstances",
				"autoscaling:CompleteLifecycleAction"
			],
			"Resource": "*"
		}
  ]
}
EOF
  role   = aws_iam_role.kad-ecs-instance.id
}

# Instance profile for this role - to be attached to ECS instances
resource "aws_iam_instance_profile" "kad-ecs-instance" {
  name = "${var.ecs_cluster_name}-instance"
  path = "/"
  role = aws_iam_role.kad-ecs-instance.name
}

data "template_file" "kad-ecs" {
  template = <<EOF
#!/bin/bash
cat << EOF_CONFIG > /etc/ecs/ecs.config
ECS_CLUSTER=${var.ecs_cluster_name}
ECS_ENABLE_TASK_IAM_ROLE=true
ECS_ENABLE_TASK_ENI=true
ECS_DISABLE_PRIVILEGED=false
ECS_AWSVPC_BLOCK_IMDS=false
EOF_CONFIG
EOF
}

module "ecs-asg" {
  source        = "silinternational/ecs-asg/aws"
  cluster_name  = var.ecs_cluster_name
  instance_type = var.ecs_instance_type
  ssh_key_name  = var.ecs_key_name

  # Launch configuration
  subnet_ids                  = var.subnet_ids
  user_data                   = data.template_file.kad-ecs.rendered

  security_groups = [
    aws_security_group.kad-ecs.id
  ]

  # Auto scaling group
  health_check_type         = "EC2"
  min_size                  = var.ecs_min_size
  max_size                  = var.ecs_max_size
}
