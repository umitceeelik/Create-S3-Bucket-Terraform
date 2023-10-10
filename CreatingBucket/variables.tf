variable "bucketName_origin" {
  description = "Represents the name of the origin s3 bucket which will create."
  type        = string
  default     = "atlas-prod-cheetos-origin"
}

variable "bucketName_logs" {
  description = "Represents the name of the logs s3 bucket which will create."
  type        = string
  default     = "atlas-prod-cheetos-logs"
}

variable "cloudfront_description" {
  description = "Represents the description of cloudfront distribution which will create."
  type        = string
  default     = "cheetos"
}

# Alternate domain name (CNAME)
variable "cloudfront_domainName" {
  description = "Represents the domain name of cloudfront distribution which will create."
  type        = string
  default     = "cheetos.atlas.space"
}

variable "Route53_domainName" {
  description = "Represents the domain of Route53."
  type        = string
  default     = "cheetos"
}

