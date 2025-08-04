provider "aws" {
  region  = var.region
  profile = "duckdb"
}

resource "aws_key_pair" "duckdb_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "duckdb_ec2" {
  ami           = "ami-0fbbcfb8985f9a341" # Amazon Linux 2 (eu-west-3)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.duckdb_key.key_name

  user_data = file("/home/lux/DuckDB_aws_project/scripts/install_duckdb.sh")

  tags = {
    Name = "DuckDB-Instance"
  }
}

resource "aws_s3_bucket" "duckdb_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "DuckDB S3 Bucket"
  }
}

resource "aws_s3_object" "csv_file" {
  bucket = aws_s3_bucket.duckdb_bucket.id
  key    = "hw_200.csv"
  source = "../data/hw_200.csv"
  tags = {
    Name = "HW CSV File"
  }
}


resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.duckdb_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.duckdb_bucket.id}/*"
        Principal = "*"
      }
    ]
  })
}


