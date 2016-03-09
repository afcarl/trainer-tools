FROM soulshake/aws.cli:latest

RUN apt-get install -y \
    ssh \
    curl \
    jq \
    bsdmainutils \
    pssh \
    python-pip

RUN curl --silent https://get.docker.com/ | sh
RUN pip install -U docker-compose
#COPY . /trainer-tools
#WORKDIR /trainer-tools
#ENTRYPOINT ["scripts/trainer-cli"]
