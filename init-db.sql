CREATE DATABASE mysite;
CREATE USER 'frappe'@'localhost' IDENTIFIED BY 'frappe';
GRANT ALL PRIVILEGES ON *.* TO 'frappe'@'localhost';
FLUSH PRIVILEGES;
