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

RUN pip3 --no-cache-dir install \
    ipykernel \
    jupyterlab \
    && \
    python3 -m ipykernel.kernelspec

COPY jupyter_notebook_config.py /root/.jupyter/

# Copy sample notebooks.
COPY notebooks /notebooks

# TensorBoard & Jupyter
EXPOSE 6006 8888

WORKDIR /notebooks

CMD jupyter lab --ip=* --no-browser --allow-root