<template>
   <div class="bg-[#001a9e] h-28 flex justify-center">
      <div class="container xm:mx-10 mx-5 my-auto flex justify-between xl:max-w-[1240px] md:max-w-[840px]">

         <NuxtLink to="/">
            <h1 class="text-center text-white font-sans font-medium md:text-4xl sm:text-2xl text-lg">
               Painel de Indicadores
            </h1>
         </NuxtLink>

         <div class="grid grid-cols-2 gap-5 sm:gap-20 items-end">
            <NuxtLink to="/">
               <h2 class="text-center text-white font-sans font-normal md:text-2xl text-lg">Início</h2>
            </NuxtLink>
            <NuxtLink to="/ajuda">
               <h2 class="text-center text-white font-sans font-normal md:text-2xl text-lg">Ajuda</h2>
            </NuxtLink>

         </div>
      </div>
   </div>
</template>

<script>
export default {
   name: 'Header',
}
</script>