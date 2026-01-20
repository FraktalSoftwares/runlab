# RunLab - Mobile Only App

## 📱 Configuração Mobile-First

Este aplicativo é **100% mobile** e não possui responsividade web.

### Características

- **Largura fixa**: 390px (baseado no design do Figma)
- **Layout mobile-only**: Sem adaptação para desktop/tablet
- **Mobile Wrapper**: Em web/desktop, o app é centralizado com largura fixa

### Desenvolvimento

Para testar em dispositivos móveis:

```bash
# iOS Simulator
flutter run -d ios

# Android Emulator
flutter run -d android

# Dispositivo físico iOS
flutter run -d <device-id>

# Dispositivo físico Android
flutter run -d <device-id>
```

### Web (apenas para desenvolvimento)

Se precisar testar no navegador durante desenvolvimento:
- O app será renderizado com largura fixa de 390px
- Centralizado na tela
- Sem responsividade - sempre mobile

### Design System

- Breakpoints removidos (mobile-only)
- Layouts fixos para 390px de largura
- Sem MediaQuery para responsividade
