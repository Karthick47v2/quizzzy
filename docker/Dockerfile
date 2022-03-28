# pulling out light-weight base image
FROM tiangolo/uvicorn-gunicorn:python3.8-alpine       

# copy to container 
COPY ./app /app

# initialize variables (ENV VAR)
ENV MAX_WORKERS = "1"
ENV WEB_CONCURRENCY = "1"

# install required libs  --disable cache for reduce size further
RUN pip install --no-cache-dir -r /app/requirements.txt