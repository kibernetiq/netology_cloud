# Creating a network
resource "yandex_vpc_network" "netology" {
  name = var.vpc_name
}

# Creating a subnets
resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.public_cidr
}

resource "yandex_vpc_subnet" "public-subnet-a" {
  name           = "public-subnet-a"
  zone           = var.a_zone
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.a_zone_public_cidr
}

resource "yandex_vpc_subnet" "public-subnet-b" {
  name           = "public-subnet-b"
  zone           = var.b_zone
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.b_zone_public_cidr
}

resource "yandex_vpc_subnet" "public-subnet-c" {
  name           = "public-subnet-c"
  zone           = var.c_zone
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.c_zone_public_cidr
}

resource "yandex_vpc_subnet" "private-subnet-a" {
  name           = "private-subnet-a"
  zone           = var.a_zone
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.a_zone_cidr
}

resource "yandex_vpc_subnet" "private-subnet-b" {
  name           = "private-subnet-b"
  zone           = var.b_zone
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.b_zone_cidr
}

resource "yandex_vpc_subnet" "private-subnet-c" {
  name           = "private-subnet-c"
  zone           = var.c_zone
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.c_zone_cidr
}

# resource "yandex_dns_zone" "netology" {
#   name        = "netology-zone"
#   description = "Public zone"
#   zone        = "kibernetique.ru."
#   public      = true
# }

# resource "yandex_dns_recordset" "rs1" {
#   zone_id = yandex_dns_zone.netology.id
#   name    = "www"
#   type    = "CNAME"
#   ttl     = 200
#   data    = ["www.kondratev.ru.website.yandexcloud.net."]
# }

# Создаем сетевой балансировщик
# resource "yandex_lb_network_load_balancer" "load-balancer" {
#   name = "network-load-balancer"
#   listener {
#     name = "lb-listener"
#     port = 80
#     external_address_spec {
#       ip_version = "ipv4"
#     }
#   }
#   attached_target_group {
#     target_group_id = yandex_compute_instance_group.test-ig-group.load_balancer.0.target_group_id

#     healthcheck {
#       name = "http"
#       http_options {
#         port = 80
#         path = "/"
#       }
#     }
#   }
#   depends_on = [
#     yandex_compute_instance_group.test-ig-group,
#   ]
# }