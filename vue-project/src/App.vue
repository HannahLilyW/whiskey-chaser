<script setup lang="ts">
import { RouterView } from 'vue-router';
</script>

<template>
    <div class="title-flexbox">
        <img src="./assets/whiskey.png" width="40" height="40">
        <div class="title">
            Whiskey Chaser
        </div>
    </div>
    <div class="main-container">
        <RouterView />
    </div>
    <div class="attrib">
        <a class="attrib-link" href="https://www.flaticon.com/free-icons/whiskey" title="whiskey icons">Whiskey icons created by monkik - Flaticon</a>
    </div>
</template>

<style scoped>
.title-flexbox {
    display: flex;
    align-items: center;
    box-shadow: 0 4px 8px -4px gray;
    padding: 8px;
}

.title {
    font-size: 32px;
    color: var(--color-text);
    font-family: cherryswash;
}

.main-container {
    padding: 8px;
}

.attrib {
    position: absolute;
    bottom: 0;
}

</style>
