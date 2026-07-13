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

- Flutter SDK 3.x compatível com `>=3.0.0 <4.0.0`
- Android Studio ou VS Code com as extensões Flutter e Dart instaladas
- Android SDK com plataforma Android 21+ configurada
- JDK 11 ou JDK 17 instalado para build Android

## 🚀 Como Executar

1. Clone o repositório e entre na pasta do projeto:
```bash
git clone 'git@github.com:GustinCode/financial-tracker.git'
cd financial-tracker
```
---

2. Instale as dependências do Flutter:
```bash
flutter pub get
```
---

3. Para garantir que os ícones do app e a localização do app(linguagem) estão atualizados, execute (opcional se já estiverem gerados):
- ícones do app:
```bash
flutter pub run flutter_launcher_icons
```

- arquivos de localização (linguagem), use:

```bash
flutter pub get
flutter gen-l10n
```
---


4. Execute o aplicativo em um dispositivo ou emulador Android:
```bash
flutter run -d <deviceId>
```
---

5. Para gerar um APK de debug:
```bash
flutter build apk --debug
```
---

### Desenvolvimento adicional

- Se você modificar modelos Hive ou gerar código, execute:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

- Se precisar regenerar arquivos de localização, use:
```bash
flutter pub get
flutter gen-l10n
```



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

