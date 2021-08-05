import 'package:glade_v2/utils/card/cardUtils.dart';

class PaymentCard {

  CardIssuer issuer = CardIssuer.unknown;
  String number;
  String name;
  String month;
  String year;
  String cvv;


  PaymentCard();

  PaymentCard.dummy({
    this.issuer = CardIssuer.amex,
    this.number = '340000000000009',
    this.name = 'Wilberforce Uwadiegwu',
    this.month = '12',
    this.year = '02',
    this.cvv = '123',

  });

  factory PaymentCard.fromJson(Map<String, dynamic> json) => new PaymentCard.dummy(
      name: json["card_name"],
      number: json["card_number"],
      month: json["exp_month"],
      year: json["exp_year"],
      cvv: json["cvv"],

  );

  Map<String, dynamic> toJson() => {
    "card_name": name,
    "card_number": number,
    "exp_month": month,
    "exp_year": year,
    "cvv": cvv,
  };

  static List<PaymentCard> getDummyCards() {
    return [
      PaymentCard.dummy(
          name: 'Chuks Ugwuh',

      ),
      PaymentCard.dummy(
          issuer: CardIssuer.master,
          number: '5500000000000004',

      ),
      PaymentCard.dummy(
          issuer: CardIssuer.visa,
          number: '4111111111111111',

      ),
      PaymentCard.dummy(
          number: 'Lois Genesis',


      ),
    ];
  }



  assignIssuer() {
    issuer = CardUtils.getTypeForIIN(number);
  }
}

enum CardIssuer { visa, master, amex, diners, discover, jcb, verve, unknown }