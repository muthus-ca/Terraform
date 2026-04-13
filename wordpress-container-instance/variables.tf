variable "tenancy_ocid" {
  description = "Tenancy OCID. Used to look up Availability Domains."
  type        = string
}

variable "compartment_ocid" {
  description = "Compartment OCID where all resources will be created."
  type        = string
}

variable "region" {
  description = "OCI region, for example ap-hyderabad-1."
  type        = string
}

variable "availability_domain" {
  description = "Optional AD name. If omitted, the first AD in the region is used."
  type        = string
  default     = null
}

variable "stack_name" {
  description = "Prefix for created resources."
  type        = string
  default     = "wordpress-ci-lb"
}

variable "vcn_cidrs" {
  description = <<EOT
List of VCN CIDR blocks. OCI does not allow a single /12 CIDR for a VCN.
Use one or more CIDR blocks between /16 and /30. Default is 172.16.0.0/16.
EOT
  type        = list(string)
  default     = ["172.16.0.0/16"]

  validation {
    condition = alltrue([
      for cidr in var.vcn_cidrs : tonumber(split("/", cidr)[1]) >= 16 && tonumber(split("/", cidr)[1]) <= 30
    ])
    error_message = "Each OCI VCN CIDR block must be between /16 and /30. A single 172.16.0.0/12 VCN is not valid in OCI."
  }
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR for the OCI Load Balancer."
  type        = string
  default     = "172.16.0.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR for the Container Instance."
  type        = string
  default     = "172.16.1.0/24"
}

variable "container_instance_shape" {
  description = "OCI Container Instance shape."
  type        = string
  default     = "CI.Standard.E4.Flex"
}

variable "container_instance_ocpus" {
  description = "OCPUs for the Container Instance."
  type        = number
  default     = 1
}

variable "container_instance_memory_in_gbs" {
  description = "Memory in GB for the Container Instance."
  type        = number
  default     = 4
}

variable "load_balancer_min_bandwidth_mbps" {
  description = "Minimum bandwidth in Mbps for the flexible OCI Load Balancer."
  type        = number
  default     = 10
}

variable "load_balancer_max_bandwidth_mbps" {
  description = "Maximum bandwidth in Mbps for the flexible OCI Load Balancer."
  type        = number
  default     = 10
}

variable "wordpress_image" {
  description = "Docker image for WordPress."
  type        = string
  default     = "docker.io/library/wordpress:6.9.4-apache"
}

variable "mysql_image" {
  description = "Docker image for MySQL."
  type        = string
  default     = "docker.io/library/mysql:8.0"
}

variable "wordpress_db_name" {
  description = "WordPress database name."
  type        = string
  default     = "wordpress"
}

variable "wordpress_db_user" {
  description = "WordPress database user."
  type        = string
  default     = "wordpress"
}

variable "mysql_password" {
  description = "Password for the WordPress MySQL user. Leave null to auto-generate."
  type        = string
  default     = null
  sensitive   = true
}

variable "mysql_root_password" {
  description = "MySQL root password. Leave null to auto-generate."
  type        = string
  default     = null
  sensitive   = true
}

variable "freeform_tags" {
  description = "Optional freeform tags applied to resources."
  type        = map(string)
  default     = {}
}
