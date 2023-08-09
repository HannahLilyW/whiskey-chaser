<script setup lang="ts">
import { ref } from 'vue';
import type { Ref } from 'vue';

let currentPosition: Ref<GeolocationPosition|null> = ref(null);

function getPosition(position: GeolocationPosition) {
    currentPosition.value = position;
}

function updatePosition() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(getPosition);
    } else {
        currentPosition.value = null;
    }
}

</script>

<template>
    <div v-if="currentPosition">
        Current Position: Lat {{ currentPosition.coords.latitude }} Lon {{ currentPosition.coords.longitude }}
    </div>
    <div v-else>
        Location unknown.
        <button @click="updatePosition()">Retry getting precise location</button>
    </div>
</template>

<style scoped>
</style>
