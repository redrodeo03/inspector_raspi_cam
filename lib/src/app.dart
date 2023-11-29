import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'resources/realm/realm_services.dart';
import 'ui/login.dart';
import 'ui/navigation_observer.dart';
//import 'ui/movie_list.dart';

class App extends StatelessWidget {
  const App({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static bool isImageUploading = false;
  @override
  Widget build(BuildContext context) {
    // final currentUser =
    //     Provider.of<RealmProjectServices?>(context, listen: false)?.currentUser;

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp(
          navigatorObservers: [NavigationObserver()],
          debugShowCheckedModeBanner: false,
          title: 'E3 Inspections',
          builder: (context, child) {
            final MediaQueryData data = MediaQuery.of(context);

            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  boldText: false,
                  textScaleFactor:
                      data.textScaleFactor > 2 ? 1.2 : data.textScaleFactor),
              child: child!,
            );
          },
          home: const SafeArea(child: LoginPage()),
        ));
  }
}
