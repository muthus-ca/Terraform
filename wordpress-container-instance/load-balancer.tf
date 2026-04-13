resource "oci_load_balancer_load_balancer" "wordpress_lb" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.stack_name}-lb"
  shape          = "flexible"
  subnet_ids     = [oci_core_subnet.public.id]
  is_private     = false
  freeform_tags  = var.freeform_tags

  shape_details {
    minimum_bandwidth_in_mbps = var.load_balancer_min_bandwidth_mbps
    maximum_bandwidth_in_mbps = var.load_balancer_max_bandwidth_mbps
  }
}

resource "oci_load_balancer_backend_set" "wordpress" {
  load_balancer_id = oci_load_balancer_load_balancer.wordpress_lb.id
  name             = "wordpress-backend-set"
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol = "TCP"
    port     = 80
    retries  = 3
    timeout_in_millis = 3000
    interval_ms       = 10000
  }
}

resource "oci_load_balancer_backend" "wordpress_ci" {
  load_balancer_id = oci_load_balancer_load_balancer.wordpress_lb.id
  backendset_name  = oci_load_balancer_backend_set.wordpress.name
  ip_address       = data.oci_core_vnic.wordpress_ci_vnic.private_ip_address
  port             = 80
  weight           = 1
}

resource "oci_load_balancer_listener" "http" {
  load_balancer_id          = oci_load_balancer_load_balancer.wordpress_lb.id
  name                      = "http"
  default_backend_set_name  = oci_load_balancer_backend_set.wordpress.name
  port                      = 80
  protocol                  = "HTTP"
}
