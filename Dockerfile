FROM elswork/tensorflow-diy:latest

LABEL mantainer="Eloy Lopez <elswork@gmail.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libzmq3-dev \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN  pip3 --no-cache-dir install \
     ipykernel \
     jupyterlab \
     #matplotlib \
     #sklearn \
     #pandas \
     && \
     python3 -m ipykernel.kernelspec	

COPY jupyter_notebook_config.py /root/.jupyter/

# Copy sample notebooks.
COPY notebooks /notebooks

# TensorBoard & Jupyter
EXPOSE 6006 8888

WORKDIR "/notebooks"

CMD jupyter lab --ip=* --no-browser --allow-root