# 🚀 Como Executar no Android

## Opção 1: Usar Emulador Android (Recomendado)

### Passo 1: Iniciar um Emulador

Você tem 2 emuladores disponíveis. Escolha um:

```bash
# Opção A: Emulador Flutter
flutter emulators --launch flutter_emulator

# Opção B: Medium Phone API 36.1
flutter emulators --launch Medium_Phone_API_36.1
```

Aguarde o emulador iniciar completamente (pode levar 1-2 minutos).

### Passo 2: Verificar Dispositivos

Após o emulador iniciar, verifique se está disponível:

```bash
flutter devices
```

Você deve ver algo como:
```
sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64  • Android 14 (API 36)
```

**O Device ID é `emulator-5554`** (a parte entre os dois pontos • no meio)

### Passo 3: Executar o App

```bash
flutter run -d android
```

O Flutter irá compilar e instalar o app no emulador Android automaticamente.

**Nota**: Se você tiver múltiplos dispositivos Android conectados, você pode especificar o dispositivo exato:
```bash
# Ver o ID do dispositivo
flutter devices

# Executar no dispositivo específico (exemplo: sdk gphone64 x86 64)
flutter run -d <device-id>
```

---

## Opção 2: Usar Dispositivo Android Físico

### Passo 1: Habilitar Modo Desenvolvedor

1. Vá em **Configurações** > **Sobre o telefone**
2. Toque 7 vezes em **Número da versão** ou **Versão do MIUI**
3. Uma mensagem aparecerá: "Você agora é um desenvolvedor!"

### Passo 2: Ativar Depuração USB

1. Vá em **Configurações** > **Opções do desenvolvedor**
2. Ative **Depuração USB**
3. Conecte o celular ao computador via USB
4. No celular, aceite a autorização de depuração USB quando aparecer

### Passo 3: Verificar Conexão

```bash
flutter devices
```

Você deve ver seu dispositivo listado.

### Passo 4: Executar o App

```bash
flutter run -d android
```

**Nota**: Se você tiver múltiplos dispositivos, pode especificar o dispositivo exato pelo ID:
```bash
flutter run -d <device-id>
```

---

## 📱 Como Descobrir o Device ID

Para descobrir o ID do seu dispositivo Android, execute:

```bash
flutter devices
```

### Exemplo de Saída:
```
Found 4 connected devices:
  sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64    • Android 14
  Windows (desktop)            • windows       • windows-x64    • Microsoft Windows
  Chrome (web)                 • chrome        • web-javascript • Google Chrome
```

O **Device ID** é a parte entre os dois pontos (•) no meio. No exemplo acima:
- Android: `emulator-5554`
- Windows: `windows`
- Chrome: `chrome`

**Para mais detalhes, consulte:** [COMO_DESCOBRIR_DEVICE_ID.md](COMO_DESCOBRIR_DEVICE_ID.md)

---

## ⚡ Comandos Rápidos

### Instalar dependências (primeira vez)
```bash
flutter pub get
```

### Limpar e reinstalar (se houver problemas)
```bash
flutter clean
flutter pub get
flutter run -d android
```

### Executar em dispositivo específico
```bash
# Listar dispositivos
flutter devices

# Executar em qualquer dispositivo Android
flutter run -d android

# Executar em dispositivo específico pelo ID
flutter run -d <device-id>
# Exemplo: flutter run -d emulator-5554
```

### Modo Release (APK otimizado)
```bash
flutter build apk
```

O APK estará em: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🔧 Solução de Problemas

### ❌ "No devices found"
- **Emulador**: Certifique-se de que o emulador está totalmente iniciado
- **Dispositivo físico**: Verifique se a depuração USB está ativada e o cabo está conectado

### ❌ "Android SDK not found"
Execute no Android Studio:
- **Tools** > **SDK Manager**
- Instale **Android SDK Platform-Tools** e **Android SDK Build-Tools**

### ❌ "Build failed"
```bash
flutter clean
flutter pub get
flutter run -d android
```

### ❌ Erro de permissões no Windows
Execute o terminal como Administrador

---

## 📱 Após Executar

Quando o app iniciar, você verá:
- ✅ Tela inicial com saldo (R$ 0,00 inicialmente)
- ✅ Botão "+" para adicionar transações
- ✅ Aba de Histórico
- ✅ Aba de Configurações

**Dica**: Adicione algumas transações de teste para ver o app funcionando!

---

## 🎯 Próximos Passos

1. Teste adicionar receitas e despesas
2. Verifique o cálculo automático do saldo
3. Explore o histórico de transações
4. Teste editar e excluir transações

