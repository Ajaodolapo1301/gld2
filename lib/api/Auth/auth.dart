import 'dart:convert';
import 'dart:developer';

import 'package:glade_v2/api/Business/AddBusiness/addBusiness.dart';
import 'package:glade_v2/core/models/apiModels/Auth/balance.dart';
import 'package:glade_v2/core/models/apiModels/Auth/bvn.dart';
import 'package:glade_v2/core/models/apiModels/Auth/register.dart';
import 'package:glade_v2/core/models/apiModels/Auth/user.dart';
import 'package:glade_v2/core/models/apiModels/Business/FundTransfer/bankModel.dart';
import 'package:glade_v2/pages/authentication/register/stages/emailVerification.dart';
import 'package:http/http.dart' as http;
import 'package:glade_v2/utils/apiUrls/env.dart';

abstract class AbstractAuth {
  Future<Map<String, dynamic>> login({email, password});

  // Future<Map<String, dynamic>> bvnValidation({bvn});
  // "first_name" : firstName.text,
  // "last_name" :lastName.text,
  // "bvn" :bvnNumber.text,
  // "bank_code" :  bank['code'],
  // "account_number" : accountNumber.text
  // auth/devices
  Future<Map<String, dynamic>> bvnMatch(
      {bvn, first_name, last_name, bank_code, account_number, token});
  Future<Map<String, dynamic>> register1(
      {email, firstName, lastName, phone, bvn, password});

  Future<Map<String, dynamic>> checkEmail({email});
  Future<Map<String, dynamic>> resendEmail({user_uuid});
  Future<Map<String, dynamic>> otpValidation({otp, user_uuid});
  Future<Map<String, dynamic>> getUser({token});
  Future<Map<String, dynamic>> emailVerification({otp, token});

  Future<Map<String, dynamic>> createPassword({password, user_uuid});
  Future<Map<String, dynamic>> createPasscode({passCode, user_uuid});
  Future<Map<String, dynamic>> verifyPasscode({
    passCode,
    token,
  });
  Future<Map<String, dynamic>> changePin({
    currentPin,
    newPin,
    token,
  });
  Future<Map<String, dynamic>> changePassword({
    currentPassword,
    newPassword,
    token,
  });

  Future<Map<String, dynamic>> getBalance({token});
  Future<Map<String, dynamic>> resetPin1({
    token,
  });
  Future<Map<String, dynamic>> resetPin2({
    newPasscode,
    verification_code,
    token,
  });
  Future<Map<String, dynamic>> resetPassword({email});
  Future<Map<String, dynamic>> resetpassword2(
      {email, verification_code, new_pass});

  Future<Map<String, dynamic>> bvnMatchBanks({token});
  Future<Map<String, dynamic>> phoneInfo(
      {token, device_token, device_uuid, device_platform});
}

//
class Auth implements AbstractAuth {
  @override
  Future<Map<String, dynamic>> bvnValidation({bvn}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/lookup/bvn/$bvn";

    try {
      var response = await http
          .get(
            url,
          )
          .timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

//      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;

        BVNModel bvn = BVNModel.fromJson(json.decode(response.body)["data"]);

        result['bvn'] = bvn;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> createPasscode({passCode, user_uuid}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/passcode";

    var body = {"passcode": passCode.trim(), "user_uuid": user_uuid.toString()};

    print("my body$body");

    try {
      var response =
          await http.post(url, body: body).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result["message"] = "Internal Server Error";
      } else {
        result['error'] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> login({email, password}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/login";

    var body = {"email": email.trim(), "password": password.trim()};
    print("my body$body");
    print(url);
    try {
      var response =
          await http.post(url, body: body).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      print(statusCode);
      print(jsonDecode(response.body));
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var user = User.fromJson(json.decode(response.body));
        result['user'] = user;
      }
    } catch (error) {
      // log(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> otpValidation({otp, user_uuid}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/verification/phone";

    var body = {"otp": otp.trim(), "user_uuid": user_uuid.trim()};

    print(body);

    try {
      var response =
          await http.post(url, body: body).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
//
//      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else if (statusCode == 500) {
        result["message"] = "Internal Server Error";
      } else {
        result['error'] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> register1(
      {email, firstName, lastName, phone, bvn, password}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/register";

    var body = {
      "email": email.trim(),
      "first_name": firstName.trim(),
      "last_name": lastName.trim(),
      "phone_number": phone.trim(),
      "preferred_phone_number": phone.trim(),
      "bvn": bvn.trim(),
      "password": password.trim()
    };

    print("my body$body");

    try {
      var response =
          await http.post(url, body: body).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

//      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result['error'] = false;
        result["message"] = jsonDecode(response.body)["message"];
        var res = Register1.fromJson(jsonDecode(response.body)["data"]);
        result["res"] = res;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> createPassword({password, user_uuid}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/password";

    var body = {"password": password.trim(), "user_uuid": user_uuid.trim()};

    try {
      var response =
          await http.post(url, body: body).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

//      print(statusCode);
//      print(response.body);
      print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];
        result["statusCode"] = statusCode;
        print("eeroror${result["message"]}");
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result['error'] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> verifyPasscode({passCode, token}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/confirm/passcode";

    var body = {
      "passcode": passCode.trim(),
    };

    var header = {"Authorization": "Bearer $token"};

    print(body);
    try {
      var response = await http
          .post(url, body: body, headers: header)
          .timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

//      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];

        result["statusCode"] = statusCode;
        print("eeroror${result["message"]}");
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result['error'] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      // result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> emailVerification({otp, token}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/verification/email";

    var body = {
      "verification_code": otp.trim(),
    };
    var header = {"Authorization": "Bearer $token"};

    try {
      var response = await http
          .post(url, body: body, headers: header)
          .timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

//      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result['error'] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> resetPassword({email}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/reset/password";

    var body = {
      "email": email,
    };

    try {
      var response =
          await http.post(url, body: body).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

//      print(statusCode);
      print(response.body);

      if (statusCode != 201 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];

        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result['error'] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> changePin({
    currentPin,
    newPin,
    token,
  }) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/passcode";
//    final String url = "http://192.168.68.121:8081/auth/verification/email";

    var body = {"old_passcode": currentPin, "new_passcode": newPin};
    var header = {"Authorization": "Bearer $token"};

    print(body);
    try {
      var response = await http
          .put(url, body: body, headers: header)
          .timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

//      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];

        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result['error'] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> resetpassword2(
      {email, verification_code, new_pass}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/reset/password";

    var body = {
      "email": email,
      "new_password": new_pass,
      "verification_code": verification_code
    };

    try {
      var response =
          await http.put(url, body: body).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

//      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];

        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result['error'] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> resetPin1({token}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/reset/passcode";

    var header = {"Authorization": "Bearer $token"};

    try {
      var response =
          await http.post(url, headers: header).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(response.body);

      if (statusCode != 201 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];

        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result['error'] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> resetPin2(
      {newPasscode, verification_code, token}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/reset/passcode";
//    final String url = "http://192.168.68.121:8081/auth/verification/email";

    var body = {
      "new_passcode": newPasscode,
      "verification_code": verification_code
    };
    var header = {"Authorization": "Bearer $token"};

    print(body);
    try {
      var response = await http
          .put(url, body: body, headers: header)
          .timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

//      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];

        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result['error'] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> changePassword(
      {currentPassword, newPassword, token}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/password";

    var body = {
      "new_password": newPassword.trim(),
      "old_password": currentPassword.trim()
    };

    var header = {"Authorization": "Bearer $token"};

    try {
      var response = await http
          .put(url, body: body, headers: header)
          .timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

//      print(statusCode);
//      print(response.body);
      print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];

        print("eeroror${result["message"]}");
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result['error'] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getUser({token}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/me";

    var header = {"Authorization": "Bearer $token"};
    print("my body$url");

    try {
      var response =
          await http.get(url, headers: header).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      print(statusCode);
      print(jsonDecode(response.body));
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var user = User.fromJson2(json.decode(response.body));
        result['user'] = user;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> bvnMatch(
      {bvn, first_name, last_name, bank_code, account_number, token}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/lookup/bvn/match";

    var header = {
      "content_Type": "application/json",
      "Authorization": "Bearer $token"
    };

    var body = {
      "first_name": first_name,
      "last_name": last_name,
      "bvn": bvn,
      "bank_code": bank_code,
      "account_number": account_number,
    };
    print(body);
    try {
      var response = await http
          .post(url, body: body, headers: header)
          .timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      print(statusCode);
      print(jsonDecode(response.body));
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getBalance({token}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/balance";

    var header = {"Authorization": "Bearer $token"};
    print("my body$url");

    try {
      var response =
          await http.get(url, headers: header).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      print(statusCode);
      print(jsonDecode(response.body));
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var balance = Balance.fromJson(jsonDecode(response.body)["data"]);
        result["balance"] = balance;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> bvnMatchBanks({token}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/lookup/bvn/banks";

    var headers = {"Authorization": "Bearer $token"};
    print(url);
    try {
      var response =
          await http.get(url, headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      print(response.body);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<BankBVNModel> banks = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat) {
          banks.add(BankBVNModel.fromJson(dat));
        });
        result['banks'] = banks;
      }
    } catch (error) {
      print(error.toString());
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> phoneInfo(
      {token, device_token, device_uuid, device_platform}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/auth/devices";

    var headers = {"Authorization": "Bearer $token"};

    var body = {
      "device_token": device_token,
      "device_uuid": device_uuid,
      "device_platform": device_platform,
      "is_default": "1",
      "device_fingerprint": "iiiiii"
    };

    print(body);
    print(url);
    try {
      var response = await http
          .post(url, body: body, headers: headers)
          .timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      print(response.body);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
      }
    } catch (error) {
      print(error.toString());
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> resendEmail({user_uuid}) async {
    Map<String, dynamic> result = {};
    final String url =
        "$core/aaa/resend/verification/email?user_uuid=$user_uuid";

    var header = {
      "content_Type": "application/json",
      // "Authorization" : "Bearer $token"
    };

    // print(body);
    try {
      var response =
          await http.post(url, headers: header).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      print(statusCode);
      print(jsonDecode(response.body));
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["error"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> checkEmail({email}) async {
    Map<String, dynamic> result = {};
    final String url = "$core/aaa/check/email?email=$email";

    var header = {
      "content_Type": "application/json",
      // "Authorization" : "Bearer $token"
    };

    print(url);
    try {
      var response = await http.get(url).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      print(" status$statusCode");
      print(jsonDecode(response.body));
      if (jsonDecode(response.body)["status"] == "error") {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }
}
