<template>
  <section class="page-container">
    <Suspense>
      <ProductsTable v-if="!this.$route.query.id"></ProductsTable>
    </Suspense>
    <section class="col" v-if="this.$route.query.id">
      <div class="row">
        <h1 class="col">Editar Produto (id={{ this.$route.query.id }})</h1>
      </div>
        <ProductForms class="row" @submit="(e) => {this.getStore().editProduct(e)}" :productInfoBase="this.$data.productInfo"></ProductForms>
    </section>
  </section>
</template>

<style>
:deep(.close-button .q-btn){
  position: inherit;
  right: 0;
}
.page-container{
  margin-top: 80px;
  max-width: 1500px;
  padding: 40px;
  margin-left: 14vw;
}
</style>

<script>
import ProductForms from 'src/components/productForms.vue';

import ProductsTable from 'src/components/productsTable.vue';
import { useProductsStore } from 'src/stores/productsStore';
let productsStore = useProductsStore()

export default{
  name: 'AdminPage',
  components:{ProductForms, ProductsTable},
  data(){
    return {
      productInfo: {
                "product_id": 1,
                "product_name": "Peitoral Pet para cães American pets",
                "product_description": "Resumo\n- Com suporte para ajuste, e guia com gancho para maior segurança;\n- Fabricado em tecido que permite a ventilação da pele e dos pelos;\n- Promove passeios mais confortáveis para o seu pet;\n- Elegância e charme com diversas opções de cores;\n- Resistente e prático de usar.",
                "category_name": "Coleiras",
                "category_description": "Coleiras e Itens de Segurança",
                "variants": [
                    {
                        "item_id": 1,
                        "color_name": "Azul Royal",
                        "color_hex": "#004680",
                        "price": "R$ 14,00",
                        "sale_price": "R$ 10,00",
                        "image_file": "",
                        "size_name": "P",
                        "stock_qty": 20
                    },
                    {
                        "item_id": 2,
                        "color_name": "Azul Royal",
                        "color_hex": "#004680",
                        "price": "R$ 50,00",
                        "sale_price": "R$ 25,00",
                        "image_file": "",
                        "size_name": "M",
                        "stock_qty": 20
                    }
                ]
	    }
    }
  },
  methods: {
    getStore(){
      return productsStore
    }
  }
};
</script>
