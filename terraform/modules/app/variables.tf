#variable "cloud_id" {
#  description = "Cloud"
#}

#variable "folder_id" {
#  description = "Folder"
#}

variable "zone" {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}

variable "public_key_path" {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  # Описание переменной
  description = "Path to the private key used for ssh access for provisioning"
}

#variable "image_id" {
#  description = "Disk image"
#}

variable "subnet_id" {
  description = "Subnet"
}

#variable "service_account_key_file" {
#  description = "key .json"
#}

variable "app_count" {
  description = "count instances for app"
}

variable "platform_id" {
  description = "Platform . See https://cloud.yandex.ru/docs/compute/concepts/vm-platforms"
}

variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

#variable db_disk_image {
#  description = "Disk image for reddit db"
#  default = "reddit-db-base"
#}

variable "environment" {
  description = "Production environment. Example: prod, stage, dev, test ..."
  default     = "test"
}

variable "db_ip" {
  description = "database ip"
}
