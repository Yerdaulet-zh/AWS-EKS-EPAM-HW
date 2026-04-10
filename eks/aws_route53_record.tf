data "aws_elb_hosted_zone_id" "main" {}

resource "aws_route53_record" "todo" {
  zone_id = data.aws_route53_zone.zones["imon.work"].zone_id
  name    = "todo.${data.aws_route53_zone.zones["imon.work"].name}"
  type    = "A"

  allow_overwrite = true

  alias {
    name                   = "a33c2fd21f0e54fa4a54c4a3b327000a-2006863013.eu-central-1.elb.amazonaws.com"
    zone_id                = data.aws_elb_hosted_zone_id.main.id
    evaluate_target_health = true
  }

  set_identifier = "prod-eks-frankfurt"
  weighted_routing_policy {
    weight = 100
  }
}
