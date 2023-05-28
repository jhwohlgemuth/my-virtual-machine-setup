FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y dos2unix figlet make

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]