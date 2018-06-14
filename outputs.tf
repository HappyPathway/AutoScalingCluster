output "elb_security_group" {
  value = "${aws_security_group.elb.id}"
}

output "nodes_security_group" {
  value = "${aws_security_group.service.id}"
}
