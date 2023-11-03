variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default     = "trfm-ste-bkt-final1"
}

variable "table_name" {
  description = "The name of the DynamoDB table."
  type        = string
  default     = "terraform-lock1"
}

variable "region" {
    description = "The name of the region where we're working."
    type        = string
    default     = "us-east-1"
}

variable "vpc_id" {
  type = string
}