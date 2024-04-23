# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# resource "aws_instance" "web-1" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"
#   subnet_id     = "subnet-0145c8fbb04c2d540"
#   security_groups = [aws_security_group.public-instance_sg.id]

#   tags = {
#     Name = "CA-EC2-Public"
#   }
# }

# resource "aws_security_group" "public-instance_sg" {
#   name        = "Public-InstanceSecurityGroup"
#   description = "Security group for EC2 instance"

#   vpc_id = var.vpc_id

#   # Define ingress rules (inbound traffic)
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access from anywhere
#   }

#   # Define egress rules (outbound traffic)
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"  # Allow all outbound traffic
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "Public-InstanceSecurityGroup"
#   }
# }

# ##############################
# # Instance in private Subnet #
# ##############################

# data "aws_ami" "ubuntu2" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# resource "tls_private_key" "my_private_key" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# # Save the private key to a file
# output "private_key_pem" {
#   value     = tls_private_key.my_private_key.private_key_pem
#   sensitive = false
# }

# data "aws_key_pair" "my_key_pair" {
#   key_name = aws_key_pair.my_key_pair.key_name  # Specify the name of your existing EC2 key pair
# }

# resource "local_file" "private_key_file" {
#   content  = data.aws_key_pair.my_key_pair.public_key
#   filename = "key.pem"  # Specify the path and filename where you want to save the private key
# }

# resource "aws_key_pair" "my_key_pair" {
#   key_name   = "private-ec2-key-pair"  # Specify the name for your key pair
#   public_key = tls_private_key.my_private_key.public_key_openssh

#   tags = {
#     Name = "CA-private-ec2-key-pair"
#   }
# }


# resource "aws_instance" "web-2" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"
#   key_name = "${aws_key_pair.my_key_pair.key_name}"
#   subnet_id     = "subnet-0513aa6e693f3ef2e"
#   security_groups = [aws_security_group.private-instance_sg.id]

#   tags = {
#     Name = "CA-EC2-Private"
#   }
# }

# resource "aws_security_group" "private-instance_sg" {
#   name        = "Private-InstanceSecurityGroup"
#   description = "Security group for EC2 instance"

#   vpc_id = var.vpc_id

#   # Define ingress rules (inbound traffic)
#   ingress {
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "tcp"
#     # cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere
#     security_groups = [aws_security_group.public-instance_sg.id]
#   }

#   # Define egress rules (outbound traffic)
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"  # Allow all outbound traffic
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "Private-InstanceSecurityGroup"
#   }
# }
