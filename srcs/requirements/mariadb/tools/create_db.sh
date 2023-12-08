#!/bin/sh

print_success() {
	printf "\e[32m%s\e[0m\n" "$1"
}

print_failure() {
	printf "\e[31m%s\e[0m\n" "$1"
}

# Start the mysql daemon in the background.
if service mariadb start; then
	print_success "mariadb service started successfully ✔️"
else
	print_failure "mariadb service failed to start ❌"
	exit 1
fi

# Create the 'inception_db' database if it doesn't exist.
if mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"; then
	print_success "database \`${MYSQL_DATABASE}\` created ✔️"
else
	print_failure "database \`${MYSQL_DATABASE}\` failed to create ❌"
	exit 1
fi

# mysql -e "USE inception_db;"

# Create the 'user' user if it doesn't exist.
if mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USERNAME}\`@'localhost' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"; then
	print_success "user \`${MYSQL_USERNAME}\` created ✔️"
else
	print_failure "user \`${MYSQL_USERNAME}\` failed to create ❌"
	exit 1
fi

# Grant privileges to the 'user' user for the 'inception_db' database.
if mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USERNAME}\`@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"; then
	print_success "user \`${MYSQL_USERNAME}\` granted ✔️"
else
	print_failure "user \`${MYSQL_USERNAME}\` failed to grant ❌"
	exit 1
fi

# Make changes take effect
if mysql -e "FLUSH PRIVILEGES;"; then
	print_success "privileges flushed ✔️"
else
	print_failure "privileges failed to flush ❌"
	exit 1
fi

# Update root password
if mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"; then
	print_success "root password changed ✔️"
else
	print_failure "root password failed to change ❌"
	exit 1
fi

# Stop the mysql daemon to restart it with the new configuration.
if mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown; then
	print_success "mariadb service stopped successfully ✔️"
else
	print_failure "mariadb service failed to stop ❌"
	exit 1
fi

if exec mysqld_safe; then
	print_success "mariadb service restarted successfully ✔️"
else
	print_failure "mariadb service failed to restart ❌"
	exit 1
fi
