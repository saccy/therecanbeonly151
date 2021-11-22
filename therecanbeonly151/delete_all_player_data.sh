#!/bin/bash

source .env.local

api_key=$VITE_JSONBIN_API_KEY
collection_id='6198674562ed886f9151cea6'

echo "Deleting all bins in collection $collection_id"

# Get all bins in collection
bin_ids=($(curl -s \
    -H "X-Master-key: $api_key" \
    --request GET \
        https://api.jsonbin.io/v3/c/${collection_id}/bins |
        jq -r '.[] | .record'))

# Loop through all bins and delete them
for bin in ${bin_ids[@]}; do
    echo "Deleting bin $bin"
    curl -s \
        -H "X-Master-key: $api_key" \
        --request DELETE \
        https://api.jsonbin.io/v3/b/${bin}
    echo -e "\n"
done
