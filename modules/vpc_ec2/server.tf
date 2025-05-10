provider "aws" {
  region = "us-east-1"  # Set your desired AWS region
}

resource "aws_instance" "example" {
  ami           = "ami-12345678"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.ingress_vpc_public_subnet[count.index].id  # Replace with a valid subnet ID
  key_name      = "example-key"     # Replace with a valid key pair name
  
  root_block_device {
      encrypted = false
  }

  ebs_block_device {
    device_name = "/dev/sdg"
    volume_size = 5
    volume_type = "gp2"
    delete_on_termination = false
    encrypted = false
  }
  tags = {
    Name = "example-instance"
  }
}

resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Security group allowing SSH and HTTP traffic"
  vpc_id      = aws_vpc.ingress_vpc.id  # Replace with your VPC ID
}
