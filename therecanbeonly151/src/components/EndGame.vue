<template>
    <div class="columns">
        <div class="column is-half is-offset-one-quarter">
            <h2 class="subtitle">Game over <b>{{playerName}}</b>!</h2>
            <h2 v-show="newHighScore" class="subtitle">You got a new high score: <b>{{ points }}</b></h2>
            <h2 v-show="!newHighScore" class="subtitle">Your score: <b>{{ points }}</b></h2>
            <h2 v-show="!newHighScore" class="subtitle">Your previous high score: <b>{{ this.currentHighScore }}</b></h2>
            <h2 class="subtitle">Game time: <b>{{ gameTime }}</b></h2>
            <a href="/" class="button is-info is-fullwidth">Play again</a>
        </div>
    </div>
</template>

<script>
export default {
    props: {
        jsonbin_api_key: {
            type: String,
            required: true
        },
        jsonbin_collection: {
            type: String,
            required: true
        },
        gameTime: {
            required: true
        },
        points: {
            required: true
        },
        playerName: {
            required: true
        },
        playerID: {
            required: true
        },
        getPlayerData: {
            required: true,
            type: Boolean
        }
    },
    data() {
        return {
            newHighScore: false,
            currentHighScore: 0,
        }
    },
    methods: {
        getPlayerDataFn() {
            // Get current highscore from player bin
            const playerBinUrl = `https://api.jsonbin.io/v3/b/${this.playerID}/latest`
            fetch(playerBinUrl, {
                headers: {
                    'X-Master-key': this.jsonbin_api_key
                },
            })
            .then(response => { 
                if (!response.ok) {
                    throw Error(response.statusText);
                }
                return response.json();
            })
            .then(playerBin => {
                this.currentHighScore = playerBin.record[this.playerName].high_score;
                if (this.points > this.currentHighScore) {
                    this.newHighScore = true;
                }
            })
            .catch(err => {
                console.log(err);
            });

                // Update bin
                // curl -v\
                //   -H "Content-Type: application/json" \
                //   -H "X-Master-key: <YOUR_API_KEY>" \
                //   --request PUT \
                //   --data '{"sample": "Hello World"}' \
                //     https://api.jsonbin.io/v3/b/<BIN_ID>

        },
        updatePlayerData() {
            const playerData = {
                [this.playerName]: {
                    'high_score': this.points
                }
            }
            const playerBinUrl = `https://api.jsonbin.io/v3/b/${this.playerID}`
            fetch(playerBinUrl, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Master-key': this.jsonbin_api_key
                },
                body: JSON.stringify(playerData),
            })
            .then(response => { 
                if (!response.ok) {
                    throw Error(response.statusText);
                }
                return response.json();
            })
            .then(playerBin => {
                console.log('Updated high score')
            })
            .catch(err => {
                console.log(err);
            });
        }
    },
    watch: {
        getPlayerData() {
            if (this.getPlayerData) {
                this.getPlayerDataFn()
            }
        },
        newHighScore() {
            if (this.newHighScore) {
                this.updatePlayerData();
            }
        }
    }
}
</script>
