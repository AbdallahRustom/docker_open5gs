apt-get update
apt-get install -y openssh-server nano

# Create an SFTP user and set a password
useradd sftpuser
echo "sftpuser:sftpuser" | chpasswd

# Edit sshd_config to configure SFTP
echo "Match User sftpuser" >> /etc/ssh/sshd_config
echo "ChrootDirectory /" >> /etc/ssh/sshd_config
echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config

# Restart the SSH service
service ssh restart

echo "SFTP server setup complete."