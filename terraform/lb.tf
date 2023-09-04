
resource "yandex_lb_target_group" "myfoo1" {
  name      = "my-target-group"

  target {
    subnet_id = "${yandex_compute_instance.app.network_interface.0.subnet_id}"
    address   = "${yandex_compute_instance.app.network_interface.0.ip_address}"
  }
}

resource "yandex_lb_network_load_balancer" "mylb1" {
  name = "my-network-load-balancer"

  listener {
    name = "my-listener"
    port = 80
    target_port = 9292
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_lb_target_group.myfoo1.id}"

    healthcheck {
      name = "http"
      http_options {
        port = 9292
        path = "/"
      }
    }
  }
}
