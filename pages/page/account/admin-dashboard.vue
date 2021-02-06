<template>
  <div>
    <Header />
    <Breadcrumbs title="Админ Панель" />
    <b-overlay :show="!is_admin" rounded="sm">
      <section class="section-b-space">
        <div class="container" v-if="is_admin">
          <div class="row">
            <b-card no-body v-bind:class="'dashboardtab'">
              <AddCategory />

              <AddProduct />

              <b-button class="mb-5" @click="getEmails()" v-if="show_emails">Отобразить почты пользователей</b-button>

              <b-card header="Почты пользователей" v-if="emails.length > 0" class="mt-5">
                  <ul v-for="(item, i) in emails" :key="i">
                    <li>{{item.email}}</li>
                  </ul>
              </b-card>
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
import AddProduct from "../../../components/admin/addProduct";
import AddCategory from "../../../components/admin/addCategory";
import Api from "~/utils/api";
export default {
  data() {
    return {
      is_admin: false,
      is_user: true,
      show_emails: true,
      emails: []
    };
  },
  components: {
    Header,
    Footer,
    Breadcrumbs,
    AddProduct,
    AddCategory,
  },
  mounted() {
    this.check_is_admin();
  },
  methods: {
    getEmails() {
      Api.getInstance().auth.getEmailClients().then((response) => {
          this.emails = response.data;
          this.show_emails = false;
        })
        .catch((error) => {
          console.log('getEmails-> ', error);
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