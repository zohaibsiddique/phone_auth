import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:phone_auth/util/colors.dart';

class CountryCodeLayout extends StatelessWidget {

  final Function(String,String) phoneNumber;
  final String labelText, initialSelection, suffixTxt;

  const CountryCodeLayout({Key key, @required this.labelText,
    @required this.initialSelection, @required this.phoneNumber, this.suffixTxt,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IntlPhoneField(
          decoration: InputDecoration(
            labelText: labelText,
            suffixText: suffixTxt, suffixStyle: TextStyle(color: Colors.red),
          ),
          initialCountryCode: initialSelection,
          initialValue: "3087476605",
          onChanged: (phone) {
            phoneNumber(phone.countryCode,phone.number);
          },
        ),
    );
  }
}
