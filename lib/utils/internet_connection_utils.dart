import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectionUtils {
  InternetConnectionUtils._();

  static final InternetConnectionUtils _instance = InternetConnectionUtils._();

  static  InternetConnectionUtils get instance => _instance;

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false; // Not connected to any network
    } else if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.vpn) {
      return true; // Connected to either mobile data or Wi-Fi
    }

    return false; // Default to not connected
  }
}