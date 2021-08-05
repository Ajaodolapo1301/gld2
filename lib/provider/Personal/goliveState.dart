
import 'package:flutter/cupertino.dart';
import 'package:glade_v2/api/Personal/goLive/goLive.dart';
import 'package:glade_v2/core/models/apiModels/Personal/GoLive/IdcardTypes.dart';
import 'package:glade_v2/core/models/apiModels/Personal/GoLive/StateAndLGA.dart';

abstract class AbstractGoLiveViewModel {
  Future<Map<String, dynamic>> goLive({String token, id_type_id, id_number, id_image, state_id, lga_id, residential_address, selfie_image});
  Future<Map<String, dynamic>> getIdCardTypes({String token});


  Future<Map<String, dynamic>> getStates({String token, String country_id});
  Future<Map<String, dynamic>> getLGAs({String token, String country_id, String state_id});

}



class GoLIveState with ChangeNotifier implements AbstractGoLiveViewModel{


  List<LGA> _lga= [];
  List<LGA> get lga => _lga;
  set lga(List<LGA> lga1) {
    _lga = lga1;
    notifyListeners();
  }


  List<States> _states= [];
  List<States> get states => _states;
  set states(List<States> states1) {
    _states = states1;
    notifyListeners();
  }

  List<IdCardTypes> _idCardTypes= [];
  List<IdCardTypes> get idCardTypes => _idCardTypes;
  set idCardTypes(List<IdCardTypes> idCardTypes1) {
    _idCardTypes = idCardTypes1;
    notifyListeners();
  }





  @override
  Future<Map<String, dynamic>> getIdCardTypes({String token})async {
    Map<String, dynamic> result = Map();

    try{
      result = await GoliveImpl().getIdCardTypes(token: token);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          idCardTypes = result["idcardTypes"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getLGAs({String token, String country_id, String state_id}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await GoliveImpl().getLGAs(token: token, country_id: country_id, state_id: state_id);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          lga = result["localGovts"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getStates({String token, String country_id}) async{
    Map<String, dynamic> result = Map();

    try{
      result = await GoliveImpl().getStates(token: token, country_id: country_id);
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){
          states = result["states"];
        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> goLive({String token, id_type_id, id_number, id_image, state_id, lga_id, residential_address, selfie_image, }) async{
    Map<String, dynamic> result = Map();

    try{
      result = await GoliveImpl().goLive(token: token, id_image: id_image, id_type_id: id_type_id, state_id: state_id, lga_id: lga_id, residential_address: residential_address, selfie_image: selfie_image,id_number: id_number,  );
      if(result["error"] == null) {
        result['error'] = true;
        result['message'] = 'An Error occured, please  check your internet connection and try again';
      }else{
        if(result['error'] == false){

        }

      }
    }catch(e){
      print(e.toString());
    }
    return result;
  }

}