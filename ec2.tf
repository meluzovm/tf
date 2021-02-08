data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name   = "image-id"
    values = ["ami-047a51fa27710816e"]
  }
}

resource "aws_instance" "mariadb" {
  #name          = "mariadb-ec2"
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro" 
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.ec2.id ]

  root_block_device {
    delete_on_termination = true
  }
  user_data = <<XXX
sudo tee /etc/yum.repos.d/mariadb.repo<<EOF
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

sudo yum makecache 
sudo yum repolist
sudo yum install  -y  mariadb-server git
sudo systemctl enable --now mariadb

git clone https://github.com/datacharmer/test_db
cd test_db/
mysql -t -u root < employees.sql
mysql -u root
create user 'ec2-user'@'%' identified by 'QQqq1234';
grant SELECT ON *.*  to  'ec2-user'@'%';
grant SELECT ON mysql.proc   to  'ec2-user'@'%';
grant SHOW VIEW ON *.*  to  'ec2-user'@'%';
flush privileges;
exit;
echo "Setup finished"
XXX

}