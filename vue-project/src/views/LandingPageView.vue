<script setup lang="ts">
import { ref } from 'vue';
import type { Ref } from 'vue';
import type { Store } from '../models';
import { get } from '../services/api.js';


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

let allStores: Ref<Store[]> = ref([]);

get('/stores.json').then(response => {
    allStores.value = response;
})

updatePosition();

</script>

<template>
    <div class="current-location">
        <div v-if="currentPosition">
            Current Location: {{ currentPosition.coords.latitude }}, {{ currentPosition.coords.longitude }}
        </div>
        <div v-else>
            Location unknown. Are location permissions allowed?
        </div>
        <button @click="updatePosition()">↻ Refresh location</button>
    </div>
    <div v-for="store in allStores">
        Store {{ store.store_id }}: {{ store.address }}
    </div>
</template>

<style scoped>
</style>
