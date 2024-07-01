variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = ""
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "vpc_tags" {
  description = "A map of tags to add to the VPC"
  type        = map(string)
  default     = {}
}

variable "private_subnets" {
  description = "A list of private subnets to create"
  type = list(object({
    availability_zone = string
    cidr_block        = string
  }))
  default = []
}

variable "public_subnets" {
  description = "A list of public subnets to create"
  type = list(object({
    availability_zone = string
    cidr_block        = string
  }))
  default = []
}

variable "private_subnet_tags" {
  description = "Additional tags to add to the private subnets"
  type = map(string)
  default = {}
}

variable "public_subnet_tags" {
  description = "Additional tags to add to the public subnets"
  type = map(string)
  default = {}
}
