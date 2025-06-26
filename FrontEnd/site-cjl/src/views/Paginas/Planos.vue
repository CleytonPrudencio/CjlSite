<script setup lang="ts">
import { ref } from 'vue'
</script>

<template lang="pug">
main.planos
  section.consultoria
    .container
      h2 Planos de Consultoria
      .cards
        .card
          h3 Essencial
          p Ideal para pequenas empresas que estão começando sua jornada digital.
          ul
            li Diagnóstico inicial
            li Suporte remoto mensal
            li Relatório estratégico
          span.preco R$ 499/mês
          button Contratar

        .card
          h3 Profissional
          p Consultoria com acompanhamento mais próximo e reuniões estratégicas.
          ul
            li Tudo do Essencial
            li 2 reuniões mensais
            li Acesso a especialista dedicado
          span.preco R$ 899/mês
          button Contratar

        .card
          h3 Corporativo
          p Consultoria personalizada para times e empresas em escala.
          ul
            li Tudo do Profissional
            li Treinamentos exclusivos
            li Plano de ação trimestral
          span.preco R$ 1499/mês
          button Contratar

  section.software
    .container
      h2 Planos de Desenvolvimento de Software
      .cards
        .card
          h3 MVP Rápido
          p Ideal para startups que precisam lançar rápido com baixo custo.
          ul
            li Até 3 telas principais
            li Backend básico incluso
            li Entrega em até 3 semanas
          span.preco R$ 3.500
          button Solicitar Orçamento

        .card
          h3 Projeto Personalizado
          p Para empresas que precisam de uma solução sob medida.
          ul
            li Levantamento de requisitos
            li Design de interface personalizado
            li Integração com APIs
          span.preco A partir de R$ 7.000
          button Solicitar Orçamento

        .card
          h3 Software Completo
          p Solução empresarial com painel administrativo e suporte contínuo.
          ul
            li Dashboard completo
            li Usuários e permissões
            li Suporte e manutenção 6 meses
          span.preco Sob consulta
          button Solicitar Orçamento
</template>

<style scoped>
.planos {
  background-color: #f8f8f8;
  color: #222;
  padding: 4rem 2rem;
}

section {
  margin-bottom: 4rem;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  text-align: center;
}

h2 {
  font-size: 2.5rem;
  margin-bottom: 2rem;
  color: #111;
}

.cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 2rem;
}

.card {
  background: #fff;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
  transition:
    transform 0.3s ease,
    box-shadow 0.3s ease;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.card h3 {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
  color: #00c58e;
}

.card p {
  font-size: 1rem;
  color: #555;
  margin-bottom: 1rem;
}

ul {
  list-style: none;
  padding: 0;
  margin-bottom: 1rem;
  text-align: left;
}

ul li::before {
  content: '✓ ';
  color: #00c58e;
  margin-right: 0.5rem;
}

.preco {
  font-size: 1.2rem;
  font-weight: bold;
  color: #111;
  margin-bottom: 1rem;
  display: inline-block;
}

button {
  background-color: #00c58e;
  color: #fff;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  font-size: 1rem;
  cursor: pointer;
  transition: background-color 0.3s;
}

button:hover {
  background-color: #009f75;
}
</style>
