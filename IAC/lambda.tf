# Lambda function to stop instances after office hours
resource "aws_lambda_function" "instance_scheduler" {
  filename         = "lambda_function.zip"   # build the zip from lambda_function.py
  function_name    = "InstanceScheduler"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime          = "python3.8"
  
  environment {
    variables = {
      ACTION = "stop"
    }
  }
}

resource "aws_cloudwatch_event_rule" "stop_rule" {
  name                = "StopInstancesSchedule"
  schedule_expression = "cron(0 19 ? * MON-FRI *)"  # e.g., 7:00 PM UTC on weekdays
}

resource "aws_cloudwatch_event_target" "stop_target" {
  rule      = aws_cloudwatch_event_rule.stop_rule.name
  target_id = "LambdaStopInstances"
  arn       = aws_lambda_function.instance_scheduler.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_stop" {
  statement_id  = "AllowExecutionFromCloudWatchStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.instance_scheduler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_rule.arn
}

# Lambda function to start instances in the morning
resource "aws_lambda_function" "instance_scheduler_start" {
  filename         = "lambda_function.zip"
  function_name    = "InstanceSchedulerStart"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime          = "python3.8"
  
  environment {
    variables = {
      ACTION = "start"
    }
  }
}

resource "aws_cloudwatch_event_rule" "start_rule" {
  name                = "StartInstancesSchedule"
  schedule_expression = "cron(0 12 ? * MON-FRI *)"  # e.g., 12:00 PM UTC on weekdays
}

resource "aws_cloudwatch_event_target" "start_target" {
  rule      = aws_cloudwatch_event_rule.start_rule.name
  target_id = "LambdaStartInstances"
  arn       = aws_lambda_function.instance_scheduler_start.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_start" {
  statement_id  = "AllowExecutionFromCloudWatchStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.instance_scheduler_start.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_rule.arn
}
