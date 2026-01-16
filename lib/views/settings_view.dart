import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.read<TransactionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Sobre o App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Versão'),
            subtitle: Text('0.0.4'),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Dados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Limpar Todos os Dados'),
            subtitle: const Text('Excluir todas as transações'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Limpar Todos os Dados'),
                  content: const Text(
                    'Tem certeza que deseja excluir todas as transações? Esta ação não pode ser desfeita.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final transactions = transactionProvider.transactions;
                        for (var transaction in transactions) {
                          await transactionProvider
                              .deleteTransaction(transaction.id);
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Todos os dados foram excluídos'),
                            ),
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Excluir Tudo'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Informações',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Política de Privacidade'),
            subtitle: const Text('Como protegemos seus dados'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text('Política de Privacidade'),
                  content: Text(
                    'Todos os seus dados são armazenados localmente no seu dispositivo. '
                    'Nenhuma informação é enviada para servidores externos. '
                    'Você tem controle total sobre seus dados financeiros.',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Ajuda'),
            subtitle: const Text('Como usar o aplicativo'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text('Ajuda'),
                  content: SingleChildScrollView(
                    child: Text(
                      '• Toque no botão "+" para adicionar uma nova transação\n\n'
                      '• Na tela inicial, você vê seu saldo e transações recentes\n\n'
                      '• No histórico, você pode ver todas as transações organizadas por data\n\n'
                      '• Toque em uma transação para editá-la\n\n'
                      '• Mantenha pressionado uma transação para excluí-la',
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
