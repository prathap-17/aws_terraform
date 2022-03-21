resource "aws_instance" "web1" {
   ami           = "ami-0c02fb55956c7d316"
   instance_type = "t2.micro"
 }
