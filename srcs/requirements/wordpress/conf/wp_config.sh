#!/bin/sh

print_success() {
	printf "\e[32m ✔\e[0m %s\t\e[32msuccess\e[0m\n" "$1"
}

print_failure() {
	printf "\e[31m ✗\e[0m %s\t\e[31mfailed\e[0m\n" "$1"
}

print_info() {
	printf "\e[33m%s\e[0m\n" "$1"
}

# Waiting for mariadb to start
print_info "Waiting 10s before starting mariadb service..."
sleep 10;

# Check if wp-config.php exists
if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
	print_info "wp-config.php not found, creating one..."
	wp config create --allow-root \
					--dbname=$MYSQL_DATABASE \
					--dbuser=$MYSQL_USERNAME \
					--dbpass=$MYSQL_USER_PASSWORD \
					--dbhost=mariadb:3306 \
					--path='/var/www/wordpress' \
					--quiet

	if [ $? -eq 0 ]; then
		print_success "create wp-config.php"
	else
		print_failure "create wp-config.php"
	fi
	sleep 5;
	# print_info "installing wordpress to ${DOMAIN_NAME}..."
	wp core install --allow-root \
					--url=$DOMAIN_NAME \
					--title=$WORDPRESS_WP_NAME \
					--admin_user=$WORDPRESS_ADMIN_USERNAME \
					--admin_password=$WORDPRESS_ADMIN_PASSWORD \
					--admin_email=$WORDPRESS_ADMIN_EMAIL \
					--path='/var/www/wordpress' \
					--quiet
	if [ $? -eq 0 ]; then
		print_success "install wordpress"
	else
		print_failure "install wordpress"
		exit 1
	fi
	# print_info "creating user \`${WORDPRESS_USERNAME}\`... "
	wp user create --allow-root \
					$WORDPRESS_USERNAME \
					$WORDPRESS_USER_EMAIL \
					--user_pass=$WORDPRESS_PASSWORD \
					--role=author \
					--path='/var/www/wordpress' \
					--quiet
	if [ $? -eq 0 ]; then
		print_success "create user"
	else
		print_failure "create user"
		exit 1
	fi

	wp theme install astra \
					--allow-root \
					--activate \
					--path='/var/www/wordpress' \
					--quiet
	if [ $? -eq 0 ]; then
		print_success "install theme"
	else
		print_failure "install theme"
		exit 1
	fi

else
	print_info "wp-config.php found, skipping configuration..."
fi


printf "\n\n\n\e[1m\e[32m🚀 Website is ready 🚀\e[0m\n"

/usr/sbin/php-fpm8.2 -F
