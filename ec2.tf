# key pair
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# vpc

resource "aws_default_vpc" "default" {
  
}


resource "aws_security_group" "my_security_group" {
    name = "automate-sg"
    description = "this is will open security group"
    vpc_id = aws_default_vpc.default.id #interpolation
    # inbound rules 
    ingress {
        description = "SSH-OPEN"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP-OPEN"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "flask-app"
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

        # outbound rules
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
tags = {
    Name = "automate-sg"
}
  
}
# ec2 instance

resource "aws_instance" "my_instance" {
    for_each = tomap({

        "Hamza Billionaire" = "c7i-flex.large" , #key #value
        "Hamza Millionaire" = "t3.micro" 
        "Hamza Millionaire" = "t3.small" 

        
        })
    depends_on = [ aws_security_group.my_security_group ]
    key_name = aws_key_pair.my_key.key_name
    security_groups = [aws_security_group.my_security_group.name]
    instance_type = each.value
    ami = var.ec2_ami_id #ubuntu
    user_data = file("script.sh")
    user_data_replace_on_change = true

    root_block_device {
      volume_size =  var.env == "prd" ? 20 : var.ec2_default_root_storage_size
      volume_type = "gp3"

    }
    tags = {
        Name = each.key
        Environment = var.env
    }
  
}
