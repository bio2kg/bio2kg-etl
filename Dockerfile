FROM ghcr.io/maastrichtu-ids/jupyterlab:latest

# ADD requirements.txt .
# RUN pip install -r requirements.txt && \
#     rm requirements.txt

# Additional packages you might need to install
# conda install --quiet -y wget unzip


ENV PATH="$PATH:$HOME/.yarn/bin"
RUN yarn global add @rmlio/yarrrml-parser
RUN yarn --cwd /opt add shex

# Install RocketRML, useless if workspace mounted
# ADD package.json .
# RUN yarn install

# Download latest RML mapper in /opt/rmlmapper.jar
RUN curl -s https://api.github.com/repos/RMLio/rmlmapper-java/releases/latest \
    | grep browser_download_url | grep .jar | cut -d '"' -f 4 \
    | wget -O /opt/rmlmapper.jar -qi -

RUN mkdir -p ~/.local/share/d2s && \
    cp /opt/rmlmapper.jar ~/.local/share/d2s/rmlmapper.jar

# Use custom config to make sure d2s is cloned and installed at start
# USER root
COPY jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py
# --chown=root:0
# USER $NB_USER

# ENTRYPOINT [ "jupyter", "lab", "--no-browser", "--allow-root", "--ip=0.0.0.0", "--port=8888", "--config=/etc/jupyter/jupyter_notebook_config.py"]

# ENTRYPOINT [ "/home/jovyan/work/prepare_docker.sh", "&&", "jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--port=8888", "--config=/etc/jupyter/jupyter_notebook_config.py"]
# CMD [ "prepare_docker.sh", "&&", "start-notebook.sh" ]
# CMD [ "prepare_docker.sh", "&&", "start-notebook.sh" ]