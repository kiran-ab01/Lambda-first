# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "basic_lambda_exec_role_01"  # <- Updated name
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}
 
# Attach basic execution policy (CloudWatch logging)
resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
 
# Create a temporary zip file containing Lambda code
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function_payload.zip"
 
  source {
    content  = <<EOF
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Hello from Terraform Lambda!'
    }
EOF
    filename = "lambda_function.py"
  }
}
 
# Lambda Function
resource "aws_lambda_function" "hello" {
  function_name = "basic_hello_lambda_01"  # <- Updated name
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
 
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}
 
 
