variable "instance_type" {
  description = "Instance types for each instance"
  type        = list(string)
  default     = ["t2.medium", "t2.micro", "t2.micro"]
}

variable "tag_name" {
  description = "Instance types for each instance"
  type        = list(string)
  default     = ["jenkins-master", "jenkins-slave", "ansible"]
}