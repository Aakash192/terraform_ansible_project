resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command = "/bin/bash ${path.module}/../ansible/runansible.sh"
  }
  depends_on = [
    module.rgroup-n01603990,
    module.datadisk-n01603990,
    module.linux-n01603990
  ]
}