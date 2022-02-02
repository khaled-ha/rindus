# Build Image
FROM    python:3.9-slim-bullseye as builder
RUN apt-get -y update
RUN apt-get -y install git 

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --upgrade pip

COPY  requirements.txt /tmp

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt


FROM python:3.9-slim-bullseye
# Run the image

EXPOSE  8000/tcp

RUN     mkdir -p /rindus_test/ && \
        addgroup --gid 9999 python && \
        adduser --system --disabled-password --gecos '' --gid 9999 -uid 9999 python && \
        chown python:python /rindus_test/

# Set the working directory to /rindus_test
WORKDIR /rindus_test

COPY    --from=builder /opt/venv /opt/venv

ENV     PYTHONPATH /rindus_test/
ENV     PATH="/opt/venv/bin:$PATH"
COPY ./rindus_test/ /rindus_test/
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]