<template>
  <div>
    <img src="../assets/pika.png" width="200" height="200" />
    <hr>



    <!-- <input type="text" placeholder="Filter Search" v-model="query" /> -->
    <!-- {{ query }} -->
    <!-- <button @click="reset">Reset</button> -->
    
    <!-- {{ timerCount }} -->

    <!-- <div class="columns">
      <div class="box column is-half is-offset-one-quarter">
        <h1 class="title">Original pokemans is best pokemans</h1>
        <h2 class="subtitle">Name all 151 originals as fast as you can</h2>
      </div>
    </div> -->

    <div v-show="!started">
      
      <div class="columns">
        <div class="column is-half is-offset-one-quarter">
          <h1 class="title">Original pokemans is best pokemans</h1>
          <h2 class="subtitle">Name all 151 originals as fast as you can</h2>
        </div>
      </div>
      
      <div class="columns">
        <div class="column is-half is-offset-one-quarter">
          <button class="button is-primary is-fullwidth" @click="start()">Start</button>
        </div>
      </div>
      
    </div>

    <div v-show="started">
      
      <br>
      
      <form class="pokemons-form" @submit.prevent="onSubmit">
        <div class="columns is-mobile is-centered">
          <div class="field has-addons is-centered">
            <div class="control">
              <input id="pokemonInput" v-model="pokemonName" class="input" type="text" placeholder="Input a pokemans">
            </div>
            <div class="control">
              <a class="button is-info">
                Submit
              </a>
            </div>
          </div>
        </div>
      </form> 

      <!-- <form class="pokemons-form" @submit.prevent="onSubmit">
        <h3>Leave a review</h3>
        <label for="name">Name:</label>
        <input id="name" v-model="name">

        <label for="review">Review:</label>
        <textarea id="name" v-model="review"></textarea>

        <label for="rating">Rating:</label>
        <select id="rating" v-model.number="rating">
            <option>5</option>
            <option>4</option>
            <option>3</option>
            <option>2</option>
            <option>1</option>
        </select>

        <label for="recommend">Would you recommend this product?</label>
        <select id="recommend" v-model="recommend">
            <option>Yes</option>
            <option>No</option>
        </select>

        <input class="button" type="submit" value="Submit">
      </form>  -->

      <br>

      <!-- TODO make progress dynamic, only show when game starts -->
      <progress class="progress is-primary" value="0" max="151"></progress>
      <p>Progress: {{ Math.round((progress + Number.EPSILON) * 100) / 100 }}%</p>

      <hr>

      <div v-if="correct.length > 0">
        <h2 class="subtitle">Correct</h2>
        <div class="columns is-flex-wrap-wrap">
          <div v-for="(poke, index) in correct" :key="index" class="column is-one-fifth has-text-primary">{{ poke }}</div>
        </div>
      </div>

      <div v-if="incorrect.length > 0">
        <hr>
        <h2 class="subtitle">Incorrect</h2>
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
      timerEnabled: true,
      timerCount: 3
    }
  },
  methods: {
    start() {
      this.started = true
    },
    finish() {
      this.finished = true
    },
    addCorrect() {
      this.correct += 1
    },
    addIncorrect() {
      this.incorrect += 1
    },
    play() {
      this.timerEnabled = true;
    },
    pause() {
      this.timerEnabled = false;
    },
    onSubmit() {
      if (this.pokemon.includes(this.pokemonName)) {
        this.correct.push(this.pokemonName)
      }
      else {
        this.incorrect.push(this.pokemonName)
      }
      this.pokemonName = ''
    }
  },
  computed: {
    progress() {
        return (this.correct.length / 151 * 100)
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
  watch: {
    timerEnabled(value) {
      if (value) {
        setTimeout(() => {
          this.timerCount--;
        }, 1000);
      }
    },
    timerCount: {
      handler(value) {
        if (value > 0 && this.timerEnabled) {
          setTimeout(() => {
            this.timerCount--;
          }, 1000);
        }
      },
      immediate: true // This ensures the watcher is triggered upon creation
    }
  }
}
</script>
