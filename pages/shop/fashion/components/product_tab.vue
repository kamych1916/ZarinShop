<template>
  <div>
    <div class="title1 section-t-space">
      <h4>{{subtitle}}</h4>
      <h2 class="title-inner1">{{title}}</h2>
    </div>
    <b-overlay :show="!products" rounded="sm">
      <section class="section-b-space p-t-0 ratio_asos">
        <div class="container">
          <div class="row">
            <div class="col">
              <div class="theme-tab">
                <!-- <b-tabs content-class="mt-3">
                  <b-tab
                    :title="collection"
                    v-for="(collection,index) in category"
                    :key="index"
                  > -->
                    <div class="no-slider row">
                      <div
                        class="product-box"
                        v-for="(product,index) in products"
                        :key="index"
                      >
                      <productBox1
                        @opencartmodel="showCartModal"
                        @showCompareModal="showcomparemodal"
                        @openquickview="showquickview"
                        @showalert="alert"
                        @alertseconds="alert"
                        :product="product"
                        :index="index"
                      />
                      </div>
                    </div>
                  <!-- </b-tab>
                </b-tabs> -->
              </div>
            </div>
          </div>
        </div>
      </section>
    </b-overlay>
  </div>
</template>
<script type="text/javascript">
import Api from "~/utils/api";
import productBox1 from '../../../../components/product-box/product-box1'
export default {
  // props: ['products', 'category'],
  components: {
    productBox1
  },
  data() {
    return {
      products: null,
      title: 'спецпредложения',
      subtitle: 'эксклюзивные продукты',
      showCart: false,
      showquickviewmodel: false,
      showcomapreModal: false,
      quickviewproduct: {},
      comapreproduct: {},
      cartproduct: {},
      dismissSecs: 5,
      dismissCountDown: 0
    }
  },
  mounted(){
    this.getSpecialOffer()
  },
  methods: {
    getSpecialOffer(){
      Api.getInstance().products.getSpecialOffer().then((response) => {
          this.products = response.data
      })
      .catch((error) => {
          console.log('getCategories -> ', error);
          this.$bvToast.toast("Категории не подгрузились.", {
              title: `Системная ошибка`,
              variant: "danger",
              solid: true,
          });
      });
    },
    // getCategoryProduct(collection) {
    //   return this.products.filter((item) => {
    //     if (item.collection.find(i => i === collection)) {
    //       return item
    //     }
    //   })
    // },
    alert(item) {
      this.dismissCountDown = item
    },
    showCartModal(item, productData) {
      this.showCart = item
      this.cartproduct = productData
      this.$emit('openCart', this.showCart, this.cartproduct)
    },
    showquickview(item, productData) {
      this.showquickviewmodel = item
      this.quickviewproduct = productData
      this.$emit('openQuickview', this.showquickviewmodel, this.quickviewproduct)
    },
    showcomparemodal(item, productData) {
      this.showcomapreModal = item
      this.comapreproduct = productData
      this.$emit('openCompare', this.showcomapreModal, this.comapreproduct)
    }
  }
}
</script>

<style >
h4{
  text-transform: inherit
}
</style>
