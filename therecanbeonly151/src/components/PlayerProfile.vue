<template>
<div>
    <div class="field is-grouped" >
        <p class="control is-expanded">
            <input @keyup.enter="setPlayerName" class="input" v-model="playerNameTemp" type="text" placeholder="Input new player name">
        </p>
        <p class="control" v-show="playerNameValid" @click="setPlayerName" >
            <a class="button is-info">
                Submit
            </a>
        </p>
        <p class="control" v-show="!playerNameValid">
            <a class="button is-danger" disabled>
                In use
            </a>
        </p>
    </div>
    <p v-show="errorMsg" class="has-text-danger">{{ errorMsg }}, try again</p>
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
        }
    },
    data() {
        return {
            players: {},
            player: null,
            playerName: null,
            playerID: null,
            playerNameTemp: null,
            playerNamesArr: [],
            playerNameValid: false,
            playerJSONBinId: null,
            errorMsg: null,
        }
    },
    methods: {

        emitPlayerName(){
            const player = {'name': this.playerName, 'id': this.playerID, 'players': this.players}
            this.$emit('setPlayerName', player)
        },

        validatePlayerName(value) {
            if(!this.playerNamesArr.includes(value) && value != ''){
                this.playerNameValid = true;
            }
            else {
                this.playerNameValid = false;
            }
        },

        // Sets session data for current player and saves data in jsonbin
        setPlayerName() {
            if (this.playerNameValid) {

                // const playerData = {
                //     [this.playerName]: { 
                //         "high_score": 0, 
                //         "attempts": 0
                //     }
                // }

                this.playerNameTemp = this.playerNameTemp.trim();

                const playerData = {
                    [this.playerNameTemp]: {
                        'high_score': 0
                    }
                }

                const playersUrl = 'https://api.jsonbin.io/v3/b';
                fetch(playersUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Master-key': this.jsonbin_api_key,
                        'X-Collection-Id': this.jsonbin_collection,
                        'X-Bin-Name': this.playerNameTemp,
                    },
                    body: JSON.stringify(playerData)
                })
                .then(response => {
                    if (!response.ok) {
                        this.errorMsg = Error(response.statusText);
                        throw Error(response.statusText);
                    }
                    return response.json();
                })
                .then(player => {
                    this.playerID = player.metadata.id;
                    this.playerName = this.playerNameTemp;
                    this.playerNameTemp = null;
                    localStorage.playerName = this.playerName;
                    this.playerNameSubmitted = true;
                    this.emitPlayerName();
                })
                .catch(err => {
                    console.log(err);
                });
            }
        },

        // Retrieve data for all players - used in hall of fame, to ensure player names are unique and to store persistent data for current player
        getPlayers() {
            const playersUrl = `https://api.jsonbin.io/v3/c/${this.jsonbin_collection}/bins`;
            fetch(playersUrl, {
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
            .then(players => {
                this.players = players;
                for (const player of this.players) {
                    this.playerNamesArr.push(player.snippetMeta.name);
                    if (player.snippetMeta.name == localStorage.playerName) {
                        this.playerID = player.record;
                        this.playerName = localStorage.playerName;
                        this.emitPlayerName();
                    }
                }
            })
            .catch(err => {
                console.log(err);
            });
        },
    },
    created() {
        this.getPlayers();
    },
    watch: {
        playerNameTemp(value) {
            this.playerNameTemp = value;
            this.validatePlayerName(value);
        }
    },
}
</script>
