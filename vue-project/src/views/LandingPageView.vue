<script setup lang="ts">
import { ref, computed } from 'vue';
import type { Ref } from 'vue';
import type { Store } from '../models';
import { get } from '../services/api.js';


let currentPosition: Ref<GeolocationPosition|null> = ref(null);

function getPosition(position: GeolocationPosition) {
    currentPosition.value = position;
}

function updatePosition() {
    if (navigator.geolocation) {
        navigator.geolocation.watchPosition(getPosition);
    } else {
        currentPosition.value = null;
    }
}

function getDistance(lat1: number, lon1: number, lat2: number, lon2: number) {
    /**
     * Gets distance between 2 lat/lon coordinates in miles.
     */
    const r: number = 6371 * 0.6213; // radius of earth in miles
    const p: number = Math.PI / 180;
    const a = 0.5 - Math.cos((lat2 - lat1) * p) / 2
        + Math.cos(lat1 * p) * Math.cos(lat2 * p) *
        (1 - Math.cos((lon2 - lon1) * p)) / 2;
    return 2 * r * Math.asin(Math.sqrt(a));
}

let allStores: Ref<Store[]> = ref([]);
let allStoresWithDistance = computed(() => {
    let stores: Store[] = []
    for (let store of allStores.value) {
        stores.push({
            'store_id': store['store_id'],
            'address': store['address'],
            'lat': store['lat'],
            'lon': store['lon']
        })
        if (currentPosition && currentPosition.coords && currentPosition.coords.latitude && currentPosition.coords.longitude) {
            stores[stores.length - 1]['distance'] = getDistance(currentPosition.coords.latitude, currentPosition.coords.longitude, store['lat'], store['lon'])
        }
    }
    return stores;
})

get('/stores.json').then(response => {
    allStores.value = response['data'];
})

updatePosition();

</script>

<template>
    <div class="current-location">
        <div v-if="currentPosition">
            Current Location: {{ currentPosition.coords.latitude }}, {{ currentPosition.coords.longitude }}
        </div>
        <div v-else>
            <div>
                Location unknown. Are location permissions allowed?
            </div>
            <button @click="updatePosition()">↻ Retry location</button>
        </div>
    </div>
    <div v-for="store in allStoresWithDistance">
        Store {{ store.store_id }}: {{ store.address }} ({{ store.distance }} mi)
    </div>
</template>

<style scoped>
</style>
