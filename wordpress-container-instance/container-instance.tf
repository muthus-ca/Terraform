resource "oci_container_instances_container_instance" "wordpress_ci" {
  availability_domain    = local.ad_name
  compartment_id         = var.compartment_ocid
  display_name           = "${var.stack_name}-ci"
  shape                  = var.container_instance_shape
  container_restart_policy = "ALWAYS"
  freeform_tags          = var.freeform_tags

  shape_config {
    ocpus         = var.container_instance_ocpus
    memory_in_gbs = var.container_instance_memory_in_gbs
  }

  containers {
    display_name = "mysql"
    image_url    = var.mysql_image

    environment_variables = {
      MYSQL_DATABASE      = var.wordpress_db_name
      MYSQL_USER          = var.wordpress_db_user
      MYSQL_PASSWORD      = local.effective_mysql_pw
      MYSQL_ROOT_PASSWORD = local.effective_mysql_root_pw
    }
  }

  containers {
    display_name = "wordpress"
    image_url    = var.wordpress_image

    environment_variables = {
      WORDPRESS_DB_HOST     = "127.0.0.1:3306"
      WORDPRESS_DB_NAME     = var.wordpress_db_name
      WORDPRESS_DB_USER     = var.wordpress_db_user
      WORDPRESS_DB_PASSWORD = local.effective_mysql_pw
    }
  }

  vnics {
    subnet_id             = oci_core_subnet.private.id
    display_name          = "${var.stack_name}-ci-vnic"
    is_public_ip_assigned = false
  }
}

data "oci_core_vnic" "wordpress_ci_vnic" {
  vnic_id = oci_container_instances_container_instance.wordpress_ci.vnics[0].vnic_id
}
