resource "aws_efs_file_system" "tf2_efs" {
  tags = {
    Name = "ECS-EFS"
  }
}

resource "aws_efs_mount_target" "tf2_efs_mount_terraform-public-1a" {
  file_system_id  = aws_efs_file_system.tf2_efs.id
  subnet_id       = data.aws_subnet.terraform-public-1a.id
  security_groups = [aws_security_group.tf2_efs.id]
}

resource "aws_efs_access_point" "tf2_ap" {
  file_system_id = aws_efs_file_system.tf2_efs.id
  posix_user {
    uid = 1000
    gid = 1000
  }
  root_directory {
    path = "/tf2"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = 755
    }
  }
}