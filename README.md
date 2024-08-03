Docker compose for frappe-erpnext


bash:

docker-compose up -d
docker exec -it <web-container-id> bash
bench new-site mysite.local --mariadb-root-password 123 --admin-password admin
bench get-app erpnext --branch version-14
bench --site mysite.local install-app erpnext
