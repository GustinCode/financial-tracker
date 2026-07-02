import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'models/transaction_model.dart';
import 'models/category_model.dart';
import 'models/budget_model.dart';
import 'providers/transaction_provider.dart';
import 'providers/category_provider.dart';
import 'providers/budget_provider.dart';
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
  Hive.registerAdapter(BudgetAdapter());

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
              (previous ?? TransactionProvider())
                ..categoryProvider = categoryProvider,
        ),
        ChangeNotifierProxyProvider2<CategoryProvider, TransactionProvider,
            BudgetProvider>(
          create: (_) => BudgetProvider()..loadBudgets(),
          update: (_, categoryProvider, transactionProvider, previous) =>
              (previous ?? BudgetProvider())
                ..transactionProvider = transactionProvider,
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
            seedColor: const Color(0xFF0F766E),
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF7F8FA),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
          cardTheme: const CardThemeData(
            elevation: 0.8,
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          chipTheme: ChipThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          ),
        ),
        home: HomeView(
          onLocaleChanged: _rebuildApp,
        ),
      ),
    );
  }
}
