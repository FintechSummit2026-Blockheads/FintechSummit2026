import 'package:get/get.dart';
import 'package:mingle/services/auth_service.dart';

class RegisterController extends GetxController {
  final AuthService authService = AuthService();
  
  var isLoading = false.obs;

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String description,
    required bool isUser,
  }) async {
    try {
      isLoading.value = true;
      
      final result = await authService.register(
        name: name,
        email: email,
        password: password,
        description: description,
        isUser: isUser,
      );
      
      isLoading.value = false;
      return result;
    } catch (e) {
      isLoading.value = false;
      return {'success': false, 'message': e.toString()};
    }
  }
}