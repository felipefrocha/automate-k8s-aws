# Inicializando o ambiente de gerenciamento do backend 

echo '###################################################'
echo 'Inicializando ambiente de AWS e controle de estado'
echo '###################################################'
echo ''
cd terraform/s3
terraform init
terraform apply -auto-approve
echo ''
echo '#########################################################'
echo 'Finalizado inicalização do ambiente e controle de estado'
echo '#########################################################'
echo ''

# inicializando a infra base para 

echo ''
echo '#######################################'
echo '      Inicializando infra de rede'
echo '#######################################'
echo ''
cd ../vpc
terraform init
terraform apply -auto-approve
echo ''
echo '#######################################'
echo '      Infra de rede finalizada'
echo '#######################################'
echo ''


# Inicializando o Packer

echo ''
echo '#######################################'
echo '      Inicializando o packer'
echo '#######################################'
echo ''
cd ../../packer
packer build .
echo ''
echo '#######################################'
echo '            Packer ok'
echo '#######################################'
echo ''

# Inicializando restante do ambiente

echo ''
echo '#######################################'
echo '      Inicializando Infra Kubernetes'
echo '#######################################'
echo ''
cd ../terraform
terraform init
terraform apply -auto-approve
echo ''
echo '#######################################'
echo '     Infra de k8s pronta para usar'
echo '#######################################'
echo ''