terraform {
  backend "s3" {
    bucket = "tfstatee"
    key    = "terraform.tfstate"
    region = "sa-east-1"
  }
}
