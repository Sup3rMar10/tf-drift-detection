resource "local_file" "app_config" {
  filename        = "${path.module}/out/app.json"
  file_permission = "0640"
  content         = jsonencode({ feature_flags = { new_checkout = false } })
}
