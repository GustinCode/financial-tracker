# Instruções de Instalação e Execução

## 📋 Pré-requisitos

1. **Flutter SDK** (versão 3.0.0 ou superior)
   - Baixe em: https://flutter.dev/docs/get-started/install
   - Verifique a instalação: `flutter doctor`

2. **Android Studio** ou **VS Code** com extensão Flutter
   - Android Studio: https://developer.android.com/studio
   - VS Code: https://code.visualstudio.com/

3. **Dispositivo Android** ou **Emulador Android**
   - Para dispositivo físico: ative o modo desenvolvedor e depuração USB
   - Para emulador: configure no Android Studio

## 🚀 Passos para Executar

### 1. Instalar Dependências

Abra o terminal na pasta do projeto e execute:

```bash
flutter pub get
```

Este comando irá baixar todas as dependências necessárias (Provider, Hive, etc).

### 2. Verificar Configuração

Verifique se tudo está configurado corretamente:

```bash
flutter doctor
```

Certifique-se de que o Flutter e o Android estão configurados corretamente.

### 3. Executar o Aplicativo

**Opção 1: Dispositivo Físico**
- Conecte seu dispositivo Android via USB
- Ative a depuração USB no dispositivo
- Execute: `flutter run -d android`

**Opção 2: Emulador**
- Inicie um emulador Android no Android Studio
- Execute: `flutter run -d android`

**Opção 3: Selecionar Dispositivo Específico**
- Liste dispositivos disponíveis: `flutter devices`
- Execute em dispositivo específico: `flutter run -d <device-id>`
  - Exemplo: `flutter run -d emulator-5554` ou `flutter run -d sdk gphone64 x86 64`

## 📱 Funcionalidades do App

### Tela Inicial
- Visualização do saldo atual
- Total de receitas e despesas
- Lista das 10 transações mais recentes
- Botão flutuante para adicionar nova transação

### Adicionar/Editar Transação
- Seleção de tipo (Receita ou Despesa)
- Campos: Título, Valor, Categoria, Data, Descrição
- Validação de campos obrigatórios
- Categorias pré-definidas com ícones

### Histórico
- Visualização de todas as transações
- Agrupamento por data
- Filtro por tipo (Receitas/Despesas/Todas)
- Edição e exclusão de transações

### Configurações
- Informações sobre o app
- Opção para limpar todos os dados
- Política de privacidade
- Ajuda

## 🗄️ Banco de Dados

O aplicativo usa **Hive** para armazenamento local. Os dados são salvos no dispositivo e não são enviados para servidores externos.

### Categorias Padrão

**Receitas:**
- 💰 Salário
- 💵 Vendas
- 📈 Investimentos
- 🎁 Presentes
- 💳 Outras Receitas

**Despesas:**
- 🍔 Alimentação
- 🚗 Transporte
- 🏠 Moradia
- 🏥 Saúde
- 📚 Educação
- 🎮 Lazer
- 🛍️ Compras
- 💡 Contas e Serviços
- 📦 Outras Despesas

## 🔧 Solução de Problemas

### Erro: "No devices found"
- Verifique se o dispositivo está conectado ou o emulador está rodando
- Execute `flutter devices` para listar dispositivos disponíveis

### Erro: "Package not found"
- Execute `flutter pub get` novamente
- Verifique se o arquivo `pubspec.yaml` está correto

### Erro: "Build failed"
- Limpe o projeto: `flutter clean`
- Reinstale dependências: `flutter pub get`
- Tente novamente: `flutter run -d android`

### Dados não aparecem
- O banco de dados é inicializado na primeira execução
- As categorias padrão são criadas automaticamente
- Se necessário, desinstale e reinstale o app

## 📝 Notas Importantes

- O aplicativo armazena dados localmente no dispositivo
- Não há sincronização com a nuvem no MVP
- Os dados são perdidos se o app for desinstalado
- Para backup, use a funcionalidade de exportação (futura)

## 🎯 Próximos Passos

Após executar o app com sucesso, você pode:
1. Adicionar transações de teste
2. Explorar as funcionalidades
3. Verificar o cálculo automático de saldo
4. Testar edição e exclusão de transações

