# terraform-lab01

## Objetivo del taller

Esta configuración genera cinco sufijos aleatorios y crea cinco archivos de inventario. Cada nombre de archivo incorpora uno de los sufijos para que los nombres no sean iguales.

## `code/random.tf`: generar los sufijos

```terraform
resource "random_string" "sufijo" {
	count   = 5
	length  = 4
	special = false
	upper   = false
	numeric = false
}
```

- `resource "random_string" "sufijo" {` declara un recurso de tipo `random_string`. `sufijo` es el nombre local con el que otros recursos de esta configuración pueden referirse a él. La llave `{` abre el bloque.
- `count = 5` crea cinco instancias del recurso, con índices del 0 al 4.
- `length = 4` hace que cada sufijo tenga cuatro caracteres.
- `special = false` excluye los símbolos especiales.
- `upper = false` excluye las letras mayúsculas.
- `numeric = false` excluye los números. Como las mayúsculas y los símbolos también están desactivados, los sufijos se forman con letras minúsculas.
- `}` cierra la definición del recurso.

## `code/local_file.tf`: crear los archivos

```terraform
resource "local_file" "inventario" {
	count    = 5
	content  = "listado de inventario del mes actual ..."
	filename = "inventario-${random_string.sufijo[count.index].id}.txt"
}
```

- `resource "local_file" "inventario" {` declara un recurso `local_file`, que crea archivos en el equipo donde se ejecuta Terraform. `inventario` es el nombre local del recurso. La llave `{` abre el bloque.
- `count = 5` crea cinco instancias del recurso y, por tanto, cinco archivos.
- `content = "..."` define el texto que se escribe dentro de cada archivo. En este ejemplo, los cinco archivos tienen el mismo contenido.
- `filename = "inventario-${random_string.sufijo[count.index].id}.txt"` construye la ruta de cada archivo. `${...}` inserta un valor calculado: `random_string.sufijo` apunta al recurso de sufijos, `[count.index]` elige el sufijo que corresponde a esta instancia del archivo, e `.id` obtiene la cadena generada. Así se crean nombres como `inventario-abcd.txt`.
- `}` cierra la definición del recurso.

## Cómo se conectan

Ambos recursos usan `count = 5`, de modo que cada archivo puede usar el sufijo de la instancia con el mismo índice. La referencia a `random_string.sufijo` en `filename` también permite a Terraform deducir que debe generar los sufijos antes de crear los archivos.