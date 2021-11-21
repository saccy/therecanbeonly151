#!/bin/bash

api_key='$2b$10$pA/ASqkuXn1h5R5sDrizg.2M3mwIUNrhf9B2hRXAuLgH5pbP0Rfw.'
collection_id='6198674562ed886f9151cea6'

echo 'Get all bins in a collection'
curl -s \
    -H "X-Master-key: $api_key" \
    --request GET \
        https://api.jsonbin.io/v3/c/$collection_id/bins

# for bin in ${bin_ids[@]}; do
#   echo "Deleting bin $bin"
#   curl -s \
#     -H "X-Master-key: $api_key" \
#     --request DELETE \
#       https://api.jsonbin.io/v3/b/${bin}
# done
