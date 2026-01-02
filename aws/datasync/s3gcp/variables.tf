# Variables for GCP credentials
variable "aws_region" {
  description = "AWS region"
  type        = string
}



variable "hmac_access_id" {
  description = "GCP HMAC access key for authentication"
  type        = string
  sensitive   = true
}

variable "hmac_secret" {
  description = "GCP HMAC secret key for authentication"
  type        = string
  sensitive   = true
}

variable "s3_dest_bucket" {
  description = "s3 destination bucket for transferring data from GCP"
  type        = string
}

variable "s3_source_bucket" {
  description = "s3 source bucket for transferring data to GCP"
  type        = string
}

variable "s3_datsync_reports" {
  description = "s3 source bucket for transferring data to GCP"
  type        = string
}

variable "gcp_source_bucket" {
  description = "GCP source bucket for transferring data to AWS"
  type        = string
}

variable "gcp_dest_bucket" {
  description = "GCP dest bucket for transferring data from AWS"
  type        = string
}

variable "datasync_ami_id" {
  description = "ami-id-for-datasync"
  type        = string
}


variable "agent_arn" {
  description = "agent arn"
  type        = string
}


variable "datasync_agent_size" {
  description = "size of datasync_agent"
  type        = string
}

variable "schedule_expression" {
  description = "schedule expression"
  type        = string
}

variable "use_datasync_schedule" {
  description = "Whether to use schedule-based execution or manual trigger"
  type        = bool
}

variable "tags" {
  description = "tags"
  type        = map(string)
}


variable "datasync_task_options" {
  type = object({
    verify_mode            = string
    preserve_deleted_files = string
    task_queueing          = string
    log_level              = string
    transfer_mode          = string
  })
  default = {
    verify_mode            = "ONLY_FILES_TRANSFERRED"
    preserve_deleted_files = "REMOVE"
    task_queueing          = "ENABLED"
    log_level              = "BASIC"
    transfer_mode          = "CHANGED"
  }
}


variable "datasync_role_name" {
  description = "role name for datasync s3"
  type        = string
}


variable "datasync_ec2_profile" {
  description = "datsync profile ec2"
  type        = string
}

variable "workload_subnet_ids" {
  description = "workload subnet ids"
  type        = list(string)
}


variable "endpoint_subnet_ids" {
  description = "endpoint subnet ids"
  type        = list(string)
}


variable "endpoint_security_group_arn" {
  description = "datasync security group arn"
  type        = string
  }

variable "endpoint_security_group_id" {
  description = "datasync security group id"
  type        = string
  }

variable "source_s3_bucket_arn" {
  description = "source s3 bucket arn"
  type        = string
  }

variable "destination_s3_bucket_arn" {
  description = "dest s3 bucket arn"
  type        = string
  }

variable "report_s3_bucket_arn" {
  description = "report s3 bucket arn"
  type        = string
  }



variable "s3_source_object_prefix" {
  description = "subdir of object in s3 source bucket"
  type        = string
  default  = "/"
  }

  

variable "s3_dest_object_prefix" {
  description =  "subdir of object in s3 dest bucket"
  type        = string
  default  = "/"
  }

  
variable "gcp_dest_object_prefix" {
  description =  "subdir of object in gcp dest bucket"
  type        = string
  default  = "/"
  }

  
variable "gcp_source_object_prefix" {
  description =  "subdir of object in gcp source bucket"
  type        = string
  default  = "/"
  }
