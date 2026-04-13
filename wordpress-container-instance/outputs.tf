locals {
  lb_public_ip = [for ip in oci_load_balancer_load_balancer.wordpress_lb.ip_address_details : ip.ip_address if ip.is_public][0]
}

output "wordpress_url" {
  description = "Public URL for the WordPress site through the OCI Load Balancer."
  value       = "http://${local.lb_public_ip}"
}

output "load_balancer_public_ip" {
  description = "Public IP of the OCI Load Balancer."
  value       = local.lb_public_ip
}

output "container_instance_private_ip" {
  description = "Private IP of the Container Instance backend."
  value       = data.oci_core_vnic.wordpress_ci_vnic.private_ip_address
}

output "mysql_password" {
  description = "Generated or provided MySQL application password."
  value       = local.effective_mysql_pw
  sensitive   = true
}

output "mysql_root_password" {
  description = "Generated or provided MySQL root password."
  value       = local.effective_mysql_root_pw
  sensitive   = true
}
