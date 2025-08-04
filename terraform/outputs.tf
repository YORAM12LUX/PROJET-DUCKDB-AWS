output "ec2_public_ip" {
  value = aws_instance.duckdb_ec2.public_ip
}

output "bucket_name" {
  value = aws_s3_bucket.duckdb_bucket.id
}
