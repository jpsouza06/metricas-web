<template>
   <div class="flex flex-col max-w-[900px] w-full space-y-20">
      <BarChart id="mrr-chart" :data="mrrChartData" :options="mrrChartOptions" />
      <canvas id="mixed-chart" :data="mountMixedChart"></canvas>
   </div>
</template>
 
<script>
import Chart from 'chart.js/auto'
import { Bar } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

export default {
   name: 'ChartComponent',
   components: { BarChart: Bar, Chart },
   props: ['mrr', 'churnRate', 'totalAssinaturasAtivas'],
   data() {
      return {
         mrrChartOptions: {
            responsive: true,
            scales: {
               x: {
                  grid: {
                     display: false
                  }
               },
               y: {
                  ticks: {
                     callback: (value) => value.toLocaleString('pt-BR', {
                        style: 'currency',
                        currency: 'BRL',
                        minimumFractionDigits: 2,
                     }),
                  },
               }
            },
         },
      };
   },
   computed: {
      mrrChartData() {
         const data = this.extractChartData(this.mrr);
         return this.createChartData('MRR', 'rgba(75,192,192,0.4)', data);
      },
      mixedChartData() {
         const totalAssinaturasAtivas = this.extractChartData(this.totalAssinaturasAtivas);
         const churnRate = this.extractChartData(this.churnRate);

         return this.createMixedChartData('Churn Rate', 'Assinaturas Ativas', churnRate, totalAssinaturasAtivas)
      },
      mountMixedChart() {
         const ctx = document.getElementById('mixed-chart');
         const chartInstance = Chart.getChart(ctx);
         if (chartInstance) {
            chartInstance.destroy();
         }

         new Chart(document.getElementById('mixed-chart'), this.mixedChartData)
      }
   },
   methods: {
      extractChartData(data) {
         return Object.fromEntries(Object.entries(data));
      },
      createChartData(label, backgroundColor, data) {
         return {
            labels: Object.keys(data),
            datasets: [
               {
                  label: label,
                  backgroundColor: backgroundColor,
                  borderColor: 'rgba(0, 0, 0, 0.4)',
                  borderWidth: 1,
                  data: Object.values(data),
               }
            ],
         }
      },
      createMixedChartData(label1, label2, data1, data2) {
         return {
            type: "bar",
            data: {
               labels: Object.keys(data1),
               datasets: [
                  {
                     label: label1,
                     type: "line",
                     data: data1,
                     backgroundColor: "rgba(255,99,72,1)",
                     borderColor: "rgba(255,99,72,1)",
                     borderWidth: 3,
                     yAxisID: 'left',
                  },
                  {
                     label: label2,
                     type: "bar",
                     data: data2,
                     backgroundColor: "rgba(37,25,120,0.4)",
                     yAxisID: 'right',
                  }
               ]
            },
            options: {
               responsive: true,
               lineTension: 0,
               interaction: {
                  intersect: false,
                  mode: 'index',
                  ticks: {
                     color: "rgba(255,99,132,1)",
                     callback: (value) => value + '%',
                  }
               },
               scales: {
                  left: {
                     type: 'linear',
                     position: 'left',
                     min: 0,
                     max: 100,
                     ticks: {
                        color: "rgba(255,99,132,1)",
                        callback: (value) => value + '%',
                     }
                  },
                  right: {
                     type: 'linear',
                     position: 'right',
                     ticks: {
                        color: "rgba(37,25,120,1)"
                     },
                     grid: {
                        drawOnChartArea: false
                     }
                  }
               }
            }
         }
      },
   },
   mounted() {
      const ctx = document.getElementById('mixed-chart');
      new Chart(ctx, this.mixedChartData)
   }
};
</script>
 