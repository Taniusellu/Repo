terraform {
  backend "s3" {
    bucket = "bucket-virginia"
    key    = "path/to/my/key"
    region = "us-west-2"
  }
}

# asw s3 mb s3://bucket-virginia --region us-east-1 CLI