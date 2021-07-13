FROM ghcr.io/maastrichtu-ids/jupyterlab:latest



# Download latest RML mapper in /opt/rmlmapper.jar
RUN curl -s https://api.github.com/repos/RMLio/rmlmapper-java/releases/latest \
    | grep browser_download_url \
    | grep .jar \
    | cut -d '"' -f 4 \
    | wget -O /opt/rmlmapper.jar -qi -

RUN npm i -g @rmlio/yarrrml-parser


# FROM quay.io/redhat-github-actions/runner:latest as runner
# USER root
# RUN dnf module install -y nodejs:14/default

## Install conda
# ENV CONDA_DIR=/opt/conda \
#     SHELL=/bin/bash \
#     LC_ALL=en_US.UTF-8 \
#     LANG=en_US.UTF-8 \
#     LANGUAGE=en_US.UTF-8
# ENV PATH="${CONDA_DIR}/bin:${PATH}" \
#     # HOME="/home/${NB_USER}" \
#     CONDA_VERSION="${conda_version}"
# RUN wget --quiet "https://github.com/conda-forge/miniforge/releases/download/${miniforge_version}/${miniforge_installer}" && \
#     /bin/bash "${miniforge_installer}" -f -b -p "${CONDA_DIR}" && \
#     rm "${miniforge_installer}" && \
#     conda config --system --set auto_update_conda false && \
#     conda config --system --set show_channel_urls true
# RUN conda install --quiet --yes \
#     pip \
#     "conda=${CONDA_VERSION}" \
#     nodejs \
#     yarn \
#     openjdk 
# RUN conda update --all --quiet --yes && \
#     conda clean --all -f -y 

# USER $UID