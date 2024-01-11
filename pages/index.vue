<template>
   <div class="xl:max-w-[1240px] md:max-w-[840px] mx-auto">

      <div class="flex flex-col my-10 md:my-16 ">
         <div class="container mx-auto flex w-60 justify-center align-middle">
            <label for="fileInput"
               class="cursor-pointer bg-blue-500 hover:bg-blue-600 flex flex-col max-w-[250px] w-full text-white text-center h-18 rounded-md p-5">

               <div v-if="carregandoDados" class="flex justify-center">
                  <svg class="h-5 w-5 animate-spin" xmlns="http://www.w3.org/2000/svg" height="16" width="16"
                     viewBox="0 0 512 512">
                     <path
                        d="M304 48a48 48 0 1 0 -96 0 48 48 0 1 0 96 0zm0 416a48 48 0 1 0 -96 0 48 48 0 1 0 96 0zM48 304a48 48 0 1 0 0-96 48 48 0 1 0 0 96zm464-48a48 48 0 1 0 -96 0 48 48 0 1 0 96 0zM142.9 437A48 48 0 1 0 75 369.1 48 48 0 1 0 142.9 437zm0-294.2A48 48 0 1 0 75 75a48 48 0 1 0 67.9 67.9zM369.1 437A48 48 0 1 0 437 369.1 48 48 0 1 0 369.1 437z" />
                  </svg>
               </div>

               <h2 v-else>Selecione um arquivo excel</h2>
            </label>
            <input id="fileInput" type="file" class="hidden" @change="onChangeFileInput" accept=".xlsx, .xls" />
         </div>

         <span v-if="mrr && churnRate" class="text-center text-green-600">
            {{ $data.file.name }}
         </span>


      </div>

      <div v-if="mrr && churnRate && totalAssinaturasAtivas" class="container bg-gray-100 py-5 border">
         <div
            class="mx-auto sm:h-24h mb-16 grid base:grid-rows-3 md:grid-cols-3 gap-5 sm:gap-10 justify-center md:w-[700px]">
            <div
               class="flex flex-col justify-center max-w-[250px] w-full bg-[#4bc0c0] text-white text-center font-bold text-sm rounded-md p-2">
               <h3>Total de MRR</h3>
               <span class="text-3xl">
                  {{
                     $data.mrrMedia.toLocaleString('pt-BR', {
                        style: 'currency',
                        currency: 'BRL',
                        minimumFractionDigits: 2,
                     })
                  }}
               </span>
            </div>
            <div
               class="flex flex-col justify-center max-w-[250px] w-full bg-[#ff6348] text-white text-center font-bold text-sm rounded-md p-2">
               <h3>Total de Cancelamento</h3>
               <span class="text-3xl">
                  {{
                     $data.churnRateMedia.toFixed(2) + '%'
                  }}
               </span>
            </div>
            <div
               class="flex flex-col justify-center max-w-[250px] w-full bg-[#251978] text-white text-center font-bold text-sm rounded-md p-2">
               <h3>Média de Assinaturas Ativas</h3>
               <span class="text-3xl">
                  {{
                     $data.totalAssinaturasAtivasMedia.toFixed(0)
                  }}
               </span>
            </div>

         </div>

         <div class="flex justify-center p-5">
            <Chart :mrr="mrr" :churnRate="churnRate" :totalAssinaturasAtivas="totalAssinaturasAtivas" />
         </div>
      </div>



   </div>
</template>
 
<script>
import Chart from '../components/Chart.vue';
import Header from '~/components/Header.vue';

export default {
   name: 'Home',
   components: { Chart, Header },
   data() {
      return {
         mrr: null,
         mrrMedia: 0,
         churnRate: null,
         churnRateMedia: 0,
         totalAssinaturasAtivas: null,
         totalAssinaturasAtivasMedia: 0,
         file: null,
         carregandoDados: false
      };
   },

   methods: {
      async onChangeFileInput(event) {
         const runtimeConfig = useRuntimeConfig()
         this.carregandoDados = true
         this.file = event.target.files ? event.target.files[0] : null;

         const formData = new FormData();
         formData.append('file', this.file);
         const response = await $fetch(`${runtimeConfig.public.API_BASE_URL}/metricas`, {
            method: 'POST',
            body: formData,
         });

         this.mrr = response.mrr
         this.churnRate = response.churnRate
         this.totalAssinaturasAtivas = response.totalAssinaturasAtivas

         this.mrrMedia = this.calculaMedia(this.mrr)
         this.churnRateMedia = this.calculaMedia(this.churnRate)
         this.totalAssinaturasAtivasMedia = this.calculaMedia(this.totalAssinaturasAtivas)
         this.carregandoDados = false
      },
      calculaMedia(objeto) {
         const arrayDeValores = Object.values(objeto);
         return arrayDeValores.reduce((soma, valor) => soma + valor, 0) / arrayDeValores.length;
      }
   },
};
</script>
 