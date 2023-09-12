import 'dart:convert';
import 'package:deckinspectors/src/bloc/settings_bloc.dart';
import 'package:deckinspectors/src/bloc/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'src/app.dart';
import 'src/resources/realm/app_services.dart';
import 'src/resources/realm/realm_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final realmConfig = json
      .decode(await rootBundle.loadString('assets/config/atlasConfig.json'));
  String appId = realmConfig['appId'];
  Uri baseUrl = Uri.parse(realmConfig['baseUrl']);

  return runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AppServices>(
        create: (_) => AppServices(appId, baseUrl)),
    ChangeNotifierProxyProvider<AppSettings, RealmProjectServices?>(
        create: (context) => null,
        update: (BuildContext context, AppSettings appSettings,
            RealmProjectServices? realmServices) {
          realmServices?.uploadLocalImages();
          return realmServices;
        }),
    ChangeNotifierProxyProvider<AppServices, RealmProjectServices?>(
        // RealmServices can only be initialized only if the user is logged in.
        create: (context) => null,
        update: (BuildContext context, AppServices appServices,
            RealmProjectServices? realmServices) {
          return (appServices.app.currentUser != null &&
                  usersBloc.userDetails.username != null)
              ? RealmProjectServices(
                  appServices.app, usersBloc.userDetails.username as String)
              : null;
        }),
  ], child: const App()));
}
