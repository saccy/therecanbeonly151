<template>
  <div>

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
        <p v-show="showCorrect" class="has-text-success">Correct</p>
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
          <button class="button is-one-third is-danger is-fullwidth" @click="emitEndGame()">End game</button>
        </div>
      </div>

      <hr>

      <div v-if="correct.length > 0">
        <div class="columns is-flex-wrap-wrap">
          <div v-for="(poke, index) in correct" :key="index" class="column is-one-eigth has-text-primary">{{ poke }}</div>
        </div>
      </div>

  </div>
</template>

<script>
export default {
  props: {
    start: {
      type: Boolean,
      required: true
    },
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
      pokemon: [],
      pokemonName: '',
      correct: [],
      showCorrect: false,
      gameTime: 180,
      timeFormat: '3m 00s',
      points: 0,
    }
  },
  methods: {
    startGame() {
      setTimeout(() => {
        if(this.gameTime) {
            this.gameTime -= 1;
            const timeMin = Math.floor(this.gameTime / 60);
            const timeSec = this.gameTime % 60;
            this.timeFormat = `${timeMin}m ${timeSec}s`;
            this.startGame();
        }
      }, 1000)
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
    playTransition() {
      this.showCorrect = true;
      setTimeout(() => {
          if(this.showCorrect) {
            this.showCorrect = false;
          }
      }, 500)
    },
    emitEndGame() {
        const timeUsed = 180 - this.gameTime
        const timeUsedMin = Math.floor(timeUsed / 60);
        const timeUsedSec = timeUsed % 60;
        const timeUsedFormat = `${timeUsedMin}m ${timeUsedSec}s`;
        this.$emit('endGame', { 'gameTime': timeUsedFormat, 'points': this.points})
    },
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
  },
  watch: {
    pokemonName() {
      this.submitPokemon();
    },
    start() {
      if (this.start) {
        this.startGame();
      }
    },
    gameTime() {
      if (this.gameTime == 0) {
        this.emitEndGame();
      }
    }
  },
}
</script>
