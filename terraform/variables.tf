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

variable "region" {
  description = "Região AWS para o bucket S3"
  type        = string
  default     = "sa-east-1"
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID do domínio"
  type        = string
}

variable "custom_domain" {
  description = "Domínio personalizado para apontar para o S3"
  type        = string
}

variable "cloudflare_api_token" {
  description = "API Token do Cloudflare com permissão para editar DNS"
  type        = string
}
variable "domain" {
  description = "Domínio base (ex: michellemohrer.com)"
  type        = string
}