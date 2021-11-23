#!/bin/sh

# npm install vue
# npm install bulma
# npm install -g @vue/cli

# vue create therecanbeonly151

echo "VITE_JSONBIN_API_KEY" > .env
echo "VITE_JSONBIN_COLLECTION_ID" >> .env
npm run build
