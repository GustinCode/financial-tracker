# Financial Tracker

Aplicativo mobile de gerenciamento financeiro pessoal desenvolvido em Flutter para Android.

## 📱 Sobre o Projeto

O Financial Tracker é um aplicativo simples e intuitivo para controle de finanças pessoais. Permite registrar receitas e despesas, visualizar saldo em tempo real e acompanhar o histórico de transações.

## ✨ Funcionalidades

- ✅ Registro manual de receitas e despesas
- ✅ Categorização de transações
- ✅ Cálculo automático de saldo, receitas e despesas
- ✅ Histórico de transações organizado por data
- ✅ Interface simples e intuitiva
- ✅ Armazenamento local seguro (Hive)
- ✅ Edição e exclusão de transações

## 🛠️ Tecnologias

- **Flutter** - Framework de desenvolvimento
- **Provider** - Gerenciamento de estado
- **Hive** - Banco de dados local NoSQL
- **Material Design 3** - Design system

## 📋 Pré-requisitos

- Flutter SDK (>=3.0.0)
- Android Studio ou VS Code
- Dispositivo Android ou emulador

## 🚀 Como Executar

1. Clone o repositório ou navegue até a pasta do projeto

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o aplicativo no Android:
```bash
flutter run -d android
```

Para mais detalhes, consulte [EXECUTAR_ANDROID.md](EXECUTAR_ANDROID.md)

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── models/                   # Modelos de dados
│   ├── transaction_model.dart
│   └── category_model.dart
├── repositories/             # Camada de acesso a dados
│   ├── transaction_repository.dart
│   └── category_repository.dart
├── providers/                # Gerenciamento de estado
│   ├── transaction_provider.dart
│   └── category_provider.dart
├── views/                    # Telas da aplicação
│   ├── home_view.dart
│   ├── add_transaction_view.dart
│   ├── history_view.dart
│   └── settings_view.dart
├── widgets/                  # Componentes reutilizáveis
│   ├── balance_display.dart
│   └── transaction_card.dart
├── services/                 # Serviços auxiliares
│   └── database_service.dart
└── utils/                    # Utilitários
    ├── constants.dart
    └── formatters.dart
```

## 🎨 Arquitetura

O projeto segue o padrão **MVVM (Model-View-ViewModel)**:

- **Model**: Classes de dados (Transaction, Category)
- **View**: Widgets da interface (Views e Widgets)
- **ViewModel**: Providers que gerenciam estado e lógica de negócio

## 📝 Licença

Este projeto é de código aberto e está disponível para uso pessoal.

## 🔮 Melhorias Futuras

- Filtros avançados por categoria, mês ou tipo
- Gráficos de gastos e ganhos
- Metas e orçamentos mensais
- Exportação em PDF, Excel ou CSV
- Autenticação e sincronização com a nuvem
- Backup automático
- Notificações
- Integração com Open Finance



