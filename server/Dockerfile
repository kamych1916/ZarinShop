FROM python:3
RUN pip install fastapi uvicorn
RUN pip install pymongo
RUN pip install aiohttp
RUN pip install python-jose
COPY ./app /app
WORKDIR /app
CMD ["uvicorn", "server:app", "--host", "0.0.0.0" ,"--port" ,"80","--reload"]