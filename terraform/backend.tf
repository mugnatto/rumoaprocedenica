provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "= 5.5.0"
    }
  }
  backend "s3" {
    bucket  = "mugnattoworktfstate"
    key     = "rumoaprocedencia/terraform.tfstate"
    region  = "sa-east-1"
    encrypt = true
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
