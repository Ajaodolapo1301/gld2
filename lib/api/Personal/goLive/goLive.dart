

import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:glade_v2/api/Business/AddBusiness/addBusiness.dart';
import 'package:glade_v2/core/models/apiModels/Personal/GoLive/IdcardTypes.dart';
import 'package:glade_v2/core/models/apiModels/Personal/GoLive/StateAndLGA.dart';
import 'package:glade_v2/pages/personal/go_live/go_live_personal_page.dart';
import 'package:http/http.dart' as http;

import 'package:glade_v2/utils/apiUrls/env.dart';
import 'package:http_parser/http_parser.dart';
abstract class AbstractGoLive {
  Future<Map<String, dynamic>> goLive({String token, id_type_id, id_number, File id_image, state_id, lga_id, residential_address, XFile selfie_image, });
  Future<Map<String, dynamic>> getIdCardTypes({String token});


  Future<Map<String, dynamic>> getStates({String token, String country_id});
  Future<Map<String, dynamic>> getLGAs({String token, String country_id, String state_id});
}



// const ngrok = "https://6cc3843a668a.ngrok.io";
class GoliveImpl implements AbstractGoLive{
  @override
  Future<Map<String, dynamic>> getIdCardTypes({String token}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/go-live/lookup/identity-types";

    try {
      var response =
          await http.get(url).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);
      print(jsonDecode(response.body)["token"]);
      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];

        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<IdCardTypes> idcardTypes = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          idcardTypes.add(IdCardTypes.fromJson(dat));
        });
        result['idcardTypes'] = idcardTypes;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getLGAs({String token, String country_id, String state_id,})async {
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/go-live/lookup/country/$country_id/$state_id/lgas";
  print(url);
  var header = {
      "authorization": "Bearer $token",

      // "business-uuid" : business_uuid

  };

    try {
      var response =
          await http.get(url, headers: header).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result['error'] = true;
        result["statusCode"] = statusCode;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<LGA> localGovts = [];
        (jsonDecode(response.body)['data'] as List).forEach((dat){
          localGovts.add(LGA.fromJson(dat));
        });
        result['localGovts'] = localGovts;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getStates({String token, String country_id}) async{
    Map<String, dynamic> result = {};
    final String url = "${Env.testing}/go-live/lookup/country/$country_id/states";

    try {
      var response =
          await http.get(url).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      // print(statusCode);
      // print(response.body);

      if (statusCode != 200 && statusCode != 500) {
        result["message"] = jsonDecode(response.body)["message"];
        result["statusCode"] = statusCode;
        result['error'] = true;
      } else if (statusCode == 500) {
        result['error'] = true;
        result["message"] = "Internal Server Error";
      } else {
        result["error"] = false;
        List<States> states = [];

        (jsonDecode(response.body)['data'] as List).forEach((dat){
          states.add(States.fromJson(dat));
        });
        result['states'] = states;
      }
    } catch (error) {
      print(error.toString());
      result["message"] = error.toString();
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> goLive({String token, id_type_id, id_number, File id_image, state_id, lga_id, residential_address,  XFile selfie_image, }) async{


    Dio dio = new Dio();
    Map<String, dynamic> result = {};


    var formData = FormData.fromMap({
      "id_card_type" : id_type_id,
        "id_card_number": id_number,
        "id_card" : await MultipartFile.fromFile(id_image.path, filename: id_image.path.split("/").last,  contentType:  MediaType("application", "png"), ),
        "state": state_id,
        "lga" : lga_id,
        "address" : residential_address.trim(),
        "selfie" : await MultipartFile.fromFile(selfie_image.path, filename: selfie_image.path.split("/").last, contentType:  MediaType("application", "png"),),

    });
    //
    print(formData.fields);
    print(formData.files);
    print( {
      "authorization": "Bearer $token",
      // "Content-type" : "application/json",
    });
    try{
      var resp =  await dio.post('$core/business/compliance/personal', data: formData,  options:  Options(
        headers: {
          "authorization": "Bearer $token",
          "content-type" : "multipart/form-data",
          // "business-uuid" : business_uuid

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
      // print("data obj ${resp.data}");
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



}
