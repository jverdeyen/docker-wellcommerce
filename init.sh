#!/bin/bash
git clone -b master https://github.com/WellCommerce/WellCommerce.git /var/www/app

cp /var/www/app/app/config/parameters.yml.dist /var/www/app/app/config/parameters.yml
sed -i "s|127.0.0.1|mysql|g" /var/www/app/app/config/parameters.yml
sed -i "s|root|admin|g" /var/www/app/app/config/parameters.yml
sed -i "s|database_password: null|database_password: admin|g" /var/www/app/app/config/parameters.yml
# sed -i "s|%database_password%|admin|g" app/config/config.yml

composer install --prefer-source --no-interaction -d /var/www/app/
php /var/www/app/app/console doctrine:schema:create --env=prod
php /var/www/app/app/console doctrine:fixtures:load --env=prod
php /var/www/app/app/console bazinga:js-translation:dump --env=prod
php /var/www/app/app/console assetic:dump --env=prod
php /var/www/app/app/console cache:warmup --env=prod
chown -R www-data:www-data /var/www/app

exec /usr/bin/supervisord