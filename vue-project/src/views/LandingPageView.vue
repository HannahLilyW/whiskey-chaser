<script setup lang="ts">
function showPosition(position) {
    console.log(`Latitude: ${position.coords.latitude} Longitude: ${position.coords.longitude}`)
}

if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition);
} else {
    console.log('Geolocation not supported');
}
</script>

<template>
    <div>Landing Page</div>
</template>

<style scoped>
</style>