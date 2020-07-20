## Kube Volumes

[Volumes](https://kubernetes.io/docs/concepts/storage/volumes/) são um diretório gerido por um sistema de arquivos (FS), como o nfs.
Esses volumes são utilizados para persistir dados de um container (que roda em um [pod](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/)). Esse tipo de solução garante que containers, os quais tem um ciclo de vida efêmero, possam retornar (ao serem reinicializados) de onde estavam sem que haja uma perda do estado em que rodavam anteriormente.

São configurados em dois pontos de uma arquivo yaml, `.spec.volumes`e `.spec.containers[*].volumeMoutns`

Existe uma variedade de sistemas de arquivo compatilhado que podem ser utilizados entre eles o [PVC](#pvc). 

## Kube PesistentVolume <a name="pv"></>

Volumes persistentes são componentes do kubernetes que permitem não somente a persistência de um volume, mas o gerenciamento e compartilhamento entre diferentes containers de diferentes pods para o mesmo. 

## Kube PersistentVolumesClaim <a name="pvc"></>