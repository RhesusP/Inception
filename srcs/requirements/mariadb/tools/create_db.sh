#!/bin/sh

print_success() {
	printf "\e[32m ✔\e[0m %s\t\e[32msuccess\e[0m\n" "$1"

}

print_failure() {
	printf "\e[31m ✗\e[0m %s\t\e[31mfailed\e[0m\n" "$1"
}

# Start the mysql daemon in the background.
if service mariadb start; then
	print_success "start mariadb service"
else
	print_failure "start mariadb service"
	exit 1
fi

# Create the 'inception_db' database if it doesn't exist.
if mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"; then
	print_success "create database \`${MYSQL_DATABASE}\`"
else
	print_failure "create database \`${MYSQL_DATABASE}\`"
	exit 1
fi

# Create the 'user' user if it doesn't exist.
if mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USERNAME}\`@'localhost' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"; then
	print_success "create user \`${MYSQL_USERNAME}\`"
else
	print_failure "create user \`${MYSQL_USERNAME}\`"
	exit 1
fi

# Grant privileges to the 'user' user for the 'inception_db' database.
if mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USERNAME}\`@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"; then
	print_success "user \`${MYSQL_USERNAME}\` granted"
else
	print_failure "user \`${MYSQL_USERNAME}\` granted"
	exit 1
fi

# Make changes take effect
if mysql -e "FLUSH PRIVILEGES;"; then
	print_success "privileges flushed"
else
	print_failure "privileges flushed"
	exit 1
fi

# Update root password
if mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"; then
	print_success "update root password"
else
	print_failure "update root password"
	exit 1
fi

# Stop the mysql daemon to restart it with the new configuration.
if mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown; then
	print_success "stop mariadb service"
else
	print_failure "stop mariadb service"
	exit 1
fi

if exec mysqld_safe; then
	print_success "restart mariadb service"
else
	print_failure "restart mariadb service"
	exit 1
fi
