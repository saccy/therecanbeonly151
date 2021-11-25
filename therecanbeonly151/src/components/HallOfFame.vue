<template>
    <div>
        <div v-show="showPlayerInfo" class="column is-half is-offset-one-quarter">
            <h2 class="subtitle"><b>{{ playerName }}</b>, your highest score is <b>{{ currentPlayerHighScore }}</b>!</h2>
        </div>
        <br>
        <table class="table is-striped is-centered" style="margin-left:auto; margin-right:auto;">
            <thead>
                <tr>
                <th>Player</th>
                <th>Score</th>
                <th>Rank</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(player, index) in playerScores" :key="index">
                    <td>{{ player.player_name }}</td>
                    <td>{{ player.high_score }}</td>
                    <td>{{ index + 1 }}</td>
                </tr>
            </tbody>
        </table>
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
        players: {
            required: true
        },
        playerName: {
            required: true
        },
        playerID: {
            required: true
        },
        getTop10: {
            type: Boolean,
            required: true
        },
    },
    data() {
        return {
            playerIDs: [],
            playerScores: [],
            errorMsg: null,
            currentPlayerHighScore: null,
        }
    },
    methods: {
        getTop10Fn() {
            for (const player of this.players) {
                this.playerIDs.push(player.record)
            }
            for (const id of this.playerIDs) {
                const playerBinUrl = `https://api.jsonbin.io/v3/b/${id}/latest`
                fetch(playerBinUrl, {
                    headers: {
                        'X-Master-key': this.jsonbin_api_key
                    },
                })
                .then(response => { 
                    if (!response.ok) {
                        this.errorMsg = response.statusText;
                        throw Error(response.statusText);
                    }
                    return response.json();
                })
                .then(playerBin => {
                    for (const [k, v] of Object.entries(playerBin.record)) {
                        if (this.playerName == k) {
                            this.currentPlayerHighScore = v.high_score;
                        }
                        this.playerScores.push({
                            "player_name": k,
                            "high_score": v.high_score
                        });
                        this.playerScoresSorted();
                    };
                })
                .catch(err => {
                    console.log(err);
                });
            }
        },
        playerScoresSorted() {
            this.playerScores.sort(function(a, b){
                return b.high_score - a.high_score;
            });
        }
    },
    computed: {
        showPlayerInfo() {
            if (this.playerName && this.currentPlayerHighScore) {
                return true;
            }
            else {
                return false;
            }
        }
        
    },
    watch: {
        getTop10() {
            if (this.getTop10) {
                this.getTop10Fn();
            }
        },
    }
}
</script>
