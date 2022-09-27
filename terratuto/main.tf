provider "aws" {
	region = var.AWS_REGION
	access_key = var.AWS_ACCESS_KEY
	secret_key = var.AWS_SECRET_KEY
}

resource "aws_vpc" "main" {
        cidr_block = "10.0.0.0/18"
        tags = {
                Name = "MainVPC_mch"
        }
}

#1st subenet composed of 128 hosts
resource "aws_subnet" "public_mch1" {
        vpc_id = aws_vpc.main.id
        cidr_block = "10.0.0.0/25"
        availability_zone = "us-east-2a"
        tags = {
                Name = "public-mch-us-east-2a"
        }
}

#2nd subnet compsed of 128 hosts
resource "aws_subnet" "public_mch2" {
        vpc_id = aws_vpc.main.id
        cidr_block = "10.0.0.128/25"
        availability_zone = "us-east-2b"
        tags = {
                Name = "public-mch-us-east-2b"
        }
}

resource "aws_internet_gateway" "gate_mch" {
        vpc_id = aws_vpc.main.id
        tags = {
                Name = "MainGate_mch
        }
}

resource "aws_key_pair" "dev" {
	key_name = "mch_rsa_key"
	public_key = var.MY_SSH_KEY
}

resource "aws_security_group" "micka_instance" {
	name = "secumicka"

	egress {
		from_port	= 0
		to_port		= 0
		protocol	= "-1"
		cidr_blocks	= ["0.0.0.0/0"]
	}

	ingress {
		from_port 	= 22
		to_port 	= 22
		protocol 	= "tcp"
		cidr_blocks 	= ["0.0.0.0/0"]
	}

	ingress {
		from_port	= 80
		to_port		= 80
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}

}

resource "aws_instance" "ec2" {
	ami = var.AWS_AMIS[var.AWS_REGION]
	instance_type = "t2.micro"
	key_name = "mch_rsa_key"
	vpc_security_group_ids = [aws_security_group.micka_instance.id]
	
	tags = {
		Name = "${terraform.workspace == "prod" ? "prod-ec2" : "default-ec2"}"
	}
	
	user_data = <<-EOF
		#!/bin/bash
		sudo yum -y install httpd
		sudo systemctl start httpd
		sudo systemctl enable httpd
		sudo echo "<h1>Hello from aws</h1>" > /var/www/html/index.html
	EOF

	provisioner "local-exec" {
		command = "echo ${aws_instance.ec2.public_ip} > adresse_ip.txt"
	}

	provisioner "local-exec" {
		when = "destroy"
		command = "echo \"destruction de l instance ${self.public_ip}\" > ip_address.txt"
	}

	connection {
		type = "ssh"
		user = "ec2-user"
		private_key = file("D:\\Documents\\Formation_Devops_Cloud\\rsa_key\\terra\\id_rsa")
		host = self.public_ip
	}

	provisioner "remote-exec" {
		inline = [
			"sudo yum -y upgrade",
			"sudo yum -y install mariadb-server",
			"sudo systemctl start mariadb",
			"sudo systemctl enable mariadb",
		]
	}
}

terraform {
	backend "s3" {
		bucket 	= "mickabucket"
		key 	= "states/terraform.state"
		region	= "us-east-2"
	}
}

output "public_ip" {
	value = aws_instance.ec2.public_ip
}
