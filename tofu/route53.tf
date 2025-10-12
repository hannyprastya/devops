# Route53 hosted zone for domain
resource "aws_route53_zone" "primary" {
  name    = var.domain_name
  comment = "Hosted zone for ${var.domain_name}"

  tags = {
    Name = var.domain_name
  }
}

# A record for root domain pointing to CloudFront
resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# AAAA record for IPv6 support
resource "aws_route53_record" "root_ipv6" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# A record for www subdomain
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# AAAA record for www subdomain (IPv6)
resource "aws_route53_record" "www_ipv6" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.${var.domain_name}"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# CAA records for certificate authority authorization
resource "aws_route53_record" "caa" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "CAA"
  ttl     = 300

  records = [
    "0 issue \"amazon.com\"",
    "0 issuewild \"amazon.com\"",
  ]
}

# A record for apps subdomain
resource "aws_route53_record" "apps" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "apps.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = ["16.78.142.92"]
}

# A record for portfolio subdomain
resource "aws_route53_record" "portfolio" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "portfolio.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = ["16.78.142.92"]
}

# A record for api subdomain
resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "api.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = ["16.78.142.92"]
}
