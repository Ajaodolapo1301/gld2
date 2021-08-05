
import 'package:firebase_remote_config/firebase_remote_config.dart';

const String _BOOLEAN_VALUE = 'sample_bool_value';
const String _INT_VALUE = 'sample_int_value';
const String _STRING_VALUE_IOS = 'current_ios_version';
const String _STRING_VALUE_ANDROID = 'current_android_version';
const String _STRING_VALUE_IOS_MANDATORY = 'ios_update_mandatory';
// const bool _STRING_VALUE_IOS_MANDATORY = ;

class RemoteConfigService {
  final RemoteConfig remoteConfig;
  RemoteConfigService({RemoteConfig remoteConfig})
      : remoteConfig = remoteConfig;

  final defaults = <String, dynamic>{
    'current_ios_version': '1.0.0',
    'current_android_version': '1.0.0',
    'ios_active': true,
    'android_active': true,
    'android_update_mandatory': true,
    'ios_update_mandatory': true,
  };

  static RemoteConfigService _instance;
  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance = RemoteConfigService(remoteConfig: await RemoteConfig.instance,
      );
    }
    return _instance;
  }

  bool get getBoolValue => remoteConfig.getBool(_BOOLEAN_VALUE);
  int get getIntValue => remoteConfig.getInt(_INT_VALUE);
  // String get getStringValue => _remoteConfig.getString(_STRING_VALUE);

  Future initialize() async {
    print("initing remote");
    try {
      await remoteConfig.setDefaults(defaults);
      await _fetchAndActivate();
    } on FetchThrottledException catch (e) {
      print("Remeote Config fetch throttled: $e");
    } catch (e) {
      print("Unable to fetch remote config. Default value will be used");
    }
  }

  Future _fetchAndActivate() async {
    await remoteConfig.fetch(expiration: Duration(seconds: 0));
    await remoteConfig.activateFetched();

  }











}