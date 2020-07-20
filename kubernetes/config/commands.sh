
# Descrição dos nós
kubectl get node
kubectl describe node $(kubectl get nodes | grep worker | head -n 1 | cut -d' ' -f1)

# Join command
kubeadm token create --print-join-command

# Namespace command
kubectl get namespaces --all

kubectl get po
kubectl run --image=nginx nginx
kubectl get pods
kubectl describe pods nginx

kubectl get pods nginx -o yaml
cat po_nginx.yaml
kubectl run --image=nginx webnginx --dry-run=client -o yaml > po_nginx.yaml
kubectl delete pods nginx
kubectl get pods
kubectl create -f po_nginx.yaml
kubectl get pods
kubectl delete pods webnginx


kubectl create deployment webserver --image=nginx --dry-run=client -o yaml > deploy_nginx.yaml
cat deploy_nginx.yaml
kubectl create -f deploy_nginx.yaml
kubectl get deploy
kubectl get po

kubectl delete -f deploy_nginx.yaml
kubectl get po,deploy

# Namespaces
kubectl create namespace vlad
cat deploy_nginx.yaml
kubectl create deployment webserver --image=nginx --dry-run=client -o yaml > deploy_nginx.yaml
kubectl create -f deploy_nginx.yaml -n vlad
kubectl get deploy -n vlad
kubectl get po -n vlad

kubectl get deploy, po 
kubectl get deploy, po -n vlad

kubectl delete -f deploy_nginx.yaml -n vlad
kubectl get po,deploy

kubectl get no,deploy,rs,po,svc -o wide

kubectl explain deployment
kubectl explain pod
kubectl explain pod --recursive
kubectl explain deployment.spec.template.spec

kubectl create deployment webserver --image=nginx --dry-run=client -o yaml > deploy_nginx.yaml
kubectl create -f deploy_nginx.yaml
kubectl expose deploy webserver --port 80
kubectl get deploy,svc,po -o wide
curl $(kubectl get svc webserver| grep webserver | cut -d ' ' -f7)
kubectl delete svc webserver
kubectl create -f deploy_nginx.yaml
kubectl expose deploy webserver --port 80 --type NodePort
kubectl get deploy,svc,po -o wide
curl $(kubectl get svc webserver| grep webserver | cut -d ' ' -f7)
kubectl delete svc webserver
kubectl create -f deploy_nginx.yaml
kubectl expose deploy webserver --port 80 --type LoadBalancer
kubectl get deploy,svc,po -o wide
curl $(kubectl get svc webserver| grep webserver | cut -d ' ' -f7)
kubectl delete deploy,svc webserver

## https://metallb.universe.tf/




# Atualizando a Page do nginx

kubectl create deployment webserver --image=nginx --dry-run=client -o yaml > deploy_nginx.yaml
kubectl create -f deploy_nginx.yaml
kubectl expose deploy webserver --port 80 --type NodePort
kubectl get deploy,svc,po -o wide
curl $(kubectl get svc webserver| grep webserver | cut -d ' ' -f7)

kubectl exec -it $(kubectl get po | grep webserver | cut -d ' ' -f1) bash  
echo '<html lang="en"><head><meta charset="UTF-8">><title>Teste</title></head><body><h1>TESTE FELIPE </h1></div></body></html>' > /usr/share/nginx/html/index.html
kubectl cp index.html $(kubectl get po | sed -n 2p | cut -d ' ' -f1):/usr/share/nginx/html/

kubectl logs -f $(kubectl get po | sed -n 2p | cut -d ' ' -f1)
