
// title: json["title"],

class PaymentLinkItem {
  int id;
  int userId;
  String name;
  String description;
  var amount;
  String currency;
  var isFixed;
  var extraAmount;
  var extraCurrency;
  var extraFields;

  String eventTicketingCurrency;

  var status;
  String link;
  String mid;
  String phoneNumber;
  var acceptPhonenumber;
  String redirectLink;
  String customMessage;
  String notificationEmail;
  var type;
  var image;
  var frequency;
  var value;
  var frequencyLimit;
  var chooseFrequency;
  String bearer;
  var isTicket;
  List<EventData> eventData;
  List<TicketData> ticketData;
  var quantity;
  var showQuantity;
  var isSplit;
  var splitReference;
  var splitShare;
  var splitType;
  String createdAt;
  String updatedAt;

  PaymentLinkItem.fromJson(Map<String, dynamic> json) {

    id = json["id"];
    userId = json["user_id"];
    name = json["title"];
    description = json["description"];
    amount = json["amount"]; // for fixed amount
    currency = json["currency"]; // for fixed amount
    isFixed = json["is_fixed"];
    extraAmount = getExtraAmount(extra: json["extra_amounts"]);
    extraCurrency = getExtraCurrency(extra: json["extra_currency"]);
    extraFields = json["extra_fields"];
    status = json["status"];
    link = json["paycode"];
    mid = json["mid"];
    phoneNumber = json["phone_number"];
    acceptPhonenumber = json["accept_phonenumber"];
    redirectLink = json["redirect_link"];
    customMessage = json["custom_message"];
    notificationEmail = json["notification_email"];
    type = json["type"];
    image = json["image"];
    frequency = json["frequency"]; // is null if one time payment
    value = json["value"]; // represents the day set for frequency 1 - 29?
    frequencyLimit = json["frequency_limit"];
    chooseFrequency = json["choose_frequency"];
    bearer = json["bearer"];
    isTicket = json["is_ticket"]; // 1 or 0
//    eventTicketingCurrency = json["ticket_data"] != null ? json["ticket_data"]["currency"] : "";
    eventData = json["event_data"] != null
        ? getEventData(data: json["event_data"])
        : [];
    ticketData = json["ticket_data"] != null
        ? getTicketData(data: json["ticket_data"])
        : [];
    quantity = json["quantity"];
    showQuantity = json["show_quantity"];
    isSplit = json["is_split"];
    splitReference = json["split_reference"];
    splitType = json["split_type"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  getEventData({String data}) {
    List<EventData> eventDatas = [];
    if (data != null){
      List<String> filter = data.replaceAll("{", "").replaceAll("}", "").split(",");

      filter.forEach((v){
        var s = v.split(":");
        if (s.isNotEmpty && s.length > 2){
          eventDatas.add(EventData(eventDetails: purge(string: s[0]), valueDetails: purge(string: s[1])));
        }
      });
    }

    return eventDatas;
  }

  getTicketData({String data}) {
    List<TicketData> ticketDatas = [];

    if (data != null && data != "[]") {
      List<String> filter = data.replaceAll("{", "").replaceAll("}", "").split(",");

      eventTicketingCurrency = filter[0].split(":")[1].replaceAll("\"", "");

      for (int i = 1; i < filter.length; i++){
        ticketDatas.add(TicketData(ticketName: purge(string: purge(string: filter[i]).split(":")[0]),
            ticketPrice: purge(string: purge(string: filter[i]).split(':')[1])));
      }
    }
    return ticketDatas;
  }

  String purge({String string}){
    return string.replaceAll("\"data\":", "").replaceAll("\"", "");
  }

  getExtraAmount({String extra}){
    List<String> extraAmounts = [];
    if (extra != null){
      extraAmounts.addAll(extra.replaceAll("[", "").replaceAll("]", "").replaceAll("\"", "").split(","));
    }
    return extraAmounts;
  }

  getExtraCurrency({String extra}){
    List<String> extraCurrency = [];
    if (extra != null){
      extraCurrency.addAll(extra.replaceAll("[", "").replaceAll("]", "").replaceAll("\"", "").split(','));
    }
    return extraCurrency;
  }
}

class EventData {
  String eventDetails;
  String valueDetails;

  EventData({this.valueDetails, this.eventDetails});

  @override
  String toString() {
    super.toString();
    return "eventDetails: $eventDetails, valueDetails: $valueDetails";
  }


}

class TicketData {
  String ticketName;
  String ticketPrice;

  TicketData({this.ticketName, this.ticketPrice});


  @override
  String toString() {
    super.toString();
    return "ticketName: $ticketName, ticketPrice: $ticketPrice";
  }

}
