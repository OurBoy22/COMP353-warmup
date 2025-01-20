# COMP353-warmup
This is the COMP353 warmup project for TEAM XX
By Luis Ramirez, xxx, xxx, and xxx

# Setup
## Prerequisites:
- Docker Desktop - https://www.docker.com/products/docker-desktop/
- MySQL client - https://dev.mysql.com/downloads/installer/

## Launching Database
- Set up the MySQL server instance by running the following command for docker: 
```
docker-compose build
docker-compose down
docker-compose up
``` 
The docker container should be running (see the green light)
![test](docker_image.PNG)

- Open up the MySQL database client, add a connection with the following credentials by going into "Database > Connect to Database":
```
IP: localhost - 127.0.0.1
PORT: 3306
username: myuser
password: mypassword
```
![test](MySQL_connection_image.PNG)
This should allow you to connect into the database. You can now write your own SQL Queries

## Loading Example data into the database
- Copy the contents in `sql/add_data.sql`, and paste it into the SQL query editor of the SQL Client

