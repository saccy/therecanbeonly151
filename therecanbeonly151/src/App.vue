<template>
  <div>
    <!-- <a href="#" class="subtitle has-text-info">Leaderboard</a> -->
    <section class="section is-small">
      <div class="container">
        <Pokemans msg="Hello pokomen" />
      </div>
    </section>
  </div>
</template>

<script>
import Pokemans from './components/Pokemans.vue'

export default {
  name: 'App',
  components: {
    Pokemans
  }
}
</script>
