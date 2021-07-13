FROM ghcr.io/maastrichtu-ids/jupyterlab:latest

# Download latest RML mapper in /opt/rmlmapper.jar
RUN curl -s https://api.github.com/repos/RMLio/rmlmapper-java/releases/latest \
    | grep browser_download_url \
    | grep .jar \
    | cut -d '"' -f 4 \
    | wget -O /opt/rmlmapper.jar -qi -

RUN npm i -g @rmlio/yarrrml-parser
