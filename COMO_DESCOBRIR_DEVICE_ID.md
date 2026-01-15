# 📱 Como Descobrir o Device ID

## Método 1: Usando Flutter (Recomendado)

Execute o comando no terminal:

```bash
flutter devices
```

### Exemplo de Saída:

```
Found 4 connected devices:
  sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64    • Android 14 (API 36)
  Windows (desktop)            • windows       • windows-x64    • Microsoft Windows
  Chrome (web)                 • chrome        • web-javascript • Google Chrome
  Edge (web)                   • edge          • web-javascript • Microsoft Edge
```

### Como Ler a Saída:

O formato é: `Nome do Dispositivo • Device ID • Plataforma • Informações Adicionais`

**Device ID** é a parte entre os dois pontos (•) no meio.

No exemplo acima:
- **Android Emulator**: Device ID = `emulator-5554`
- **Windows**: Device ID = `windows`
- **Chrome**: Device ID = `chrome`
- **Edge**: Device ID = `edge`

### Para Android:

O Device ID geralmente é:
- **Emulador**: `emulator-5554`, `emulator-5556`, etc.
- **Dispositivo Físico**: Pode ser algo como `ABC123XYZ` ou similar

---

## Método 2: Usando ADB (Android Debug Bridge)

Se você tem o Android SDK instalado:

```bash
adb devices
```

### Exemplo de Saída:

```
List of devices attached
emulator-5554    device
ABC123XYZ        device
```

A primeira coluna mostra o Device ID.

---

## Como Usar o Device ID

Depois de descobrir o Device ID, você pode executar o app especificamente nele:

```bash
flutter run -d emulator-5554
```

Ou para qualquer dispositivo Android:

```bash
flutter run -d android
```

---

## Dicas

1. **Múltiplos Dispositivos**: Se você tiver vários dispositivos Android conectados, o Flutter pode perguntar qual usar. Especifique o Device ID para evitar isso.

2. **Device ID Muda?**: 
   - **Emuladores**: O ID geralmente é `emulator-XXXX` onde XXXX é a porta (5554, 5556, etc.)
   - **Dispositivos Físicos**: O ID geralmente permanece o mesmo, mas pode mudar se você desconectar e reconectar

3. **Dispositivo Não Aparece?**:
   - Verifique se está conectado (USB ou emulador rodando)
   - Para dispositivo físico: verifique se a depuração USB está ativada
   - Execute `flutter doctor` para diagnosticar problemas

---

## Exemplo Prático

**Seu caso atual:**
- Device ID do Android: `emulator-5554`
- Nome: `sdk gphone64 x86 64`

**Para executar no seu dispositivo Android:**
```bash
flutter run -d emulator-5554
```

**Ou simplesmente:**
```bash
flutter run -d android
```





