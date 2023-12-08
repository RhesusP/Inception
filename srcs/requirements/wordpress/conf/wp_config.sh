#!/bin/sh

print_success() {
	printf "\e[32m%s\e[0m\n" "$1"
}

print_failure() {
	printf "\e[31m%s\e[0m\n" "$1"
}

# Waiting for mariadb to start
print_success "Waiting for mariadb to start..."
sleep 10;

# Check if wp-config.php exists
if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
	print_success "wp-config.php not found, creating one..."
	wp config create --allow-root \
					--dbname=$MYSQL_DATABASE \
					--dbuser=$MYSQL_USERNAME \
					--dbpass=$MYSQL_USER_PASSWORD \
					--dbhost=mariadb:3306 \
					--path='/var/www/wordpress'
	if [ $? -eq 0 ]; then
		print_success "wp-config.php created successfully ✔️"
	else
		print_failure "wp-config.php creation failed ❌"
		# exit 1
	fi
	sleep 5;
	print_success "installing wordpress... to ${DOMAIN_NAME}"
	wp core install --allow-root \
					--url=$DOMAIN_NAME \
					--title=$WORDPRESS_WP_NAME \
					--admin_user=$WORDPRESS_ADMIN_USERNAME \
					--admin_password=$WORDPRESS_ADMIN_PASSWORD \
					--admin_email=$WORDPRESS_ADMIN_EMAIL \
					--path='/var/www/wordpress'
	if [ $? -eq 0 ]; then
		print_success "wordpress installed successfully ✔️"
	else
		print_failure "wordpress installation failed ❌"
		exit 1
	fi
	print_success "creating user \`${WORDPRESS_USERNAME}\`... "
	wp user create --allow-root \
					$WORDPRESS_USERNAME \
					$WORDPRESS_USER_EMAIL \
					--user_pass=$WORDPRESS_PASSWORD \
					--role=author \
					--path='/var/www/wordpress'
	if [ $? -eq 0 ]; then
		print_success "user created successfully ✔️"
	else
		print_failure "user creation failed ❌"
		exit 1
	fi

	wp theme install astra \
					--allow-root \
					--activate \
					--path='/var/www/wordpress'
	if [ $? -eq 0 ]; then
		print_success "theme installed successfully ✔️"
	else
		print_failure "theme installation failed ❌"
		exit 1
	fi

else
	print_success "wp-config.php found, skipping configuration..."
fi

wp --allow-root theme list --path='/var/www/wordpress'

/usr/sbin/php-fpm7.3 -F