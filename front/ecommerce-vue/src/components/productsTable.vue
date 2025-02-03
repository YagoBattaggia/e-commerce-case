<template>
    <div>
        <q-table
            dense
            title="Meus Produtos"
            :rows="products"
            row-key="id"
        >
        <template v-slot:header="props">
        <q-tr :props="props">
          <q-th auto-width />
          <q-th
            v-for="col in props.cols"
            :key="col.name"
            :props="props"
          >
            {{ col.label }}
          </q-th>
        </q-tr>
        </template>
        <template v-slot:body="props">
        <q-tr :props="props">
            <q-td auto-width class="q-gutter-x-sm">
                {{ props.row.product_id }}
                <q-btn size="sm" color="blue" :to="`/admin?id=${props.row.product_id}`" round dense icon="edit" />
                <q-btn size="sm" color="blue" @click="this.getStore().deleteProduct(props.row.product_id)" round dense icon="delete" />
            </q-td>
            <q-td
                v-for="col in props.cols"
                :key="col.name"
                :props="props"
                >
            {{ col.value }}
            </q-td>
        </q-tr>
        </template>
        </q-table>
    </div>
</template>

<style>

</style>

<script>
import { defineComponent } from 'vue'
import { useProductsStore } from 'src/stores/productsStore';
import { ref } from 'vue';
let productsStore = useProductsStore()
export default defineComponent({
  name: 'productTable',
  props: {
  },
  data(){
        return {
            products: ref([{
                "product_id": 1,
                "product_name": "Peitoral Pet para cães American pe",
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
	    }]),
        productsStore
        }
    },
    setup(props) {
    },
    async created(){
        this.products = await productsStore.getAllProducts()
        // this.productInfo = await productsStore.retrieveProductInfo('1')
    },
    mounted(){
    },
    methods:{
        getStore(){
            return this.productsStore
        }
    }
})


</script>