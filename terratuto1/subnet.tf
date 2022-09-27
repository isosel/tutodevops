resource "aws_subnet" "public_mch1" {
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.0.0/24"
	availability_zone = "us-east-2a"
	tags = {
		Name = "public-mch-us-east-2a"
	}
}

resource "aws_subnet" "public_mch2" {
        vpc_id = aws_vpc.main.id
        cidr_block = "10.0.0.128/24"
        availability_zone = "us-east-2b"
        tags = {
                Name = "public-mch-us-east-2b"
        }
}

