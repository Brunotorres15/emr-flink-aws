resource "aws_iam_role" "erm_service_role" {
  name = "${var.project}-emr-service-role-${var.environment}" 
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "elasticmapreduce.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    emr-role = "service role"
  }
}

resource "aws_iam_role_policy_attachment" "emr_service_role_policy" {
  role       = aws_iam_role.erm_service_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}



resource "aws_iam_role" "erm_ec2_service_role" {
  name = "${var.project}-emr-ec2-service-role-${var.environment}" 
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
     ec2-role = "profile role"
  }
}

resource "aws_iam_role_policy_attachment" "emr_ec2_role_policy-attach" {
  role       = aws_iam_role.erm_ec2_service_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}

resource "aws_iam_instance_profile" "emr_ec2_instance_profile" {
  name = "emr_ec2_instance_profile"
  role = aws_iam_role.erm_ec2_service_role.name
}


output "emr_ec2_instance_profile" {
  value = aws_iam_instance_profile.emr_ec2_instance_profile.arn
}