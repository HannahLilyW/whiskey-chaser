<script setup lang="ts">
import { RouterView } from 'vue-router';
import router from './router';

function navigateToAbout() {
    router.push('/about');
}

function navigateToLandingPage() {
    router.push('/');
}
</script>

<template>
    <div class="title-flexbox">
        <div class="title-flexbox-left" @click="navigateToLandingPage()">
            <img src="./assets/whiskey.png" width="40" height="40">
            <div class="title">
                Whiskey Chaser
            </div>
        </div>
        <div class="title-flexbox-right">
            <div class="about" @click="navigateToAbout()">About</div>
        </div>
    </div>
    <div class="main-container">
        <RouterView />
        <div class="attrib">
            <p>Whiskey Chaser was created by <a href="https://hannahwatsky.best/">Hannah Watsky</a>. If you have any issues, please email <a href="mailto:hannah@mail.whiskeychaser.org">hannah@mail.whiskeychaser.org</a>.</p>
            <p>Special thanks to Brandon Cross, a true whiskey chaser, who came up with the idea for this site and the name 😊</p>
            <a class="attrib-link" href="https://www.flaticon.com/free-icons/whiskey" title="whiskey icons">Whiskey icons created by monkik - Flaticon</a>
        </div>
    </div>
</template>

<style scoped>
.title-flexbox {
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 4px 8px -4px gray;
    padding: 8px;
}

.title-flexbox-left {
    display: flex;
    align-items: center;
    justify-content: flex-start;
    cursor: pointer;
}

.title-flexbox-right {
    display: flex;
    align-items: center;
    justify-content: flex-end;
}

.title {
    font-size: 32px;
    color: var(--color-text);
    font-family: cherryswash;
}

.about {
    font-family: cherryswash;
    cursor: pointer;
}

.main-container {
    padding: 8px;
}

@media (min-width: 480px) {
    .main-container {
        padding: 8px 48px;
    }
}

</style>
