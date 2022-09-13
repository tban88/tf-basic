######################## TERRAFORM CONFIG ########################

terraform {
  required_version = ">=1.2"
}

######################## PROVIDERS ########################

# Define provided: AWS
provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

resource "aws_iam_policy" "CodeBuild-FullECS" {
  name        = "CodeBuild-FullECS"
  description = "CodeBuild Full ECS Control"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "iam:PassRole",
          "ecs:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "CodeBuildBasePolicy" {
  name        = "CodeBuildBasePolicy"
  description = "CodeBuild Base Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:logs:${var.region}:${var.aws_account}:log-group:/",
          "arn:aws:logs:${var.region}:${var.aws_account}:log-group:/*:*"
        ],
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases"
        ],
        "Resource" : [
          "arn:aws:codebuild:${var.region}:${var.aws_account}:report-group/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "codebuild_base1" {
  name        = "CodeBuildBasePolicy-${var.name}-${var.region}"
  description = "CodeBuild Base Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:logs:${var.region}:${var.aws_account}:log-group:/aws/codebuild/${var.name}",
          "arn:aws:logs:${var.region}:${var.aws_account}:log-group:/aws/codebuild/${var.name}:*"
        ],
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::codepipeline-${var.region}-*"
        ],
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ],
        "Resource" : [
          "arn:aws:codebuild:${var.region}:${var.aws_account}:report-group/${var.name}-*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "codebuild_base2" {
  name        = "CodeBuildCloudWatchLogsPolicy-${var.name}-${var.region}"
  description = "CodeBuildCloudWatchLogsPolicy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:logs:${var.region}:${var.aws_account}:log-group:/aws/codebuild/${var.name}",
          "arn:aws:logs:${var.region}:${var.aws_account}:log-group:/aws/codebuild/${var.name}:*"
        ],
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "read-secret" {
  name        = "SecretManager-Read"
  description = "Read Secrets"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetRandomPassword",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:UntagResource",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds",
          "secretsmanager:ListSecrets",
          "secretsmanager:TagResource"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "ECS_KMS" {
  name = "ECS_KMS"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "kms:DescribeCustomKeyStores",
          "kms:ListKeys",
          "kms:DeleteCustomKeyStore",
          "kms:GenerateRandom",
          "kms:UpdateCustomKeyStore",
          "kms:ListAliases",
          "kms:DisconnectCustomKeyStore",
          "kms:CreateKey",
          "kms:ConnectCustomKeyStore",
          "kms:CreateCustomKeyStore"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : "kms:*",
        "Resource" : [
          "arn:aws:kms:*:${var.aws_account}:key/*",
          "arn:aws:kms:*:${var.aws_account}:alias/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "new_role" {
  name = "codebuild-${var.name}-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ecs-tasks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role" "ecsTaskRole" {
  name = "ecsTaskRole"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ecs-tasks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role-ecsTaskRole1" {
  role       = aws_iam_role.ecsTaskRole.name
  policy_arn = aws_iam_policy.read-secret.arn
}

resource "aws_iam_role_policy_attachment" "role-ecsTaskRole2" {
  role       = aws_iam_role.ecsTaskRole.name
  policy_arn = aws_iam_policy.ECS_KMS.arn
}

resource "aws_iam_role_policy_attachment" "role-ecsTaskRole3" {
  role       = aws_iam_role.ecsTaskRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "role-ecsTaskRole4" {
  role       = aws_iam_role.ecsTaskRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "role-ecsTaskRole5" {
  role       = aws_iam_role.ecsTaskRole.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

resource "aws_iam_role_policy_attachment" "role-ecsTaskRole6" {
  role       = aws_iam_role.ecsTaskRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

resource "aws_iam_role_policy_attachment" "role-ecsTaskExecutionRole1" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = aws_iam_policy.read-secret.arn
}

resource "aws_iam_role_policy_attachment" "role-ecsTaskExecutionRole2" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "role-ecsTaskExecutionRole3" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "role-secret" {
  role       = aws_iam_role.new_role.name
  policy_arn = aws_iam_policy.read-secret.arn
}

resource "aws_iam_role_policy_attachment" "role-attach1" {
  role       = aws_iam_role.new_role.name
  policy_arn = aws_iam_policy.CodeBuild-FullECS.arn
}

resource "aws_iam_role_policy_attachment" "role-attach2" {
  role       = aws_iam_role.new_role.name
  policy_arn = aws_iam_policy.codebuild_base1.arn
}

resource "aws_iam_role_policy_attachment" "role-attach3" {
  role       = aws_iam_role.new_role.name
  policy_arn = aws_iam_policy.codebuild_base2.arn
}

resource "aws_iam_role_policy_attachment" "role-attach4" {
  role       = aws_iam_role.new_role.name
  policy_arn = aws_iam_policy.CodeBuildBasePolicy.arn
}

resource "aws_iam_role_policy_attachment" "role-attach5" {
  role       = aws_iam_role.new_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployDeployerAccess"
}

resource "aws_iam_role_policy_attachment" "role-attach6" {
  role       = aws_iam_role.new_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_cloudwatch_log_group" "prod" {
  name = "/aws/ecs/prod"
}
resource "aws_cloudwatch_log_group" "feature" {
  name = "/aws/ecs/feature"
}

resource "aws_codebuild_project" "new_codebuild" {
  name          = var.name
  description   = "${var.name} project"
  build_timeout = "60"
  service_role  = aws_iam_role.new_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type            = var.source_type
    location        = var.git_repo_url
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "/aws/codebuild/${var.name}"
    }
  }
}