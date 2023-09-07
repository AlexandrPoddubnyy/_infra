resource "yandex_compute_instance" "app" {

  count       = var.app_count
  platform_id = var.platform_id
#  name = "reddit-app"
#  name = "reddit-app-${count.index}"
  name = "reddit-app-${var.environment}-${count.index}"

  labels = {
    tags = "reddit-app"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
    }
  }

  network_interface {
#    subnet_id = "${yandex_vpc_subnet.app-subnet.id}"
    subnet_id = var.subnet_id
    nat = true
  }

  metadata = {
  ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}
