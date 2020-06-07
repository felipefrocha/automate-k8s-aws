
#Install NFS file system (not the best performance)
apt-get install nfs-kernel-server -y
# Create dir
mkdir /opt/teste-1
# Permission
chmod 1777 /opt/teste-1/
# Add rule to nfs
echo '/opt/teste-1 *(rw,sync,no_root_squash,subtree_check)' >> /etc/exports
exportfs -ra
# Inicial 
touch /opt/teste-1/FUNCIONA
vim primeiro-pv.yaml
kubectl create -f primeiro-pv.yaml 
kubectl get pv
cat primeiro-pv.yaml 
vim pvc.yaml
kubectl crete -f pvc.yaml 
kubectl create -f pvc.yaml 
kubectl get pvc
vim nfs-pvc.yaml
kubectl create nfs-pvc.yaml 
kubectl create -f nfs-pvc.yaml 
kubectl get deployments.apps 
kubectl get po
kubectl get po -o wide
kubectl describe deployments.apps nginx 
kubectl exec -ti nginx-74685fd5cf-zgg4h  --sh
kubectl exec -ti nginx-74685fd5cf-zgg4h  -- sh
vim /opt/teste-1/FUNCIONA 
touch /opt/teste-1/TESTE
kubectl exec -ti nginx-74685fd5cf-zgg4h  -- sh
kubectl delete deployments.apps nginx 
ls /opt/teste-1/
history