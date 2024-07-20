# Use a imagem base do Ubuntu
FROM ubuntu:latest


# Atualizar os pacotes do sistema e instalar dependências
RUN apt-get update && \
    apt-get install -y \
    curl \
    unzip \
    wget \
    gnupg \
    software-properties-common \
    openssh-client \
    git \
    iputils-ping \
    apt-transport-https \
    ca-certificates

# Instalar o AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws/

# Instalar o Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && \
    apt-get install -y terraform && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir iac/
VOLUME iac/

# Definir o ponto de entrada padrão para bash
CMD ["/bin/bash"]
