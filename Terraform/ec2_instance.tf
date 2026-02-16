data "aws_security_group" "grp" {
  name = "launch-wizard-4"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "test-instance-profile"
  role = "Ec2_role"
}

resource "aws_instance" "web" {
  ami           = "ami-023a307f3d27ea427"
  instance_type = "t3a.small"

  vpc_security_group_ids = [data.aws_security_group.grp.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = file("data.sh")

  root_block_device {
    volume_size = 20           # Set EBS root volume size to 50 GB
    volume_type = "gp3"        # Recommended general-purpose SSD (you can also use "gp2")
    delete_on_termination = true
  }

  tags = {
    project = "test"
    Name    = "test"
  }
}