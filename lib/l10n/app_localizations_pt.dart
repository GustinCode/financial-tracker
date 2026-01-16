// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Financial Tracker';

  @override
  String get home => 'Início';

  @override
  String get history => 'Histórico';

  @override
  String get settings => 'Configurações';

  @override
  String get newTransaction => 'Nova Transação';

  @override
  String get recentTransactions => 'Transações Recentes';

  @override
  String get noTransactionsRegistered => 'Nenhuma transação registrada';

  @override
  String get tapToAdd => 'Toque no botão + para adicionar';

  @override
  String get editTransaction => 'Editar Transação';

  @override
  String get type => 'Tipo';

  @override
  String get income => 'Receita';

  @override
  String get expense => 'Despesa';

  @override
  String get title => 'Título';

  @override
  String get titleRequired => 'Título *';

  @override
  String get titleHint => 'Ex: Salário, Almoço, etc.';

  @override
  String get pleaseEnterTitle => 'Por favor, insira um título';

  @override
  String get amount => 'Valor';

  @override
  String get amountRequired => 'Valor *';

  @override
  String get pleaseEnterAmount => 'Por favor, insira um valor';

  @override
  String get pleaseEnterValidAmount => 'Por favor, insira um valor válido';

  @override
  String get category => 'Categoria';

  @override
  String get categoryRequired => 'Categoria *';

  @override
  String get noCategoryAvailable => 'Nenhuma categoria disponível';

  @override
  String get pleaseSelectCategory => 'Por favor, selecione uma categoria';

  @override
  String get date => 'Data';

  @override
  String get description => 'Descrição';

  @override
  String get descriptionOptional => 'Descrição (opcional)';

  @override
  String get descriptionHint => 'Observações adicionais...';

  @override
  String get saveTransaction => 'Salvar Transação';

  @override
  String get updateTransaction => 'Atualizar Transação';

  @override
  String get addToList => 'Adicionar à Lista';

  @override
  String get transactionUpdated => 'Transação atualizada com sucesso!';

  @override
  String get transactionAdded => 'Transação adicionada com sucesso!';

  @override
  String get all => 'Todas';

  @override
  String get incomes => 'Receitas';

  @override
  String get expenses => 'Despesas';

  @override
  String get noIncomeRegistered => 'Nenhuma receita registrada';

  @override
  String get noExpenseRegistered => 'Nenhuma despesa registrada';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get currentBalance => 'Saldo Atual';

  @override
  String get incomesLabel => 'Receitas';

  @override
  String get expensesLabel => 'Despesas';

  @override
  String get deleteTransaction => 'Excluir Transação';

  @override
  String get confirmDeleteTransaction =>
      'Tem certeza que deseja excluir esta transação?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get aboutApp => 'Sobre o App';

  @override
  String get version => 'Versão';

  @override
  String get data => 'Dados';

  @override
  String get clearAllData => 'Limpar Todos os Dados';

  @override
  String get clearAllDataDescription => 'Excluir todas as transações';

  @override
  String get confirmClearData =>
      'Tem certeza que deseja excluir todas as transações? Esta ação não pode ser desfeita.';

  @override
  String get deleteAll => 'Excluir Tudo';

  @override
  String get allDataDeleted => 'Todos os dados foram excluídos';

  @override
  String get information => 'Informações';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get privacyPolicyDescription => 'Como protegemos seus dados';

  @override
  String get privacyPolicyContent =>
      'Todos os seus dados são armazenados localmente no seu dispositivo. Nenhuma informação é enviada para servidores externos. Você tem controle total sobre seus dados financeiros.';

  @override
  String get help => 'Ajuda';

  @override
  String get helpDescription => 'Como usar o aplicativo';

  @override
  String get helpContent =>
      '• Toque no botão \"+\" para adicionar uma nova transação\n\n• Na tela inicial, você vê seu saldo e transações recentes\n\n• No histórico, você pode ver todas as transações organizadas por data\n\n• Toque em uma transação para editá-la\n\n• Mantenha pressionado uma transação para excluí-la';

  @override
  String get entries => 'Lançamentos';

  @override
  String get noEntriesYet =>
      'Nenhum lançamento ainda.\nUse o botão abaixo para adicionar.';

  @override
  String get totalIncome => 'Total Receitas:';

  @override
  String get totalExpenses => 'Total Despesas:';

  @override
  String get balance => 'Saldo:';

  @override
  String get addIncomeExpense => 'Adicionar Receita/Despesa';

  @override
  String get confirm => 'Confirmar';

  @override
  String get noTransactionsToConfirm => 'Nenhuma transação para confirmar';

  @override
  String transactionsConfirmed(int count) {
    return '$count transação(ões) confirmada(s) com sucesso!';
  }

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar Idioma';

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
  String get categorySalary => 'Salário';

  @override
  String get categorySales => 'Vendas';

  @override
  String get categoryInvestments => 'Investimentos';

  @override
  String get categoryGifts => 'Presentes';

  @override
  String get categoryOtherIncome => 'Outras Receitas';

  @override
  String get categoryFood => 'Alimentação';

  @override
  String get categoryTransport => 'Transporte';

  @override
  String get categoryHousing => 'Moradia';

  @override
  String get categoryHealth => 'Saúde';

  @override
  String get categoryEducation => 'Educação';

  @override
  String get categoryLeisure => 'Lazer';

  @override
  String get categoryShopping => 'Compras';

  @override
  String get categoryBills => 'Contas e Serviços';

  @override
  String get categoryOtherExpense => 'Outras Despesas';
}
