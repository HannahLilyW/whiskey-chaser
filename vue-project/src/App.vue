<script setup lang="ts">
import { RouterView } from 'vue-router';
</script>

<template>
    <div class="title-flexbox">
        <img src="./assets/whiskey.png" width="32" height="32">
        <div class="title">
            Whiskey Chaser
        </div>
    </div>
    <RouterView />
    <a href="https://www.flaticon.com/free-icons/whiskey" title="whiskey icons">Whiskey icons created by monkik - Flaticon</a>
</template>

<style scoped>
.title-flexbox {
    display: flex;
}

.title {
    font-size: 32px;
    color: var(--color-text);
}

</style>
