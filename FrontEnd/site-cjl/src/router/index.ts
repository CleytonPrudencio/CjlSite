import { createRouter, createWebHistory } from 'vue-router'
import Inicial from '@/views/Inicial.vue'
import Planos from '@/views/Paginas/Planos.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: Inicial,
    },
    {
      path: '/planos',
      name: 'Planos',
      component: Planos,
    },
  ],
})

export default router
