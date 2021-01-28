import os
import shutil

from fastapi import APIRouter, UploadFile, File
from models.files import*
router = APIRouter()
@router.post("/api/v1/uploadfile/")
async def create_upload_file(file: UploadFile = File(...)):
    try:
      with open('/app/images/' + file.filename, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    finally:
      file.file.close()
    return {"file_name": file.filename, "file_url":"https://mirllex.site/img/" + file.filename}




@router.post("/api/v1/del_file/")
async def create_upload_file(del_file:del_file):
    try:
        with open('/app/images/' + del_file.name, "wb") as buffer:
           os.remove(buffer.name)
    finally:
        return


