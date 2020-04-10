# Understanding Jenkins: Running Jenkins and Docker on a server in AWS
To practice installing Jenkins and Docker manually without a server, you can use Vagrant: https://www.vagrantup.com. You can clone this repository and use vagrant up and vagrant ssh:
```
git clone git@github.com:getintodevops/bestpractices-docker-jenkins.git
cd bestpractices-docker-jenkins/understanding-jenkins
vagrant up && vagrant ssh
```

# Install Docker on Ubuntu
```
sudo apt update

sudo apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt update

sudo apt install docker-ce

sudo usermod -a -G docker ubuntu

docker version
```

# Install Java 8 and Jenkins
```
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo add-apt-repository ppa:webupd8team/java -y

sudo apt update

sudo apt install oracle-java8-set-default

java -version

sudo apt install jenkins

sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
