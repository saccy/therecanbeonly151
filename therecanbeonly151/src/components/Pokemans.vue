<template>
  <div>
    <img src="../assets/pika.png" width="200" height="200" />
    <h1 class="title">Original pokemans is best pokemans</h1>
    <hr>

    <div v-show="!started">
      
      <div v-show="!finished">

        <div class="columns">
          <div class="column is-half is-offset-one-quarter">
            <h2 class="subtitle">Gotta name 'em all in <b>3 minutes</b>!</h2>
            <h2 class="subtitle">A dimishing points multiplier is in effect, the quicker you are the better your score.</h2>
            <h2 class="subtitle" v-show="playerNameSubmitted">{{ playerName }}, I choose you!</h2>

            <div v-show="!playerNameSubmitted">

              <div class="column is-offset-one-quarter">
                <div class="field has-addons">
                  <div class="control">
                    <input @keyup.enter="setPlayerName" class="input" v-model="playerName" type="text" placeholder="Input new player name">
                  </div>
                  <div class="control" v-show="!playerNameValid" >
                    <a class="button is-danger" disabled>
                      Name taken/invalid
                    </a>
                  </div>
                  <div class="control" v-show="playerNameValid" >
                    <a class="button is-info" v-show="playerNameValid">
                      Submit
                    </a>
                  </div>
                </div>
              </div>

            </div>
          </div>
        </div>

        <div v-show="playerNameSubmitted">
          
          <div class="columns">
            <div class="column is-half is-offset-one-quarter">
              <button v-show="!timerEnabled" class="button is-primary is-fullwidth" @click="setTimer(180)">Start</button>
            </div>
          </div>
        
        </div>

      </div>

      <div v-show="finished">
        <div class="columns">
          <div class="column is-half is-offset-one-quarter">
            <h2 class="subtitle">Game over {{playerName}}!</h2>
            <h2 class="subtitle">Your score: {{ points }}</h2>
          </div>
        </div>
      </div>      

    </div>

    <div v-show="started">

      <div class="columns">
        <div class="column box is-one-third is-offset-one-third">
          <p><progress class="progress is-warning" :value="timerCount" max="180"></progress></p>
          <br>
          <h2 class="subtitle">{{ timeFormat }} (mutliplier x{{ pointsMultiplier }})</h2>
        </div>
      </div>
      
      <br>

      <div class="columns">
        <div class="column box is-one-third is-offset-one-third has-background-info">
          <div class="field">
            <div class="control">
              <input id="pokemonInput" autocomplete="off" v-model="pokemonName" class="input" type="text" placeholder="type here">
            </div>
            <p class="help has-text-white">Input pokemans</p>
          </div>
        </div>
      </div>
      
      <transition name="fade">
        <p v-show="showTick" class="has-text-success">Correct</p>
      </transition>

      <br>

      <div class="columns">
        <div class="column box is-one-third is-offset-one-third">
          <h2 class="subtitle">Correct: {{ Math.round((progress + Number.EPSILON) * 100) / 100 }}% ({{points}} points)</h2>
          <progress class="progress is-primary" :value="correct.length" max="151"></progress>
        </div>
      </div>
      
      <br>

      <div class="columns">
        <div class="column is-one-third is-offset-one-third">
          <button v-show="timerEnabled" class="button is-one-third is-danger is-fullwidth" @click="stopTimer()">End game</button>
        </div>
      </div>

      <hr>

      <div v-if="correct.length > 0">
        <div class="columns is-flex-wrap-wrap">
          <div v-for="(poke, index) in correct" :key="index" class="column is-one-eigth has-text-primary">{{ poke }}</div>
        </div>
      </div>

    </div>

    <div v-show="finished">
    </div>

  </div>
</template>

<script>
export default {
  data() {
    return {
      pokemon: [],
      pokemonName: '',
      started: false,
      finished: false,
      correct: [],
      incorrect: [],
      showTick: false,
      playerName: null,
      playerNameValid: false,
      playerNameSubmitted: false,
      players_api_key: import.meta.env.VITE_PLAYERS_API_KEY,
      players_collection: import.meta.env.VITE_PLAYERS_COLLECTION_ID,
      players: {},
      playerNamesArr: [],
      bin_id: null,
      highScore: 0,

      // TODO split these to CountDown component
      timerEnabled: false,
      timerCount: null,
      timeMin: null,
      timeSec: null,
      finishTime: null,
      timeFormat: '3m 00s',
      points: 0,
    }
  },
  methods: {
    validatePlayerName(value) {
      if(!this.playerNamesArr.includes(value) && value != ''){
        this.playerNameValid = true;
      }
      else {
        this.playerNameValid = false;
      }
    },
    setPlayerName() {
      if (this.playerNameValid) {
        console.log(this.playerName)
        localStorage.playerName = this.playerName;
        this.playerNameSubmitted = true;
        const json_data = {
          [this.playerName]: { 
            "high_score": 0, 
            "attempts": 0
          }
        }
        const playersUrl = 'https://api.jsonbin.io/v3/b';
        fetch(playersUrl, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-Master-key': this.players_api_key,
            'X-Collection-Id': this.players_collection,
            'X-Bin-Name': this.playerName,
          },
          body: JSON.stringify(json_data)
        })
        .then(response => {
          console.log(response);
          return response.json();
        })
        .then(player => {
          console.log(player);
        })
        .catch(err => {
            console.log(err);
        });
      }
    },
    playTransition() {
      this.showTick = true;
      setTimeout(() => {
          if(this.showTick) {
            console.log('waiting');
            this.showTick = false;
          }
      }, 500)
    },
    onSubmit() {
      var formattedName = this.pokemonName.toLowerCase();
      if (this.pokemon.includes(formattedName) && !this.correct.includes(formattedName)) {
        this.points += this.pointsMultiplier * 1;
        this.correct.push(formattedName);
        this.pokemonName = '';
        this.playTransition();
      }
    },

    // TODO split these to CountDown component
    setTimer(secs) {
        this.timerEnabled = true;
        this.timerCount = secs;
        this.startTimer();
    },
    startTimer() {
      this.started = true;
      if(this.timerEnabled) {
        setTimeout(() => {
            if(this.timerCount) {
                this.timerCount -= 1;
                this.timeMin = Math.floor(this.timerCount / 60);
                this.timeSec = this.timerCount % 60;
                this.timeFormat = `${this.timeMin}m ${this.timeSec}s`;
                this.startTimer();
            }
        }, 1000)
      }
    },
    stopTimer() {
        this.finished = true,
        this.started = false,
        this.timerEnabled = false;
        this.finishTime = this.timerCount;
        this.timerCount = null;
        this.timeMin = null;
        this.timeSec = null;
        this.timeFormat = null;

        // Compare score with high score
        for (const player of this.players) {
          if (player.snippetMeta.name == this.playerName) {
            console.log(player)
            this.highScore = player.record[this.playerName].high_score
            console.log(this.highScore)
          }
        }

    },
    // End CountDown component
  },
  computed: {
    progress() {
        return (this.correct.length / 151 * 100)
    },
    pointsMultiplier() {
      if (this.timerCount > 150) {
        return 6
      }
      else if (this.timerCount > 120 && this.timerCount <= 150 ) {
        return 5
      }
      else if (this.timerCount > 90 && this.timerCount <= 120 ) {
        return 4
      }
      else if (this.timerCount > 60 && this.timerCount <= 90 ) {
        return 3
      }
      else if (this.timerCount > 30 && this.timerCount <= 60 ) {
        return 2
      }
      else if (this.timerCount > 0 && this.timerCount <= 30 ) {
        return 1
      }
      else {
        return null
      }
    },
  },
  created() {
    const pokeUrl = 'https://pokeapi.co/api/v2/pokedex/2';
    fetch(pokeUrl)
    .then(response => { 
      return response.json();
    }).then(pokemonList => {
      for (const [k, v] of Object.entries(pokemonList.pokemon_entries)) {
        this.pokemon.push(v.pokemon_species.name);
      };
    })
    .catch(err => {
        console.log(err);
    });

    const playersUrl = `https://api.jsonbin.io/v3/c/${this.players_collection}/bins`;
    fetch(playersUrl, {
      headers: {
        'X-Master-key': this.players_api_key
      },
    })
    .then(response => { 
      return response.json();
    })
    .then(players => {
      console.log(players)
      if (players[0].snippetMeta.name) {
        this.players = players
        for (const player of this.players) {
          this.playerNamesArr.push(player.snippetMeta.name);
        }
      }
      console.log(this.players);
    })
    .catch(err => {
        console.log(err);
    });
  },
  watch: {
    pokemonName() {
      this.onSubmit();
    },
    playerName(value) {
      this.playerName = value;
      this.validatePlayerName(value);
    },
    timerCount() {
      if (this.timerCount == 0) {
        this.stopTimer();
      }
    }
  },
  mounted() {
    console.log(`${import.meta.env.MODE} mode`)
    if (localStorage.playerName) {
      this.playerName = localStorage.playerName;
      this.playerNameSubmitted = true;
    }
  },
}
</script>
