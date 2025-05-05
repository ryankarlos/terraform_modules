
data "aws_route53_zone" "selected" {
    name = var.hosted_zone_name
    private_zone =  true
}


resource "aws_route53_record" "alias_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name = "${var.subdomain}.${data.aws_route53_zone.selected.name}"
  type = "A"
  alias  {
    name = var.alias_name
    zone_id = var.alias_zone_id
    evaluate_target_health = true
  }

}