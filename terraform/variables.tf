variable "AWS_ACCOUNT_ID" {
  description = "AWS Account ID"
  type        = string
}

variable "github_org" {
  description = "GitHub Organization name"
  type        = string
}

variable "github_repo" {
  description = "GitHub Repository name"
  type        = string
}

variable "bucket_name" {
  description = "Nome do bucket S3 para o site estático"
  type        = string
}