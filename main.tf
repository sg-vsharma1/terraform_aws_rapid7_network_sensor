provider "aws" {
  region = "us-east-1"
}
resource "aws_iam_role" "lambda_role" {
name   = var.iam_setup["role_name"]
assume_role_policy = <<EOF
{
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
}
EOF
}
resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name         = var.iam_setup["policy_name"]
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
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
EOF
}
 
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}
 
data "archive_file" "zip_the_python_code" {
type         = "zip"
source_file  = "${path.module}/python/hello-python.py"
#source_dir  = "${path.module}/python/"
#output_path = "${path.module}/python/hello-python.zip"
output_path  = "hello-python.zip"
}
 
resource "aws_lambda_function" "terraform_lambda_func" {
filename                       = var.lamda_setup["filename"]
function_name                  = var.lamda_setup["name"]
role                           = aws_iam_role.lambda_role.arn
handler                        = var.lamda_setup["handler_name"]
runtime                        = var.lamda_setup["python"]
timeout                        = var.lamda_setup["timeout"]
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
environment {
    variables = {
      filter_id = var.lamda_setup["filter_id"],
      mirror_target_id = var.lamda_setup["mirror_target_id"],
    }
  }

}
