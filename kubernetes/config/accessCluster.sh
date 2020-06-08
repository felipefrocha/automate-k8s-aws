TOKEN=$(kubectl describe secrets -n kube-system $(kubectl get secrets -n kube-system | grep default | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d '\t' | tr -d " ")
echo $TOKEN
APISERVER=$(kubectl config view | grep https | cut -f 2- -d':' | tr -d " ")
echo $APISERVER
curl $APISERVER --header "Authorization: Bearer $TOKEN" --insecure
