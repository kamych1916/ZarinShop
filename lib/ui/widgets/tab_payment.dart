import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/models/credit_card.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:credit_card_input_form/constants/constanst.dart';
import 'package:credit_card_input_form/credit_card_input_form.dart';
import 'package:credit_card_input_form/model/card_info.dart';
import 'package:flutter/material.dart';

class PaymentTab extends StatefulWidget {
  final Function(CreditCard) callback;

  const PaymentTab(this.callback, {Key key}) : super(key: key);
  @override
  _PaymentTabState createState() => _PaymentTabState();
}

class _PaymentTabState extends State<PaymentTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Выберите карту",
            style: TextStyle(fontFamily: "SegoeUISemiBold", fontSize: 16),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
          ),
          Container(
              decoration: BoxDecoration(
                  color: Styles.mainColor,
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.all(20.0),
              child: StreamBuilder<List<CreditCard>>(
                  stream: appBloc.creditCards.stream,
                  builder: (context, AsyncSnapshot<List<CreditCard>> snapshot) {
                    return snapshot.hasData
                        ? ListView.separated(
                            separatorBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                ),
                            shrinkWrap: true,
                            itemCount: appBloc.creditCards.value.length +
                                (appBloc.creditCards.value.length < 3 ? 1 : 0),
                            itemBuilder: (context, index) {
                              return index ==
                                          appBloc.creditCards.value.length &&
                                      appBloc.creditCards.value.length < 3
                                  ? GestureDetector(
                                      onTap: () async {
                                        CardInfo cardInfo =
                                            await showModalBottomSheet(
                                                isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              25.0)),
                                                ),
                                                context: context,
                                                builder: (context) =>
                                                    AddCardSheet());
                                        if (cardInfo != null &&
                                            cardInfo.cardNumber.length == 19 &&
                                            cardInfo.name.isNotEmpty &&
                                            cardInfo.validate.isNotEmpty) {
                                          appBloc.addCreditCard(cardInfo);
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add_circle,
                                              size: 26.0,
                                              color: Styles.mainColor,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Добавить карту",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "SegoeUIBold"),
                                                ),
                                                Text(
                                                  "Master Card / Visa",
                                                  style: TextStyle(
                                                      fontFamily: "SegoeUI",
                                                      fontSize: 12),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () => widget.callback(
                                          appBloc.creditCards.value[index]),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              AppIcons.credit_card,
                                              size: 22,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "**** **** **** " +
                                                    appBloc.creditCards
                                                        .value[index].cardNumber
                                                        .substring(14),
                                                style: TextStyle(
                                                    fontFamily: "SegoeUI",
                                                    fontSize: 14),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => appBloc
                                                  .removeCreditCard(appBloc
                                                      .creditCards
                                                      .value[index]),
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              child: Container(
                                                child: Icon(
                                                  Icons.close,
                                                  size: 18,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                            })
                        : Container();
                  })),
          Expanded(child: Container())
        ],
      ),
    );
  }
}

class AddCardSheet extends StatefulWidget {
  @override
  _AddCardSheetState createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<AddCardSheet> {
  final Map<String, String> cardCaptions = {
    'PREV': 'Назад',
    'NEXT': 'Далее',
    'DONE': 'Готово',
    'CARD_NUMBER': 'Номер карты',
    'CARDHOLDER_NAME': 'Имя держателя карты',
    'VALID_THRU': 'Срок действия карты',
    'SECURITY_CODE_CVC': 'Security Code (CVC)',
    'NAME_SURNAME': 'Имя Фамилия',
    'MM_YY': 'ММ/ГГ',
    'RESET': 'Сбросить',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
              width: 25.0,
              height: 2.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey,
              ),
            ),
          ),
          CreditCardInputForm(
            customCaptions: cardCaptions,
            onStateChange: (currentState, cardInfo) {
              if (currentState == InputState.CVV)
                Navigator.of(context).pop(cardInfo);
            },
            nextButtonDecoration: BoxDecoration(
                color: Styles.mainColor,
                borderRadius: BorderRadius.circular(10)),
            prevButtonDecoration: BoxDecoration(
                color: Styles.mainColor,
                borderRadius: BorderRadius.circular(10)),
            resetButtonDecoration: BoxDecoration(
                color: Styles.mainColor,
                borderRadius: BorderRadius.circular(10)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
          )
        ],
      ),
    );
  }
}
