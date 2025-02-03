<template>
  <q-layout view="lHh Lpr lFf">
    <q-page-container>
      <router-view></router-view>
      <navbar></navbar>
    </q-page-container>
  </q-layout>
</template>

<script>
import { defineComponent, ref } from 'vue'
import EssentialLink from 'components/EssentialLink.vue'

import navbar from 'src/components/navbar.vue';
import { RouterView } from 'vue-router';

export default defineComponent({
  name: 'MainLayout',

  components: {
    EssentialLink,
    navbar
  },

  data () {
    return {
      leftDrawerOpen: false
    }
  },

  methods: {
    toggleLeftDrawer () {
      this.leftDrawerOpen = !this.leftDrawerOpen
    }
  }
})
</script>
