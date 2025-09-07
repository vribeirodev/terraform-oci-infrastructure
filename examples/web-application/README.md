# Web Application Example

Exemplo completo de aplicação web com alta disponibilidade usando Load Balancer no OCI.

## Arquitetura

```
Internet → Network Load Balancer → [Web Server 1, Web Server 2]
              ↓                          ↓
         Public Subnet              Debian + Nginx
```

## Recursos Criados

- **VCN** com subnets pública e privada
- **2 instâncias compute** com Nginx pré-configurado
- **Network Load Balancer** com health checks
- **Security Lists** configuradas para HTTP/HTTPS
- **Health check endpoint** automático

## Características

- Alta disponibilidade com múltiplos servidores
- Load balancing automático
- Health checks configurados
- Páginas web personalizadas mostrando informações do servidor
- Always Free eligible (usa recursos gratuitos do OCI)
- Auto-healing via health checks

## Pré-requisitos

1. **Conta OCI** configurada
2. **OCI CLI** instalado e configurado
3. **Par de chaves SSH** gerado
4. **Terraform** instalado

## Como usar

### 1. Gerar chave SSH (se não tiver)

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/oci_key
```

### 2. Configurar variáveis

```bash
# Copie o arquivo de exemplo
cp terraform.tfvars.example terraform.tfvars

# Edite com seus valores
nano terraform.tfvars
```

**Obrigatório preencher:**
- `compartment_id` - OCID do seu compartimento OCI
- `ssh_public_key` - Conteúdo da sua chave pública SSH

### 3. Deploy da infraestrutura

```bash
# Inicializar
terraform init

# Verificar o plano
terraform plan

# Aplicar (tempo estimado: 5-10 minutos)
terraform apply

# Confirmar com 'yes' quando solicitado
```

### 4. Testar a aplicação

Após o deploy, o Terraform exibirá os outputs com URLs e comandos de teste:

```bash
# Testar o Load Balancer
curl http://LOAD_BALANCER_IP

# Testar health check
curl http://LOAD_BALANCER_IP/health

# Teste de distribuição de carga
for i in {1..10}; do 
  curl -s http://LOAD_BALANCER_IP | grep Hostname
done
```

### 5. Acessar via browser

Abra no navegador: `http://LOAD_BALANCER_IP`

- Você verá uma página personalizada com informações do servidor
- Refresh da página mostra diferentes servidores (load balancing)
- Health check disponível em `/health`

## Outputs Importantes

| Output | Descrição |
|--------|-----------|
| `web_application_url` | URL principal da aplicação |
| `health_check_url` | URL do health check |
| `load_balancer_ip` | IP público do Load Balancer |
| `web_servers` | Informações dos servidores backend |
| `quick_test_commands` | Comandos prontos para teste |

## Monitoramento

### Health Checks
- **Protocolo:** HTTP
- **Porta:** 80
- **Path:** `/`
- **Intervalo:** 10 segundos
- **Timeout:** 3 segundos
- **Retries:** 3

### Logs dos Servidores
```bash
# SSH para um servidor
ssh debian@SERVER_IP

# Ver logs do Nginx
sudo tail -f /var/log/nginx/access.log

# Ver logs de inicialização
sudo cat /var/log/web_server_init.log
```

## Troubleshooting

### Load Balancer não responde
```bash
# Verificar status dos backends
oci nlb backend list --backend-set-name web-backend-set --network-load-balancer-id LOAD_BALANCER_ID

# Testar servidores diretamente
curl http://SERVER_1_IP
curl http://SERVER_2_IP
```

### Servidor não responde
```bash
# SSH para o servidor
ssh debian@SERVER_IP

# Verificar status do Nginx
sudo systemctl status nginx

# Reiniciar se necessário
sudo systemctl restart nginx
```

### Health Check falhando
```bash
# Testar health endpoint diretamente
curl http://SERVER_IP/health

# Verificar configuração do Nginx
sudo nginx -t
```

## Customização

### Alterar número de servidores
```hcl
# No terraform.tfvars
web_server_count = 3  # Até 4 servidores
```

### Usar shape diferente
```hcl
# No terraform.tfvars
instance_shape = "VM.Standard.E4.Flex"
```

### Personalizar conteúdo web
Edite o arquivo `scripts/web_server_init.sh` e execute `terraform apply` novamente.

## Custos

Esta configuração usa recursos Always Free do OCI:
- **Compute:** 2x VM.Standard.E2.1.Micro (Always Free)
- **Network Load Balancer:** 10 Mbps (Always Free)
- **Networking:** VCN, subnets, gateways (Always Free)

**Custo total:** $0/mês dentro dos limites Always Free

## Limpeza

```bash
# Destruir toda a infraestrutura
terraform destroy

# Confirmar com 'yes' quando solicitado
```

## Próximos Passos

1. **SSL/TLS:** Adicionar certificado e HTTPS
2. **Database:** Conectar a um banco de dados
3. **CDN:** Adicionar distribuição de conteúdo
4. **Auto Scaling:** Implementar scaling automático
5. **Monitoring:** Adicionar métricas e alertas
6. **CI/CD:** Automatizar deploys

## Segurança

- Firewalls configurados via Security Lists
- SSH apenas com chave pública
- Load Balancer em subnet pública
- Servidores podem ser movidos para subnet privada
- Health checks garantem disponibilidade
