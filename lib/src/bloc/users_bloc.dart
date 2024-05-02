import 'dart:convert';
import '../models/login_response.dart';
import '../models/users_response.dart';
import '../resources/repository.dart';

class UsersBloc {
  final Repository _repository = Repository();

  //final _usersFetcher = PublishSubject<LoginResponse>();
  LoginResponse userDetails = LoginResponse();

  Future<LoginResponse> login(String username, String password) async {
    username = username;
    //print('called login api');
    final loginObject =
        jsonEncode({'username': username, 'password': password});
    LoginResponse response = await _repository.login(loginObject);
    userDetails = response;

    return response;
  }

  register(String username, String password, String firstName, String lastName,
      String emailId) async {
    final loginObject = jsonEncode({
      'username': username,
      'password': password,
      'email': emailId,
      'first_name': firstName,
      'last_name': lastName,
      'access_type': 'mobile'
    });
    RegisterResponse response = await _repository.register(loginObject);
    return response;
  }

  getAllUsers() async {
    UsersResponse userResponse = await _repository.usersApiProvider
        .getAllUsers(userDetails.token as String);

    return userResponse;
  }

  // dispose() {
  //   _usersFetcher.close();
  // }
}

final usersBloc = UsersBloc();
