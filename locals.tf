locals {
  project       = "netology"
  ssh_key       = "ubuntu:${var.public_key}"
  k8s_version   = "1.25"
  sa_name       = "k8s-sa"
}