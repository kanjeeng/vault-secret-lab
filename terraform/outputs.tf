output "vault_server_public_ip" {
  value = aws_eip.vault.public_ip
}

output "db_server_public_ip" {
  value = aws_instance.db.public_ip
}

output "ssh_target_public_ip" {
  value = aws_instance.ssh_target.public_ip
}

output "client_node_public_ip" {
  value = aws_instance.client.public_ip
}

output "ssh_vault_server" {
  value = "ssh -i vault-lab-key.pem ubuntu@${aws_eip.vault.public_ip}"
}

output "ssh_db_server" {
  value = "ssh -i vault-lab-key.pem ubuntu@${aws_instance.db.public_ip}"
}

output "ssh_ssh_target" {
  value = "ssh -i vault-lab-key.pem ubuntu@${aws_instance.ssh_target.public_ip}"
}

output "ssh_client_node" {
  value = "ssh -i vault-lab-key.pem ubuntu@${aws_instance.client.public_ip}"
}
