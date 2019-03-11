ARG BASEIMAGE=elswork/tensorflow-diy:latest
FROM ${BASEIMAGE}

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL mantainer="Eloy Lopez <elswork@gmail.com>" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="tf-jupyterlab" \
    org.label-schema.description="JupyterLab + Tensorflow for amd64 and arm32v7" \
    org.label-schema.url="https://deft.work" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/DeftWork/tf-jupyterlab" \
    org.label-schema.vendor="Deft Work" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0"

#RUN apt-get update && apt-get install -y --no-install-recommends \
    #http://tardis.tiny-vps.com/aarm/packages/p/python-pyzmq/python-pyzmq-17.1.2-1-armv7h.pkg.tar.xz \
    #libzmq3-dev:armhf=4.1.4-7 \
    #http://ports.ubuntu.com/ubuntu-ports/ubuntu-ports/pool/universe/z/zeromq3/libzmq5_4.2.5-2ubuntu0.1_armhf.deb \
    #python3-zmq \
    #libzmq3-dev && \
    #apt-get clean && \
    #rm -rf /var/lib/apt/lists/*

#RUN python3 -m pip --no-cache-dir install --upgrade six pip

RUN pip3 --no-cache-dir install \
    #python-language-server \
    #https://www.piwheels.org/simple/pyzmq/pyzmq-17.0.0b2-cp36-cp36m-linux_armv7l.whl \
    #libzmq3-dev \
    #pyzmq \
    #https://www.piwheels.org/simple/pyzmq/pyzmq-16.0.2-cp36-cp36m-linux_armv7l.whl \
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

WORKDIR /notebooks

CMD jupyter lab --ip=* --no-browser --allow-root