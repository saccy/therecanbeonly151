<template>
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
</template>

<script>
export default {
    data() {
        return {
            // player: {
            //     name: '',
            //     attempts: {
            //         start_time: null,
            //         play_time: null,
            //         correct: 0,
            //         points: 0,
            //         badges: [],
            //     },
            //     high_score: 0,
            // },
            players: {},
            player: null,
            playerName: null,
            playerNameTemp: null,
            playerNamesArr: [],
            playerNameValid: false,
            playerJSONBinId: null,
            jsonbin_api_key: import.meta.env.VITE_JSONBIN_API_KEY,
            jsonbin_collection: import.meta.env.VITE_JSONBIN_COLLECTION_ID,
        }
    },
    methods: {

        emitPlayerName(){
            this.$emit('setPlayerName',this.playerName)
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
                this.playerName = this.playerNameTemp;
                this.playerNameTemp = null;
                localStorage.playerName = this.playerName;
                this.playerNameSubmitted = true;
                this.emitPlayerName();

                // const playerData = {
                //     [this.playerName]: { 
                //         "high_score": 0, 
                //         "attempts": 0
                //     }
                // }

                const playerData = {}

                const playersUrl = 'https://api.jsonbin.io/v3/b';
                fetch(playersUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Master-key': this.jsonbin_api_key,
                        'X-Collection-Id': this.jsonbin_collection,
                        'X-Bin-Name': this.playerName,
                    },
                    body: JSON.stringify(playerData)
                })
                .then(response => {
                    return response.json();
                })
                .then(player => {
                    // console.log(player);
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
                return response.json();
            })
            .then(players => {
                if (players[0].snippetMeta.name) {
                    this.players = players
                    for (const player of this.players) {
                        this.playerNamesArr.push(player.snippetMeta.name);
                        if (player.snippetMeta.name == localStorage.playerName) {
                            this.playerJSONBinId = player.record;
                        }
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
        if (localStorage.playerName) {
            this.playerName = localStorage.playerName;
            this.emitPlayerName();
        }
    },
    watch: {
        playerNameTemp(value) {
            this.playerNameTemp = value;
            this.validatePlayerName(value);
        }
    },
}
</script>
