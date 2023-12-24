resource "yandex_mdb_mysql_cluster" "netology-mysql-1" {
  name                = "netology-mysql-1"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.netology.id
  security_group_ids  = [ yandex_vpc_security_group.mysql-sg.id ]
  version             = "8.0"
  deletion_protection = true

  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }
  
  backup_window_start {
    hours = 23
    minutes = 59
  }

  host {
    name             = "master"
    zone             = var.a_zone
    subnet_id        = yandex_vpc_subnet.private-subnet-a.id
    assign_public_ip = true
    backup_priority  = 10
  }

  host {
    name             = "slave-1"
    zone             = var.b_zone
    subnet_id        = yandex_vpc_subnet.private-subnet-b.id
    assign_public_ip = true
  }

  host {
    name             = "slave-2"
    zone             = var.c_zone
    subnet_id        = yandex_vpc_subnet.private-subnet-c.id
    assign_public_ip = true
  }
}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.netology-mysql-1.id
  name       = "netology_db"
}

resource "yandex_mdb_mysql_user" "user1" {
  cluster_id = yandex_mdb_mysql_cluster.netology-mysql-1.id
  name       = "yura"
  password   = "123456789"
  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }
}
