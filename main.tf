terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.67.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
resource "random_id" "rand_id" {
  byte_length = 8
  }
resource "aws_s3_bucket" "vrushu-project-bucket" {
  bucket = "vrushu-project-bucket-${random_id.rand_id.hex}"
  }
  resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.vrushu-project-bucket.id

  block_public_acls = false
  block_public_policy = false   
  ignore_public_acls = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_policy" "vrushu-project-bucket-policy" {
  bucket = aws_s3_bucket.vrushu-project-bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.vrushu-project-bucket.bucket}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.vrushu-project-bucket.bucket
  source = "./index.html"
  key = "index.html"
  content_type = "text/html"
  
}
resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.vrushu-project-bucket.bucket
  source = "./styles.css"
  key = "styles.css"
  content_type = "text/css"
}
output "name" {
  value = random_id.rand_id.hex
}