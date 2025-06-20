resource "aws_vpc" "babaji-vpc"{
  cidr_block = var.vpccidr
  tags= {
    Name = var.vpcname
  }
}
resource "aws_subnet" "babaji-pubsub"{
  vpc_id = aws_vpc.babaji-vpc.id
  avaialbility_zone = var.pubaz
  cidr_block = var.pubcidr
  map_public_ip_on_launch =true
  tags ={
    Name = var.pubsubname
  }
}
resource "aws_subnet" "babaji-prisub"{
  vpc_id = aws_vpc.babaji-vpc.id
  availability_zone = var.priaz
  cidr_block = var.pricidr
  tags={
    Name = var.prisubname
  }
}
resource "aws_internet_gateway" "babaji-igw"{
  vpc_id = aws_vpc.babaji-vpc.id
  tags = {
    Name = var.igw
  }
}
resource "aws_route" "babaji-rt"{
  route_table_id = aws_vpc.babaji-vpc.default_route_table_id
  destination_cidr_block = var.igwcidr
  gateway_id = aws_internet_gateway.babaji-igw.id
  }
resource "aws_route_table_association" "pubrta"{
  route_table_id =aws_vpc.babaji-vpc.default_route_table_id
  subnet_id = aws_subnet.babaji-pubsub.id
}
resource "aws_security_group" "babaji-sg"{
  vpc_id= aws_vpc.babaji-vpc.id
  ingress {
    description = "allow ssh"
    from_port = "22"
    to_port = "22"
    protocol ="tcp"
    cidr_blocks = var.inboundcidr
  }
  ingress {
    description ="allow http"
    from_port ="80"
    to_port = "80"
    protocol ="tcp"
    cidr_blocks = var.inboundcidr1
  }
  egress {
    description = "allow outbound traffic"
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = var.outboundcidr
  }
}
resource "aws_instance" "babaji-web"{
  ami = var.ami-id
  instance_type = var.instance-type
  vpc_security_group_ids = aws_security_group.babaji-sg.id
  vpc_id = aws_vpc.babaji-vpc.id
  subnet_id = aws_subnet.babaji-pubsub.id
  key_name = "babaji-RDS"
  tags={
    Name =var.instancename
  }
}
resource "aws_ebs_volume" "babaji-volume"{
  availability_zone = var.volaz
  size = 1
  tags={
    Name = var.volname
  }
}
resource "aws_volume_attachment" "babaji-vol-att"{
  device_name = "/dev/xvdf"
  volume_id = aws_ebs_volume.babaji-volume.id
  instance_id = aws_instance.babaji-web.id
  force_detach = true
}


