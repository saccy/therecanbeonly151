<template>
    <div>
        <button v-show="!timerEnabled" class="button is-primary is-fullwidth" @click="setTimer(180)">Start</button>
        <button v-show="timerEnabled" class="button is-danger is-fullwidth" @click="stopTimer()">End game</button>
        <!-- <p v-show="timerEnabled">{{ timeFormat }}</p> -->
        <!-- <p v-show="finishTime">{{ finishTime }}</p> -->
    </div>
</template>

<script>
export default {
    data() {
        return {
            timerEnabled: false,
            timerCount: null,
            timeMin: null,
            timeSec: null,
            finishTime: null,
            timeFormat: null,
            pointsMultiplier: 0,
            points: 0,
        }
    },
    methods: {
        setTimer(secs) {
            this.timerEnabled = true;
            this.timerCount = secs;
            this.startTimer();
        },
        startTimer() {
            if(this.timerEnabled) {
                setTimeout(() => {
                    if(this.timerCount) {
                        this.timerCount -= 1;
                        this.timeMin = Math.floor(this.timerCount / 60);
                        this.timeSec = this.timerCount % 60;
                        this.timeFormat = `${this.timeMin}m ${this.timeSec}s`;
                        this.setPoints();
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
        setPoints() {
            if (this.timerCount > 150) {
                this.pointsMultiplier = 6
            }
            else if (this.timerCount > 120 && this.timerCount <= 150 ) {
                this.pointsMultiplier = 5
            }
            else if (this.timerCount > 90 && this.timerCount <= 120 ) {
                this.pointsMultiplier = 4
            }
            else if (this.timerCount > 60 && this.timerCount <= 90 ) {
                this.pointsMultiplier = 3
            }
            else if (this.timerCount > 30 && this.timerCount <= 60 ) {
                this.pointsMultiplier = 2
            }
            else if (this.timerCount > 0 && this.timerCount <= 30 ) {
                this.pointsMultiplier = 1
            }
        },
    }
}
</script>
