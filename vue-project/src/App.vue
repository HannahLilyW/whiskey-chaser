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
    <p class="sad-update">Sad Update: Virginia ABC has changed the way they distribute allocated whiskeys. They no longer send emails notifying the public of random drops, they just quietly put rare bottles out at random times without notifying the public. So, this site is now obsolete. It will stay up until the domain expires for nostalgia's sake. Thank you to everyone who made use of Whiskey Chaser!</p>
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

.sad-update {
    padding: 8px;
    background-color: rgba(0, 0, 255, 0.25)
}

@media (min-width: 480px) {
    .main-container {
        padding: 8px 48px;
    }
}

</style>
