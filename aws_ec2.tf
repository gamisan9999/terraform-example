variable "bastion" {
  type = "map"

  default {
    ami_id          = "ami-1e434370" #RHEL-6.7_HVM-20160219-x86_64-1-Hourly2-GP2
    instance_type   = "t2.medium"
    tag_name        = "bastion"
    tag_role        = "bastion"
    tag_service     = "demo"
    tag_environment = "production"
    volume_type     = "gp2"
    volume_size     = "30"
    count           = 1
  }
}

variable "stg" {
  type = "map"

  default {
    ami_id          = "ami-1e434370" #RHEL-6.7_HVM-20160219-x86_64-1-Hourly2-GP2
    instance_type   = "t2.micro"
    tag_name        = "study"
    tag_role        = "study"
    tag_service     = "demo"
    tag_environment = "staging"
    volume_type     = "gp2"
    volume_size     = "30"
    count           = 0
  }
}

variable "prod-www" {
  type = "map"

  default {
    ami_id          = "ami-92df37ed"
    instance_type   = "t2.micro"
    tag_name        = "prod-www"
    tag_role        = "app"
    tag_service     = "demo"
    tag_environment = "production"
    volume_type     = "gp2"
    volume_size     = "30"
    count           = 0
  }
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPOEMiyyTPQXh01XAO9venmvDx+y9VTc0QNUoXPd7La9ZdM3QxZE0nzvnXc26d58tE3Z5HiGTAYOcux7PhPla/yYDRdDALl/6jMvLmNWM2utGHoUXwv/ryfVDVSUKlTSfSTQoKVA506Fs6Pt4Z7Ej4vukMivZGJPSZVbc3FWquysD5leHvU70e9xXsGxqa+eIMLHu0vGvHdO3vImY2pKGfU1aYFV0BqVSRMxbLw4HUYfpefp4BaIkMmC5gRCICHsAQwCo7NwrKmxzsBpqoB0RY+k+q20FxfOOr0aeqdyOzv7COG+MJDb5QluHOXRB5omSnSvAnDm/mUI6Hybd/kE2T kentaro@kishigamikentarounoMacBook-Pro.local"
}

resource "aws_eip" "bastion" {
  vpc = true
}

resource "aws_eip_association" "bastion" {
  instance_id   = "${aws_instance.bastion.id}"
  allocation_id = "${aws_eip.bastion.id}"
  count         = "${var.bastion["count"]}"
}

resource "aws_instance" "bastion" {
  ami                    = "${var.bastion["ami_id"]}"
  instance_type          = "${var.bastion["instance_type"]}"
  key_name               = "${aws_key_pair.mykeypair.key_name}"
  vpc_security_group_ids = ["${aws_security_group.prod-bastion.id}", "${aws_security_group.common.id}"]
  subnet_id              = "${aws_subnet.public-route-igw.4.id}"
  iam_instance_profile   = "${aws_iam_instance_profile.bastion.name}"
  count                  = "${var.bastion["count"]}"

  tags {
    Name        = "${var.bastion["tag_name"]}"
    Role        = "${var.bastion["tag_role"]}"
    Environment = "${var.bastion["tag_environment"]}"
    amirotate   = "{\"NoReboot\": true, \"Retention\": {\"Count\": 3}}"
    Service     = "${var.bastion["tag_service"]}"
  }
}

resource "aws_ebs_volume" "bastion-data-1a" {
  availability_zone = "ap-northeast-1a"
  type              = "gp2"
  size              = 30
  count             = "${var.bastion["count"]}"

  tags {
    Name = "bastion-data"
  }
}

resource "aws_volume_attachment" "bastion-data-1a" {
  device_name = "/dev/sdi"
  volume_id   = "${aws_ebs_volume.bastion-data-1a.id}"
  instance_id = "${aws_instance.bastion.id}"
  count       = "${var.bastion["count"]}"
}

resource "aws_instance" "stg" {
  ami                    = "${var.stg["ami_id"]}"
  instance_type          = "${var.stg["instance_type"]}"
  key_name               = "${aws_key_pair.mykeypair.key_name}"
  vpc_security_group_ids = ["${aws_security_group.stg-app.id}", "${aws_security_group.common.id}"]
  subnet_id              = "${aws_subnet.protected-route-nat.4.id}"
  iam_instance_profile   = "${aws_iam_instance_profile.stg.name}"
  count                  = "${var.stg["count"]}"

  tags {
    Name        = "${var.stg["tag_name"]}${count.index}"
    Role        = "${var.stg["tag_role"]}"
    Environment = "${var.stg["tag_environment"]}"
    amirotate   = "{\"NoReboot\": true, \"Retention\": {\"Count\": 3}}"
    Service     = "${var.stg["tag_service"]}"
  }
}

resource "aws_instance" "prod-www" {
  ami                    = "${var.prod-www["ami_id"]}"
  instance_type          = "${var.prod-www["instance_type"]}"
  key_name               = "${aws_key_pair.mykeypair.key_name}"
  vpc_security_group_ids = ["${aws_security_group.prod-www.id}", "${aws_security_group.common.id}"]
  subnet_id              = "${aws_subnet.protected-route-nat.5.id}"
  iam_instance_profile   = "${aws_iam_instance_profile.prod-www.name}"
  count                  = "${var.prod-www["count"]}"

  tags {
    Name        = "${var.prod-www["tag_name"]}"
    Role        = "${var.prod-www["tag_role"]}"
    Environment = "${var.prod-www["tag_environment"]}"
    amirotate   = "{\"NoReboot\": true, \"Retention\": {\"Count\": 3}}"
    Service     = "${var.prod-www["tag_service"]}"
  }
}
