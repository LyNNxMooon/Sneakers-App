import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectionUtils {
  InternetConnectionUtils._();

  static final InternetConnectionUtils _instance = InternetConnectionUtils._();

  static InternetConnectionUtils get instance => _overrideInstance ?? _instance;

  static InternetConnectionUtils? _overrideInstance;
  static set testInstance(InternetConnectionUtils? dao) => _overrideInstance = dao;

  Future<bool> checkInternetConnection() async {
    var connectivityResults = await Connectivity().checkConnectivity();

    if (connectivityResults.isNotEmpty) {
      if (connectivityResults.contains(ConnectivityResult.mobile) ||
          connectivityResults.contains(ConnectivityResult.wifi) ||
          connectivityResults.contains(ConnectivityResult.vpn)) {
        return true; // Connected to either mobile data, Wi-Fi, or VPN
      }
    }

    return false; // Not connected
  }
}
