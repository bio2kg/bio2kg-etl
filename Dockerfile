FROM condaforge/mambaforge:latest

LABEL org.opencontainers.image.source https://github.com/bio2kg/bio2kg-etl

RUN apt-get update
RUN apt-get install -y build-essential

RUN conda install --quiet -y \
    conda \
    pip \
    wget curl unzip \
    nodejs \
    yarn \
    openjdk \
    maven
    # sbt
    # pugixml
RUN conda update --all --quiet -y && \
    conda clean --all -f -y 


ADD requirements.txt .
RUN pip install -r requirements.txt && \
    rm requirements.txt


# $(yarn global bin)
ENV PATH="$PATH:$HOME/.yarn/bin"
ADD package.json .
RUN yarn install
RUN yarn global add @rmlio/yarrrml-parser
RUN yarn --cwd /opt add shex


# Download latest RML mapper in /opt/rmlmapper.jar
RUN curl -s https://api.github.com/repos/RMLio/rmlmapper-java/releases/latest \
    | grep browser_download_url | grep .jar | cut -d '"' -f 4 \
    | wget -O /opt/rmlmapper.jar -qi -

