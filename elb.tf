resource "aws_elb" "service" {
  name            = "${var.service_name}"
  subnets         = ["${var.private_subnet_id}"]
  security_groups = ["${aws_security_group.service.id}"]
  internal        = false

  listener {
    instance_port     = "${var.service_port}"
    instance_protocol = "${var.instance_protocol}"
    lb_port           = "${var.service_port}"
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = "${var.service_healthcheck_healthy_threshold}"
    unhealthy_threshold = "${var.service_healthcheck_unhealthy_threshold}"
    timeout             = "${var.service_healthcheck_timeout}"
    target              = "HTTP:${var.service_port}/${var.service_healthcheck}"
    interval            = "${var.service_healthcheck_interval}"
  }

  cross_zone_load_balancing   = "${var.cross_zone_load_balancing}"
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = "${var.connection_draining}"
  connection_draining_timeout = "${var.connection_draining_timeout}"

  tags {
    Name = "${var.service_name}"
  }
}

resource "aws_lb_cookie_stickiness_policy" "cookie_stickness" {
  name                     = "${var.service_name}-cookiestickness"
  load_balancer            = "${aws_elb.service.id}"
  lb_port                  = "${var.service_port}"
  cookie_expiration_period = 600
}
