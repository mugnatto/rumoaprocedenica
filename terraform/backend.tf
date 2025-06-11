provider "aws" {
  region = "sa-east-1"
}


terraform {
  backend "s3" {
    bucket = "mugnattoworktfstate"
    key    = "rumoaprocedencia/terraform.tfstate"
    region = "sa-east-1"
    encrypt        = true
  }
}
