<template>
  <div>
    <footer class="footer-light">
      <div class="light-layout">
        <div class="container">
          <section class="small-section border-section border-top-0">
            <div class="row">
              <div class="col-lg-6">
                <div class="subscribe">
                  <div>
                    <h4>УЗНАЙТЕ О НОВОСТЯХ ПЕРВЫМИ!</h4>
                    <p>Вы не пропустите о поступлении новых товарах, подписавшись на рассылку.</p>
                  </div>
                </div>
              </div>
              <div class="col-lg-6">
                <form
                  class="form-inline subscribe-form auth-form needs-validation"
                  id="mc-embedded-subscribe-form"
                  name="mc-embedded-subscribe-form"
                  @submit.prevent="sendClientEmail()"
                >
                  <div class="form-group mx-sm-3">
                    <input
                      type="text"
                      class="form-control"
                      name="EMAIL"
                      id="mce-EMAIL"
                      placeholder="Введите свою почту"
                      required="required"
                      v-model="ClientEmail"
                    />
                  </div>
                  <button type="submit" class="btn btn-solid" id="mc-submit">подписаться</button>
                </form>
              </div>
            </div>
          </section>
        </div>
      </div>
      <section class="section-b-space light-layout">
        <div class="container">
          <div class="row footer-theme partition-f">
            <div class="col-lg-6 col-md-6">
              <div class="footer-contant">
                <div class="footer-logo">
                  <h1>ZARINSHOP</h1>
                </div>
                <p>Компания Zarin Shop предоставляет обширный спектр товаров. Каждый посетитель сможет найти подходящий себе товар. Гарантия качества!</p>
                <div class="footer-social">
                  <ul>
                    <li>
                      <a href="https://www.facebook.com/zarin.home.96">
                        <i class="fa fa-facebook" aria-hidden="true"></i>
                      </a>
                    </li>
                    <li>
                      <a href="https://instagram.com/zarin_home_collection.uz?igshid=b8ik4lwxxile">
                        <i class="fa fa-instagram" aria-hidden="true"></i>
                      </a>
                    </li>
                    <li>
                      <a href="https://t.me/zarinhomecollection_1">
                        <i class="fa fa-telegram" aria-hidden="true"></i>
                      </a>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            <div class="col">

            </div>

            <div class="col-xl-4">
              <div class="sub-title">
                <div class="footer-title">
                  <h4>ИНФОРМАЦИЯ</h4>
                </div>
                <div class="footer-contant">
                  <ul class="contact-list">
                    <li style="text-transform: unset">
                      <i class="fa fa-map-marker"></i>Ташкент, Яшнабадский р-н, 1 проезд Алимкент 36/1
                    </li>
                    <li style="text-transform: unset">
                      <i class="fa fa-phone"></i>
                      <a href="tel:+998722240101">+998 (72) 224-01-01</a> 
                    </li>
                    <li style="text-transform: unset">
                      <i class="fa fa-envelope-o"></i>
                      <a href="mailto:info@zarinshop.uz" >info@zarinshop.uz</a>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
      <div class="sub-footer">
        <div class="container">
          <div class="row">
            <div class="col-xl-6 col-md-6 col-sm-12">
              <div class="footer-end">
                <p>
                  <i class="fa fa-copyright" aria-hidden="true"></i> 2021 разработано компанией <b> <a href="https://mirllex.space" style="color: black">Mirllex</a> </b> 
                </p>
              </div>
            </div>
            <div class="col-xl-6 col-md-6 col-sm-12">
              <div class="payment-card-bottom">
                <ul>
                  <li>
                    Платежные системы: 
                  </li>
                  <li>
                    <a href="https://click.uz/ru">
                      <img :src='"@/assets/images/icon/click.png"' width="30px" alt />
                    </a>
                  </li>
                  <li>
                    <a href="https://payme.uz/">
                      <img :src='"@/assets/images/icon/payme.png"' width="30px" alt />
                    </a>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<script>
import Api from "~/utils/api";

export default {
  data () {
    return {
      ClientEmail: ''
    }
  },
  methods: {
    sendClientEmail(){
      Api.getInstance().auth.sendClientEmail(this.ClientEmail).then((response) => {
        this.$bvToast.toast('Ваш E-mail был успешно добавлен в базу данных.', {
            title: `Сообщение`,
            variant: "success",
            solid: true
        })
      }).catch((error) => {
        console.log('sendClientEmail -> ', error)
      });
    },
  }
}
</script>
