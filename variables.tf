variable "FILENAME_PATH" {
  description = "Path for the zip file"
  type = string
  default = "${path.module}/src/lambda-layer/lambda_function.zip"
}

variable "ROLE_NAME" {
    description = "Lambda function role name"
    type = string
    default = "terraform_aws_lambda_role"
}

variable "IAM_POLICY_NAME" {
    description = "Name for IAM policy"
    type = string
    default = "aws_iam_policy_for_terraform_aws_lambda_role"
}

variable SOURCE_DIR_NAME {
    description = "Name for source python directory"
    type = string
    default = "${path.module}/python/"
}

variable SOURCE_OUT_NAME {
    description = "Name for output python directory"
    type = string
    default = "${path.module}/python/hello-world.zip"
}

variable LAMBDA_RUNTIME {
    description = "Define runtime"
    type = string
    default = "python3.8"
}
variable "IAM_POLICY" {
    description = "Full policy details for IAM user"
    type = string
    default = "<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF"
}

variable "ROLE_POLICY" {
    description = "Full policy details for the IAM role"
    type = string
    default = "<<EOF
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
EOF"
}