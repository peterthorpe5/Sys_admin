# install singularity

# Install system dependencies
sudo yum groupinstall -y 'Development Tools' && \
  sudo yum install -y epel-release && \
  sudo yum install -y golang openssl-devel libuuid-devel libseccomp-devel squashfs-tools


# Install Golang
export VERSION=1.11.4 OS=linux ARCH=amd64  # change this as you need

wget -O /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz && \
  sudo tar -C /usr/local -xzf /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz

# put in path 
echo 'export GOPATH=${HOME}/go' >> ~/.bashrc && \
  echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> ~/.bashrc && \
  source ~/.bashrc
  

# Install golangci-lint
curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh |
  sh -s -- -b $(go env GOPATH)/bin v1.15.0  

# extra depenedency
  
yum install openssl-devel
yum install libuuid-devel

# Clone the repo of singularity
mkdir -p ${GOPATH}/src/github.com/sylabs && \
  cd ${GOPATH}/src/github.com/sylabs && \
  git clone https://github.com/sylabs/singularity.git && \
  cd singularity


# stable release 
git checkout v3.2.0

# Compiling Singularity
cd ${GOPATH}/src/github.com/sylabs/singularity && \
  ./mconfig && \
  cd ./builddir && \
  make && \
  sudo make install
  

singularity version  


###########################################################
# To run
full doc: https://www.sylabs.io/guides/3.2/user-guide/

# to get an image: (search here: https://hub.docker.com/)

# singularity pull docker:nextgenusfs/funannotate

# for braker:
singularity pull docker:bschiffthaler/braker

singularity shell braker_latest.sif

