# # Создаем сервисный аккаунт для работы в Object Storage
# resource "yandex_iam_service_account" "sa-object-storage-editor" {
#   name = "sa-object-storage-editor"
# }

# # Назначение роли сервисному аккаунту (Делаем руками в админке YC)
# resource "yandex_resourcemanager_folder_iam_member" "sa-object-storage-editor-role" {
#   folder_id = var.folder_id
#   role      = "storage.editor"
#   member    = "serviceAccount:${yandex_iam_service_account.sa-object-storage-editor.id}"
# }

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = var.sa_bucket
  description        = "static access key for object storage"
}

resource "yandex_iam_service_account" "ig-sa" {
  name        = "ig-sa"
  description = "service account to manage IG"
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  members    = [
    "serviceAccount:${yandex_iam_service_account.ig-sa.id}",
  ]
  depends_on = [
    yandex_iam_service_account.ig-sa,
  ]
}