<template>
  <div>
    <img src="../assets/pika.png" width="200" height="200" />
    <h1 class="title">Original pokemans is best pokemans</h1>
    <hr>

    <div v-show="!started">
      
      <div class="columns">
        <div class="column is-half is-offset-one-quarter">
          <h2 class="subtitle">Gotta name 'em all in <b>3 minutes</b>!</h2>
          <h2 class="subtitle">A dimishing points multiplier is in effect, the quicker you are the better your score.</h2>
        </div>
      </div>
      
{{ playerName }}

      <div v-show="!playerName">
        <form autocomplete="off" @submit.prevent="setPlayerName()">
          <div class="columns is-mobile is-centered">
            <div class="field has-addons is-centered">
              <div class="control">
                <input class="input" type="text" placeholder="Input player name">
              </div>
              <div class="control">
                <button class="button is-info">
                  Submit
                </button>
              </div>
            </div>
          </div>
        </form> 
      </div>

      <div v-show="playerName">
        <div class="columns">
          <div class="column is-half is-offset-one-quarter">
            <button v-show="!timerEnabled" class="button is-primary is-fullwidth" @click="setTimer(180)">Start</button>
          </div>
        </div>
      </div>

    </div>

    <div v-show="started">

      <div class="columns">
        <div class="column is-one-third is-offset-one-third">
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
          <p class="help">Input pokemans</p>
          </div>
        </div>
      </div>
      
      <transition name="fade">
        <p v-show="showTick" class="has-text-success">Correct</p>
      </transition>

      <br>

      <div class="columns">
        <div class="column is-one-third is-offset-one-third">
          <h6 class="title is-6">Correct: {{ Math.round((progress + Number.EPSILON) * 100) / 100 }}% ({{points}} points)</h6>
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

  </div>
</template>

<script>
import { useCookies } from "vue3-cookies";

export default {
   setup() {
    const { cookies } = useCookies();
    return { cookies };
  },
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

      tester:'',

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
    setPlayerName(playerName) {
      this.cookies.set("playerName", playerName);
      this.playerName = this.cookies.get('playerName');
    },
    finish() {
      this.finished = true
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
      // var formattedName = this.pokemonName.toLowerCase().replace('-','').trim();
      // var formattedName = this.pokemonName.toLowerCase().trim();
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

    if (this.cookies.get("playerName")) {
      this.playerName = this.cookies.get("playerName");
    }

  },
  watch: {
    pokemonName(value) {
      this.onSubmit();
    }
  }
}
</script>
