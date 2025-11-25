# **Guia Completo: Build para Web e APK no Flutter via VSCode**

## 📋 **1. Pré-requisitos**

### **1.1 Verificar ambiente Flutter**

```bash
flutter doctor
```

### **1.2 Atualizar Flutter e dependências**

```bash
flutter upgrade
flutter pub get
```

---

## 🌐 **2. Build para Web**

### **2.1 Build básico**

```bash
# Build padrão
flutter build web

# Build otimizado para produção
flutter build web --release
```

### **2.2 Renderizadores**

```bash
# Compatibilidade máxima (recomendado)
flutter build web --web-renderer html

# Melhor performance em browsers modernos
flutter build web --web-renderer canvaskit

# Automático
flutter build web --web-renderer auto
```

### **2.3 Análise de tamanho**

```bash
flutter build web --analyze-size
```

### **2.4 Builds avançados**

```bash
# Tree shaking agressivo
flutter build web --tree-shake-icons --release

# Com source maps
flutter build web --source-maps

# Para PWA
flutter build web --pwa
```

---

## 📱 **3. Build para Android (APK)**

### **3.1 Comandos principais**

```bash
# APK universal
flutter build apk

# Dividido por arquitetura
flutter build apk --split-per-abi

# Release
flutter build apk --release

# Análise de tamanho
flutter build apk --analyze-size

# Arquitetura específica
flutter build apk --target-platform android-arm64
```

### **3.2 Localização dos APKs**

```bash
📁 build/app/outputs/flutter-apk/
├── app-release.apk
├── app-armeabi-v7a-release.apk
├── app-arm64-v8a-release.apk
└── app-x86_64-release.apk
```

---

## 🔧 **4. Comandos de Preparação e Qualidade**

### **4.1 Limpeza e manutenção**

```bash
flutter clean
flutter clean && flutter pub get
flutter precache
```

### **4.2 Dependências**

```bash
flutter pub deps
flutter pub outdated
flutter pub upgrade
flutter pub deps --style=tree
```

### **4.3 Análise, testes e formatação**

```bash
flutter analyze
flutter test
flutter test --coverage
flutter format --set-exit-if-changed lib/

flutter build apk --analyze-size
flutter build web --analyze-size
```

---

## 🚀 **5. Workflows**

### **5.1 Workflow recomendado (produção)**

```bash
flutter clean
flutter pub get
flutter upgrade

flutter analyze
flutter test
flutter format lib/

flutter build web --release --web-renderer html
flutter build apk --release --split-per-abi

firebase deploy --only hosting

ls -la build/web/
ls -la build/app/outputs/flutter-apk/
```

### **5.2 Workflow rápido (desenvolvimento)**

```bash
flutter clean && flutter pub get && \
flutter analyze && flutter test && \
flutter build web --release && \
flutter build apk --release
```

---

## 🐛 **6. Solução de Problemas Comuns**

### **6.1 Erros frequentes**

```bash
# Keystore ausente
flutter clean && flutter build apk --release

# Permissões no Android
chmod +x android/gradlew

# Conflitos de dependência
flutter pub deps --style=tree > deps.txt

# Web muito grande
flutter build web --analyze-size
flutter build web --tree-shake-icons

# Problemas de cache
flutter precache
```

### **6.2 Verificação geral**

```bash
flutter doctor -v
flutter devices
flutter doctor --android-licenses
```

---

## 📊 **7. Pós-Build**

### **7.1 Web**

* Publicar a pasta `build/web/`
* Ativar HTTPS (necessário para PWA)
* Testar em múltiplos navegadores

### **7.2 Android**

* Testar APK em dispositivos reais
* Enviar para Google Play Console
* Guardar o keystore com segurança

### **7.3 Comandos úteis finais**

```bash
du -sh build/web/
du -sh build/app/outputs/flutter-apk/

find build/ -name "*.apk" -o -name "*.html"
```