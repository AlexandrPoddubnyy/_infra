resource "yandex_compute_instance" "db" {

#  count       = var.app_count
  count       = 1
  platform_id = var.platform_id
#  name = "reddit-app"
#  name = "reddit-db-${count.index}"
  name = "reddit-db-${var.environment}-${count.index}"

  labels = {
#    tags = "reddit-app"
    tags = "reddit-db"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.db_disk_image
    }
  }

  network_interface {
#    subnet_id = yandex_vpc_subnet.app-subnet.id
    subnet_id = var.subnet_id
    nat = true
  }

  metadata = {
  ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}
