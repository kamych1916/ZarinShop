import os


def delete_file(del_file):
    try:
        with open('/app/images/' + del_file, "wb") as buffer:
            os.remove(buffer.name)
    finally:
        return