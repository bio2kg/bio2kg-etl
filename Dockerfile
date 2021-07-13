FROM quay.io/redhat-github-actions/runner:latest as runner
LABEL org.opencontainers.image.source https://github.com/bio2kg/bio2kg-etl
USER root

# dnf not working
# RUN dnf -y upgrade --security && \
#     dnf -y install wget

# RUN chown -R 1000:1000 /opt
# USER $UID

# Install conda
ARG conda_version="4.10.3"
ARG miniforge_patch_number="0"
ARG miniforge_python="Mambaforge"
ARG miniforge_arch="x86_64"
ARG miniforge_version="${conda_version}-${miniforge_patch_number}"
ENV miniforge_installer="${miniforge_python}-${miniforge_version}-Linux-${miniforge_arch}.sh"

ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    # LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH="${CONDA_DIR}/bin:${PATH}" \
    # HOME="/home/${NB_USER}" \
    CONDA_VERSION="${conda_version}"

RUN curl -Lf "https://github.com/conda-forge/miniforge/releases/download/${miniforge_version}/${miniforge_installer}" -o miniforge.sh && \
    /bin/bash "miniforge.sh" -f -b -p "${CONDA_DIR}" && \
    rm "miniforge.sh" && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true

RUN conda install --quiet -y \
    "conda=${CONDA_VERSION}" \
    pip \
    wget \
    nodejs \
    yarn \
    openjdk 
RUN conda update --all --quiet -y && \
    conda clean --all -f -y 

ADD requirements.txt .
RUN conda install --file requirements.txt && \
    rm requirements.txt

# WORKDIR /root

# RUN chown -R $UID:$GID /opt
# USER $UID

# Download latest RML mapper in /opt/rmlmapper.jar
# RUN curl -s https://api.github.com/repos/RMLio/rmlmapper-java/releases/latest \
#     | grep browser_download_url \
#     | grep .jar \
#     | cut -d '"' -f 4 \
#     | wget -O /opt/rmlmapper.jar -qi -
# RUN export download_url=$(curl -s https://api.github.com/repos/RMLio/rmlmapper-java/releases/latest | grep browser_download_url | grep .jar | cut -d '"' -f 4) && \
#     curl -L -o rmlmapper.jar $download_url 
# RUN npm i -g @rmlio/yarrrml-parser