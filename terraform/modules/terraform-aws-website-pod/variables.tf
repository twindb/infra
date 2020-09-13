variable "ami" {
  description = "Image for EC2 instances"
}

variable "asg_min_size" {
  description = "Minimum number of instances in ASG"
  default     = 2
  type        = number
}

variable "asg_max_size" {
  description = "Maximum number of instances in ASG"
  default     = 10
  type        = number
}

variable "dns_zone" {
  description = "Domain name zone where the website will be available"
}

# A records in dns_zone
# If the zone is revdb.io and A records ["", "www"] then the module
# will create records (and certificate for):
# - revdb.io
# - www.revdb.io
# If we pass A records as ["something"] then the module
# will create A records:
# - something.revdb.io
variable "dns_a_records" {
  description = "List of A records in the dns_zone that will resolve to ALB dns name. Empty string list element is valid."
  type        = list
  default     = ["", "www"]
}

variable "enable_deletion_protection" {
  description = "Prevent load balancer from destroying"
  default     = true
  type        = bool
}
variable "environment" {
  description = "Name of environment"
  default     = "development"
}

variable "instance_type" {
  description = "EC2 instances type"
  default     = "t2.micro"
}

variable "internet_gateway_id" {
  description = "AWS Internet Gateway must be present. Ensure by passing its id."
}

variable "health_check_type" {
  # Good summary
  # https://stackoverflow.com/questions/42466157/whats-the-difference-between-elb-health-check-and-ec2-health-check
  description = "Type of healthcheck the ASG uses. Can be EC2 or ELB."
  type        = string
  default     = "EC2"
}

variable "root_volume_size" {
  description = "Root volume size in EC2 instance in Gigabytes"
  default     = 30
}
variable "service_name" {
  description = "Descriptive name of a service that will use this VPC"
}

variable "subnets" {
  description = "Subnet ids where load balancer should be present"
  type        = list
}

variable "backend_subnets" {
  description = "Subnet ids where EC2 instances should be present"
  type        = list
}

variable "tags" {
  description = "Tags to apply to each resource"
  default     = {}
}

variable "userdata" {
  description = "userdata for cloud-init to provision EC2 instances"
  default     = "#cloud-config"
}

variable "deployer_key_pair_name" {
  description = "SSH keypair name to be deployed in EC2 instances"
}

variable "issue_certificate" {
  description = "Amazon has a quota on SSL certificted. For sake of testing and not exceeding the quota you can skip issuing a certificate"
  default     = true
  type        = bool
}

variable "secrets_arn_list" {
  description = "List of arm of secrets (SSM) the instances need RO access to"
  type        = list
}

variable "keys_arn_list" {
  description = "List of arm of encryption keys (KSM) the instances need RO access to"
  type        = list
}

variable "s3_bucket_rw_list" {
  description = "List of arm of s3 buckets the instances need RW access to"
  type        = list
}

variable "s3_bucket_ro_list" {
  description = "List of arm of s3 buckets the instances need RO access to"
  type        = list
}

variable "alb_healthcheck_path" {
  description = "Path on the webserver that the elb will check to determine whether the instance is healthy or not"
  default     = "/index.html"
}

variable "alb_healthcheck_port" {
  description = "Port of the webserver that the elb will check to determine whether the instance is healthy or not"
  default     = "80"
}

variable "alb_healthcheck_protocol" {
  description = "Protocol to use with the webserver that the elb will check to determine whether the instance is healthy or not"
  default     = "HTTP"
}

variable "alb_healthcheck_healthy_threshold" {
  description = "Number of times the host have to pass the test to be considered healthy"
  default     = 2
}

variable "alb_healthcheck_uhealthy_threshold" {
  description = "Number of times the host have to pass the test to be considered UNhealthy"
  default     = 2
}

variable "alb_healthcheck_interval" {
  description = "Number of seconds between checks"
  default     = 5
}

variable "alb_healthcheck_timeout" {
  description = "Number of seconds to timeout a check"
  default     = 4
}

variable "alb_healthcheck_response_code_matcher" {
  description = "Range of http return codes that can match"
  default     = "200-299"
}

variable "autoscaling_target_cpu_load" {
  description = "Target CPU load for autoscaling"
  default     = 60
  type        = number
}

variable "wait_for_capacity_timeout" {
  description = "How much time to wait until all instances are healthy"
  default     = "20m"
  type        = string
}

variable "max_instance_lifetime_days" {
  description = "The maximum amount of time, in _days_, that an instance can be in service, values must be either equal to 0 or between 7 and 365 days."
  default     = 30
  type        = number
}
