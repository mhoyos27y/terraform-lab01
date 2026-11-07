resource "local_file" "inventario" {
  count    = 5
  content  = "listado de inventario del mes actual ..."
  filename = "inventario-${random_string.sufijo[count.index].id}.txt"
}


