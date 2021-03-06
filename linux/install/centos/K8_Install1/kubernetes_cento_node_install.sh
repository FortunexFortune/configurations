#! /bin/bash
#Kubernetes setup with kubeadm, kubectl adn kubelet

#Remove docker dependencies 
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
                  
                  
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2                  
                  
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
    
#installing docker 
yum install -y docker-ce-18.06.1.ce-3.el7 

#Prevents docker from ever updating
yum -y install yum-versionlock
yum versionlock add docker-ce
yum versionlock list
yum list updates | cat -n


#Starting docker
systemctl start docker
systemctl enable docker
systemctl status docker
docker run hello-world

#Add the Kubernetes repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

# Set SELinux in permissive mode (effectively disabling it)
# don't do this in production
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

#instakk kubeadm , kubectl and kubelet
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet
kubeadm version

#Conditional will keep asking for token and hash until the exit status of the kubeadm join comand is 0 
while true      
do
  echo "============================================"
  echo "insert cluster token and hash :"
  echo "============================================"
  echo " > "
  read INPUT
  eval "$INPUT" 2>> /dev/null
  if [[ "$?" == "0" ]] && [[ "${INPUT:0:12}" == "kubeadm join" ]];
    then
      break
  fi
done

#Flannel setup
echo "net.bridge.bridge-nf-call-iptables=1" | tee -a /etc/sysctl.conf
sysctl -p

#sudo chmod 766 configurations/linux/install/centos/K8_Install1/kubernetes_cento_node_install.sh &&  sudo configurations/linux/install/centos/K8_Install1/kubernetes_cento_node_install.sh
