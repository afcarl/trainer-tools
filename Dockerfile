FROM soulshake/aws.cli:latest

RUN apt-get install -y \
    ssh \
    curl \
    jq \
    bsdmainutils \
    pssh
#COPY . /trainer-tools
#WORKDIR /trainer-tools
#ENTRYPOINT ["scripts/trainer-cli"]
