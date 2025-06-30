# Master node role
resource "aws_iam_role" "k3s_master_role" {
  name = "k3s-master-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "k3s_master_ssm_policy" {
  name        = "k3s-master-ssm-policy"
  description = "Allow master to write node token to SSM"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ssm:PutParameter"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "k3s_master_ssm_attach" {
  role       = aws_iam_role.k3s_master_role.name
  policy_arn = aws_iam_policy.k3s_master_ssm_policy.arn
}

resource "aws_iam_instance_profile" "k3s_master_instance_profile" {
  name = "k3s-master-profile"
  role = aws_iam_role.k3s_master_role.name
}

# Agent node role
resource "aws_iam_role" "k3s_agent_role" {
  name = "k3s-agent-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "k3s_agent_ssm_policy" {
  name        = "k3s-agent-ssm-policy"
  description = "Allow agent to read node token from SSM"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ssm:GetParameter"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "k3s_agent_ssm_attach" {
  role       = aws_iam_role.k3s_agent_role.name
  policy_arn = aws_iam_policy.k3s_agent_ssm_policy.arn
}

resource "aws_iam_instance_profile" "k3s_agent_instance_profile" {
  name = "k3s-agent-profile"
  role = aws_iam_role.k3s_agent_role.name
}