import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/theme_manager/presentation/theme_cubit.dart';
import 'features/theme_manager/data/local_theme_store.dart';
import 'navigation/router.dart' as nav;
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Build4AllManagerApp());
}

class Build4AllManagerApp extends StatelessWidget {
  const Build4AllManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(LocalThemeStore())..load(),
      child: BlocBuilder<ThemeCubit, ThemeVM>(
        builder: (context, vm) {
          return MaterialApp.router(
            title: 'Build4All Manager',
            debugShowCheckedModeBanner: false,
            theme: vm.light,
            darkTheme: vm.dark,
            themeMode: vm.mode,
            routerConfig: nav.router,
            supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
