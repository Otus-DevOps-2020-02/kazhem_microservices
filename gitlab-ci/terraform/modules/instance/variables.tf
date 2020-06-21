variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable instance_disk_image {
  description = "Instance base disk image"
}

variable vpc_network_name {
  description = "Network name"
  default     = "default"
}

variable environment {
  description = "Environment name"
  default     = "stage"
}

variable machine_type {
  description = "Machine type"
  default     = "g1-small"
}

variable tags {
  description = "Tags list"
  type        = list
  default     = []
}

variable instance_count {
  description = "instances count"
  default     = 1
}

variable name_prefix {
  description = "Name prefix of instance"
  default     = "instance"
}

variable tcp_ports {
  description = "TCP ports list to open list"
  type        = list
  default     = []
}

variable use_static_ip {
  description = "Need to create static ip for instance?"
  default     = false
}

variable public_key_path {
  description = "Public key path"
  default = "~/.ssh/appuser.pub"
}
