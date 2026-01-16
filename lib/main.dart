import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'models/transaction_model.dart';
import 'models/category_model.dart';
import 'providers/transaction_provider.dart';
import 'providers/category_provider.dart';
import 'services/database_service.dart';
import 'services/localization_service.dart';
import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Hive
  await Hive.initFlutter();

  // Registrar adapters
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());

  // Inicializar banco de dados
  await DatabaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _savedLocale;
  int _rebuildKey = 0;

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final locale = await LocalizationService.getSavedLocale();
    setState(() {
      _savedLocale = locale;
    });
  }

  void _rebuildApp() {
    setState(() {
      _rebuildKey++;
      _loadSavedLocale();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoryProvider()..loadCategories(),
        ),
        ChangeNotifierProxyProvider<CategoryProvider, TransactionProvider>(
          create: (_) => TransactionProvider(),
          update: (_, categoryProvider, previous) =>
              previous ?? TransactionProvider()
                ..categoryProvider = categoryProvider,
        ),
      ],
      child: MaterialApp(
        title: 'Financial Tracker',
        debugShowCheckedModeBanner: false,
        // Localization configuration
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: LocalizationService.supportedLocales,
        locale: _savedLocale,
        key: ValueKey(_rebuildKey),
        // Theme configuration
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            primary: Colors.blue,
            secondary: Colors.green,
          ),
          useMaterial3: true,
          cardTheme: const CardThemeData(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
        ),
        home: HomeView(
          onLocaleChanged: _rebuildApp,
        ),
      ),
    );
  }
}
