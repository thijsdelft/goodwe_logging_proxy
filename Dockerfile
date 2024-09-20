FROM python:3.11-alpine as builder

WORKDIR /install
COPY goodwe_proxy_server/requirements.txt requirements.txt
RUN pip install setuptools wheel

#RUN apk upgrade --update-cache \
#    && apk add --no-cache --virtual .build-deps gcc musl-dev # \
#    # && pip wheel -r requirements.txt \
#    # &&  apk del .build-deps gcc musl-dev
        
# All these commands (pip wheel moet er nog tussen omdat die GCC nodig heeft) are in one RUN to get a lightweight image. However, we are using a builder image, and only use the resulting wheels.
# Cython lijkt helemaal niet nodig.
#RUN apk add --no-cache --virtual .build-deps gcc musl-dev \
#     && pip install cython \
#     && apk del .build-deps gcc musl-dev

RUN apk add --no-cache --virtual .build-deps gcc musl-dev
RUN pip wheel -r requirements.txt
#no need to worry to remove all APK in same RUN as we are lifting the artefacts from the builder.

FROM python:3.11-alpine
WORKDIR /app

# install python lib
COPY --from=builder /install/*.whl /tmp/
RUN pip install /tmp/*.whl

COPY goodwe_proxy_server/*.py ./

# run as user and group 1000
#USER 1000:1000

# start script
CMD [ "python3", "main.py"]
