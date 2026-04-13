# OCI Terraform stack: WordPress on Container Instance behind OCI Load Balancer

This stack creates:

- A VCN
- One public subnet for an OCI Load Balancer
- One private subnet for an OCI Container Instance
- An Internet Gateway for the public subnet
- A NAT Gateway for the private subnet
- Security lists for the public and private subnets
- One OCI Container Instance with two containers:
  - WordPress
  - MySQL
- One public OCI Load Balancer with the Container Instance private IP as backend
- Outputs for the public WordPress URL and the Load Balancer public IP

## Important note about your requested VCN CIDR

This stack uses `172.16.0.0/16` by default. You can change as per your VCN CIDR range.

## Files

- `versions.tf` - Terraform and provider versions
- `variables.tf` - input variables
- `networking.tf` - VCN, subnets, route tables, gateways, security lists
- `container-instance.tf` - WordPress + MySQL OCI Container Instance
- `load-balancer.tf` - public OCI Load Balancer, backend set, backend, listener
- `outputs.tf` - WordPress URL and IP outputs
- `terraform.tfvars.example` - example variable values

## Prerequisites

- Terraform 1.5+
- OCI credentials configured through the OCI CLI config file or environment variables
- An OCI compartment with permission to create networking, load balancer, and container instance resources

## Deploy

1. Copy the example variables file:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your tenancy, compartment, and region.

3. Initialize and apply:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. After apply completes, get the public endpoint:

   ```bash
   terraform output wordpress_url
   ```

## Notes

- The Container Instance is placed in a **private subnet** and uses the **NAT Gateway** so it can pull `docker.io` images and reach the internet for outbound traffic.
- The OCI Load Balancer is placed in the **public subnet** and forwards HTTP traffic on port 80 to the Container Instance private IP.
- The MySQL container is not exposed publicly. WordPress connects to it on `127.0.0.1:3306` because both containers run in the same Container Instance.
- This is an MVP/demo stack. For production, consider using HTTPS on the Load Balancer, externalizing the database, and adding persistent storage and secrets handling.
