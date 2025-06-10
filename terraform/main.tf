provider "aws" {
  region = "sa-east-1"
}

terraform {
  backend "s3" {}
}
