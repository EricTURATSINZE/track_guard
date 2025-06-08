import 'package:incident_tracker/services/http_service.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final result = await HttpService.sendRequest(
        "http://197.243.1.84:3020/users/login",
        method: 'post',
        data: {
          "email": email,
          "password": password,
        },
      );
      return result as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}
