import 'package:Zarin/app_icons.dart';
import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/models/address.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class AddressTab extends StatefulWidget {
  final Function(Address, String) callback;

  const AddressTab(this.callback, {Key key}) : super(key: key);
  @override
  _AddressTabState createState() => _AddressTabState();
}

class _AddressTabState extends State<AddressTab> {
  String deliveryType = "Доставка домой";

  deliveryTypePickerCallback(String currentType) => deliveryType = currentType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Выберите способ и адрес доставки",
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
              child: StreamBuilder<List<Address>>(
                  stream: appBloc.addressesStream,
                  builder: (context, AsyncSnapshot<List<Address>> snapshot) {
                    return snapshot.hasData
                        ? ListView.separated(
                            physics: BouncingScrollPhysics(),
                            separatorBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                ),
                            shrinkWrap: true,
                            itemCount: appBloc.addresses.length +
                                1 +
                                (appBloc.addresses.length < 3 ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == 0)
                                return DeliveryTypePicker(
                                    deliveryTypePickerCallback);
                              return index == appBloc.addresses.length + 1 &&
                                      appBloc.addresses.length < 3
                                  ? GestureDetector(
                                      onTap: () => showModalBottomSheet(
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(25.0)),
                                          ),
                                          context: context,
                                          builder: (context) =>
                                              AddAddressSheet()),
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
                                            Text(
                                              "Добавить адрес",
                                              style: TextStyle(
                                                  fontFamily: "SegoeUIBold"),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () => widget.callback(
                                          appBloc.addresses[index - 1],
                                          deliveryType),
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
                                              AppIcons.map_marker,
                                              size: 22,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    appBloc.addresses[index - 1]
                                                        .code,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                        fontFamily: "SegoeUI",
                                                        fontSize: 12),
                                                  ),
                                                  Text(
                                                    appBloc.addresses[index - 1]
                                                        .city,
                                                    maxLines: 5,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: "SegoeUI",
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    appBloc.addresses[index - 1]
                                                            .street +
                                                        " " +
                                                        appBloc
                                                            .addresses[
                                                                index - 1]
                                                            .houseNumber +
                                                        " - " +
                                                        appBloc
                                                            .addresses[
                                                                index - 1]
                                                            .apartmentNumber,
                                                    maxLines: 5,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "SegoeUISemiBold",
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () =>
                                                  appBloc.removeAddress(appBloc
                                                      .addresses[index - 1]),
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 20.0),
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
          Expanded(
            child: Container(),
          )
        ],
      ),
    );
  }
}

class AddAddressSheet extends StatefulWidget {
  @override
  _AddAddressSheetState createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<AddAddressSheet> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> data = ["", "", "", "", ""];

  Widget field(String hintText, int index,
      {TextInputType textInputType, bool hasFocus}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 60,
        child: TextFormField(
            cursorColor: Colors.black54,
            keyboardType: textInputType ?? TextInputType.text,
            textAlign: TextAlign.center,
            onChanged: (value) => data[index] = value,
            autofocus: hasFocus ?? false,
            validator: (value) =>
                value != null && value.isNotEmpty ? null : "Заполните поле",
            style: TextStyle(
                decoration: TextDecoration.none,
                decorationColor: Colors.white.withOpacity(0)),
            decoration: InputDecoration(
                helperText: ' ',
                contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5),
                filled: true,
                fillColor: Color.fromRGBO(230, 236, 240, 1),
                hintMaxLines: 1,
                hintStyle: TextStyle(
                    color: Color.fromRGBO(134, 145, 173, 1), fontSize: 14.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                hintText: hintText)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fields = List.from([
      field("Населенный пункт", 0,
          textInputType: TextInputType.streetAddress, hasFocus: true),
      field("Улица", 1, textInputType: TextInputType.streetAddress),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: field("Номер дома", 2)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
          Expanded(child: field("Номер квартиры", 3)),
        ],
      ),
      field("Индекс", 4),
    ]);

    return Container(
      padding: MediaQuery.of(context).viewInsets,
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Text(
            "Новый адрес доставки",
            style: TextStyle(fontFamily: "SegoeUIBold"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: fields,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_formKey.currentState.validate()) {
                Address address =
                    Address(data[0], data[1], data[2], data[3], data[4]);
                appBloc.addAddress(address);
                Navigator.of(context).pop();
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Styles.mainColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Text("Готово"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
          )
        ],
      ),
    );
  }
}

class DeliveryTypePicker extends StatefulWidget {
  final Function(String) callback;

  const DeliveryTypePicker(this.callback, {Key key}) : super(key: key);

  @override
  _DeliveryTypePickerState createState() => _DeliveryTypePickerState();
}

class _DeliveryTypePickerState extends State<DeliveryTypePicker> {
  String currentType = "Доставка домой";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String type = await showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            context: context,
            builder: (context) => DeliveryTypePickerSheet(
                  currentType: currentType,
                ));

        if (type != null && type != currentType)
          setState(() => currentType = type);

        widget.callback(currentType);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(
              Icons.move_to_inbox,
              size: 26.0,
              color: Styles.mainColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Способ доставки",
                  style: TextStyle(fontFamily: "SegoeUIBold"),
                ),
                Text(
                  currentType,
                  style: TextStyle(fontFamily: "SegoeUISemiBold"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DeliveryTypePickerSheet extends StatelessWidget {
  final String currentType;

  final List<String> deliveryTypes = [
    "Доставка домой",
    "Еще какой-то тип",
    "Еще тип какой-то"
  ];

  DeliveryTypePickerSheet({Key key, this.currentType}) : super(key: key);

  Widget sortElement(String type, BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.of(context).pop(type);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          color: Styles.backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(type)),
              type == currentType
                  ? Icon(
                      Icons.check,
                      size: 20.0,
                    )
                  : Container()
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets,
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Text(
            "Выберите способ доставки",
            style: TextStyle(fontFamily: "SegoeUIBold"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
          ),
          ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              shrinkWrap: true,
              itemCount: deliveryTypes.length,
              itemBuilder: (context, index) =>
                  sortElement(deliveryTypes[index], context)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
          ),
        ],
      ),
    );
  }
}
