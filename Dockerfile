FROM ghcr.io/maastrichtu-ids/jupyterlab:latest

# ADD requirements.txt .
# RUN pip install -r requirements.txt && \
#     rm requirements.txt

# Additional packages you might need to install
# conda install --quiet -y wget unzip


# $(yarn global bin)
ENV PATH="$PATH:$HOME/.yarn/bin"
# ADD package.json .
# RUN yarn install
RUN yarn global add @rmlio/yarrrml-parser
RUN yarn --cwd /opt add shex


# Download latest RML mapper in /opt/rmlmapper.jar
RUN curl -s https://api.github.com/repos/RMLio/rmlmapper-java/releases/latest \
    | grep browser_download_url | grep .jar | cut -d '"' -f 4 \
    | wget -O /opt/rmlmapper.jar -qi -


ADD jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

# ENTRYPOINT [ "/home/jovyan/work/prepare_docker.sh", "&&", "jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--config=/etc/jupyter/jupyter_notebook_config.py"]

# CMD [ "prepare_docker.sh", "&&", "start-notebook.sh" ]

# CMD [ "prepare_docker.sh", "&&", "start-notebook.sh" ]