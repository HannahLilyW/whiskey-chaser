<script setup lang="ts">
import { RouterView } from 'vue-router';
</script>

<template>
    <div class="background">
        <div class="title-flexbox">
            <img src="./assets/whiskey.png" width="64" height="64">
            <div class="title">
                Whiskey Chaser
            </div>
        </div>
        <RouterView />
        <a href="https://www.flaticon.com/free-icons/whiskey" title="whiskey icons">Whiskey icons created by monkik - Flaticon</a>
    </div>
</template>

<style scoped>
.title-flexbox {
    display: flex;
}

.title {
    font-size: 64px;
    color: var(--color-text);
}

.background {
    background-color: var(--background-color);
}
</style>
