// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  User read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      bvn: fields[5] as dynamic,
      email: fields[1] as String,
      hasBusinessAccount: fields[7] as bool,
      accountNum: fields[9] as String,
      hasPassCode: fields[8] as bool,
      compliance_status: fields[6] as String,
      phone: fields[3] as String,
      preferredPhone: fields[4] as bool,
      token: fields[2] as String,
      is_email_verified: fields[0] as bool,
      availableBalance: fields[11] as String,
      bank_name: fields[10] as String,
      ledgerBalance: fields[12] as String,
      firstname: fields[13] as String,
      lastname: fields[14] as String,
      is_phone_verified: fields[15] as bool,
      business_message: fields[16] as dynamic,
      business_uuid: fields[17] as String,
      business_name: fields[18] as String,
      mid: fields[19] as dynamic,
      key: fields[20] as String,
      referral_code: fields[21] as String,
      is_bvn_matched: fields[22] as bool,
      currency: fields[23] as String,
      user_uuid: fields[24] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.is_email_verified)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.token)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.preferredPhone)
      ..writeByte(5)
      ..write(obj.bvn)
      ..writeByte(6)
      ..write(obj.compliance_status)
      ..writeByte(7)
      ..write(obj.hasBusinessAccount)
      ..writeByte(8)
      ..write(obj.hasPassCode)
      ..writeByte(9)
      ..write(obj.accountNum)
      ..writeByte(10)
      ..write(obj.bank_name)
      ..writeByte(11)
      ..write(obj.availableBalance)
      ..writeByte(12)
      ..write(obj.ledgerBalance)
      ..writeByte(13)
      ..write(obj.firstname)
      ..writeByte(14)
      ..write(obj.lastname)
      ..writeByte(15)
      ..write(obj.is_phone_verified)
      ..writeByte(16)
      ..write(obj.business_message)
      ..writeByte(17)
      ..write(obj.business_uuid)
      ..writeByte(18)
      ..write(obj.business_name)
      ..writeByte(19)
      ..write(obj.mid)
      ..writeByte(20)
      ..write(obj.key)
      ..writeByte(21)
      ..write(obj.referral_code)
      ..writeByte(22)
      ..write(obj.is_bvn_matched)
      ..writeByte(23)
      ..write(obj.currency)
      ..writeByte(24)
      ..write(obj.user_uuid);
  }

  @override
  // TODO: implement typeId
  int get typeId => 0;
}
