Run bootstrap.sh

ssh into master and run master.sh
run kubeadm join with --control-plane on other masters
and kubeadm join on worker


cp {k8s-master1}:/etc/kubernetes/admin.conf ${HOME}/kube/config
