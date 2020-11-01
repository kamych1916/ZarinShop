FROM python:3
RUN pip install fastapi uvicorn
RUN pip install pymongo
RUN pip install aiohttp
RUN pip install python-jose
RUN pip install python-multipart
COPY ./app /app
CMD  ["/app","uvicorn", "server:app", "--host", "0.0.0.0" ,"--port" ,"80","--reload"]