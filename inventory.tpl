[all]
demoapp ansible_host=${vm_ip} app_name=${app_name}

[all:vars]
ansible_user=student
ansible_ssh_private_key_file=~/.ssh/id_ed25519

