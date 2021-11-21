<template>
  <div>

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
              <button v-show="!timerEnabled" class="button is-primary is-fullwidth" @click="startGame(180)">Start</button>
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
          <p><progress class="progress is-warning" :value="gameTime" max="180"></progress></p>
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
          <button v-show="timerEnabled" class="button is-one-third is-danger is-fullwidth" @click="endGame()">End game</button>
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

      highScore: 0,

      // TODO split these to CountDown component
      timerEnabled: false,
      gameTime: 180,
      timeMin: null,
      timeSec: null,
      finishTime: null,
      timeFormat: '3m 00s',
      points: 0,
    }
  },
  methods: {

    playTransition() {
      this.showTick = true;
      setTimeout(() => {
          if(this.showTick) {
            // console.log('waiting');
            this.showTick = false;
          }
      }, 500)
    },

    submitPokemon() {
      var formattedName = this.pokemonName.toLowerCase();
      if (this.pokemon.includes(formattedName) && !this.correct.includes(formattedName)) {
        this.points += this.pointsMultiplier * 1;
        this.correct.push(formattedName);
        this.pokemonName = '';
        this.playTransition();
      }
    },

    // TODO split these to GameTime component
    startGame() {
      this.timerEnabled = true;
      this.started = true;
      if(this.timerEnabled) {
        setTimeout(() => {
            if(this.gameTime) {
                this.gameTime -= 1;
                this.timeMin = Math.floor(this.gameTime / 60);
                this.timeSec = this.gameTime % 60;
                this.timeFormat = `${this.timeMin}m ${this.timeSec}s`;
                this.startGame();
            }
        }, 1000)
      }
    },
    endGame() {
        this.finished = true,
        this.started = false,
        this.timerEnabled = false;
        this.finishTime = this.gameTime;
        this.gameTime = null;
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
    // End GameTime component

  },
  computed: {
    progress() {
        return (this.correct.length / 151 * 100)
    },
    pointsMultiplier() {
      if (this.gameTime > 150) {
        return 6
      }
      else if (this.gameTime > 120 && this.gameTime <= 150 ) {
        return 5
      }
      else if (this.gameTime > 90 && this.gameTime <= 120 ) {
        return 4
      }
      else if (this.gameTime > 60 && this.gameTime <= 90 ) {
        return 3
      }
      else if (this.gameTime > 30 && this.gameTime <= 60 ) {
        return 2
      }
      else if (this.gameTime > 0 && this.gameTime <= 30 ) {
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
      this.submitPokemon();
    },
    playerName(value) {
      this.playerName = value;
      this.validatePlayerName(value);
    },
    gameTime() {
      if (this.gameTime == 0) {
        this.endGame();
      }
    }
  },
  mounted() {
    if (localStorage.playerName) {
      this.playerName = localStorage.playerName;
      this.playerNameSubmitted = true;
    }
  },
}
</script>
