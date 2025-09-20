FROM ubuntu:25.10

WORKDIR /home/user

RUN apt-get update && \
    apt-get install -y curl && \
    curl -L "https://download.jetbrains.com/idea/code-with-me/backend/jetbrains-clients-downloader-linux-x86_64-2149.tar.gz" -o clients_downloader.tar.gz

COPY --chmod=777 pull-remote.sh .

RUN tar -xvf clients_downloader.tar.gz

VOLUME "/home/user/output"
ENTRYPOINT [ "./pull-remote.sh" ]