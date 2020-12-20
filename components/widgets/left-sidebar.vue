<template>

  <div id="mySidenav" class="sidenav" :class="{ openSide:leftSidebarVal }">
    <a class="sidebar-overlay" @click="closeLeftBar(leftSidebarVal)"></a>
    <nav>
      <a @click="closeLeftBar(leftSidebarVal)">
        <div class="sidebar-back text-left">
          <i class="fa fa-angle-left pr-2" aria-hidden="true"></i> Выйти
        </div>
      </a>
      <!-- Sample menu definition -->

      <ul id="sub-menu" class="sidebar-menu">
        <li v-for="(category, i) in categories" :key="i">
          <nuxt-link :to="'/collection/leftsidebar/' + category.id" v-if="category.subcategories.length > 0" href="javascript:void(0)" @click="setActive('clothing')">{{category.name}}
            <span class="sub-arrow"></span>
          </nuxt-link>
          <nuxt-link :to="'/collection/leftsidebar/' + category.id" v-else>
            {{category.name}}
          </nuxt-link>
          <ul v-if="category.subcategories.length > 0" class="mega-menu clothing-menu" :class="{ opensidesubmenu: isActive('clothing') }">
            <li>
                <div class="row m-0">
                  <div v-for="(sub, i) in category.subcategories" :key="i" class="col-xl-6">
                    <div  class="link-section">
                      <nuxt-link :to="'/collection/leftsidebar/' + sub.id" v-if="sub.subcategories.length > 0" style="padding: 0"><h5>{{sub.name}}</h5></nuxt-link> 
                      <nuxt-link :to="'/collection/leftsidebar/' + sub.id" v-else style="padding: 0"><h5 style="font-weight:100">{{sub.name}}</h5></nuxt-link> 
                      <ul v-if="sub.subcategories.length > 0">
                        <li v-for="(lastSub, i) in sub.subcategories" :key="i">
                          <nuxt-link :to="'/collection/leftsidebar/' + lastSub.id">{{lastSub.name}}</nuxt-link>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
            </li>
          </ul>
        </li>
      </ul>
      <!-- <ul id="sub-menu" class="sidebar-menu">
        <li>
          <a href="javascript:void(0)" @click="setActive('clothing')">clothing
            <span class="sub-arrow"></span>
          </a>
          <ul class="mega-menu clothing-menu" :class="{ opensidesubmenu: isActive('clothing') }">
            <li>
              <div class="row m-0">
                <div class="col-xl-4">
                  <div class="link-section">
                    <h5>women's fashion</h5>
                    <ul>
                      <li>
                        <a href="#">dresses</a>
                      </li>
                      <li>
                        <a href="#">skirts</a>
                      </li>
                      <li>
                        <a href="#">westarn wear</a>
                      </li>
                      <li>
                        <a href="#">ethic wear</a>
                      </li>
                      <li>
                        <a href="#">sport wear</a>
                      </li>
                    </ul>
                    <h5>men's fashion</h5>
                    <ul>
                      <li>
                        <a href="#">sports wear</a>
                      </li>
                      <li>
                        <a href="#">western wear</a>
                      </li>
                      <li>
                        <a href="#">ethic wear</a>
                      </li>
                      <li>
                        <a href="#">sports wear</a>
                      </li>
                      <li>
                        <a href="#">western wear</a>
                      </li>
                      <li>
                        <a href="#">ethic wear</a>
                      </li>
                    </ul>
                  </div>
                </div>
                <div class="col-xl-4">
                  <div class="link-section">
                    <h5>accessories</h5>
                    <ul>
                      <li>
                        <a href="#">fashion jewellery</a>
                      </li>
                      <li>
                        <a href="#">caps and hats</a>
                      </li>
                      <li>
                        <a href="#">precious jewellery</a>
                      </li>
                      <li>
                        <a href="#">necklaces</a>
                      </li>
                      <li>
                        <a href="#">earrings</a>
                      </li>
                      <li>
                        <a href="#">wrist wear</a>
                      </li>
                      <li>
                        <a href="#">ties</a>
                      </li>
                      <li>
                        <a href="#">cufflinks</a>
                      </li>
                      <li>
                        <a href="#">pockets squares</a>
                      </li>
                    </ul>
                  </div>
                </div>
                <div class="col-xl-4">
                  <a href="#" class="mega-menu-banner">
                    <img :src='"../../assets/images/mega-menu/fashion.jpg"' alt class="img-fluid">
                  </a>
                </div>
              </div>
            </li>
          </ul>
        </li>
        <li>
          <a href="javascript:void(0)" @click="setActive('bags')">bags
            <span class="sub-arrow"></span>
          </a>
          <ul :class="{ opensub1: isActive('bags') }">
            <li>
              <a href="#">shopper bags</a>
            </li>
            <li>
              <a href="#">laptop bags</a>
            </li>
            <li>
              <a href="#">clutches</a>
            </li>
          </ul>
        </li>
        <li>
          <a href="javascript:void(0)" @click="setActive('footwear')">footwear
            <span class="sub-arrow"></span>
          </a>
          <ul :class="{ opensub1: isActive('footwear') }">
            <li>
              <a href="#">sport shoes</a>
            </li>
            <li>
              <a href="#">formal shoes</a>
            </li>
            <li>
              <a href="#">casual shoes</a>
            </li>
          </ul>
        </li>
        <li>
          <a href="#">watches</a>
        </li>
        <li>
          <a href="javascript:void(0)" @click="setActive('accessories')">Accessories
            <span class="sub-arrow"></span>
          </a>
          <ul :class="{ opensub1: isActive('accessories') }">
            <li>
              <a href="#">fashion jewellery</a>
            </li>
            <li>
              <a href="#">caps and hats</a>
            </li>
            <li>
              <a href="#">precious jewellery</a>
            </li>
          </ul>
        </li>
        <li>
          <a href="javascript:void(0)">house of design</a>
        </li>
        <li>
          <a href="javascript:void(0)" @click="setActive('beauty')">beauty & personal care
            <span class="sub-arrow"></span>
          </a>
          <ul :class="{ opensub1: isActive('beauty') }">
            <li>
              <a href="#">makeup</a>
            </li>
            <li>
              <a href="#">skincare</a>
            </li>
            <li>
              <a href="#">premium beaty</a>
            </li>
          </ul>
        </li>
        <li>
          <a href="#">home & decor</a>
        </li>
        <li>
          <a href="#">kitchen</a>
        </li>
      </ul> -->
    </nav>
  </div>
</template>

<script>
import Api from "~/utils/api";
export default {
  props: ['leftSidebarVal'],
  data() {
    return {
      activeItem: 'clothing',
      categories: null,
    }
  },
  mounted(){
    this.getCategories();
  },
  methods: {

    // encrypt(id){
    //   return CryptoJS.AES.encrypt(id, "Secret Passphrase");
    // },

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

    closeLeftBar(val) {
      val = false
      this.$emit('closeVal', val)
    },
    isActive: function (menuItem) {
      return this.activeItem === menuItem
    },
    setActive: function (menuItem) {
      if (this.activeItem === menuItem) {
        this.activeItem = ''
      } else {
        this.activeItem = menuItem
      }
    }
  }
}
</script>
