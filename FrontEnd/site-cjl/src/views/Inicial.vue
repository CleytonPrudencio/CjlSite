<script setup lang="ts">
import { ref } from 'vue'
import Logo from '@/assets/logocjl.png'

const sobre = ref<HTMLElement | null>(null)

function scrollToSobre() {
  sobre.value?.scrollIntoView({ behavior: 'smooth' })
}
</script>

<template lang="pug">
main.home
  section.hero
    .conteudo
      h1 Bem-vindo ao Sistema CJL
      p.subtitulo Controle completo para oficinas, com estoque, clientes e veículos
      .seta(@click="scrollToSobre")
        svg(xmlns="http://www.w3.org/2000/svg" width="36" height="36" fill="white" viewBox="0 0 24 24")
          path(d="M12 16.5l-8-8L5.5 7l6.5 6.5L18.5 7 20 8.5z")

  section.sobre(ref="sobre")
    .container
      h2 Sobre o Sistema CJL
      p O Sistema CJL foi desenvolvido para oferecer uma solução completa e intuitiva para oficinas.
      p Controle de estoque, cadastro de clientes, gestão de veículos e muito mais, tudo em um só lugar.

  section.metricas
    .container
      h2 Nossos Números
      .cards
        .card
          h3 150+
          p Clientes Atendidos
        .card
          h3 300+
          p Projetos Entregues
        .card
          h3 24/7
          p Suporte Ativo
        .card
          h3 10+
          p Anos de Experiência

  section.contato
    .container
      h2 Fale Conosco
      p Entre em contato para orçamentos, dúvidas ou parcerias.

      form.formulario(@submit.prevent="enviarFormulario")
        .campo
          label(for="nome") Nome
          input#nome(type="text" required placeholder="Seu nome")
        .campo
          label(for="email") E-mail
          input#email(type="email" required placeholder="seu@email.com")
        .campo
          label(for="mensagem") Mensagem
          textarea#mensagem(rows="5" required placeholder="Digite sua mensagem")
        button.btn-enviar(type="submit") Enviar Mensagem


</template>

<style scoped>
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css');

.home {
  width: 100%;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: url('@/assets/fundo.jpg') no-repeat center center / cover;
  box-sizing: border-box;
  color: white;
  scroll-behavior: smooth;
}

.hero::before {
  content: '';
  position: absolute;
  inset: 0;
  background-color: rgba(30, 30, 30, 0.7);
  backdrop-filter: blur(6px);
  z-index: 0;
}
.hero {
  position: relative;
  overflow: hidden;
}

.hero {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 2rem;
  text-align: center;
  position: relative;
  z-index: 1;
}

.conteudo {
  max-width: 700px;
  z-index: 1;
  position: relative;
}

.logo {
  width: 100px;
  margin-bottom: 1.5rem;
}

h1 {
  font-size: 2.8rem;
  margin-bottom: 1rem;
}

.subtitulo {
  font-size: 1.3rem;
  color: #ccc;
}

.seta {
  margin-top: 2rem;
  font-size: 2rem;
  color: white;
  cursor: pointer;
  animation: bounce 2s infinite;
}

@keyframes bounce {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(10px);
  }
}

/* Seção "Sobre" */
.sobre {
  background-color: #000;
  color: #fff;
  padding: 4rem 2rem;
  text-align: center;
  z-index: 1;
  position: relative;
}

.sobre .container {
  max-width: 800px;
  margin: 0 auto;
}

.sobre h2 {
  font-size: 2rem;
  margin-bottom: 1rem;
}

.sobre p {
  font-size: 1.1rem;
  color: #ccc;
  margin-bottom: 1rem;
  line-height: 1.6;
}

.metricas {
  background-color: #111;
  color: white;
  padding: 4rem 2rem;
  text-align: center;
  position: relative;
  z-index: 1;
}

.metricas .container {
  max-width: 1000px;
  margin: 0 auto;
}

.metricas h2 {
  font-size: 2rem;
  margin-bottom: 3rem;
}

.cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 2rem;
}

.card {
  background-color: #1e1e1e;
  border-radius: 12px;
  padding: 2rem;
  transition:
    transform 0.3s ease,
    background-color 0.3s ease;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
}

.card:hover {
  transform: scale(1.05);
  background-color: #2a2a2a;
}

.card h3 {
  font-size: 2rem;
  margin-bottom: 0.5rem;
  color: #00c58e;
}

.card p {
  font-size: 1rem;
  color: #ccc;
}

.contato {
  background-color: #0e0e0e;
  color: white;
  padding: 4rem 2rem;
  text-align: center;
}

.contato .container {
  max-width: 800px;
  margin: 0 auto;
}

.contato h2 {
  font-size: 2rem;
  margin-bottom: 0.5rem;
}

.contato p {
  font-size: 1.1rem;
  color: #ccc;
  margin-bottom: 2rem;
}

.formulario {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  text-align: left;
}

.campo {
  display: flex;
  flex-direction: column;
}

label {
  font-size: 1rem;
  margin-bottom: 0.5rem;
  color: #eee;
}

input,
textarea {
  padding: 0.75rem 1rem;
  background-color: #1e1e1e;
  border: 1px solid #444;
  border-radius: 8px;
  color: white;
  font-size: 1rem;
  outline: none;
}

input:focus,
textarea:focus {
  border-color: #00c58e;
}

.btn-enviar {
  background-color: #00c58e;
  color: #000;
  border: none;
  padding: 1rem 2rem;
  font-size: 1rem;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s;
  align-self: flex-start;
}

.btn-enviar:hover {
  background-color: #00a36f;
}
</style>
