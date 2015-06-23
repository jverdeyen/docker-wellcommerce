#!/bin/bash
php /var/www/app/app/console doctrine:schema:create --env=prod
php /var/www/app/app/console doctrine:fixtures:load --env=prod
php /var/www/app/app/console bazinga:js-translation:dump --env=prod
php /var/www/app/app/console assetic:dump --env=prod
php /var/www/app/app/console cache:warmup --env=prod

chown -R www-data:www-data /var/www/app

exec /usr/bin/supervisord