variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
	type = string
	default = "us-east-2"
	description = "Region de mon instance..."
}

variable "AWS_AMIS" {
	type = map
	default = {
		"us-east-2" : "ami-0f924dc71d44d23e2"
		"us-east-1" : "ami-026b57f3c383c2eec"
	}
}
