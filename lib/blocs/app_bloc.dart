import 'dart:convert';

import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/models/address.dart';
import 'package:Zarin/models/credit_card.dart';
import 'package:credit_card_input_form/model/card_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBloc {
  SharedPreferences prefs;
  FlutterSecureStorage storage;

  BehaviorSubject<List<CreditCard>> _creditCardsSubject = BehaviorSubject();
  BehaviorSubject<List<Address>> _addressesSubject = BehaviorSubject();

  Stream<List<CreditCard>> get creditCardsStream => _creditCardsSubject.stream;
  Stream<List<Address>> get addressesStream => _addressesSubject.stream;

  List<CreditCard> get creditCards => _creditCardsSubject.value;
  List<Address> get addresses => _addressesSubject.value;

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

    addresses.add(address);
    _addressesSubject.sink.add(addresses);

    saveAddresses();
  }

  removeAddress(Address address) {
    addresses.remove(address);
    _addressesSubject.sink.add(addresses);

    saveAddresses();
  }

  saveAddresses() {
    appBloc.storage.write(key: "addresses", value: json.encode(addresses));
  }

  loadAddresses() async {
    String addressesJSON = await appBloc.storage.read(key: "addresses");

    if (addressesJSON == null || addressesJSON.isEmpty) {
      _addressesSubject.sink.add([]);
      return;
    }

    List<dynamic> addressesEncode = json.decode(addressesJSON);

    List<Address> adresses = [];

    for (dynamic address in addressesEncode)
      adresses.add(Address.fromJson(address));

    if (adresses != null) {
      _addressesSubject.sink.add(adresses);
      return;
    }
  }

  /// Карты

  addCreditCard(CardInfo cardInfo) {
    CreditCard creditCard = new CreditCard(
        cardNumber: cardInfo.cardNumber,
        name: cardInfo.name,
        validate: cardInfo.validate);

    creditCards.add(creditCard);
    _creditCardsSubject.sink.add(creditCards);

    saveCreditCards();
  }

  removeCreditCard(CreditCard creditCard) {
    creditCards.remove(creditCard);
    _creditCardsSubject.sink.add(creditCards);

    saveCreditCards();
  }

  saveCreditCards() {
    appBloc.storage.write(key: "creditCards", value: json.encode(creditCards));
  }

  loadCreditCards() async {
    String creditCardsJSON = await appBloc.storage.read(key: "creditCards");

    if (creditCardsJSON == null || creditCardsJSON.isEmpty) {
      _creditCardsSubject.sink.add([]);
      return;
    }

    List<dynamic> creditCardsEncode = json.decode(creditCardsJSON);

    List<CreditCard> creditCards = [];

    for (dynamic creditCard in creditCardsEncode)
      creditCards.add(CreditCard.fromJson(creditCard));

    if (creditCards != null) {
      _creditCardsSubject.sink.add(creditCards);
      return;
    }
  }

  /// Dispose

  void dispose() async {
    await _creditCardsSubject.drain();
    _creditCardsSubject.close();
    await _addressesSubject.drain();
    _addressesSubject.close();
  }
}

final AppBloc appBloc = AppBloc();
