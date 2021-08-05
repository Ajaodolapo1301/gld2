// const core = "https://core-test.glade.ng";
// "core-prod.glade.ng"
// const core = "https://core-staging.glade.ng";
//===== Prod =============
const core = "https://core-prod.glade.ng";
class Env {
  static String _prod = "";
  static String _staging = "";

  static String _testing =
      //Testing
      // "https://mobile-test.glade.ng/api/v2";

                  //======== Prod ====
                  "https://mobile-api.glade.ng/api/v2" ;

  // Staging
  // "https://mobile-staging.glade.ng/api/v2";


  // "https://mobile-test.glade.ng/api/v2";

  static String _app = "release";
  static String _accessToken;

//  static String _oneSignalToken = "ddbc2c61-6a76-41d3-825d-12a4671e0f85";
  static String _oneSignalToken = "cf3d0a6f-f4ef-4f8c-a290-d28fa1aa3c8f";

  static String get prod => _prod;
  static String get staging => _staging;
  static String get testing => _testing;
  static String get accessToken => _accessToken;
  static String get oneSignalToken => _oneSignalToken;

  /// Assert only runs in debug mode and can be used to test if the app is in debug mode
  /// Change the env variable to tests when in debug mode.

//  static checkEnv() {
//    assert(() {
//      _baseUrl = "http://dashboard.demo.gladepay.com";
//      _app = "debug";
//      _apiUrl = "https://demo.api.gladepay.com";
//      _accessToken = "Bxddtu853Rn6y";
//
////      _baseUrl = "https://dashboard.glade.ng";
////      _apiUrl = "https://api.gladepay.com";
////      _accessToken =
////      'j6L6yvBxddtu853Rn6yzCIG6Td1zB23xcvoTC21j0DtUuW6M3ssrS30YMM';
////      _app = "debug";
//      return true;
//    }());
//  }

  void initEnv(accessToken){
    _accessToken = accessToken;
  }



}
