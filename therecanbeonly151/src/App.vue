// FIXME: bug when you go from endgame to hall of fame, data doesnt load properly for current player.

<template>
  <div>
    <div style="padding-top: 25px;">
      <button v-show="!hallOfFame" class="subtitle button button is-info is-inverted" @click="hallOfFameFn">Hall of Fame</button>
      <a href="/" v-show="hallOfFame" class="subtitle button button is-info is-inverted">Back to game</a>
    </div>
    <section class="section is-small" style="padding-top: 0px;">
      <div class="container">

        <img src="./assets/pika.png" width="200" height="200" />
        <h1 class="title">Original pokemans is best pokemans</h1>
        <hr>

        <div v-show="preGame">
          <PreGame
            :playerName="playerName"
            @startGame="startGameFn()"
          />
        </div>

        <div class="columns is-centered">
          <div class="column is-one-quarter">
            <div v-show="playerProfile">
              <PlayerProfile 
                :jsonbin_api_key="jsonbin_api_key"
                :jsonbin_collection="jsonbin_collection"
                @setPlayerName="setPlayerName($event)"
              />
            </div>
          </div>
        </div>
        
        <div v-show="game">
          <Game
            :start="start"
            :jsonbin_api_key="jsonbin_api_key"
            :jsonbin_collection="jsonbin_collection"
            @endGame="endGameFn($event)"
          />
        </div>
        
        <div v-show="endGame">
          <EndGame
            :jsonbin_api_key="jsonbin_api_key"
            :jsonbin_collection="jsonbin_collection"
            :gameTime="gameTime"
            :points="points"
            :playerName="playerName"
            :playerID="playerID"
            :getPlayerData="getPlayerData"
          />
        </div>
        
        <div v-show="hallOfFame">
          <HallOfFame
            :jsonbin_api_key="jsonbin_api_key"
            :jsonbin_collection="jsonbin_collection"
            :players="players"
            :playerName="playerName"
            :playerID="playerID"
            :getTop10="getTop10"
          />
        </div>

      </div>
    </section>
  </div>
</template>

<script>
import PreGame from './components/PreGame.vue'
import Game from './components/Game.vue'
import EndGame from './components/EndGame.vue'
import HallOfFame from './components/HallOfFame.vue'
import PlayerProfile from './components/PlayerProfile.vue'

export default {
  name: 'App',
  components: {
    PreGame,
    Game,
    EndGame,
    HallOfFame,
    PlayerProfile,
  },
  data() {
    return {
      jsonbin_api_key: import.meta.env.VITE_JSONBIN_API_KEY,
      jsonbin_collection: import.meta.env.VITE_JSONBIN_COLLECTION_ID,
      start: false,
      playerProfile: true,
      playerName: null,
      playerID: null,
      players: null,
      preGame: true,
      game: false,
      endGame: false,
      hallOfFame: false,
      gameTime: 0,
      points: 0,
      getTop10: false,
      getPlayerData: false,
    }
  },
   methods: {
    hallOfFameFn() {
      this.preGame = false;
      this.start = false;
      this.game = false;
      this.endGame = false;
      this.playerProfile = false;
      this.hallOfFame = true;
      this.getTop10 = true;
    },
    setPlayerName(player) {
      this.playerName = player.name;
      this.playerID = player.id;
      this.players = player.players; // FIXME this var name sucks (emitted from PlayeProfile component)
      this.playerProfile = false;
    },
    preGameFn() {
      this.hallOfFame = false;
      this.getTop10 = false;
      this.preGame = true;
      this.start = false;
      this.game = false;
      this.endGame = false;
    },
    startGameFn() {
      this.hallOfFame = false;
      this.preGame = false;
      this.start = true;
      this.game = true;
      this.endGame = false;
    },
    endGameFn(args) {
      this.hallOfFame = false;
      this.preGame = false;
      this.game = false;
      this.endGame = true;
      this.gameTime = args.gameTime;
      this.points = args.points;
      this.getPlayerData = true;
    }
  },
  mounted() {
    console.log(`${import.meta.env.MODE} mode`)
  }
}
</script>
