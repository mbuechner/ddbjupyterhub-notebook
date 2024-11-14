FROM quay.io/jupyter/scipy-notebook:notebook-7.2.2

USER root

ENV TZ=Europe/Berlin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y upgrade\
    && apt-get install -y hunspell-de-de \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm /var/log/alternatives.log /var/log/apt/* \
    && rm -R /var/log/* /var/lib/apt/lists/*;

USER jovyan

# copy environment.yaml
COPY environment.yaml /tmp

# install packages from environment
RUN mamba env update -f /tmp/environment.yaml && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# RUN pip install jupyter-shared-drive
# RUN mamba env export --no-builds > /tmp/environment-new.yaml && \
#   cat /tmp/environment-new.yaml;

# Enable extensions
RUN jupyter labextension enable jupyter-ai jupyter-ai-magics jupyter-collaboration jupyter-shared-drive jupyter_scheduler jupyterlab-spellchecker;

# Download Spacy model
RUN python -m spacy download de_core_news_lg;
