output "load_balancer_ip" {
  description = "IP público do Load Balancer"
  value       = oci_network_load_balancer_network_load_balancer.web_lb.ip_addresses[0].ip_address
}

output "web_application_url" {
  description = "URL da aplicação web"
  value       = "http://${oci_network_load_balancer_network_load_balancer.web_lb.ip_addresses[0].ip_address}"
}

output "health_check_url" {
  description = "URL do health check"
  value       = "http://${oci_network_load_balancer_network_load_balancer.web_lb.ip_addresses[0].ip_address}/health"
}

output "web_servers" {
  description = "Informações dos web servers"
  value = {
    server_1 = {
      name        = module.web_server_1.instance_name
      public_ip   = module.web_server_1.public_ip
      private_ip  = module.web_server_1.private_ip
      ssh_command = module.web_server_1.ssh_connection
    }
    server_2 = {
      name        = module.web_server_2.instance_name
      public_ip   = module.web_server_2.public_ip
      private_ip  = module.web_server_2.private_ip
      ssh_command = module.web_server_2.ssh_connection
    }
  }
}

output "load_balancer_details" {
  description = "Detalhes do Load Balancer"
  value = {
    id          = oci_network_load_balancer_network_load_balancer.web_lb.id
    name        = oci_network_load_balancer_network_load_balancer.web_lb.display_name
    ip_address  = oci_network_load_balancer_network_load_balancer.web_lb.ip_addresses[0].ip_address
    backend_set = oci_network_load_balancer_backend_set.web_backend_set.name
  }
}

output "networking_info" {
  description = "Informações da rede"
  value = {
    vcn_id            = module.networking.vcn_id
    public_subnet_id  = module.networking.public_subnet_id
    private_subnet_id = module.networking.private_subnet_id
  }
}

output "project_summary" {
  description = "Resumo do projeto"
  value = {
    project_name     = var.project_name
    environment      = var.environment
    region           = var.region
    servers_deployed = 2
    load_balanced    = true
    status           = "deployed"
  }
}

output "quick_test_commands" {
  description = "Comandos para testar a aplicação"
  value = {
    test_load_balancer = "curl http://${oci_network_load_balancer_network_load_balancer.web_lb.ip_addresses[0].ip_address}"
    test_health_check  = "curl http://${oci_network_load_balancer_network_load_balancer.web_lb.ip_addresses[0].ip_address}/health"
    load_test          = "for i in {1..10}; do curl -s http://${oci_network_load_balancer_network_load_balancer.web_lb.ip_addresses[0].ip_address} | grep Hostname; done"
  }
}