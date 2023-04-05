import 'dart:convert';
import '../models/login_response.dart';
import '../resources/repository.dart';


class UsersBloc {
  final Repository _repository = Repository();

  //final _usersFetcher = PublishSubject<LoginResponse>();
  LoginResponse userDetails = LoginResponse();
  Future<LoginResponse> login(String username, String password) async {
    //print('called login api');
    final loginObject =jsonEncode({
      'username': username,
      'password':password
    });
    LoginResponse response = await _repository.login(loginObject);
    userDetails=response;
    return response;
  }
  


  // dispose() {
  //   _usersFetcher.close();
  // }
}

final usersBloc = UsersBloc();