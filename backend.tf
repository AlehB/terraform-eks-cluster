# Creating S3 bucket to store terraform state file
#resource "aws_s3_bucket" "terraform_state" {
#  bucket        = "tfstate-remote-s3"
#  force_destroy = false
#  lifecycle {
#    ignore_changes = [bucket]
#  }
#}

# S3 bucket to store terraform state file. Versioning
#resource "aws_s3_bucket_versioning" "terraform_state" {
#  bucket = aws_s3_bucket.terraform_state.id
#  versioning_configuration {
#    status = "Enabled"
#  }
#}

# S3 bucket to store terraform state file. Encryption
#resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
#  bucket = aws_s3_bucket.terraform_state.bucket
#  rule {
#    apply_server_side_encryption_by_default {
#      sse_algorithm = "AES256"
#    }
#  }
#}

# Creating DynamoDB Table to Lock Terraform State
#resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
#  name = "tfstate-lock-dynamodb"
#  hash_key = "LockID"
#  read_capacity = 20
#  write_capacity = 20
# 
#  attribute {
#    name = "LockID"
#    type = "S"
#  }
#}