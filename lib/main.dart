import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';
import 'provider/locale_provider.dart';
import 'provider/map_provider.dart';
import 'provider/profile_provider.dart';
import 'screens/splash_page.dart';
import 'service/api_service.dart';
import 'service/base_service.dart';
import 'utils/constants/colors.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final prefs = await SharedPreferences.getInstance();
  final language = prefs.getString('language') ?? 'English';
  runApp(MyApp(language: language));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.language});

  final String? language;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ListenableProvider(create: (_) => LocaleProvider()),
        Provider<BaseService>(create: (_) => APIService()),
      ],
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        final fallback = language == 'Arabic' ? const Locale('ar') : const Locale('en');
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          locale: provider.locale ?? fallback,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            scaffoldBackgroundColor: AppColors.bg,
            useMaterial3: true,
          ),
          home: SplashPage.create(context),
        );
      },
    );
  }
}
