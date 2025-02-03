<template>
<nav>
    <ul class="glass">
        <li>
            <a routerLink="/">Home</a>
            <a routerLink="/">Criar Produto</a>
        </li>
    </ul>
</nav>

</template>

<style>
nav{
    position: fixed;
    top: 10px;
    left: 0;
    width: 100%;
    justify-content: center;
    display: flex;
    flex-wrap: nowrap;
    text-decoration: none;
}

nav ul{
    border-radius: 10px;
    width: auto;
    height: 100%;
    line-height: 60px;
    display:flex;
    margin: 0;
    list-style-type: none;
    padding: 5px 10px;
    text-align: center;
    gap: 20px;
}

nav ul li{
    width: auto;
    display:flex;
}

nav ul li a{
    text-decoration: none;
    color: inherit;
    min-width: 70px;
    padding: 0 20px;
    border-radius: 10px;
}
nav ul li a:hover{
    /* filter: brightness(10) contrast(175%); */
    background-color: rgba(0,0,0,0.05);
    /* background-color: black; */
}
</style>

<script>
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'navbar',
  props: {
    
  },
  data(){
        return ({
                isExpanded: false,
                height: 0
        })
    },
    setup(props) {
        // console.log(props)

    },
    created(){
        // console.log(this.name)
    },
    mounted(){
        // console.log()
        this.height = `30px`
    }
})
</script>
