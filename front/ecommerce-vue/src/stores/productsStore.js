import { defineStore } from 'pinia';
import { api } from 'src/boot/axios';
export const useProductsStore = defineStore('products', {
  state: () => ({
    allProducs: [],
  }),
  getters: {
    doubleCount: (state) => state.counter * 2,
  },
  actions: {
    async retrieveProductInfo(productId){
      console.log(productId)
      let product = await api.get('/products', {params: {id: productId}})
      console.log(product)
      return product.data
    },
    async editProduct(productData){
      let product = await api.put('/products', productData)
    },
    async createProduct(productData){
      let product = await api.post('/products', productData)
    },
    async deleteProduct(productId){
      let product = await api.delete('/products', {data: {
        product_id: productId
      }})
    },
    async getAllProducts(){
      let product = await api.get('/products')
      return product.data
    }
  },
});
