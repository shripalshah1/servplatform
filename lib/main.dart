import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider_start/core/localization/localization.dart';
import 'package:provider_start/core/managers/dialog_manager.dart';
import 'package:provider_start/core/managers/lifecycle_manager.dart';
import 'package:provider_start/core/services/key_storage_service.dart';
import 'package:provider_start/core/services/navigation_service.dart';
import 'package:provider_start/locator.dart';
import 'package:provider_start/provider_setup.dart';
import 'package:provider_start/ui/router.dart';
import 'package:provider_start/ui/views/login/login_view.dart';
import 'package:provider_start/ui/views/splash/splash_view.dart';

void main() async {
  await setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeData>(
        builder: (context, theme, child) => LifeCycleManager(
          child: MaterialApp(
            theme: theme,
            localizationsDelegates: [
              const AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en'),
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (Locale supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode ||
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }

              return supportedLocales.first;
            },
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            navigatorKey: locator<NavigationService>().navigatorKey,
            onGenerateRoute: Router.generateRoute,
            builder: (context, widget) => Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => DialogManager(
                  child: widget,
                ),
              ),
            ),
            home: _getStartupScreen(),
          ),
        ),
      ),
    );
  }

  Widget _getStartupScreen() {
    var localStorageService = locator<KeyStorageService>();

    if (!localStorageService.hasLoggedIn) {
      return LoginView();
    }

    return SplashView();
  }
}
