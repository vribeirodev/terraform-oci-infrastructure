# Basic Infrastructure Example

Este exemplo demonstra como usar o módulo de networking para criar uma infraestrutura básica no OCI.

## O que será criado

- Virtual Cloud Network (VCN)
- Internet Gateway e NAT Gateway
- Subnet pública e privada
- Security Lists e Route Tables

## Como usar

### 1. Configurar credenciais OCI

```bash
# Configure o OCI CLI
oci setup config
```

### 2. Preparar variáveis

```bash
# Copie o arquivo de exemplo
cp terraform.tfvars.example terraform.tfvars

# Edite com seus valores
nano terraform.tfvars
```

**Obrigatório:** Preencha o `compartment_id` com o OCID do seu compartimento.

### 3. Deploy

```bash
# Inicializar
terraform init

# Planejar
terraform plan

# Aplicar
terraform apply
```

### 4. Limpeza

```bash
terraform destroy
```

## Outputs

Após o deploy, você terá acesso aos IDs dos recursos criados para usar em outros projetos.

## Custos

Esta configuração usa apenas recursos Always Free do OCI, não gerando custos.