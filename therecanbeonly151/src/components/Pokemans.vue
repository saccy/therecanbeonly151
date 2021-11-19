<template>
  <div>
    <img src="../assets/pika.png" width="200" height="200" />
    <h1 class="title">Original pokemans is best pokemans</h1>
    <hr>

    <div v-show="!started">
      
      <div class="columns">
        <div class="column is-half is-offset-one-quarter">
          <!-- <h1 class="title">Original pokemans is best pokemans</h1> -->
          <h2 class="subtitle">Gotta name 'em all in <b>3 minutes</b>!</h2>
          <h2 class="subtitle">A dimishing points multiplier is in effect, the quicker you are the better your score.</h2>
        </div>
      </div>
      
      <div class="columns">
        <div class="column is-half is-offset-one-quarter">
          <!-- <button class="button is-primary is-fullwidth" @click="timerEnabled(300)">Start</button> -->
          <button v-show="!timerEnabled" class="button is-primary is-fullwidth" @click="setTimer(180)">Start</button>
          <button v-show="timerEnabled" class="button is-danger is-fullwidth" @click="stopTimer()">End game</button>
        </div>
      </div>
      
    </div>

    <div v-show="started">
      
      <br>
      
      <form class="pokemons-form" autocomplete="off" @submit.prevent="onSubmit">
        <div class="columns is-mobile is-centered">
          <div class="field has-addons is-centered">
            <div class="control">
              <input id="pokemonInput" v-model="pokemonName" class="input" type="text" placeholder="Input a pokemans">
            </div>
            <div class="control">
              <button class="button is-info">
                Submit
              </button>
            </div>
          </div>
        </div>
      </form> 

      <br>
      <br>

      <div class="columns">
        <div class="column is-half is-one-quarter">
          <h6 class="title is-6">Correct: {{ Math.round((progress + Number.EPSILON) * 100) / 100 }}%</h6>
          <progress class="progress is-primary" :value="correct.length" max="151"></progress>
        </div>
        <div class="column">
          <h6 class="title is-6">{{ timeFormat }}</h6>
          <progress class="progress is-warning" :value="timerCount" max="180"></progress>
        </div>
        <div class="column">
          <h6 class="title is-6">Points</h6>
          {{ points }}
        </div>
        <div class="column">
          <h6 class="title is-6">Points multiplier</h6>
          {{ pointsMultiplier }}
        </div>
      </div>

      <hr>

      <div v-if="correct.length > 0">
        <h2 class="subtitle has-text-left is-underlined">Correct</h2>
        <div class="columns is-flex-wrap-wrap">
          <div v-for="(poke, index) in correct" :key="index" class="column is-one-fifth has-text-primary">{{ poke }}</div>
        </div>
      </div>

      <div v-if="incorrect.length > 0">
        <hr>
        <h2 class="subtitle has-text-left is-underlined">Incorrect</h2>
        <div class="columns is-flex-wrap-wrap">
          <div v-for="(poke, index) in incorrect" :key="index" class="column is-one-fifth has-text-danger">{{ poke }}</div>
        </div>
      </div>
    
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

    finish() {
      this.finished = true
    },
    onSubmit() {
      this.pokemonName = this.pokemonName.toLowerCase().replace('-','').trim();
      if (this.pokemon.includes(this.pokemonName)) {
        this.points += this.pointsMultiplier * 1
        this.correct.push(this.pokemonName)
      }
      else {
        this.incorrect.push(this.pokemonName)
      }
      this.pokemonName = ''
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
        this.timerEnabled = false;
        this.finishTime = this.timerCount;
        this.timerCount = null;
        this.timeMin = null;
        this.timeSec = null;
        this.timeFormat = null;
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
    const url = 'https://pokeapi.co/api/v2/pokedex/2';
    fetch(url)
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
}
</script>
