<script setup lang="ts">
import { RouterView, RouterLink } from 'vue-router'
</script>

<template lang="pug">
div.layout-wrapper
  header.fixed-header
    .wrapper
      img.logo(src="@/assets/logocjl.png" alt="Vue logo" width="60" height="60")
      nav
        RouterLink(to="/") Início
        RouterLink(to="/planos") Planos

  main.main-content
    RouterView

  footer.fixed-footer
    p © 2025 - Todos os direitos reservados
</template>

<style scoped>
.layout-wrapper {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  width: 100%;
  margin: 0;
  padding: 0;
}

.fixed-header {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  background: #1e1e1e;
  color: white;
  padding: 1rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  z-index: 1000;
}

.logo {
  margin-right: 1rem;
}

.wrapper {
  display: flex;
  align-items: center;
  gap: 1rem;
}

nav a {
  align-items: center;
  color: white;
  text-decoration: none;
  margin: 0 1rem;
}

nav a.router-link-exact-active {
  font-weight: bold;
  border-bottom: 2px solid white;
}

.main-content {
  flex: 1;
  padding-top: 80px; /* espaço para header */
  padding-bottom: 60px; /* espaço para footer */
  width: 100%;
  margin: 0;
  padding-left: 0;
  padding-right: 0;
  box-sizing: border-box;
}

.fixed-footer {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  background: #1e1e1e;
  color: white;
  text-align: center;
  padding: 1rem;
}

:global(html, body) {
  margin: 0;
  padding: 0;
  width: 100vw;
  height: 100vh;
  overflow: hidden; /* remove rolagem */
  box-sizing: border-box;
}

.layout-wrapper {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  width: 100%;
  margin: 0;
  padding: 0;

  /* Fundo imagem para todo o layout */
  background: url('@/assets/fundo.jpg') no-repeat center center fixed;
  background-size: cover;
  /* se quiser escurecer um pouco o fundo */
  position: relative;
}

/* camada escura opcional para escurecer a imagem */
.layout-wrapper::before {
  content: '';
  position: fixed;
  inset: 0;
  background-color: rgba(30, 30, 30, 0.5); /* escurece a imagem */
  z-index: 0;
}

/* Garantir que conteúdo fique acima da camada escura */
.layout-wrapper > * {
  position: relative;
  z-index: 1;
}

.fixed-header {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  background-color: rgba(30, 30, 30, 0.7); /* fundo semi-transparente */
  color: white;
  padding: 1rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  z-index: 1000;
}

.fixed-footer {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  background-color: rgba(30, 30, 30, 0.7); /* fundo semi-transparente */
  color: white;
  text-align: center;
  padding: 1rem;
  z-index: 1000;
}

.logo {
  width: 60px;
  height: 60px;
  display: block;
  transform: scale(1.7);
  transform-origin: center;
}
</style>
