<template>
    
    <section class="row">
        <div class="col image-component">
            <div>
                <img src="/peitoral_azul.jpg" />
            </div>
        </div>
        
        <div class="col q-gutter-y-sm">
            <div class="row q-gutter-x-sm">
                <q-input class="col" standout v-model="productInfo.product_name" label="Nome do Produto" />
                <q-input class="col" standout v-model="productInfo.category_name" label="Categoria" />
            </div>
            <section class="row q-gutter-sm">
                <div class="variant col q-gutter-y-sm" v-for="variant of productInfo.variants">
                    <q-input dense class="row" standout v-model="variant.color_name" label="Nome da Cor" />
                    <q-input dense class="row" standout v-model="variant.color_hex" label="Hex" />
                    <q-input dense class="row" standout v-model="variant.price" label="Preço" />
                    <q-input dense class="row" standout v-model="variant.sale_price" label="Preço Promocional" />
                    <q-input dense class="row" standout v-model="variant.size_name" label="Tamanho" />
                    <q-input dense class="row" standout v-model="variant.stock_qty" label="Quantidade em Estoque" />
                </div>
            </section>
        </div>

    </section>
    <section style="margin-top: 10px;">
        <q-input
          label="Descrição do Produto" 
          v-model="productInfo.product_description"
          filled
          type="textarea"
        />
    </section>
    <section class="row  q-gutter-sm">
        <q-btn class="col" to="/admin" label="Cancelar Edição" type="submit" color="red"/>
        <q-btn class="col" @click="submitButton()" label="Editar Produto" type="submit" color="primary"/>
    </section>
</template>

<style>
h1 {
    font-size: 38px;
    font-weight: 500;
}
.variant{
    border-radius: 10px;
    padding: 10px;
}

.image-component{
    padding: 10px 30px;
}
.image-component div{
    background-color: white;
    box-shadow: rgba(0,0,0,0.35) 0px 0px 15px;
    border-radius: 10px;
}
.image-component img{
    margin: auto;
}
</style>

<script>
import { defineComponent } from 'vue'
import { useProductsStore } from 'src/stores/productsStore';
import { ref } from 'vue';

let productsStore = useProductsStore()

export default defineComponent({
  name: 'productForms',
  props: {
    productInfoBase: Object
  },
  data(){
        return {
            productInfo: ref({
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
	    }),
        productsStore
        }
    },
    setup(props) {
        
    },
    async created(){
        if (this.$props.productInfoBase){
            this.$data.productInfo = this.$props.productInfoBase
        }
        // this.productInfo = await productsStore.retrieveProductInfo('1')
    },
    mounted(){
    },
    methods:{
        getStore(){
            return this.productsStore
        },
        submitButton(){
            // console.log(productsStore.editProduct(this.productInfo))
            this.$emit("submit", this.productInfo)
            // let x = productsStore.editProduct(this.productInfo)
        }
    }
})
</script>