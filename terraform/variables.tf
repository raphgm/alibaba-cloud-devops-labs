variable "region" {
  description = "Alibaba Cloud region."
  type        = string
  default     = "ap-southeast-1"
}

variable "zone" {
  description = "Availability zone within the region."
  type        = string
  default     = "ap-southeast-1a"
}

variable "environment" {
  description = "Environment name, used as a naming suffix (staging, production)."
  type        = string
  default     = "staging"
}

variable "instance_count" {
  description = "Number of ECS instances behind the SLB."
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "ECS instance type. See the article for the family cheat sheet (g7/c7/r7/i4)."
  type        = string
  default     = "ecs.g7.large"
}
