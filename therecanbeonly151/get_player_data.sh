#!/bin/bash

api_key='$2b$10$pA/ASqkuXn1h5R5sDrizg.2M3mwIUNrhf9B2hRXAuLgH5pbP0Rfw.'
bin_id='61986f1501558c731cc5f78e'
collection_id='6198674562ed886f9151cea6'
player_json='{ "saccy": { "high_score": 60, "attempts": 4 }}'

echo 'Getting a bin'
echo ''
curl -s \
  -H "X-Master-key: $api_key" \
  --request GET \
    https://api.jsonbin.io/v3/b/${bin_id}/latest |
    jq .record.saccy.high_score

# echo 'Creating a bin'
# player_json='{ "sacco": { "high_score": 60, "attempts": 4 }}'
# curl -s \
#   -H "Content-Type: application/json" \
#   -H "X-Master-key: $api_key" \
#   --request PUT \
#   --data "$player_json" \
#     https://api.jsonbin.io/v3/b/${bin_id}

# echo 'Updating a bin'
# curl -s \
#   -H "Content-Type: application/json" \
#   -H "X-Master-key: $api_key" \
#   --request PUT \
#   --data "$player_json" \
#     https://api.jsonbin.io/v3/b/${bin_id}

# echo ''
# echo 'Fetching collections'
# curl -s \
#     -H "X-Master-key: $api_key" \
#     --request GET \
#         https://api.jsonbin.io/v3/c |
#         jq

# echo ''
# echo 'Creating a bin within collection'
# curl -s \
#     -H "Content-Type: application/json" \
#     -H "X-Master-key: $api_key" \
#     -H "X-Collection-Id: $collection_id" \
#     -H "X-Bin-Name: saccy" \
#     --request POST \
#     --data "$player_json" \
#         https://api.jsonbin.io/v3/b |
#         jq

# echo ''
# echo 'Get a bin in a collection by name'
# curl -s \
#     -H "X-Master-key: $api_key" \
#     --request GET \
#         https://api.jsonbin.io/v3/c/$collection_id/bins |
#         jq 
        # '.[] | .snippetMeta.name'

# echo ''
# echo 'Deleting bins'
# curl -s \
#   -H "X-Master-key: $api_key" \
#   --request DELETE \
#     https://api.jsonbin.io/v3/b/619869000ddbee6f8b0f04a6