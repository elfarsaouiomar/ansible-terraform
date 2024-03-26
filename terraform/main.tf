
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"]
}

resource "aws_key_pair" "webserver_key_pair" {
  key_name   = "webserver"
  public_key = file("${path.module}/id_rsa.pub")
}


resource "aws_instance" "webserver_ec2" {
    count = 3
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.webserver_sg.id]
    key_name = aws_key_pair.webserver_key_pair.id
    
    tags = {
        Name = "webserver_ec2"
        env = "dev"
        id = "vm-id-${count.index}"
    }

}
