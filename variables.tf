variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "netology"
  description = "VPC network&subnet name"
}

variable "public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPvvD+VqC+CqvR+kDLnraxgaGF6q+nJMaCiqcPWl6h18Bz9mYA7vw2S03xXNCsalPu7T/Qt6W11yLzSVTLDfeh6cfovCvNRfnw79x2qsMLSwHrImqYR8g/NNUsCCN0EJnJWMFnXWRfEkNK3r1gxCNBBsNZPlIlNYBLhf/uwMl73WHydaVZgGmtqdXR3kvfq7akPLJnyZmXuFtpP/Ql+I+0s4ZCYfc75kYmJTmKCnZY4ixr6NeTRm9hNep/8rPfxYKf19e47EdoG/Lxu6P/WbTAGXshh7m+SXmV9P+oK4LggbKAj5LhyZ4wMQi3ZG/LCFXWpMVioSqJp4ny/s1L12BV"
}

variable "yandex_compute_instance_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "https://cloud.yandex.com/en/docs/cli/cli-ref/managed-services/compute/instance/"
}

variable "yandex_compute_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "https://cloud.yandex.ru/docs/cli/cli-ref/managed-services/compute/image/"
}

variable "metadata_map" {
  type = map
  default     = {
    metadata = {
      serial-port-enable = 1
    }
  }
}

variable "image_id" {
  type        = string
  default     = "https://storage.yandexcloud.net/test-bucket-kibenetiq-yc/123.png"
}

variable "sa_bucket" {
  type        = string
  description = "Service Account ID: sa-object-storage-editor"
}