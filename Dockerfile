FROM python:3.11-alpine as builder

WORKDIR /install
COPY goodwe_proxy_server/requirements.txt requirements.txt
RUN echo $PATH
ENV PATH="$PATH:/opt/bin"
RUN echo $PATH
RUN echo $PATH; pip install setuptools wheel
RUN echo $PATH; which ls gcc nano; pip wheel -r requirements.txt


FROM python:3.11-alpine
WORKDIR /app

# install python lib
COPY --from=builder /install/*.whl /tmp/
RUN pip install /tmp/*.whl

COPY goodwe_proxy_server/*.py ./

# run as user and group 1000
USER 1000:1000

# start script
CMD [ "python3", "main.py"]
