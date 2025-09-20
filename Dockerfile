FROM python:3.12

MAINTAINER "JBraunsmaJr"
LABEL github="https://github.com/JBraunsmaJr/Jetbrains-Client-Downloader"

WORKDIR /home/user

RUN apt-get update && \
    apt-get install -y curl && \
    curl -L "https://download.jetbrains.com/idea/code-with-me/backend/jetbrains-clients-downloader-linux-x86_64-2149.tar.gz" -o clients_downloader.tar.gz

RUN tar -xvf clients_downloader.tar.gz

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY --chmod=777 download.sh .
COPY main.py .

VOLUME "/home/user/output"
ENTRYPOINT [ "python", "main.py" ]