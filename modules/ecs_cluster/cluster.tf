resource "aws_kms_key" "cw_key" {
  count = var.cw_key ? 1 : 0
  description             = "clouad watch kmw key"
  deletion_window_in_days = var.kms_deletion_window_in_days
}

resource "aws_cloudwatch_log_group" "group" {
  count = var.cw_group_name != null ? 1 : 0
  name = var.cw_group_name
}

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
  capacity_providers = var.capacity_providers

  configuration {
    execute_command_configuration {
      kms_key_id = var.cw_key ? aws_kms_key.cw_key[0].arn : null
      logging    = var.cw_group_name != null ? var.cw_logging_behavior : null

      log_configuration {
        cloud_watch_encryption_enabled = var.cw_group_name != null ? var.cloud_watch_encryption_enabled : null
        cloud_watch_log_group_name     = var.cw_group_name != null ? aws_cloudwatch_log_group.group[0].name : null
      }
    }
  }
}