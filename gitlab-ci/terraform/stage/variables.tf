variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  default     = "europe-west1"
}
variable zone {
  description = "Zone"
  default     = "europe-west1-d"
}

variable vpc_network_name {
  description = "Network name"
  default     = "default"
}

variable environment {
  description = "Environment name"
  default     = "stage"
}
