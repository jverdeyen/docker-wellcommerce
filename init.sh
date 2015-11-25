#!/bin/bash
mkdir /var/www/wellcommerce/web/js
chmod -R 0755 /var/www/wellcommerce
php /var/www/wellcommerce/app/console assets:install --env=prod
php /var/www/wellcommerce/app/console bazinga:js-translation:dump --env=prod
php /var/www/wellcommerce/app/console fos:js-routing:dump --env=prod
php /var/www/wellcommerce/app/console assetic:dump --env=prod
php /var/www/wellcommerce/app/console doctrine:schema:create --env=prod
php /var/www/wellcommerce/app/console doctrine:fixtures:load -n --env=prod
php /var/www/wellcommerce/app/console cache:warmup --env=prod

chown -R www-data:www-data /var/www/wellcommerce

exec /usr/bin/supervisord

