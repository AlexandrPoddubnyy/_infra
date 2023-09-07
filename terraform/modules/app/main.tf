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
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    content     = templatefile("${path.module}/puma.service.tpl", { ip_address_db = "${var.db_ip}" })
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "${path.module}/deploy_app.sh"
  }

}
