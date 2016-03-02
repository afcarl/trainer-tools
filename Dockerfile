FROM soulshake/aws.cli:latest

COPY . /tools
WORKDIR /tools
RUN apt-get install -y \
    ssh
#    python-pip
#RUN pip install awscli
#RUN mkdir -p /root/.aws \
#    && { \
#        echo '[default]'; \
#        echo 'output = json'; \
#        echo 'region = $AWS_REGION'; \
##        echo 'aws_access_key_id = $AWS_ACCESS_KEY_ID'; \
#        echo 'aws_secret_access_key = $AWS_SECRET_ACCESS_KEY'; \
#   } > /root/.aws/config
ENTRYPOINT ["./trainer-cli"]
