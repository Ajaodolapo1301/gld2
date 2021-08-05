// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Business.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessAdapter extends TypeAdapter<Business> {
  @override
  Business read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Business(
      business_uuid: fields[1] as String,
      business_address: fields[7] as String,
      business_category: fields[5] as String,
      business_email: fields[2] as String,
      business_name: fields[0] as String,
      contact_email: fields[3] as String,
      contact_phone: fields[6] as String,
      country: fields[8] as String,
      state: fields[9] as String,
      status: fields[4] as String,
      account_number: fields[10] as String,
      available_balance: fields[12] as String,
      bank_name: fields[11] as String,
      compliance_status: fields[14] as String,
      ledger_balance: fields[13] as String,
      currency: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Business obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.business_name)
      ..writeByte(1)
      ..write(obj.business_uuid)
      ..writeByte(2)
      ..write(obj.business_email)
      ..writeByte(3)
      ..write(obj.contact_email)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.business_category)
      ..writeByte(6)
      ..write(obj.contact_phone)
      ..writeByte(7)
      ..write(obj.business_address)
      ..writeByte(8)
      ..write(obj.country)
      ..writeByte(9)
      ..write(obj.state)
      ..writeByte(10)
      ..write(obj.account_number)
      ..writeByte(11)
      ..write(obj.bank_name)
      ..writeByte(12)
      ..write(obj.available_balance)
      ..writeByte(13)
      ..write(obj.ledger_balance)
      ..writeByte(14)
      ..write(obj.compliance_status)
      ..writeByte(15)
      ..write(obj.currency);
  }

  @override
  // TODO: implement typeId
  int get typeId => 1;
}
