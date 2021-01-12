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
                  method="post"
                  id="mc-embedded-subscribe-form"
                  name="mc-embedded-subscribe-form"
                  target="_blank"
                >
                  <div class="form-group mx-sm-3">
                    <input
                      type="text"
                      class="form-control"
                      name="EMAIL"
                      id="mce-EMAIL"
                      placeholder="Введите свою почту"
                      required="required"
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
                <p>Компания Zrin Shop предоставляет обширный спектр товаров. Каждый посетитель сможет найти подходящий себе товар. Гарантия качества!</p>
                <div class="footer-social">
                  <ul>
                    <li>
                      <a href="#">
                        <i class="fa fa-facebook" aria-hidden="true"></i>
                      </a>
                    </li>
                    <li>
                      <a href="#">
                        <i class="fa fa-google-plus" aria-hidden="true"></i>
                      </a>
                    </li>
                    <li>
                      <a href="#">
                        <i class="fa fa-twitter" aria-hidden="true"></i>
                      </a>
                    </li>
                    <li>
                      <a href="#">
                        <i class="fa fa-instagram" aria-hidden="true"></i>
                      </a>
                    </li>
                    <li>
                      <a href="#">
                        <i class="fa fa-rss" aria-hidden="true"></i>
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
                  <h4>store information</h4>
                </div>
                <div class="footer-contant">
                  <ul class="contact-list">
                    <li>
                      <i class="fa fa-map-marker"></i>страна Узбекистан, город Ташкен, улица такая-то
                    </li>
                    <li>
                      <i class="fa fa-phone"></i>+998 (78) 150-00-02
                    </li>
                    <li>
                      <i class="fa fa-envelope-o"></i>
                      <a href="#">zarinshop@gmail.com</a>
                    </li>
                    <li>
                      <i class="fa fa-fax"></i>Fax: 123456
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
                  <i class="fa fa-copyright" aria-hidden="true"></i> 2021 разработано компанией Mirllex
                </p>
              </div>
            </div>
            <div class="col-xl-6 col-md-6 col-sm-12">
              <div class="payment-card-bottom">
                <ul>
                  <li>
                    <a href="#">
                      <img :src='"@/assets/images/icon/visa.png"' alt />
                    </a>
                  </li>
                  <li>
                    <a href="#">
                      <img :src='"@/assets/images/icon/mastercard.png"' alt />
                    </a>
                  </li>
                  <li>
                    <a href="#">
                      <img :src='"@/assets/images/icon/paypal.png"' alt />
                    </a>
                  </li>
                  <li>
                    <a href="#">
                      <img :src='"@/assets/images/icon/american-express.png"' alt />
                    </a>
                  </li>
                  <li>
                    <a href="#">
                      <img :src='"@/assets/images/icon/discover.png"' alt />
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
export default {
}
</script>
