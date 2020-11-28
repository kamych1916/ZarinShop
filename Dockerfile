FROM python:3
RUN pip install fastapi uvicorn
RUN pip install pymongo
RUN pip install aiohttp
RUN pip install python-jose
RUN pip install python-multipart
COPY ./app /app
WORKDIR /app
CMD ["uvicorn", "server:app","--reload","--host", "0.0.0.0", "--port","80"]