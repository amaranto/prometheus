variable vpc_id {
  type = string
  default = null
  description = "If vpc id is null it will create a new vpc for the cluster with 2 default public subnets and 2 private subnets" 
}

variable cluster_name {
    type = string
}
variable kms_deletion_window_in_days {
    type = number
    default = 7
}

variable cw_key {
    type = bool
    default = false
}

variable cw_group_name {
  type = string
  default = null
}

variable cw_logging_behavior {
  type = string
  default = "OVERRIDE"
}

variable cloud_watch_encryption_enabled {
  type = bool
  default = false
}

variable capacity_providers {
  type = list(string)
  validation {
      condition = contains( [ for cp in var.capacity_providers : contains(
            [ 
              "FARGATE", 
              "FARGATE_SPOT"
            ], 
            cp
          )],
        false ) == false
      error_message  = "This cluster provider is not supported."
  }
}

variable vpc_cidr {
  type = string
  default = "10.32.0.0/16"
}

variable public_subnets_amount {
  type = number
  default = 2
}

variable private_subnets_amount {
  type = number
  default = 2
}

variable nat_gw_amount {
  type = number
  default = 2
}

variable tags {
  type = map
  default = {}
}