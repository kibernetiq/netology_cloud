# Создаем группу машин
resource "yandex_compute_instance_group" "test-ig-group" {
  name                = "vm-lamp"
  folder_id           = var.folder_id
  service_account_id  = "${yandex_iam_service_account.ig-sa.id}"
  deletion_protection = false
  depends_on          = [yandex_resourcemanager_folder_iam_binding.editor]
  instance_template {
    platform_id = var.yandex_compute_instance_platform_id
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 4
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.netology.id}"
      subnet_ids = ["${yandex_vpc_subnet.public-subnet.id}"]
      nat        = "true"
    }
    metadata = {
      user-data = "#cloud-config\nusers:\n  - name: ubuntu\n    groups: sudo,wheel\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("~/.ssh/id_rsa.pub")}runcmd:\n  - echo '<html><head><title>Test image</title></head><body><img src=${var.image_id}></body></html>' > /var/www/html/index.html"
    }
    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["${var.default_zone}"]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 1
  }

  health_check {
    http_options {
      port = 80
      path = "/"
    }
  }

  load_balancer {
    target_group_name        = "vm-lamp"
    target_group_description = "test-balancer"
  }
}

