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

- Flutter SDK 3.44.2 ou superior compatível com Dart 3.12+
- Android Studio ou VS Code com as extensões Flutter e Dart instaladas
- Android SDK com plataforma Android 21+ configurada
- JDK 17 para build Android

## 🚀 Como executar

1. Clone o repositório e entre na pasta do projeto:
```bash
git clone https://github.com/GustinCode/financial-tracker.git
cd financial-tracker
```
---

2. Instale as dependências:
```bash
flutter pub get
```
---

3. Atualize os recursos gerados, se necessário:
- Icones do app:
```bash
flutter pub run flutter_launcher_icons
flutter gen-l10n
```

4. Execute o aplicativo em um dispositivo ou emulador Android:
```bash
flutter run -d <deviceId>
```

5. Para gerar um APK de debug:
```bash
flutter build apk --debug
```

## 🔧 Desenvolvimento

- Se você alterar modelos Hive ou gerar código, execute:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

- Para atualizar dependências e o lockfile do projeto:
```bash
flutter pub upgrade
```

## ✅ Dependências atualizadas

- Gradle wrapper: 8.9
- Android Gradle Plugin: 8.7.2
- Kotlin: 2.1.0
- intl: 0.20.2
- build_runner: 2.4.13
- flutter_launcher_icons: 0.14.4

## 📝 Licença

Este projeto é de código aberto e está disponível para uso pessoal.

## 🔮 Melhorias futuras

- Filtros avançados por categoria, mês ou tipo
- Gráficos de gastos e ganhos
- Metas e orçamentos mensais
- Exportação em PDF, Excel ou CSV
- Autenticação e sincronização com a nuvem
- Backup automático
- Notificações
- Integração com Open Finance

