resource "aws_internet_gateway" "gate_mch" {
	vpc_id = aws_vpc.main.id
	tags = {
		Name = "MainGate_mch
	}
}
