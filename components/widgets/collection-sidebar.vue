<template>
  <div>
     <div class="row">
        <div class="col-xl-12">
          <div class="filter-main-btn"  @click="filter = !filter">
            <span class="filter-btn btn btn-theme">
              <i class="fa fa-filter" aria-hidden="true"></i> Фильтры
            </span>
          </div>
        </div>
      </div>
      <div class="collection-filter" :class="{ 'openFilterbar' : filter }">
     <div class="collection-filter-block">
      <!-- brand filter start -->
      <div class="collection-mobile-back">
        <span class="filter-back" @click="filter = !filter">
          <i class="fa fa-angle-left" aria-hidden="true"></i> back
        </span>
      </div>
      <div class="collection-collapse-block open">
        <div v-for="(category, i) in categories" :key="i">

          <template v-if="category.id == $route.params.id ">
            <h3 class="collapse-block-title" v-b-toggle.category>категории</h3>
            <b-collapse id="category" visible accordion="myaccordion" role="tabpanel">
              <div class="collection-collapse-block-content">
                <div class="collection-brand-filter">
                    <nuxt-link style="color: #444444; font-weight: 600;" :to="{ path: category.id}">
                      <li style="border-bottom: 1px solid #ccc; width:100%" class="py-3">{{category.name}}</li>
                    </nuxt-link>
                  <div v-for="(sub, y) in categories[i].subcategories" :key="y">
                    <ul class="category-list">
                      <nuxt-link style="color: #444444;" :to="{ path: categories[i].subcategories[y].id}">
                        <li style="border-bottom: 1px solid #ccc" class="py-3">{{categories[i].subcategories[y].name}}</li>
                      </nuxt-link>
                    </ul>
                  </div>
                </div>
              </div>
            </b-collapse>
          </template>

          <template v-else-if="category.id != $route.params.id & typeof(category.subcategories[0]) != undefined  & category.subcategories.length > 0">
            <div v-for="(sub, y) in categories[i].subcategories" :key="y">

              <div v-if="categories[i].subcategories[y].id == $route.params.id">
                <h3 class="collapse-block-title" v-b-toggle.category>Категории</h3>
                <b-collapse id="category" visible accordion="myaccordion" role="tabpanel">
                  <div class="collection-collapse-block-content">
                    <div class="collection-brand-filter">
                      <ul class="category-list">
                        <nuxt-link style="color: #444444; font-weight: 600;"  :to="{ path: category.id}">
                          <li style="border-bottom: 1px solid #ccc" class="py-3">{{category.name}}</li>
                        </nuxt-link>

                        <nuxt-link style="color: #444444; font-weight: 600;" :to="{ path: categories[i].subcategories[y].id}">
                          <li style="border-bottom: 1px solid #ccc" class="py-3">{{categories[i].subcategories[y].name}}</li>
                        </nuxt-link>

                        <div v-for="(lastSub, x) in categories[i].subcategories[y].subcategories" :key="x">
                          <nuxt-link style="color: #444444;" v-if="lastSub" :to="{ path: lastSub.id}">
                            <li style="border-bottom: 1px solid #ccc" class="py-3">{{lastSub.name}}</li>
                          </nuxt-link>
                        </div>
                      </ul>
                    </div>
                  </div>
                </b-collapse>
              </div>

              <div v-else>
                <div v-for="(lastSub, x) in categories[i].subcategories[y].subcategories" :key="x">
                  <div v-if="lastSub.id == $route.params.id">
                    <h3 class="collapse-block-title" v-b-toggle.category>Категории</h3>
                    <b-collapse id="category" visible accordion="myaccordion" role="tabpanel">
                      <div class="collection-collapse-block-content">
                        <div class="collection-brand-filter">
                          <ul class="category-list">
                            <nuxt-link style="color: #444444; font-weight: 600;" :to="{ path: category.id}">
                              <li style="border-bottom: 1px solid #ccc" class="py-3">{{category.name}}</li>
                            </nuxt-link>
                            <nuxt-link style="color: #444444; font-weight: 600;" :to="{ path: categories[i].subcategories[y].id}">
                              <li style="border-bottom: 1px solid #ccc" class="py-3">{{categories[i].subcategories[y].name}}</li>
                            </nuxt-link>
                            <nuxt-link style="color: #444444;" :to="{ path: lastSub.id}">
                              <li style="border-bottom: 1px solid #ccc" class="py-3">{{lastSub.name}}</li>
                            </nuxt-link>
                          </ul>
                        </div>
                      </div>
                    </b-collapse>
                    
                  </div>
                </div>
              </div>

            </div>
          </template>
        </div>
      </div>
    </div>
    <!-- side-bar colleps block stat -->
    <div class="collection-filter-block">
      <!-- price filter start here -->
      <div class="collection-collapse-block border-0 open">
        <h3 class="collapse-block-title" v-b-toggle.price>Диапазон цен</h3>
         <b-collapse id="price" visible accordion="myaccordion4" role="tabpanel">
        <div class="collection-collapse-block-content">
          <div class="collection-brand-filter price-rangee-picker">
            <vue-slider
            v-model="value"
            :min="0"
            :max="10000"
            :interval="1000"
            ref="slider"
            @change="sliderChange($refs.slider.getValue())">
            </vue-slider>
          </div>
        </div>
         </b-collapse>
      </div>
      <!-- color filter start here -->
      <div class="collection-collapse-block open" v-if="filterbycolor.length">
        <h3 class="collapse-block-title" v-b-toggle.colors>Цвета</h3>
          <b-collapse id="colors" visible accordion="myaccordion2" role="tabpanel">
        <div class="collection-collapse-block-content">
          <div class="collection-brand-filter color-filter">
            <div
              class="custom-control custom-checkbox collection-filter-checkbox"
              v-for="(color,index) in filterbycolor"
              :key="index"
            >
              <input
              type="checkbox"
              class="custom-control-input"
              :value="color"
              :id="color"
              v-model="applyFilter"
              @change="appliedFilter(color)" />
              <span :class="color" v-bind:style="{ 'background-color' : color}"></span>
              <label class="custom-control-label" :class="{selected: isActive(color)}" v-bind:for="color">{{convertColor(color)}}</label>
            </div>
          </div>
        </div>
        </b-collapse>
      </div>

      <!-- size filter start here -->
      <div class="collection-collapse-block open" v-if="filterbysize.length">
        <h3 class="collapse-block-title" v-b-toggle.size>Размеры</h3>
         <b-collapse id="size" visible accordion="myaccordion3" role="tabpanel">
        <div class="collection-collapse-block-content">
          <div class="color-selector">
            <div class="collection-brand-filter">
              <div
                class="custom-control custom-checkbox collection-filter-checkbox"
                v-for="(size,index) in filterbysize"
                :key="index"
              >
                <input
                type="checkbox"
                class="custom-control-input"
                :value="size"
                :id="size"
                v-model="applyFilter"
                @change="appliedFilter(size)" />
                <label class="custom-control-label" v-bind:for="size">{{size}}</label>
              </div>
            </div>
          </div>
        </div>
         </b-collapse>
      </div>

    </div>
      <!-- side-bar banner start here -->
      <div class="collection-sidebar-banner">
        <a href="#">
          <img :src="bannerimagepath" class="img-fluid" />
        </a>
      </div>
      <!-- side-bar banner end here -->
    </div>
    <!-- silde-bar colleps block end here -->
  </div>
</template>
<script>
import Api from "~/utils/api";
import { mapState, mapGetters } from 'vuex';
import VueSlider from 'vue-slider-component/dist-css/vue-slider-component.umd.min.js';
export default {
  data() {
    return {      
      categoryID: null,
      categories: null,
      bannerimagepath: require('@/assets/images/side-banner.png'),
      value: [50, 550],
      selectedcolor: [],
      selectedbrand: [],
      selectedsize: [],
      applyFilter: [],
      activeItem: 'category',
      filter: false,
      swiperOption: {
        loop: false,
        navigation: {
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev'
        }
      }
    }
  },
  components: {
    VueSlider
  },
  computed: {
    ...mapState({
      productslist: state => state.products.productslist,
      currency: state => state.products.currency
    }),
    ...mapGetters({
      // filterbyCategory: 'filter/filterbyCategory',
      // filterbyBrand: 'filter/filterbyBrand',
      filterbycolor: 'filter/filterbycolor',
      filterbysize: 'filter/filterbysize'
    })
  },
  mounted() {
    this.getCategories();
    this.$emit('priceVal', this.value);
    // this.$store.dispatch("filter/changeProducts", this.StoreProducts);
    // this.filterbysize = this.$store.filter.filterbysize();
    // console.log(this.$store.getters.filter)
    // console.log('kekkk -> ', this.filterbysize)
  },
  methods: {
    getCategories(){
      Api.getInstance().categories.getCategories()
        .then((response) => {
          this.categories = response.data;
        })
        .catch((error) => {
          console.log('getCategories-> ', error)
          this.forgottitle = true
        });
    },
    convertColor(color){
      let Colors = {
        blue: { title: 'Синий', color: '#0000FF'},
        green: { title: 'зеленый', color: '#008000'},
        black: { title: 'черный', color: '#000000'},
        white: { title: 'белый', color: '#FFFFFF'},
        silver: { title: 'серый', color: '#C0C0C0'},
        yellow: { title: 'желтый', color: '#FFFF00'},
        purple: { title: 'фиолетовый', color: '#800080'},
        orange: { title: 'оранжевый', color: '#FFA500'},
        pink: { title: 'розовый', color: '#FFC0CB'},
      }
      for(let indx in Colors){
        if(Colors[indx].color == color){
          return Colors[indx].title
        }
      }
    },
    getCategoryProduct(collection) {
      return this.productslist.filter((item) => {
        if (item.collection.find(i => i === collection)) {
          return item
        }
      })
    },
    getImgUrl(path) {
      return require('@/assets/images/' + path)
    },
    discountedPrice(product) {
      const price = product.price - (product.price * product.discount / 100)
      return price
    },
    isActive(filterItem) {
      return this.applyFilter.indexOf(filterItem) > -1
    },
    appliedFilter(val) {
      this.$emit('allFilters', this.applyFilter)
    },
    sliderChange(event) {
      this.$emit('priceVal', event)
    },
    toggleSidebarBlock() {
      this.openBlock = !this.openBlock
    },
    getCategoryFilter(category) {
      this.$store.dispatch('filter/getCategoryFilter', category)
    }
  }
}
</script>
<style>
.custom-control{
  padding-left: 1.6rem
}
</style>