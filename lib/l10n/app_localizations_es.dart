// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Financial Tracker';

  @override
  String get home => 'Inicio';

  @override
  String get history => 'Historial';

  @override
  String get settings => 'Configuración';

  @override
  String get newTransaction => 'Nueva Transacción';

  @override
  String get recentTransactions => 'Transacciones Recientes';

  @override
  String get noTransactionsRegistered => 'Ninguna transacción registrada';

  @override
  String get tapToAdd => 'Toca el botón + para agregar';

  @override
  String get editTransaction => 'Editar Transacción';

  @override
  String get type => 'Tipo';

  @override
  String get income => 'Ingreso';

  @override
  String get expense => 'Gasto';

  @override
  String get title => 'Título';

  @override
  String get titleRequired => 'Título *';

  @override
  String get titleHint => 'Ej: Salario, Almuerzo, etc.';

  @override
  String get pleaseEnterTitle => 'Por favor, ingrese un título';

  @override
  String get amount => 'Valor';

  @override
  String get amountRequired => 'Valor *';

  @override
  String get pleaseEnterAmount => 'Por favor, ingrese un valor';

  @override
  String get pleaseEnterValidAmount => 'Por favor, ingrese un valor válido';

  @override
  String get category => 'Categoría';

  @override
  String get categoryRequired => 'Categoría *';

  @override
  String get noCategoryAvailable => 'Ninguna categoría disponible';

  @override
  String get pleaseSelectCategory => 'Por favor, seleccione una categoría';

  @override
  String get date => 'Fecha';

  @override
  String get description => 'Descripción';

  @override
  String get descriptionOptional => 'Descripción (opcional)';

  @override
  String get descriptionHint => 'Observaciones adicionales...';

  @override
  String get saveTransaction => 'Guardar Transacción';

  @override
  String get updateTransaction => 'Actualizar Transacción';

  @override
  String get addToList => 'Agregar a la Lista';

  @override
  String get transactionUpdated => '¡Transacción actualizada con éxito!';

  @override
  String get transactionAdded => '¡Transacción agregada con éxito!';

  @override
  String get all => 'Todas';

  @override
  String get incomes => 'Ingresos';

  @override
  String get expenses => 'Gastos';

  @override
  String get noIncomeRegistered => 'Ningún ingreso registrado';

  @override
  String get noExpenseRegistered => 'Ningún gasto registrado';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get currentBalance => 'Saldo Actual';

  @override
  String get incomesLabel => 'Ingresos';

  @override
  String get expensesLabel => 'Gastos';

  @override
  String get deleteTransaction => 'Eliminar Transacción';

  @override
  String get confirmDeleteTransaction =>
      '¿Está seguro de que desea eliminar esta transacción?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get aboutApp => 'Acerca de la App';

  @override
  String get version => 'Versión';

  @override
  String get data => 'Datos';

  @override
  String get clearAllData => 'Limpiar Todos los Datos';

  @override
  String get clearAllDataDescription => 'Eliminar todas las transacciones';

  @override
  String get confirmClearData =>
      '¿Está seguro de que desea eliminar todas las transacciones? Esta acción no se puede deshacer.';

  @override
  String get deleteAll => 'Eliminar Todo';

  @override
  String get allDataDeleted => 'Todos los datos han sido eliminados';

  @override
  String get information => 'Información';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get privacyPolicyDescription => 'Cómo protegemos sus datos';

  @override
  String get privacyPolicyContent =>
      'Todos sus datos se almacenan localmente en su dispositivo. Ninguna información se envía a servidores externos. Usted tiene control total sobre sus datos financieros.';

  @override
  String get help => 'Ayuda';

  @override
  String get helpDescription => 'Cómo usar la aplicación';

  @override
  String get helpContent =>
      '• Toca el botón \"+\" para agregar una nueva transacción\n\n• En la pantalla inicial, verás tu saldo y transacciones recientes\n\n• En el historial, puedes ver todas las transacciones organizadas por fecha\n\n• Toca una transacción para editarla\n\n• Mantén presionada una transacción para eliminarla';

  @override
  String get entries => 'Registros';

  @override
  String get noEntriesYet =>
      'Aún no hay registros.\nUsa el botón de abajo para agregar.';

  @override
  String get totalIncome => 'Total Ingresos:';

  @override
  String get totalExpenses => 'Total Gastos:';

  @override
  String get balance => 'Saldo:';

  @override
  String get addIncomeExpense => 'Agregar Ingreso/Gasto';

  @override
  String get confirm => 'Confirmar';

  @override
  String get noTransactionsToConfirm => 'Ninguna transacción para confirmar';

  @override
  String transactionsConfirmed(int count) {
    return '$count transacción(es) confirmada(s) con éxito!';
  }

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get portuguese => 'Português (Brasil)';

  @override
  String get spanishSpain => 'Español (España)';

  @override
  String get spanishMexico => 'Español (México)';

  @override
  String get englishUS => 'English (United States)';

  @override
  String get englishUK => 'English (United Kingdom)';

  @override
  String get categorySalary => 'Salario';

  @override
  String get categorySales => 'Ventas';

  @override
  String get categoryInvestments => 'Inversiones';

  @override
  String get categoryGifts => 'Regalos';

  @override
  String get categoryOtherIncome => 'Otras Ingresos';

  @override
  String get categoryFood => 'Alimentación';

  @override
  String get categoryTransport => 'Transporte';

  @override
  String get categoryHousing => 'Vivienda';

  @override
  String get categoryHealth => 'Salud';

  @override
  String get categoryEducation => 'Educación';

  @override
  String get categoryLeisure => 'Ocio';

  @override
  String get categoryShopping => 'Compras';

  @override
  String get categoryBills => 'Cuentas y Servicios';

  @override
  String get categoryOtherExpense => 'Otras Gastos';
}

/// The translations for Spanish Castilian, as used in Spain (`es_ES`).
class AppLocalizationsEsEs extends AppLocalizationsEs {
  AppLocalizationsEsEs() : super('es_ES');

  @override
  String get appTitle => 'Financial Tracker';

  @override
  String get home => 'Inicio';

  @override
  String get history => 'Historial';

  @override
  String get settings => 'Configuración';

  @override
  String get newTransaction => 'Nueva Transacción';

  @override
  String get recentTransactions => 'Transacciones Recientes';

  @override
  String get noTransactionsRegistered => 'Ninguna transacción registrada';

  @override
  String get tapToAdd => 'Toca el botón + para agregar';

  @override
  String get editTransaction => 'Editar Transacción';

  @override
  String get type => 'Tipo';

  @override
  String get income => 'Ingreso';

  @override
  String get expense => 'Gasto';

  @override
  String get title => 'Título';

  @override
  String get titleRequired => 'Título *';

  @override
  String get titleHint => 'Ej: Salario, Almuerzo, etc.';

  @override
  String get pleaseEnterTitle => 'Por favor, ingrese un título';

  @override
  String get amount => 'Valor';

  @override
  String get amountRequired => 'Valor *';

  @override
  String get pleaseEnterAmount => 'Por favor, ingrese un valor';

  @override
  String get pleaseEnterValidAmount => 'Por favor, ingrese un valor válido';

  @override
  String get category => 'Categoría';

  @override
  String get categoryRequired => 'Categoría *';

  @override
  String get noCategoryAvailable => 'Ninguna categoría disponible';

  @override
  String get pleaseSelectCategory => 'Por favor, seleccione una categoría';

  @override
  String get date => 'Fecha';

  @override
  String get description => 'Descripción';

  @override
  String get descriptionOptional => 'Descripción (opcional)';

  @override
  String get descriptionHint => 'Observaciones adicionales...';

  @override
  String get saveTransaction => 'Guardar Transacción';

  @override
  String get updateTransaction => 'Actualizar Transacción';

  @override
  String get addToList => 'Agregar a la Lista';

  @override
  String get transactionUpdated => '¡Transacción actualizada con éxito!';

  @override
  String get transactionAdded => '¡Transacción agregada con éxito!';

  @override
  String get all => 'Todas';

  @override
  String get incomes => 'Ingresos';

  @override
  String get expenses => 'Gastos';

  @override
  String get noIncomeRegistered => 'Ningún ingreso registrado';

  @override
  String get noExpenseRegistered => 'Ningún gasto registrado';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get currentBalance => 'Saldo Actual';

  @override
  String get incomesLabel => 'Ingresos';

  @override
  String get expensesLabel => 'Gastos';

  @override
  String get deleteTransaction => 'Eliminar Transacción';

  @override
  String get confirmDeleteTransaction =>
      '¿Está seguro de que desea eliminar esta transacción?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get aboutApp => 'Acerca de la App';

  @override
  String get version => 'Versión';

  @override
  String get data => 'Datos';

  @override
  String get clearAllData => 'Limpiar Todos los Datos';

  @override
  String get clearAllDataDescription => 'Eliminar todas las transacciones';

  @override
  String get confirmClearData =>
      '¿Está seguro de que desea eliminar todas las transacciones? Esta acción no se puede deshacer.';

  @override
  String get deleteAll => 'Eliminar Todo';

  @override
  String get allDataDeleted => 'Todos los datos han sido eliminados';

  @override
  String get information => 'Información';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get privacyPolicyDescription => 'Cómo protegemos sus datos';

  @override
  String get privacyPolicyContent =>
      'Todos sus datos se almacenan localmente en su dispositivo. Ninguna información se envía a servidores externos. Usted tiene control total sobre sus datos financieros.';

  @override
  String get help => 'Ayuda';

  @override
  String get helpDescription => 'Cómo usar la aplicación';

  @override
  String get helpContent =>
      '• Toca el botón \"+\" para agregar una nueva transacción\n\n• En la pantalla inicial, verás tu saldo y transacciones recientes\n\n• En el historial, puedes ver todas las transacciones organizadas por fecha\n\n• Toca una transacción para editarla\n\n• Mantén presionada una transacción para eliminarla';

  @override
  String get entries => 'Registros';

  @override
  String get noEntriesYet =>
      'Aún no hay registros.\nUsa el botón de abajo para agregar.';

  @override
  String get totalIncome => 'Total Ingresos:';

  @override
  String get totalExpenses => 'Total Gastos:';

  @override
  String get balance => 'Saldo:';

  @override
  String get addIncomeExpense => 'Agregar Ingreso/Gasto';

  @override
  String get confirm => 'Confirmar';

  @override
  String get noTransactionsToConfirm => 'Ninguna transacción para confirmar';

  @override
  String transactionsConfirmed(int count) {
    return '$count transacción(es) confirmada(s) con éxito!';
  }

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get portuguese => 'Português (Brasil)';

  @override
  String get spanishSpain => 'Español (España)';

  @override
  String get spanishMexico => 'Español (México)';

  @override
  String get englishUS => 'English (United States)';

  @override
  String get englishUK => 'English (United Kingdom)';

  @override
  String get categorySalary => 'Salario';

  @override
  String get categorySales => 'Ventas';

  @override
  String get categoryInvestments => 'Inversiones';

  @override
  String get categoryGifts => 'Regalos';

  @override
  String get categoryOtherIncome => 'Otras Ingresos';

  @override
  String get categoryFood => 'Alimentación';

  @override
  String get categoryTransport => 'Transporte';

  @override
  String get categoryHousing => 'Vivienda';

  @override
  String get categoryHealth => 'Salud';

  @override
  String get categoryEducation => 'Educación';

  @override
  String get categoryLeisure => 'Ocio';

  @override
  String get categoryShopping => 'Compras';

  @override
  String get categoryBills => 'Cuentas y Servicios';

  @override
  String get categoryOtherExpense => 'Otras Gastos';
}

/// The translations for Spanish Castilian, as used in Mexico (`es_MX`).
class AppLocalizationsEsMx extends AppLocalizationsEs {
  AppLocalizationsEsMx() : super('es_MX');

  @override
  String get appTitle => 'Financial Tracker';

  @override
  String get home => 'Inicio';

  @override
  String get history => 'Historial';

  @override
  String get settings => 'Configuración';

  @override
  String get newTransaction => 'Nueva Transacción';

  @override
  String get recentTransactions => 'Transacciones Recientes';

  @override
  String get noTransactionsRegistered => 'Ninguna transacción registrada';

  @override
  String get tapToAdd => 'Toca el botón + para agregar';

  @override
  String get editTransaction => 'Editar Transacción';

  @override
  String get type => 'Tipo';

  @override
  String get income => 'Ingreso';

  @override
  String get expense => 'Gasto';

  @override
  String get title => 'Título';

  @override
  String get titleRequired => 'Título *';

  @override
  String get titleHint => 'Ej: Salario, Almuerzo, etc.';

  @override
  String get pleaseEnterTitle => 'Por favor, ingrese un título';

  @override
  String get amount => 'Valor';

  @override
  String get amountRequired => 'Valor *';

  @override
  String get pleaseEnterAmount => 'Por favor, ingrese un valor';

  @override
  String get pleaseEnterValidAmount => 'Por favor, ingrese un valor válido';

  @override
  String get category => 'Categoría';

  @override
  String get categoryRequired => 'Categoría *';

  @override
  String get noCategoryAvailable => 'Ninguna categoría disponible';

  @override
  String get pleaseSelectCategory => 'Por favor, seleccione una categoría';

  @override
  String get date => 'Fecha';

  @override
  String get description => 'Descripción';

  @override
  String get descriptionOptional => 'Descripción (opcional)';

  @override
  String get descriptionHint => 'Observaciones adicionales...';

  @override
  String get saveTransaction => 'Guardar Transacción';

  @override
  String get updateTransaction => 'Actualizar Transacción';

  @override
  String get addToList => 'Agregar a la Lista';

  @override
  String get transactionUpdated => '¡Transacción actualizada con éxito!';

  @override
  String get transactionAdded => '¡Transacción agregada con éxito!';

  @override
  String get all => 'Todas';

  @override
  String get incomes => 'Ingresos';

  @override
  String get expenses => 'Gastos';

  @override
  String get noIncomeRegistered => 'Ningún ingreso registrado';

  @override
  String get noExpenseRegistered => 'Ningún gasto registrado';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get currentBalance => 'Saldo Actual';

  @override
  String get incomesLabel => 'Ingresos';

  @override
  String get expensesLabel => 'Gastos';

  @override
  String get deleteTransaction => 'Eliminar Transacción';

  @override
  String get confirmDeleteTransaction =>
      '¿Está seguro de que desea eliminar esta transacción?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get aboutApp => 'Acerca de la App';

  @override
  String get version => 'Versión';

  @override
  String get data => 'Datos';

  @override
  String get clearAllData => 'Limpiar Todos los Datos';

  @override
  String get clearAllDataDescription => 'Eliminar todas las transacciones';

  @override
  String get confirmClearData =>
      '¿Está seguro de que desea eliminar todas las transacciones? Esta acción no se puede deshacer.';

  @override
  String get deleteAll => 'Eliminar Todo';

  @override
  String get allDataDeleted => 'Todos los datos han sido eliminados';

  @override
  String get information => 'Información';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get privacyPolicyDescription => 'Cómo protegemos sus datos';

  @override
  String get privacyPolicyContent =>
      'Todos sus datos se almacenan localmente en su dispositivo. Ninguna información se envía a servidores externos. Usted tiene control total sobre sus datos financieros.';

  @override
  String get help => 'Ayuda';

  @override
  String get helpDescription => 'Cómo usar la aplicación';

  @override
  String get helpContent =>
      '• Toca el botón \"+\" para agregar una nueva transacción\n\n• En la pantalla inicial, verás tu saldo y transacciones recientes\n\n• En el historial, puedes ver todas las transacciones organizadas por fecha\n\n• Toca una transacción para editarla\n\n• Mantén presionada una transacción para eliminarla';

  @override
  String get entries => 'Registros';

  @override
  String get noEntriesYet =>
      'Aún no hay registros.\nUsa el botón de abajo para agregar.';

  @override
  String get totalIncome => 'Total Ingresos:';

  @override
  String get totalExpenses => 'Total Gastos:';

  @override
  String get balance => 'Saldo:';

  @override
  String get addIncomeExpense => 'Agregar Ingreso/Gasto';

  @override
  String get confirm => 'Confirmar';

  @override
  String get noTransactionsToConfirm => 'Ninguna transacción para confirmar';

  @override
  String transactionsConfirmed(int count) {
    return '$count transacción(es) confirmada(s) con éxito!';
  }

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get portuguese => 'Português (Brasil)';

  @override
  String get spanishSpain => 'Español (España)';

  @override
  String get spanishMexico => 'Español (México)';

  @override
  String get englishUS => 'English (United States)';

  @override
  String get englishUK => 'English (United Kingdom)';

  @override
  String get categorySalary => 'Salario';

  @override
  String get categorySales => 'Ventas';

  @override
  String get categoryInvestments => 'Inversiones';

  @override
  String get categoryGifts => 'Regalos';

  @override
  String get categoryOtherIncome => 'Otras Ingresos';

  @override
  String get categoryFood => 'Alimentación';

  @override
  String get categoryTransport => 'Transporte';

  @override
  String get categoryHousing => 'Vivienda';

  @override
  String get categoryHealth => 'Salud';

  @override
  String get categoryEducation => 'Educación';

  @override
  String get categoryLeisure => 'Ocio';

  @override
  String get categoryShopping => 'Compras';

  @override
  String get categoryBills => 'Cuentas y Servicios';

  @override
  String get categoryOtherExpense => 'Otras Gastos';
}
