<template>
  <section class="page-container">
    <ProductForms :product_id="this.$route.query.id"></ProductForms>
  </section>
</template>

<style>
.page-container{
  margin-top: 40px;
  max-width: 1500px;
  padding: 40px;
  margin-left: 14vw;
}
</style>

<script>
import ProductForms from 'src/components/productForms.vue';

export default{
  name: 'CriarProduto',
  components:{ProductForms}
};
</script>
