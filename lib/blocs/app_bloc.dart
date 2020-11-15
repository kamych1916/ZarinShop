import 'dart:convert';

import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/address.dart';
import 'package:Zarin/models/credit_card.dart';
import 'package:Zarin/models/event.dart';
import 'package:credit_card_input_form/model/card_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBloc {
  SharedPreferences prefs;
  FlutterSecureStorage storage;

  final Event<List<CreditCard>> creditCards = Event();
  final Event<List<Address>> addresses = Event();

  /// Инициализация

  init(context) async {
    prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    storage = new FlutterSecureStorage();
    //storage.deleteAll();

    await loadCreditCards();
    await loadAddresses();

    bool auth = await userBloc.getUser();
    auth
        ? await productBloc.getCartEntities()
        : productBloc.getLocalCartEntities();

    productBloc.getFavoritesEntitiesFromLocal();
    await productBloc.getCategories(context);
  }

  /// Адреса

  addAddress(Address addressTemp) {
    Address address = Address.copy(addressTemp);

    addresses.value.add(address);
    addresses.publish(addresses.value);

    saveAddresses();
  }

  removeAddress(Address address) {
    addresses.value.remove(address);
    addresses.publish(addresses.value);

    saveAddresses();
  }

  saveAddresses() {
    appBloc.storage.write(key: "addresses", value: json.encode(addresses));
  }

  loadAddresses() async {
    String addressesJSON = await appBloc.storage.read(key: "addresses");

    if (addressesJSON == null || addressesJSON.isEmpty) {
      addresses.publish([]);
      return;
    }

    List<dynamic> addressesEncode = json.decode(addressesJSON);

    List<Address> adresses = [];

    for (dynamic address in addressesEncode)
      adresses.add(Address.fromJson(address));

    if (adresses != null) {
      addresses.publish(adresses);
      return;
    }
  }

  /// Карты

  addCreditCard(CardInfo cardInfo) {
    CreditCard creditCard = new CreditCard(
        cardNumber: cardInfo.cardNumber,
        name: cardInfo.name,
        validate: cardInfo.validate);

    creditCards.value.add(creditCard);
    creditCards.publish(creditCards.value);

    saveCreditCards();
  }

  removeCreditCard(CreditCard creditCard) {
    creditCards.value.remove(creditCard);
    creditCards.publish(creditCards.value);

    saveCreditCards();
  }

  saveCreditCards() {
    appBloc.storage.write(key: "creditCards", value: json.encode(creditCards));
  }

  loadCreditCards() async {
    String creditCardsJSON = await appBloc.storage.read(key: "creditCards");

    if (creditCardsJSON == null || creditCardsJSON.isEmpty) {
      this.creditCards.publish([]);
      return;
    }

    List<dynamic> creditCardsEncode = json.decode(creditCardsJSON);

    List<CreditCard> creditCards = [];

    for (dynamic creditCard in creditCardsEncode)
      creditCards.add(CreditCard.fromJson(creditCard));

    if (creditCards != null) {
      this.creditCards.publish(creditCards);
      return;
    }
  }

  /// Dispose

  void dispose() async {
    await creditCards.dispose();
    await addresses.dispose();
  }
}

final AppBloc appBloc = AppBloc();
