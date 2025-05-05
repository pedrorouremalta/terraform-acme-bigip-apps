resource "bigip_as3" "bigip_apps" {
  for_each = { for item in var.bigip_applications : item.name => item }
  as3_json = templatefile("${path.module}/assets/app.json.tpl", each.value)
}