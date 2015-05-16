#!/bin/bash

while [[ $# > 1 ]]
do
key="$1"

case $key in
    -e|--environment)
    ENVIRONMENT="$2"
    shift
    ;;
    -i|--id)
    ID="$2"
    shift
    ;;
    *)
            # unknown option
    ;;
esac
shift
done
echo ENVIRONMENT  = "${ENVIRONMENT}"
echo ID           = "${ID}"

bundle exec rake ranking:find[$ID] RAILS_ENV=$ENVIRONMENT
