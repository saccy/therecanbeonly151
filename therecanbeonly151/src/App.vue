<template>
  <div>
    <div style="padding-top: 25px;">
      <a href="#" class="subtitle has-text-info">Hall of Fame</a>
    </div>
    <section class="section is-small" style="padding-top: 20px;">
      <div class="container">
        <Pokemans />
        <!-- <CountDown /> -->
        <!-- <HallOfFame /> -->
      </div>
    </section>
  </div>
</template>

<script>
import Pokemans from './components/Pokemans.vue'
import CountDown from './components/CountDown.vue'
import HallOfFame from './components/HallOfFame.vue'

export default {
  name: 'App',
  components: {
    Pokemans,
    CountDown,
    HallOfFame
  }
}
</script>
