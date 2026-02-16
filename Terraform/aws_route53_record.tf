resource "aws_route53_record" "frontend" {
  zone_id = "Z081393237R77J11X3BSQ"
  name    = "${var.repo_name}-app.${var.domain}"
  type    = "A"
  ttl     = 300  # Time to live (in seconds)
  records = [aws_instance.web.public_ip] # Replace with the actual CNAME target
}

resource "aws_route53_record" "backend" {
  zone_id = "Z081393237R77J11X3BSQ"
  name    = "${var.repo_name}-backend.${var.domain}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.web.public_ip]
}