FROM ubuntu:focal-20220922

MAINTAINER Sanjeev Rana: 'srana@mirantis.com'

WORKDIR /terraform

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get install -y \
    git \
    curl \
    lsb-release \
    iputils-ping \
    vim \
    unzip \
    wget \
    python3 \
    python3-pip

#Install bot3 and community.kubernetes
RUN pip3 install boto3
RUN python3.8 -m pip install ansible && /usr/local/bin/ansible-galaxy collection install community.kubernetes


# Installing terraform

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && apt update && apt install terraform


# Clone the repository, move the code and then delete unwanted directory
RUN git clone "https://github.com/sanjeevrana-hp/aws-vanilla-k8s.git" && mv /terraform/aws-vanilla-k8s/* /terraform && rm -rf /terraform/aws-vanilla-k8s/

# Change the default /etc/ansible/ansible.cfg
COPY ansible.cfg /etc/ansible/ansible.cfg

ENV HOME /terraform
ENTRYPOINT ["/bin/bash"]
