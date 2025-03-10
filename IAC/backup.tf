resource "aws_backup_vault" "backup_vault" {
  name = "app-backup-vault"
  tags = {
    Name = "AppBackupVault"
  }
}

resource "aws_backup_plan" "backup_plan" {
  name = "app-backup-plan"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = "cron(0 5 * * ? *)"  # daily at 5 AM UTC

    lifecycle {
      cold_storage_after = 30
      delete_after       = 90
    }
  }
}

resource "aws_backup_selection" "ec2_backup" {
  name         = "ec2-backup-selection"
  iam_role_arn = aws_iam_role.lambda_exec_role.arn  # alternatively, use a dedicated backup role
  backup_plan_id = aws_backup_plan.backup_plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Name"
    value = "HelloWorldInstance"
  }
}
