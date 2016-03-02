FROM soulshake/aws.cli:latest

COPY . /tools
WORKDIR /tools
RUN apt-get install -y \
    ssh \
    curl \
    jq \
    bsdmainutils
ENTRYPOINT ["./trainer-cli"]
