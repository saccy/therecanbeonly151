<template>
    <div>
        <div class="column is-half is-offset-one-quarter">
            <h2 class="subtitle">Gotta name 'em all in <b>3 minutes</b>!</h2>
            <h2 class="subtitle">A dimishing points multiplier is in effect, the quicker you are the better your score.</h2>
            <h2 class="subtitle">You dont need to press enter! If you type a pokemon name correctly it is automatically added.</h2>
        </div>
        <div  v-show="playerName">
            <h2 class="subtitle"><b>{{ playerName }}</b>, I choose you!</h2>
            <div class="columns">
                <div class="column is-half is-offset-one-quarter">
                    <button class="button is-primary is-fullwidth" @click="emitStartGame()">Start game</button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props: {
        playerName: {
            type: String
        }
    },
    methods: {
        emitStartGame() {
            this.$emit('startGame')
        }
    }
}
</script>
