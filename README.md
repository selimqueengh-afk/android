# ChatApp - Modern Flutter Chat Application

Modern, şık animasyonlu ve gerçek zamanlı sohbet uygulaması. Firebase backend ile güçlendirilmiş, GitHub Actions ile otomatik APK build sistemi.

## 🚀 Özellikler

- **Modern UI/UX**: Şık ve kullanıcı dostu arayüz
- **Gerçek Zamanlı Sohbet**: Firebase Firestore ile anlık mesajlaşma
- **Animasyonlar**: Lottie ve Flutter animasyonları
- **Kullanıcı Kimlik Doğrulama**: Firebase Auth ile güvenli giriş
- **Medya Paylaşımı**: Resim ve dosya paylaşımı
- **Çevrimiçi Durumu**: Kullanıcı çevrimiçi durumu takibi
- **Otomatik Build**: GitHub Actions ile CI/CD pipeline

## 🛠️ Teknolojiler

- **Frontend**: Flutter 3.32.8
- **Backend**: Firebase (Auth, Firestore, Storage)
- **State Management**: Provider
- **Animasyonlar**: Lottie, Animated Text Kit
- **UI**: Material Design 3, Custom Components
- **CI/CD**: GitHub Actions

## 📱 Ekran Görüntüleri

### Splash Screen
- Şık açılış animasyonu
- Gradient arka plan
- Logo animasyonu

### Auth Screen
- Giriş/Kayıt formu
- Animasyonlu geçişler
- Form validasyonu

### Home Screen
- Sohbet listesi
- Kullanıcı avatarları
- Okunmamış mesaj sayacı

### Chat Screen
- Gerçek zamanlı mesajlaşma
- Medya paylaşımı
- Mesaj durumu (okundu/okunmadı)

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK 3.32.8+
- Dart SDK
- Android Studio / VS Code
- Firebase Projesi

### Adımlar

1. **Projeyi klonlayın**
```bash
git clone https://github.com/yourusername/chat_app.git
cd chat_app
```

2. **Bağımlılıkları yükleyin**
```bash
flutter pub get
```

3. **Firebase yapılandırması**
   - Firebase Console'da yeni proje oluşturun
   - Android uygulaması ekleyin
   - `google-services.json` dosyasını `android/app/` klasörüne ekleyin
   - `firebase_options.dart` dosyasını güncelleyin

4. **Uygulamayı çalıştırın**
```bash
flutter run
```

## 🔧 Firebase Kurulumu

1. **Firebase Console'da proje oluşturun**
2. **Authentication'ı etkinleştirin**
   - Email/Password provider'ı etkinleştirin
3. **Firestore Database oluşturun**
   - Test modunda başlatın
4. **Storage'ı etkinleştirin**
   - Güvenlik kurallarını yapılandırın

### Firestore Kuralları
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /chatRooms/{roomId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.participants;
    }
    match /messages/{messageId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 📦 APK Build

### Manuel Build
```bash
flutter build apk --release
```

### Otomatik Build (GitHub Actions)
- `main` branch'e push yapın
- GitHub Actions otomatik olarak APK oluşturacak
- Release sayfasından APK'yı indirebilirsiniz

## 🏗️ Proje Yapısı

```
lib/
├── constants/
│   ├── app_colors.dart
│   └── app_text_styles.dart
├── models/
│   ├── user_model.dart
│   ├── message_model.dart
│   └── chat_room_model.dart
├── providers/
│   ├── auth_provider.dart
│   └── chat_provider.dart
├── screens/
│   ├── splash_screen.dart
│   ├── auth_screen.dart
│   ├── home_screen.dart
│   └── chat_screen.dart
├── services/
│   └── firebase_service.dart
├── widgets/
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   ├── user_avatar.dart
│   ├── chat_list_item.dart
│   └── message_bubble.dart
├── firebase_options.dart
└── main.dart
```

## 🎨 Tasarım Sistemi

### Renkler
- **Primary**: #6366F1 (Indigo)
- **Secondary**: #10B981 (Emerald)
- **Background**: #F8FAFC (Light Gray)
- **Surface**: #FFFFFF (White)

### Tipografi
- **Font**: Poppins
- **Headings**: 32px, 28px, 24px, 20px
- **Body**: 16px, 14px, 12px
- **Caption**: 11px

## 🔄 CI/CD Pipeline

GitHub Actions workflow'u şu adımları içerir:

1. **Setup**: Java 17, Flutter 3.32.8
2. **Dependencies**: `flutter pub get`
3. **Analysis**: `flutter analyze`
4. **Testing**: `flutter test`
5. **Build**: `flutter build apk --release`
6. **Upload**: APK'yı artifact olarak yükle
7. **Release**: Main branch için otomatik release oluştur

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit yapın (`git commit -m 'Add amazing feature'`)
4. Push yapın (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

## 📞 İletişim

- **Proje Linki**: [https://github.com/yourusername/chat_app](https://github.com/yourusername/chat_app)
- **Issues**: [GitHub Issues](https://github.com/yourusername/chat_app/issues)

## 🙏 Teşekkürler

- Flutter ekibine
- Firebase ekibine
- Tüm açık kaynak katkıda bulunanlara

---

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın!
