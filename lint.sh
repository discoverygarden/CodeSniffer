#!/usr/bin/env bash

set -e #Exit entire script if any command fails

COMPOSER_HOME=$(composer -n config --global home)
COMPOSER_BIN="${COMPOSER_HOME}/vendor/bin"
readonly COMPOSER_HOME COMPOSER_BIN

ACTION_PATH="${ACTION_PATH:-./}"
ACTION_EXTENSIONS="${ACTION_EXTENSIONS:-php,module,inc,install,test,profile,theme,css,info,md,yml}"
ACTION_SUFFIX="${ACTION_SUFFIX:-.php,*.module,*.inc,*.install,*.test,*.profile,*.theme,*.js,*.css,*.info}"
ACTION_LINT="${ACTION_LINT:-php,module,inc,install,test}"

# Download dependencies
echo "Downloading dependencies ..."
composer -q global require drupal/coder
composer -q global require dealerdirect/phpcodesniffer-composer-installer
composer -q global require sebastian/phpcpd

# Run linting and static analysis
echo "Running PHPCS for Drupal standards ..."
"${COMPOSER_BIN}/phpcs" -s --standard=Drupal,DrupalPractice --extensions="${ACTION_EXTENSIONS}" "${ACTION_PATH}" --ignore="*.md" .

echo "Running PHPCS Generic sniffs ..."
"${COMPOSER_BIN}/phpcs" --standard=Generic --sniffs=Generic.PHP.Syntax --extensions="${ACTION_LINT}" "${ACTION_PATH}"

echo "Running PHPCPD for copy/paste detection ..."
"${COMPOSER_BIN}/phpcpd" --suffix="${ACTION_SUFFIX}" "${ACTION_PATH}"
