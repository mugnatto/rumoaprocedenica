variable "AWS_ACCOUNT_ID" {
  description = "AWS Account ID"
  type        = string
}

variable "bucket_name" {
  description = "Nome do bucket S3 para o site estático"
  type        = string
}
variable "sns_email" {
  description = "Email para receber alertas do SNS"
  type        = string
}