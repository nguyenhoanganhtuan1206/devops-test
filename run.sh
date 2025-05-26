#! /bin/bash

set -e

function run {
  poetry run python3 main.py
}

echo Run app in $APP_ENV environment

run