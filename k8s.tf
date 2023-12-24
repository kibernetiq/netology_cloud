resource "yandex_kubernetes_cluster" "k8s-regional" {
  name = "k8s-regional"
  network_id      = "${yandex_vpc_network.netology.id}"
  release_channel = "STABLE"
  master {
    version = local.k8s_version
    public_ip = true
    security_group_ids = [
      yandex_vpc_security_group.k8s-main-sg.id, 
      yandex_vpc_security_group.k8s-master-whitelist.id
    ]

    regional {
      region = "ru-central1"

      location {
        zone      = "${yandex_vpc_subnet.public-subnet-a.zone}"
        subnet_id = "${yandex_vpc_subnet.public-subnet-a.id}"
      }

      location {
        zone      = "${yandex_vpc_subnet.public-subnet-b.zone}"
        subnet_id = "${yandex_vpc_subnet.public-subnet-b.id}"
      }

      location {
        zone      = "${yandex_vpc_subnet.public-subnet-c.zone}"
        subnet_id = "${yandex_vpc_subnet.public-subnet-c.id}"
      }
    }

    master_logging {
      enabled                    = true
      folder_id                  = var.folder_id
      kube_apiserver_enabled     = true
      cluster_autoscaler_enabled = true
      events_enabled             = true
      audit_enabled              = true
    }
  }
  
  service_account_id      = "${yandex_iam_service_account.k8s-sa.id}"
  node_service_account_id = "${yandex_iam_service_account.k8s-sa.id}"
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller 
  ]

  kms_provider {
    key_id = yandex_kms_symmetric_key.key-a.id
  }
}

resource "yandex_kubernetes_node_group" "worker_node_group" {
  cluster_id  = "${yandex_kubernetes_cluster.k8s-regional.id}"
  name        = "worker-node-group"
  description = "K8s worker nodes"
  version     = local.k8s_version
  instance_template {
    platform_id = var.yandex_compute_instance_platform_id
    network_interface {
      nat                = true
      subnet_ids         = ["${yandex_vpc_subnet.public-subnet-a.id}", "${yandex_vpc_subnet.public-subnet-b.id}", "${yandex_vpc_subnet.public-subnet-c.id}"]
      security_group_ids = ["${yandex_vpc_security_group.k8s-main-sg.id}"]
    }
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      type = "network-hdd"
      size = 64
    }
    scheduling_policy {
      preemptible = false
    }
    container_runtime {
      type = "containerd"
    }
  }
  # scale_policy {
  #   auto_scale {
  #     initial = 3
  #     min     = 3
  #     max     = 6
  #   }
  # }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    location {
      zone      = yandex_vpc_subnet.public-subnet-a.zone
    }
    location {
      zone      = yandex_vpc_subnet.public-subnet-b.zone
    }
    location {
      zone      = yandex_vpc_subnet.public-subnet-c.zone
    }
  }
}