provider "aws" {
  profile = "educate"
  region  = var.region
}


resource "aws_s3_bucket" "backend" {
  bucket = "${var.project}-backend-${var.environment}"
}


resource "aws_s3_bucket_policy" "backend-policy" {
  bucket = aws_s3_bucket.backend.id
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Principal : {
          AWS : "*"
        },
        Effect : "Allow",
        Action : [
          "s3:ListBucket"
        ],
        Resource : aws_s3_bucket.backend.arn
      },
      {
        Principal : {
          AWS : "*"
        },
        Effect : "Allow",
        Action : [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource : "${aws_s3_bucket.backend.arn}/*"
      }
    ]
  })
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
