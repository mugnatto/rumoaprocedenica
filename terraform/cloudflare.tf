resource "cloudflare_dns_record" "custom_domain" {
  zone_id = var.cloudflare_zone_id
  name    = var.custom_domain
  type    = "CNAME"
  content = aws_s3_bucket_website_configuration.site_config.website_endpoint
  ttl     = 1
  proxied = true
}

output "cloudflare_custom_domain_url" {
  description = "URL do domínio personalizado via Cloudflare"
  value       = "https://${var.custom_domain}"
}
