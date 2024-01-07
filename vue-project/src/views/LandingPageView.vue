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
     * Gets distance between 2 lat/lon coordinates in miles,
     * rounded to the nearest tenth of a mile.
     */
    const r: number = 6371 * 0.6213; // radius of earth in miles
    const p: number = Math.PI / 180;
    const a = 0.5 - Math.cos((lat2 - lat1) * p) / 2
        + Math.cos(lat1 * p) * Math.cos(lat2 * p) *
        (1 - Math.cos((lon2 - lon1) * p)) / 2;
    return (2 * r * Math.asin(Math.sqrt(a))).toFixed(1);
}

let allStores: Ref<Store[]> = ref([]);
let dropDate: Ref<string> = ref('Loading...')
let allStoresWithDistance = computed(() => {
    let stores: Store[] = []
    for (let store of allStores.value) {
        stores.push({
            'store_id': store['store_id'],
            'address': store['address'],
            'lat': store['lat'],
            'lon': store['lon']
        })
        if (currentPosition.value && currentPosition.value.coords && currentPosition.value.coords.latitude && currentPosition.value.coords.longitude) {
            stores[stores.length - 1]['distance'] = getDistance(currentPosition.value.coords.latitude, currentPosition.value.coords.longitude, store['lat'], store['lon'])
        }
    }
    stores.sort((a, b) => {
        if (a.distance && b.distance) {
            return Number(a.distance) - Number(b.distance);
        } else if (a.distance && !b.distance) {
            return -1;
        } else if (!a.distance && b.distance) {
            return 1;
        } else {
            return 0;
        }
    })
    return stores;
})

get('/stores.json').then(response => {
    allStores.value = response['data'];
    dropDate.value = response['dropDate'];
})

updatePosition();

</script>

<template>
    <div class="unknown-location" v-if="!currentPosition">
        <div>
            Location unknown. Please allow this site to access your location, to see the closest ABC stores to you that have been authorized to sell limited availability products.
        </div>
        <button @click="updatePosition()">↻ Retry location</button>
    </div>
    <div class="drop-date">Drop date: {{ dropDate }}</div>
    <div class="grid-container">
        <template v-for="store in allStoresWithDistance" :key="store.store_id">
            <div class="grid-item mi">{{ store.distance ? store.distance + ' mi' : '? mi' }}</div>
            <a class="grid-item address" :href="'https://www.google.com/maps/place/' + store.address">{{ store.address }}</a>
        </template>
    </div>
</template>

<style scoped>
.unknown-location {
    display: flex;
    align-items: center;
    gap: 4px;
    padding: 4px 0px;
}
.drop-date {
    padding: 4px 0px;
}

.grid-container {
    display: grid;
    grid-template-columns: min-content auto;
}

.grid-header {
    border-bottom: 1px solid gray;
}

.grid-item {
    padding: 12px;
}

.mi {
    white-space: nowrap;
    padding-right: 0px;
}

.address {
    padding-left: 8px;
}

.grid-item:nth-child(4n+1),
.grid-item:nth-child(4n+2) {
    background-color: #E9E9E9;
}
</style>
