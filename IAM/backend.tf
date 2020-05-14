  
terraform {
  required_version = "0.11.14"
  backend "s3" {
    bucket = "tatiana-state-bucket"
    key    = "projects/us-east-1/tools/terraform.tfstate"
    //dynamodb_table = "state_class"
    region = "us-east-1"
  }
}