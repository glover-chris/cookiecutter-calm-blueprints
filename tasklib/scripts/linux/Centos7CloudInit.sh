#cloud-config
growpart:
  mode: growpart
  devices: ["/dev/sda"]

resize_rootfs: true

users:
  - name: @@{CENTOS.username}@@
    ssh-authorized-keys:
      - @@{CENTOS.public_key}@@
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    