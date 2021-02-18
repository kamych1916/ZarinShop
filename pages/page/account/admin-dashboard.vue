<template>
  <div>
    <Header />
    <Breadcrumbs title="Админ Панель" />
    <b-overlay :show="!is_admin" rounded="sm">
      <section class="section-b-space">
        <div class="container" v-if="is_admin">
          <div class="row">
            <b-card no-body v-bind:class="'dashboardtab'">
              <b-tabs pills card vertical>
                <b-tab title="Заказы" active><b-card-text><Orders /></b-card-text></b-tab>
                <b-tab title="Товары"><b-card-text><Products /></b-card-text></b-tab>
                <b-tab title="Категории"><b-card-text><Categories /></b-card-text></b-tab>
                <b-tab title="Почты пользователей">
                  <b-card-text>
                    <b-card header="Почты пользователей" v-if="emails.length > 0" >
                        <div class="p-3">
                          <div v-for="(item, i)  in emails" :key="i" class="pt-2">
                            <span >• {{item.email}}</span>  
                          </div>
                        </div>
                    </b-card>
                  </b-card-text>
                </b-tab>
                <b-tab title="Номера телефонов пользователей">
                  <b-card-text>
                    <b-card header="Номера телефонов пользователей" v-if="phonenumbers.length > 0" >
                        <div class="p-3">
                          <div v-for="(item, i) in phonenumbers" :key="i" class="pt-2">
                            <span >• {{item.phone}} • {{item.Name}}</span>  
                          </div>
                        </div>
                    </b-card>
                  </b-card-text>
                </b-tab>
              </b-tabs>
            </b-card>
          </div>
        </div>
      </section>
    </b-overlay>
    <Footer />
  </div>
</template>

<script>
import Header from "../../../components/header/header1";
import Footer from "../../../components/footer/footer1";
import Breadcrumbs from "../../../components/widgets/breadcrumbs";
import Products from "../../../components/admin/Products";
import Categories from "../../../components/admin/Categories";
import Orders from "../../../components/admin/Orders";
import Api from "~/utils/api";
export default {
  data() {
    return {
      is_admin: false,
      is_user: true,
      phonenumbers: [],
      emails: []
    };
  },
  components: {
    Header,
    Footer,
    Breadcrumbs,
    Products,
    Categories,
    Orders
  },
  mounted() {
    this.getPhonenumbers();
    this.getEmailClients();
    this.check_is_admin();
  },
  methods: {
    getEmailClients() {
      Api.getInstance().auth.getEmailClients().then((response) => {
          this.emails = response.data;
        })
        .catch((error) => {
          console.log('getPhonenumbers-> ', error);
        });
    },
    getPhonenumbers() {
      Api.getInstance().auth.getPhonenumbers().then((response) => {
          this.phonenumbers = response.data;
        })
        .catch((error) => {
          console.log('getPhonenumbers-> ', error);
        });
    },
    check_is_admin() {
      Api.getInstance().auth.check_is_admin().then((response) => {
          response.data === true
            ? (this.is_admin = true)
            : ((this.is_admin = false),
              setTimeout(() => {
                this.$router.push("/");
              }));
        })
        .catch((error) => {
          console.log(error);
          this.is_admin = false;
          setTimeout(() => {
            this.$router.push("/");
          });
        });
    },
  },
};
</script>

<style>
.container .imgs_object {
  position: relative;
}

.container .imgs_object .delete_imgs {
  position: absolute;
  bottom: -10px;
  left: 50%;
  margin-right: -50%;
  transform: translate(-50%, -50%);
  color: red;
  cursor: pointer;
}
</style>