# Módulo de Networking

Este módulo cria uma configuração completa de rede no Oracle Cloud Infrastructure (OCI) incluindo:

- Virtual Cloud Network (VCN)
- Internet Gateway
- NAT Gateway
- Subnets Públicas e Privadas
- Tabelas de Rota
- Listas de Segurança

## Funcionalidades

- ✅ **Configuração pronta para produção**
- ✅ **Arquitetura de subnet pública/privada**
- ✅ **Listas de segurança** com padrões sensatos
- ✅ **Blocos CIDR configuráveis**
- ✅ **Suporte a tags** de recursos

## Como Usar

```hcl
module "networking" {
  source = "../modules/networking"
  
  compartment_id      = var.compartment_id
  vcn_name           = "minha-app-vcn"
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  
  vcn_cidr_blocks      = ["10.0.0.0/16"]
  public_subnet_cidr   = "10.0.1.0/24"
  private_subnet_cidr  = "10.0.2.0/24"
  
  tags = {
    Environment = "dev"
    Project     = "minha-app"
  }
}
```

## Requisitos

| Nome | Versão |
|------|--------|
| terraform | >= 1.0 |
| oci | >= 5.0 |

## Variáveis de Entrada

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| compartment_id | O OCID do compartimento | `string` | n/a | sim |
| vcn_name | Nome de exibição para a VCN | `string` | `"main-vcn"` | não |
| vcn_cidr_blocks | Blocos CIDR para a VCN | `list(string)` | `["10.0.0.0/16"]` | não |
| public_subnet_cidr | Bloco CIDR para subnet pública | `string` | `"10.0.1.0/24"` | não |
| private_subnet_cidr | Bloco CIDR para subnet privada | `string` | `"10.0.2.0/24"` | não |
| availability_domain | Domínio de disponibilidade para as subnets | `string` | n/a | sim |
| tags | Tags a aplicar aos recursos | `map(string)` | `{}` | não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| vcn_id | OCID da VCN |
| public_subnet_id | OCID da subnet pública |
| private_subnet_id | OCID da subnet privada |
| internet_gateway_id | OCID do Internet Gateway |
| nat_gateway_id | OCID do NAT Gateway |
| public_route_table_id | OCID da tabela de rota pública |
| private_route_table_id | OCID da tabela de rota privada |
| public_security_list_id | OCID da lista de segurança pública |
| private_security_list_id | OCID da lista de segurança privada |

## Diagrama de Rede

```
┌─────────────────────────────────────┐
│              VCN                    │
│          10.0.0.0/16                │
├─────────────────┬───────────────────┤
│  Public Subnet  │  Private Subnet   │
│   10.0.1.0/24   │   10.0.2.0/24     │
│                 │                   │
│  Internet GW    │    NAT Gateway    │
└─────────────────┴───────────────────┘
```

## Security Lists

**Public Subnet:**
- Ingress: HTTP (80), HTTPS (443), SSH (22)
- Egress: All traffic

**Private Subnet:**
- Ingress: VCN traffic only
- Egress: All traffic (via NAT)