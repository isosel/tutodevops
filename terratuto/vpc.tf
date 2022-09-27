resource "aws_vpc" "main" {
	cidr_block = "10.0.0.0/18"
	tags = {
		Name = "MainVPC_mch"
	}
}
