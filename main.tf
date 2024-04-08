## IAM role
resource "aws_iam_role" "lambda_role" {
 name               = var.ROLE_NAME
 description        = "Creating the role to execute lambda"
 assume_role_policy = var.ROLE_POLICY
}

## IAM policy
resource "aws_iam_policy" "iam_policy_for_lambda" {
  name         = var.IAM_POLICY_NAME
  path         = "/"
  description  = "AWS IAM Policy for managing aws lambda role"
  policy       = var.IAM_POLICY
}

## Policy Attachment
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.var.ROLE_NAME.name
  policy_arn  = aws_iam_policy.var.IAM_POLICY_NAME.arn
}

## AWS account info
data "aws_caller_identity" "current" {

}

## Lambda cloudwatch permissions
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.cleanup_daily.function_name}"
  principal      = "events.amazonaws.com"
  source_account = "${data.aws_caller_identity.current.account_id}"
  source_arn     = "${aws_cloudwatch_event-rule.daily_rule.arn}"
}

## Create lambda function
resource "aws_lambda_function" "terraform_lambda_func" {
 filename                       = "${path.module}/python/lambda.py.zip"
 function_name                  = "lambda_demo"
 role                           = aws_iam_role.lambda_role.arn
 handler                        = "lambda.lambda_handler"
 runtime                        = var.LAMBDA_RUNTIME
 depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role.aws_cloudwatch_event_rule.aws_cloudwatch_event_target]
 layers                         = [aws_lambda_layer_version.check_status_layer.arn]
}

## Create lambda layer 
resource "aws_lambda_layer_version" "check_status_layer" {
  filename      = "${path.module}/python/check_status_layer.py.zip"
  layer_name    = "check_status_layer"
}

## Cloudwatch event rule
resource "aws_cloudwatch_event_rule" "daily_rule" {
  name                = "Timer for EC2s"
  description         = "Details on the cloudwatch alert expected to trigger lambda"
  schedule_expression = "rate(50 minutes)"
}

## Cloudwatch event trigger target
resource "aws_cloudwatch_event_target" "daily_target" {
  rule  = "${aws_cloudwatch_event_rule.daily_rule.name}"
  arn   = "${aws_lambda_function.daily_rule.arn}"
}

## Generates zip file.
data "archive_file" "zip_the_python_code" {
 type        = "zip"
 source_dir  = var.SOURCE_DIR_NAME
 output_path = var.SOURCE_OUT_NAME
}