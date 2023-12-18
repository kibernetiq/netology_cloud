# Создание корзины с использованием ключа
resource "yandex_storage_bucket" "test-bucket" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket        = "test-storage-picture"
  acl           = "public-read"
  force_destroy = "true"
}

# Создаем обьект в корзине
resource "yandex_storage_object" "image-object" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket        = "test-storage-picture"
  acl           = "public-read"
  key           = "123.png"
  source        = "data/123.png"
  depends_on    = [yandex_storage_bucket.test-bucket]
}