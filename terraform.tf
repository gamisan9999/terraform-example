terraform {
  backend "s3" {
    bucket = "terraform-demo-380476085523"
    key    = "v1/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
