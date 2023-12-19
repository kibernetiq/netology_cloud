# Создание корзины с использованием ключа
resource "yandex_storage_bucket" "test-bucket" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket        = "test-bucket-kibenetiq-yc"
  acl           = "public-read"
  force_destroy = "true"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
  # https {
  #   certificate_id = "yandex_cm_certificate.mydomain.id"
  # }
  # website {
  #   index_document = "index"
  # }
}

# Создаем обьект в корзине
resource "yandex_storage_object" "image-object" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket        = yandex_storage_bucket.test-bucket.id
  acl           = "public-read"
  key           = "123.png"
  source        = "data/123.png"
  depends_on    = [
    yandex_storage_bucket.test-bucket,
  ]
}

# resource "yandex_storage_object" "index-html" {
#   access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
#   secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
#   bucket     = yandex_storage_bucket.test-bucket.id
#   acl        = "public-read"
#   key        = "index.html"
#   source     = "data/index.html"
#   depends_on = [
#     yandex_storage_bucket.test-bucket,
#   ]
# }