variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}

resource "null_resource" "ssh_target" {
  connection {
    type 	= "ssh"
    user 	= var.ssh_user
    host	= var.ssh_host
    private_key = file(var.ssh_key)
  }
  
  provisioner "remote-exec" {
    inline = [
      "echo 'hello'",
      #"sudo yum update -y",
      #"sudo yum install -y epel-release",
      #"sudo yum install -y nginx",
      #"sudo systemctl start nginx",
      #"sudo systemctl status nginx",
      #"sudo firewall-cmd --permanent --zone=public --add-service=http",
      #"sudo firewall-cmd --permanent --zone=public --add-service=https",
      #"sudo firewall-cmd --reload",
    ]
  }

  provisioner "file" {
    source      = "D:\\gitspace\\tutodevops\\terratuto2_remote_exec\\files\\nginx.conf"
    destination = "/tmp/default"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /root/mes_fichiers",
      "sudo cp -a /tmp/default /root/mes_fichiers/default",
      "sudo echo 'ok'",
    ]
  }

  provisioner "local-exec" {
    command = "echo 'ok'"
    #command = "curl ${var.ssh_host}:667"
  }
}
