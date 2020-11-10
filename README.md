To start work with devenv:

0. Create your own branch from develop.

1. Create a file named ".env" in the root of the project. Paste in it this string: COMPOSE_FILE=devenv/docker-compose.yml

2. docker-compose up -d

3. docker exec -it play-php bash

4. Take dump.sql.gz and place it at /home/your-username/project_data/m2playground/mysqldump/. Sudo may be needed. 

5. Step-by-step. Read everything on your screen carefully. 

To apply changes:

0. Merge your branch to testN.

1. Check: https://gitlab.mavenecommerce.com/maven/m2playground/-/pipelines