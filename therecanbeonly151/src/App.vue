<template>
  <div>
    <div style="padding-top: 25px;">
      <a href="#" class="subtitle has-text-info button" @click="toggleHallOfFame">Hall of Fame</a>
    </div>
    <section class="section is-small" style="padding-top: 20px;">
      <div class="container">

        <img src="./assets/pika.png" width="200" height="200" />
        <h1 class="title">Original pokemans is best pokemans</h1>
        <hr>

        <div v-show="preGame">
          <PreGame :playerName="playerName" />
        </div>
        
        <!-- <div v-show="game">
          <Game />
        </div> -->
        
        <!-- <div v-show="endGame">
          <EndGame />
        </div> -->
        
        <!-- <div v-show="hallOfFame">
          <HallOfFame />
        </div> -->
        
        <div class="columns is-centered">
          <div class="column is-one-quarter">
            <div v-show="playerProfile">
              <PlayerProfile @setPlayerName="setPlayerName($event)" />
            </div>
          </div>
        </div>
        
        <!-- <div v-show="pokemansData">
          <PokemansData />
        </div> -->

      </div>
    </section>
  </div>
</template>

<script>
import PreGame from './components/PreGame.vue'
import Game from './components/Game.vue'
import EndGame from './components/EndGame.vue'
import GameTimer from './components/GameTimer.vue'
import HallOfFame from './components/HallOfFame.vue'
import PlayerProfile from './components/PlayerProfile.vue'
import PokemansData from './components/PokemansData.vue'

export default {
  name: 'App',
  components: {
    PreGame,
    Game,
    EndGame,
    GameTimer,
    HallOfFame,
    PlayerProfile,
    PokemansData,
  },
  data() {
    return {
      preGame: true,
      game: false,
      endGame: false,
      hallOfFame: false,
      playerProfile: true, // Loads player data
      pokemansData: false,
      playerName: null,
    }
  },
   methods: {
    toggleHallOfFame() {
      this.hallOfFame = !this.hallOfFame
    },
    setPlayerName(name) {
      this.playerName = name;
      this.playerProfile = false;
    }
  },
  mounted() {
    console.log(`${import.meta.env.MODE} mode`)
  }
}
</script>
