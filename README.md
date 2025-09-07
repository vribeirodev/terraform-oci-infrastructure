# Terraform OCI Infrastructure Modules

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Oracle Cloud](https://img.shields.io/badge/Oracle%20Cloud-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)

Módulos Terraform profissionais para Oracle Cloud Infrastructure (OCI) com foco em produtividade, segurança e melhores práticas.

## Visão Geral

Este repositório contém módulos Terraform reutilizáveis e exemplos completos para deplorar infraestrutura na Oracle Cloud. Todos os módulos são testados automaticamente e seguem as melhores práticas de segurança e governança.

### Características Principais

- **Produção-ready**: Módulos testados e validados automaticamente
- **Always Free**: Exemplos compatíveis com camada gratuita do OCI
- **Segurança**: Scans automáticos de segurança e melhores práticas
- **Documentação**: Documentação completa e exemplos funcionais
- **CI/CD**: Pipelines automatizados de validação e release

## Estrutura do Projeto

```
terraform-oci-infrastructure/
├── modules/                    # Módulos reutilizáveis
│   ├── networking/            # VCN, subnets, gateways
│   └── compute/               # Instâncias, configurações
├── examples/                  # Exemplos completos
│   ├── basic-infrastructure/  # Setup básico
│   └── web-application/       # App web com load balancer
└── .github/workflows/         # CI/CD pipelines
```

## Módulos Disponíveis

### Networking Module
Cria uma infraestrutura de rede completa com:
- Virtual Cloud Network (VCN)
- Subnets públicas e privadas
- Internet Gateway e NAT Gateway
- Security Lists configuradas
- Route Tables

```hcl
module "networking" {
  source = "./modules/networking"
  
  compartment_id      = var.compartment_id
  vcn_name           = "my-vcn"
  availability_domain = var.availability_domain
  
  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

### Compute Module
Cria instâncias compute otimizadas com:
- Instâncias Debian 12
- Configuração SSH automática
- User data para bootstrap
- Backup automático (produção)
- Shapes Always Free

```hcl
module "compute" {
  source = "./modules/compute"
  
  compartment_id      = var.compartment_id
  subnet_id          = module.networking.public_subnet_id
  availability_domain = var.availability_domain
  ssh_public_key     = file("~/.ssh/id_rsa.pub")
  
  instance_name    = "web-server"
  assign_public_ip = true
  
  user_data = <<-EOF
    #!/bin/bash
    apt update && apt install -y nginx
    systemctl enable --now nginx
  EOF
}
```

## Exemplos Disponíveis

### 1. Basic Infrastructure
Setup simples com networking e compute básico.

```bash
cd examples/basic-infrastructure
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com seus valores
terraform init && terraform apply
```

### 2. Web Application
Aplicação web completa com load balancer e alta disponibilidade.

```bash
cd examples/web-application  
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com seus valores
terraform init && terraform apply
```

## Quick Start

### Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [OCI CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm) configurado
- Conta Oracle Cloud Infrastructure
- Par de chaves SSH

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/terraform-oci-infrastructure.git
cd terraform-oci-infrastructure
```

### 2. Configure credenciais OCI

```bash
oci setup config
```

### 3. Deploy exemplo básico

```bash
cd examples/basic-infrastructure
cp terraform.tfvars.example terraform.tfvars

# Edite terraform.tfvars com:
# - compartment_id: OCID do seu compartimento
# - ssh_public_key: sua chave SSH pública

terraform init
terraform plan
terraform apply
```

### 4. Acesse sua infraestrutura

Após o deploy, use os outputs para acessar:

```bash
# SSH para instância
ssh debian@<PUBLIC_IP>

# Para web application
curl http://<LOAD_BALANCER_IP>
```

## Custos

Todos os exemplos usam recursos Always Free do OCI:

- **Compute**: 2x VM.Standard.E2.1.Micro (Always Free)
- **Network Load Balancer**: 10 Mbps (Always Free)  
- **Networking**: VCN, subnets, gateways (Always Free)
- **Storage**: 200GB total (Always Free)

**Custo estimado**: $0/mês dentro dos limites Always Free

## CI/CD e Qualidade

### Pipelines Automatizados

- **Terraform Validation**: Sintaxe e formato
- **Security Scanning**: TFSec, Checkov, GitLeaks
- **Module Testing**: Estrutura e integração
- **Release Management**: Versionamento automático

### Badges de Status

![Terraform Validation](https://github.com/seu-usuario/terraform-oci-infrastructure/workflows/Terraform%20Validation/badge.svg)
![Security Scanning](https://github.com/seu-usuario/terraform-oci-infrastructure/workflows/Security%20Scanning/badge.svg)
![Module Testing](https://github.com/seu-usuario/terraform-oci-infrastructure/workflows/Module%20Testing/badge.svg)

## Contribuição

### Desenvolvimento Local

```bash
# Validar módulos
terraform fmt -recursive
terraform validate

# Testar exemplos
cd examples/basic-infrastructure
terraform init -backend=false
terraform validate
```

### Guidelines

- Seguir convenções de naming do Terraform
- Documentar todas as variáveis e outputs  
- Adicionar exemplos para novos módulos
- Testar com `terraform validate` antes do commit
- Security scans devem passar

## Arquitetura de Referência

### Basic Infrastructure
```
┌─────────────────────────────────────┐
│              VCN                    │
│          10.0.0.0/16                │
├─────────────────┬───────────────────┤
│  Public Subnet  │  Private Subnet   │
│   10.0.1.0/24   │   10.0.2.0/24     │
│                 │                   │
│  [Compute]      │                   │
│  Internet GW    │    NAT Gateway    │
└─────────────────┴───────────────────┘
```

### Web Application
```
Internet → Load Balancer → [Web Server 1, Web Server 2]
              ↓                    ↓
         Public Subnet        Debian + Nginx
              ↓                    ↓
      Health Checks          Auto Scaling Ready
```

## Roadmap

- [ ] Módulo Database (Autonomous Database)
- [ ] Módulo Security (WAF, Vault)
- [ ] Kubernetes/OKE module
- [ ] Multi-region support
- [ ] Terraform Cloud integration
- [ ] Monitoring e observabilidade

## Recursos Úteis

- [Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs)
- [OCI Documentation](https://docs.oracle.com/en-us/iaas/)
- [OCI Always Free](https://www.oracle.com/cloud/free/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

## Licença

Este projeto é open source e está disponível sob a [MIT License](LICENSE).

## Contato

- **GitHub**: [@seu-usuario](https://github.com/seu-usuario)
- **LinkedIn**: [Seu Nome](https://linkedin.com/in/seu-perfil)
- **Email**: seu-email@exemplo.com

---

**⭐ Se este projeto foi útil, considere dar uma estrela!**