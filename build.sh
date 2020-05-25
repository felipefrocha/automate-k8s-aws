# Inicializando o ambiente de gerenciamento do backend 

echo 'Inicializando ambiente de AWS e controle de estado'
cd terraform/s3
terraform init
terraform apply -auto-approve
echo 'Finalizado inicalização do ambiente e controle de estado'

# inicializando a infra base para 

echo 'Inicializando infra de rede'
cd ../vpc
terraform init
terraform apply -auto-approve
echo 'Infra de rede finalizada'

# Inicializando o Packer

echo 'Inicializando o packer'
cd ../../packer
packer build .
echo 'Packer ok'

# Inicializando restante do ambiente

echo 'Inicializando Infra Kubernetes'
cd ../terraform
terraform init
terraform apply -auto-approve
echo 'Infra de k8s pronta para usar'
