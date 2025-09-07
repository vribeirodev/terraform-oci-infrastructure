# Compute Module

Módulo Terraform para criação de instâncias compute no OCI.

## Recursos Criados

- Instância compute (VM)
- Configuração de rede (VNIC)
- Chaves SSH para acesso
- User data para bootstrap (opcional)
- Política de backup para ambientes de produção

## Características

- Imagem padrão: Debian 12
- Shape padrão: VM.Standard.E2.1.Micro (Always Free)
- Suporte a shapes flexíveis
- Backup automático em produção
- Tags customizáveis

## Uso

```hcl
module "compute" {
  source = "../modules/compute"
  
  compartment_id      = var.compartment_id
  subnet_id          = module.networking.public_subnet_id
  availability_domain = var.availability_domain
  
  instance_name      = "web-server"
  ssh_public_key     = file("~/.ssh/id_rsa.pub")
  assign_public_ip   = true
  
  user_data = <<-EOF
    #!/bin/bash
    apt update
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOF
  
  tags = {
    Environment = "dev"
    Purpose     = "web-server"
  }
}
```

## Variáveis

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| compartment_id | OCID do compartimento | `string` | - | sim |
| subnet_id | OCID da subnet | `string` | - | sim |
| availability_domain | Availability domain | `string` | - | sim |
| ssh_public_key | Chave SSH pública | `string` | - | sim |
| instance_name | Nome da instância | `string` | `"compute-instance"` | não |
| instance_shape | Shape da instância | `string` | `"VM.Standard.E2.1.Micro"` | não |
| assign_public_ip | Atribuir IP público | `bool` | `false` | não |
| user_data | Script de inicialização | `string` | `null` | não |

## Outputs

| Nome | Descrição |
|------|-----------|
| instance_id | OCID da instância |
| public_ip | IP público (se atribuído) |
| private_ip | IP privado |
| ssh_connection | Comando SSH para conexão |

## Shapes Suportados

### Always Free
- VM.Standard.E2.1.Micro (1 OCPU, 1GB RAM)

### Shapes Flexíveis
- VM.Standard.E4.Flex
- VM.Standard.A1.Flex (ARM)

## User Data Examples

### Instalação Docker
```bash
#!/bin/bash
apt update
apt install -y docker.io
systemctl enable docker
systemctl start docker
usermod -aG docker debian
```

### Web Server
```bash
#!/bin/bash
apt update
apt install -y nginx
systemctl enable nginx
systemctl start nginx
echo "<h1>Hello from $(hostname)</h1>" > /var/www/html/index.html
```

## Segurança

- Chave SSH obrigatória para acesso
- Firewall configurado via Security Lists
- Backup automático em produção
- User data executado como root (cuidado)

## Conectar via SSH

```bash
# IP público
ssh debian@<PUBLIC_IP>

# IP privado (via bastion/VPN)
ssh debian@<PRIVATE_IP>
```