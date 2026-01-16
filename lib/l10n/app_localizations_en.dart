// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Financial Tracker';

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get newTransaction => 'New Transaction';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get noTransactionsRegistered => 'No transactions registered';

  @override
  String get tapToAdd => 'Tap the + button to add';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get type => 'Type';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get title => 'Title';

  @override
  String get titleRequired => 'Title *';

  @override
  String get titleHint => 'Ex: Salary, Lunch, etc.';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get amount => 'Amount';

  @override
  String get amountRequired => 'Amount *';

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get pleaseEnterValidAmount => 'Please enter a valid amount';

  @override
  String get category => 'Category';

  @override
  String get categoryRequired => 'Category *';

  @override
  String get noCategoryAvailable => 'No category available';

  @override
  String get pleaseSelectCategory => 'Please select a category';

  @override
  String get date => 'Date';

  @override
  String get description => 'Description';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get descriptionHint => 'Additional notes...';

  @override
  String get saveTransaction => 'Save Transaction';

  @override
  String get updateTransaction => 'Update Transaction';

  @override
  String get addToList => 'Add to List';

  @override
  String get transactionUpdated => 'Transaction updated successfully!';

  @override
  String get transactionAdded => 'Transaction added successfully!';

  @override
  String get all => 'All';

  @override
  String get incomes => 'Incomes';

  @override
  String get expenses => 'Expenses';

  @override
  String get noIncomeRegistered => 'No income registered';

  @override
  String get noExpenseRegistered => 'No expense registered';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get incomesLabel => 'Incomes';

  @override
  String get expensesLabel => 'Expenses';

  @override
  String get deleteTransaction => 'Delete Transaction';

  @override
  String get confirmDeleteTransaction =>
      'Are you sure you want to delete this transaction?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get aboutApp => 'About the App';

  @override
  String get version => 'Version';

  @override
  String get data => 'Data';

  @override
  String get clearAllData => 'Clear All Data';

  @override
  String get clearAllDataDescription => 'Delete all transactions';

  @override
  String get confirmClearData =>
      'Are you sure you want to delete all transactions? This action cannot be undone.';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get allDataDeleted => 'All data has been deleted';

  @override
  String get information => 'Information';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDescription => 'How we protect your data';

  @override
  String get privacyPolicyContent =>
      'All your data is stored locally on your device. No information is sent to external servers. You have full control over your financial data.';

  @override
  String get help => 'Help';

  @override
  String get helpDescription => 'How to use the app';

  @override
  String get helpContent =>
      '• Tap the \"+\" button to add a new transaction\n\n• On the home screen, you\'ll see your balance and recent transactions\n\n• In history, you can see all transactions organized by date\n\n• Tap a transaction to edit it\n\n• Long press a transaction to delete it';

  @override
  String get entries => 'Entries';

  @override
  String get noEntriesYet => 'No entries yet.\nUse the button below to add.';

  @override
  String get totalIncome => 'Total Income:';

  @override
  String get totalExpenses => 'Total Expenses:';

  @override
  String get balance => 'Balance:';

  @override
  String get addIncomeExpense => 'Add Income/Expense';

  @override
  String get confirm => 'Confirm';

  @override
  String get noTransactionsToConfirm => 'No transactions to confirm';

  @override
  String transactionsConfirmed(int count) {
    return '$count transaction(s) confirmed successfully!';
  }

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

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
  String get categorySalary => 'Salary';

  @override
  String get categorySales => 'Sales';

  @override
  String get categoryInvestments => 'Investments';

  @override
  String get categoryGifts => 'Gifts';

  @override
  String get categoryOtherIncome => 'Other Income';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryHousing => 'Housing';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categoryLeisure => 'Leisure';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryBills => 'Bills & Services';

  @override
  String get categoryOtherExpense => 'Other Expenses';
}

/// The translations for English, as used in the United Kingdom (`en_GB`).
class AppLocalizationsEnGb extends AppLocalizationsEn {
  AppLocalizationsEnGb() : super('en_GB');

  @override
  String get appTitle => 'Financial Tracker';

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get newTransaction => 'New Transaction';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get noTransactionsRegistered => 'No transactions registered';

  @override
  String get tapToAdd => 'Tap the + button to add';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get type => 'Type';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get title => 'Title';

  @override
  String get titleRequired => 'Title *';

  @override
  String get titleHint => 'Ex: Salary, Lunch, etc.';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get amount => 'Amount';

  @override
  String get amountRequired => 'Amount *';

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get pleaseEnterValidAmount => 'Please enter a valid amount';

  @override
  String get category => 'Category';

  @override
  String get categoryRequired => 'Category *';

  @override
  String get noCategoryAvailable => 'No category available';

  @override
  String get pleaseSelectCategory => 'Please select a category';

  @override
  String get date => 'Date';

  @override
  String get description => 'Description';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get descriptionHint => 'Additional notes...';

  @override
  String get saveTransaction => 'Save Transaction';

  @override
  String get updateTransaction => 'Update Transaction';

  @override
  String get addToList => 'Add to List';

  @override
  String get transactionUpdated => 'Transaction updated successfully!';

  @override
  String get transactionAdded => 'Transaction added successfully!';

  @override
  String get all => 'All';

  @override
  String get incomes => 'Incomes';

  @override
  String get expenses => 'Expenses';

  @override
  String get noIncomeRegistered => 'No income registered';

  @override
  String get noExpenseRegistered => 'No expense registered';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get incomesLabel => 'Incomes';

  @override
  String get expensesLabel => 'Expenses';

  @override
  String get deleteTransaction => 'Delete Transaction';

  @override
  String get confirmDeleteTransaction =>
      'Are you sure you want to delete this transaction?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get aboutApp => 'About the App';

  @override
  String get version => 'Version';

  @override
  String get data => 'Data';

  @override
  String get clearAllData => 'Clear All Data';

  @override
  String get clearAllDataDescription => 'Delete all transactions';

  @override
  String get confirmClearData =>
      'Are you sure you want to delete all transactions? This action cannot be undone.';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get allDataDeleted => 'All data has been deleted';

  @override
  String get information => 'Information';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDescription => 'How we protect your data';

  @override
  String get privacyPolicyContent =>
      'All your data is stored locally on your device. No information is sent to external servers. You have full control over your financial data.';

  @override
  String get help => 'Help';

  @override
  String get helpDescription => 'How to use the app';

  @override
  String get helpContent =>
      '• Tap the \"+\" button to add a new transaction\n\n• On the home screen, you\'ll see your balance and recent transactions\n\n• In history, you can see all transactions organized by date\n\n• Tap a transaction to edit it\n\n• Long press a transaction to delete it';

  @override
  String get entries => 'Entries';

  @override
  String get noEntriesYet => 'No entries yet.\nUse the button below to add.';

  @override
  String get totalIncome => 'Total Income:';

  @override
  String get totalExpenses => 'Total Expenses:';

  @override
  String get balance => 'Balance:';

  @override
  String get addIncomeExpense => 'Add Income/Expense';

  @override
  String get confirm => 'Confirm';

  @override
  String get noTransactionsToConfirm => 'No transactions to confirm';

  @override
  String transactionsConfirmed(int count) {
    return '$count transaction(s) confirmed successfully!';
  }

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

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
  String get categorySalary => 'Salary';

  @override
  String get categorySales => 'Sales';

  @override
  String get categoryInvestments => 'Investments';

  @override
  String get categoryGifts => 'Gifts';

  @override
  String get categoryOtherIncome => 'Other Income';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryHousing => 'Housing';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categoryLeisure => 'Leisure';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryBills => 'Bills & Services';

  @override
  String get categoryOtherExpense => 'Other Expenses';
}

/// The translations for English, as used in the United States (`en_US`).
class AppLocalizationsEnUs extends AppLocalizationsEn {
  AppLocalizationsEnUs() : super('en_US');

  @override
  String get appTitle => 'Financial Tracker';

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get newTransaction => 'New Transaction';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get noTransactionsRegistered => 'No transactions registered';

  @override
  String get tapToAdd => 'Tap the + button to add';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get type => 'Type';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get title => 'Title';

  @override
  String get titleRequired => 'Title *';

  @override
  String get titleHint => 'Ex: Salary, Lunch, etc.';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get amount => 'Amount';

  @override
  String get amountRequired => 'Amount *';

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get pleaseEnterValidAmount => 'Please enter a valid amount';

  @override
  String get category => 'Category';

  @override
  String get categoryRequired => 'Category *';

  @override
  String get noCategoryAvailable => 'No category available';

  @override
  String get pleaseSelectCategory => 'Please select a category';

  @override
  String get date => 'Date';

  @override
  String get description => 'Description';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get descriptionHint => 'Additional notes...';

  @override
  String get saveTransaction => 'Save Transaction';

  @override
  String get updateTransaction => 'Update Transaction';

  @override
  String get addToList => 'Add to List';

  @override
  String get transactionUpdated => 'Transaction updated successfully!';

  @override
  String get transactionAdded => 'Transaction added successfully!';

  @override
  String get all => 'All';

  @override
  String get incomes => 'Incomes';

  @override
  String get expenses => 'Expenses';

  @override
  String get noIncomeRegistered => 'No income registered';

  @override
  String get noExpenseRegistered => 'No expense registered';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get incomesLabel => 'Incomes';

  @override
  String get expensesLabel => 'Expenses';

  @override
  String get deleteTransaction => 'Delete Transaction';

  @override
  String get confirmDeleteTransaction =>
      'Are you sure you want to delete this transaction?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get aboutApp => 'About the App';

  @override
  String get version => 'Version';

  @override
  String get data => 'Data';

  @override
  String get clearAllData => 'Clear All Data';

  @override
  String get clearAllDataDescription => 'Delete all transactions';

  @override
  String get confirmClearData =>
      'Are you sure you want to delete all transactions? This action cannot be undone.';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get allDataDeleted => 'All data has been deleted';

  @override
  String get information => 'Information';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDescription => 'How we protect your data';

  @override
  String get privacyPolicyContent =>
      'All your data is stored locally on your device. No information is sent to external servers. You have full control over your financial data.';

  @override
  String get help => 'Help';

  @override
  String get helpDescription => 'How to use the app';

  @override
  String get helpContent =>
      '• Tap the \"+\" button to add a new transaction\n\n• On the home screen, you\'ll see your balance and recent transactions\n\n• In history, you can see all transactions organized by date\n\n• Tap a transaction to edit it\n\n• Long press a transaction to delete it';

  @override
  String get entries => 'Entries';

  @override
  String get noEntriesYet => 'No entries yet.\nUse the button below to add.';

  @override
  String get totalIncome => 'Total Income:';

  @override
  String get totalExpenses => 'Total Expenses:';

  @override
  String get balance => 'Balance:';

  @override
  String get addIncomeExpense => 'Add Income/Expense';

  @override
  String get confirm => 'Confirm';

  @override
  String get noTransactionsToConfirm => 'No transactions to confirm';

  @override
  String transactionsConfirmed(int count) {
    return '$count transaction(s) confirmed successfully!';
  }

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

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
  String get categorySalary => 'Salary';

  @override
  String get categorySales => 'Sales';

  @override
  String get categoryInvestments => 'Investments';

  @override
  String get categoryGifts => 'Gifts';

  @override
  String get categoryOtherIncome => 'Other Income';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryHousing => 'Housing';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categoryLeisure => 'Leisure';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryBills => 'Bills & Services';

  @override
  String get categoryOtherExpense => 'Other Expenses';
}
