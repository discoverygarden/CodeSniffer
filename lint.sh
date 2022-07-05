#!/usr/bin/env bash

set -e #Exit entire script if any command fails

# Download dependencies
echo "Allowing plugin dependencies ..."
composer global config --no-interaction allow-plugins.drupal/coder true
composer global config --no-interaction allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
composer global config --no-interaction allow-plugins.sebastian/phpcpd true
echo "Downloading dependencies ..."
composer global require drupal/coder
composer global require dealerdirect/phpcodesniffer-composer-installer
composer global require sebastian/phpcpd

# Run linting and static analysis
echo "Running PHPCS for Drupal standards ..."
~/.composer/vendor/bin/phpcs -s --standard=Drupal,DrupalPractice --extensions=$ACTION_EXTENSIONS $ACTION_PATH --ignore=*.md

echo "Running PHPCS Generic sniffs ..."
~/.composer/vendor/bin/phpcs --standard=Generic --sniffs=Generic.PHP.Syntax --extensions=$ACTION_LINT $ACTION_PATH

echo "Running PHPCPD for copy/paste detection ..."
~/.composer/vendor/bin/phpcpd --suffix=$ACTION_SUFFIX $ACTION_PATH
