import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/cubit_and_state/auth_state.dart';
import 'package:flutter_frontend/model/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AuthCubit extends Cubit<AuthState> {
  final storage = FlutterSecureStorage();
  final String apiUrl =
      "http://YourIP:4000/api/auth"; // Your backend API URL

  AuthCubit() : super(AuthInitial());

  // Register user
  Future<void> registerUser(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final user =
            User.fromMap(data['user']); // Create User object from 'user' key
        final token = data['token']; // Get the token
        await storage.write(key: 'token', value: token); // Store token securely
        emit(
            AuthLoggedIn(user, token)); // Pass both user and token to the state
      } else {
        emit(AuthError('Registration failed'));
      }
    } catch (e) {
      emit(AuthError('An error occurred: $e'));
    }
  }

  // Login user
  Future<void> loginUser(String email, String password) async {
    print("Login");
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        body: json.encode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user =
            User.fromMap(data['user']); // Create User object from 'user' key
        final token = data['token']; // Get the token
        await storage.write(key: 'token', value: token); // Store token securely
        emit(
            AuthLoggedIn(user, token)); // Pass both user and token to the state
      } else {
        emit(AuthError('Invalid credentials'));
      }
    } catch (e) {
      emit(AuthError('An error occurred: $e'));
    }
  }

  // Logout user
  Future<void> logoutUser() async {
    await storage.delete(key: 'token'); // Remove token from storage
    emit(AuthLoggedOut());
  }

  // Check if the user is already logged in (token exists)
  Future<void> checkAuthStatus() async {
    print("object");
    final token = await storage.read(key: 'token');

    if (token != null) {
      final response = await http.post(
        Uri.parse('$apiUrl/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user =
            User.fromMap(data['user']); // Create User object from 'user' key
        print(user);
        emit(
            AuthLoggedIn(user, token)); // Pass both user and token to the state
      } else {
        emit(AuthLoggedOut());
      }
    } else {
      emit(AuthLoggedOut());
    }
  }
}
