

data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_efs_file_system" "foo_with_lifecyle_policy" {
    count = var.efsToken == null ? 0 : 1
    creation_token = var.efsToken
    availability_zone_name = var.efsAz == null ? data.aws_availability_zones.available_zones.names[0] : var.efsAz
    encrypted = var.efsEncrypted
    kms_key_id = var.efsEncrypted ? var.efsKmsKeyId : null
    performance_mode = var.efsPerformanceMode

    dynamic "lifecycle_policy" {
        for_each = var.fsLifeCycle == null ? [] : [var.fsLifeCycle]
        content {
            transition_to_ia = var.fsLifeCycle
        }
    }
}