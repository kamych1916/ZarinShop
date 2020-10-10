# ZarinShop
Zarin Shop Project 

Настройка базы
В C:\Users\www\Desktop\zarinshop\ZarinShop\MongoStore\config.txt
Указать 
##store data
dbpath=Полностью путь \ZarinShop\MongoStore\data
 
##all output go here
logpath=Полностью путь \ZarinShop\MongoStore\log\mongo.log

Запускать базу через 
1. ZarinShop\Mongo\bin\mongod.exe --config путь до файла ZarinShop\MongoStore\config.txt
2. mongo.exe

Запуск проекта
uvicorn server:app --reload
