kubectl create deploy web --dry-run=client --image=nginx:1.15 -o yaml > deploy.yaml
kubectl apply -f deploy.yaml
ls
kubectl get deploy,rs,po
kubectl get deploy,rs,po -o wide
kubectl rollout history deployment web 
kubectl scale deployment --replicas=3 web 
kubectl rollout history deployment web 

vim deploy.yaml # alter replica
kubectl apply -f deploy.yaml 
kubectl rollout history deployment web 
kubectl rollout history deployment web  --revision=1
kubectl set image deploy web nginx=nginx:1.16-alphine
kubectl rollout history deployment web  --revision=3
kubectl get deploy,rs,po
kubectl rollout undo deployment web --to-revision=1
kubectl get deploy,rs,po
kubectl rollout history deployment web 
kubectl rollout undo deployment web --to-revision=3
kubectl rollout history deployment web 

vim deploy.yaml # alter version
kubectl apply -f deploy.yaml 
kubectl rollout history deployment web 
kubectl get deploy,rs,po

