


import 'dart:convert';
import 'dart:io';
import 'package:glade_v2/api/Personal/goLive/goLive.dart';
import 'package:glade_v2/core/models/apiModels/Auth/balance.dart';
import 'package:http_parser/http_parser.dart';
import 'package:glade_v2/core/models/apiModels/Auth/Business.dart';
import 'package:glade_v2/core/models/apiModels/Auth/allBusiness.dart';
import 'package:glade_v2/pages/personal/go_live/go_live_personal_page.dart';
import 'package:http/http.dart' as http;
import "package:dio/dio.dart" ;
import 'package:glade_v2/utils/apiUrls/env.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';

// const ngrok = "https://f9b06b04f5c9.ngrok.io";

abstract class AbstractAddBusiness {
  Future<Map<String, dynamic>> addBusiness({businessCategory, businessName, businessDesc, country, state, businessAddress, buinessWebsite, businessEmail, token, bool makeDefault});
  Future<Map<String, dynamic>> getBalance({token, business_uuid});
  Future<Map<String, dynamic>> fetchCountry({token});

  Future<Map<String, dynamic>> fetchBillTypes({token});
  Future<Map<String, dynamic>> fetchBusinesscategory({token});
  Future<Map<String, dynamic>> getAllBusiness({token});
  Future<Map<String, dynamic>> getBusiness({token,business_uuid});
  Future<Map<String, dynamic>> setDefault({token,business_uuid});
  // Future<Map<String, dynamic>> fetchState({token, country_id});
  Future<Map<String, dynamic>> addBusinessCompliance({ FileClass CAC, FileClass Tin, FileClass utitltyBill, FileClass DIrectorForm ,rcOrBN, utiltyType, tinNumber, token, registeredName, business_uuid});
  Future<Map<String, dynamic>> RegisterBusiness({company_name, company_name_two, company_name_three, company_address, company_email, company_description, company_objective, registration_type, share_capital, per_capital_share, directors, File documents, token});

}

class AddBusinessImpl implements AbstractAddBusiness{
  @override
  Future<Map<String, dynamic>> addBusiness({businessCategory, businessName, businessDesc, country, state, businessAddress, buinessWebsite, businessEmail, token, makeDefault}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/businesses";
    var body = {
      "business_category": businessCategory,
      "business_name": businessName,
      "business_email": businessEmail ,
      "state": state,
      "country": country,
      "business_address" : businessAddress,
      "business_description": businessDesc,
      "business_website": buinessWebsite ?? null,
      // "business_description": businessDesc,
      // "business_website": buinessWebsite ?? null,
      "default": makeDefault == true ? "1" : "0"

    };
    var headers = {
      "Authorization" : "Bearer $token"
    };



    print(body);
    try {
      var response =
          await http.post(url, body: body, headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var pref = await SharedPreferences.getInstance();
        pref.setString("business_uuid", jsonDecode(response.body)["data"]["business_uuid"]);
        result["message"] = jsonDecode(response.body)["message"];
      }
    } catch (error) {
      print(error.toString());

    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> addBusinessCompliance({FileClass CAC, FileClass Tin, FileClass utitltyBill, FileClass DIrectorForm, rcOrBN, utiltyType, tinNumber,token, registeredName, business_uuid})async {
var pref = await SharedPreferences.getInstance();
    Dio dio = new Dio();
    Map<String, dynamic> result = {};

//    dio.options.headers[HttpHeaders.authorizationHeader] = "Bearer $token";

    var formData = FormData.fromMap({
      'type_of_utility_bill': utiltyType,
      "registered_name" :registeredName,
      'rc_number': rcOrBN,
      "tin_number" : tinNumber,
      "utility_bill" : await MultipartFile.fromFile(utitltyBill.file.path, filename: utitltyBill.file.path.split("/").last,    contentType:  MediaType("application", "pdf"),  ),
      "tin_certificate" : await MultipartFile.fromFile(Tin.file.path, filename: Tin.file.path.split("/").last,contentType:  MediaType("application", "pdf"), ),
      "cac_certificate" : await MultipartFile.fromFile(CAC.file.path, filename: CAC.file.path.split("/").last, contentType:  MediaType("application", "pdf"), ),
      "director_page" : await MultipartFile.fromFile(DIrectorForm.file.path, filename: DIrectorForm.file.path.split("/").last, contentType:  MediaType("application", "pdf"), ),
    });
    //
    print(formData.fields);
    print(formData.files);
    // print( {
    //   "authorization": "Bearer $token",
    //   "Content-type" : "multipart/form-data",
    //   "business-uuid" : business_uuid
    //
    // });
        try{
          var resp =  await dio.post("${core}/business/compliance",data: formData,  options:  Options(
          headers: {
            "authorization": "Bearer $token",
            // "accept": "application/json",
            "content-type" : "multipart/form-data",
            // "content-type": "application/json",
            "business-uuid" : business_uuid
            // pref.getString("business_uuid")



          },

          ) ,
            onSendProgress: (int sent, int total) {
              print("sent${sent.toString()}" + " total${total.toString()}");
            },
          ).whenComplete(() {
            print("complete:");
          }).catchError((onError) {
            print("error:${onError.toString()}");
          });


          print(resp);
          int statusCode = resp.statusCode;
            print( "my token $token");

          print("data obj ${resp.data}");
          // print(resp.statusCode);
          if (statusCode != 200 && statusCode != 500) {
            result["message"] = resp.data["message"];
            result['error'] = true;
          } else if (statusCode == 500) {
            result['error'] = true;
            result["message"] = "Internal Server Error";
          } else {
            result["error"] = false;
            result["message"] = resp.data["message"];
          }
        } catch (error) {
          print("from here ${error.toString()}");

        }

    return result;




  }

  @override
  Future<Map<String, dynamic>> fetchCountry({token}) async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/businesses/lookup/countries";

    var headers = {
      "Authorization" : "Bearer $token"
    };




    try {
      var response =
          await http.get(url,  headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;


      print(jsonDecode(response.body));
      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<CountryModel> countryModel = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          countryModel.add(CountryModel.fromJson(dat));
        });
        result['countryModel'] = countryModel;
      }
    } catch (error) {
      print(error.toString());

    }

    return result;
  }

  // @override
  // Future<Map<String, dynamic>> fetchState({token, country_id}) {
  //   // TODO: implement fetchState
  //   throw UnimplementedError();
  // }

  @override
  Future<Map<String, dynamic>> getAllBusiness({token}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/businesses";

    var headers = {
      "Authorization" : "Bearer $token"
    };

    try {
      var response =
          await http.get(url,  headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;


      print(jsonDecode(response.body));
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<AllBusiness> business = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          business.add(AllBusiness.fromJson(dat));
        });
        result['business'] = business;
      }
    } catch (error) {
      print(error.toString());

    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getBusiness({token, business_uuid}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/businesses/details";
  // final String url = "https://web-v2.glade.ng/api/v2/businesses/details";
    var headers = {
      "Authorization" : "Bearer $token",
     "business-uuid" : "$business_uuid"

    };
print(headers);
    try {
      var response =
          await http.get(url,  headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;


      print("hh${response.body}");

      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        var singleBiz = Business.fromJson(jsonDecode(response.body)["data"]);
          result ["singleBusiness"] = singleBiz;
      }
    } catch (error) {
      print(error.toString());

    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> setDefault({token, business_uuid}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/businesses/default";

    var headers = {
      "Authorization" : "Bearer $token",
      "business-uuid" : "$business_uuid"

    };





    print(headers);
    try {
      var response =
          await http.put(url,  headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;



      print(jsonDecode(response.body));
      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
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

    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> fetchBusinesscategory({token}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/businesses/lookup/categories";

    var headers = {
      "Authorization" : "Bearer $token"
    };
print(url);
    try {
      var response =
          await http.get(url,  headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;


      print(jsonDecode(response.body));
      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<String> businesscat = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          businesscat.add(dat);
        });
        result['businessCategories'] = businesscat;
      }
    } catch (error) {
      print(error.toString());

    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> fetchBillTypes({token})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/limit/lookup/bill_types";

    var headers = {
      "Authorization" : "Bearer $token"
    };
    print(url);
    try {
      var response =
          await http.get(url,  headers: headers).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;


      print(jsonDecode(response.body));
      if (statusCode != 200 && statusCode != 500) {
        result["statusCode"] = statusCode;
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<String> utilityBills = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          utilityBills.add(dat);
        });
        result['utilityBills'] = utilityBills;
      }
    } catch (error) {
      print(error.toString());

    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getBalance({token, business_uuid}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/businesses/balance";

    var header ={
      "Authorization" : "Bearer $token",
      "business-uuid": "$business_uuid"
    };
    // print("my body$url");

    try {
      var response =
      await http.get(url, headers:  header).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      // print(statusCode);
      // print(jsonDecode(response.body));
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
  Future<Map<String, dynamic>> RegisterBusiness({company_name, company_name_two, company_name_three, company_address, company_email, company_description, company_objective, registration_type, per_capital_share, share_capital, directors, File documents, token}) async{

    Dio dio = new Dio();
    Map<String, dynamic> result = {};


    var formData = FormData.fromMap({
      "company_name" : company_name,
      "company_name_two" : company_name_two,
      "company_name_three" : company_name_three,
      "company_address" : company_address,
      "company_email": company_email,
      "share_capital" : share_capital ?? "",
      "per_capital_share" : per_capital_share ??"",
        "directors" : directors,
      "documents" : await MultipartFile.fromFile(documents.path, filename: documents.path.split("/").last,  contentType:  MediaType("application", "png"), ),
      "company_description": company_description,
      "company_objective" : company_objective,
      "registration_type" : registration_type.trim(),


    });
    //
    print(formData.fields);
    print(formData.files);
    print( {
      "authorization": "Bearer $token",
      // "Content-type" : "application/json",
    });
    try{
      var resp =  await dio.post(
          '$core/business/registration',


        data: formData,  options:  Options(
        headers: {
          "authorization": "Bearer $token",

          "content-type" : "multipart/form-data",


        },

      ) ,
        onSendProgress: (int sent, int total) {
          // print("sent${sent.toString()}" + " total${total.toString()}");
        },
      ).whenComplete(() {
        // print("complete:");
      }).catchError((onError) {
        // print("error:${onError.toString()}");
      });


      print(resp);
      int statusCode = resp.statusCode;

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = resp.data["message"];
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        result["message"] = resp.data["message"];
      }
    } catch (error) {
      // print("from here ${error.toString()}");

    }

    return result;
  }


}
