output "rds-endpoint" {
  description = "Plaintext connection host:port pairs"
  value       = "${aws_security_group.kad-rds.id}"
}