# Fastlane iOS Konfigürasyonu

Bu klasör PawfectGear Co uygulamasının iOS App Store yayın sürecini otomatikleştirmek için gerekli Fastlane konfigürasyonlarını içerir.

## 📋 Gerekli Bilgiler ve Adımlar

### 1. Apple Developer Account Gereksinimleri

Aşağıdaki bilgileri toplamanız ve ilgili dosyalarda doldurmanız gerekir:

#### `Appfile` dosyasında doldurulması gerekenler:
```ruby
apple_id "sizin-apple-id@email.com"                    # Apple ID
app_store_connect_api_key_id "XXXXXXXXXX"              # App Store Connect API Key ID
app_store_connect_api_issuer_id "xxxxxxxx-xxxx-xxxx"   # App Store Connect API Issuer ID
app_store_connect_api_key_path "./fastlane/AuthKey_XXXXXXXXXX.p8"  # API Key dosya yolu
itc_team_id "XXXXXXXXXX"                               # iTunes Connect Team ID
```

### 2. App Store Connect API Key Kurulumu

1. [App Store Connect](https://appstoreconnect.apple.com) → Users and Access → Keys sekmesi
2. "Generate API Key" butonuna tıklayın
3. Key Name: "Fastlane" (veya istediğiniz bir isim)
4. Access: "App Manager" veya "Admin"
5. İndirilen `.p8` dosyasını `fastlane/` klasörüne koyun
6. Key ID ve Issuer ID'yi `Appfile`'a ekleyin

### 3. Match (Certificate Management) Kurulumu

1. GitHub'da private bir repository oluşturun (örn: `certificates`)
2. `Matchfile`'da `git_url` kısmını güncelleyin:
```ruby
git_url "https://github.com/KULLANICI_ADI/certificates"
```
3. İlk kurulum için çalıştırın:
```bash
fastlane match init
fastlane match development
fastlane match adhoc
fastlane match appstore
```

### 4. Metadata Konfigürasyonu

`fastlane/metadata/` klasöründeki dosyaları uygulamanıza göre düzenleyin:

#### İngilizce (`en-US/`):
- `name.txt` - Uygulama adı
- `subtitle.txt` - Alt başlık
- `description.txt` - Açıklama
- `keywords.txt` - Anahtar kelimeler
- `support_url.txt` - Destek URL'i
- `marketing_url.txt` - Pazarlama URL'i
- `privacy_url.txt` - Gizlilik politikası URL'i
- `release_notes.txt` - Sürüm notları

#### Türkçe (`tr/`):
- Aynı dosyalar Türkçe olarak

### 5. Ekran Görüntüleri

`fastlane/screenshots/` klasöründe her dil için aşağıdaki boyutlarda ekran görüntüleri:

- **iPhone 6.7"**: 1290x2796 pixels
- **iPhone 6.5"**: 1242x2688 pixels  
- **iPhone 5.5"**: 1242x2208 pixels
- **iPad Pro 12.9"**: 2048x2732 pixels

### 6. App Icon

`fastlane/metadata/app_icon.jpg` dosyasını 1024x1024 piksel boyutunda gerçek app icon'unuzla değiştirin.

## 🚀 Kullanım

### Geliştirme Build'i
```bash
fastlane dev
```

### TestFlight'a Beta Yükleme
```bash
fastlane beta
```

### App Store'a Yükleme
```bash
fastlane deploy
```

### Sadece Metadata Güncelleme
```bash
fastlane update_metadata
```

### Ekran Görüntüsü Oluşturma
```bash
fastlane screenshots
```

### Certificate Kurulumu
```bash
fastlane setup_certificates
```

## 📁 Dosya Yapısı

```
fastlane/
├── Appfile                 # Apple ID, Team ID, Bundle ID
├── Fastfile               # Lane'ler (otomatik süreçler)
├── Deliverfile            # App Store metadata ayarları
├── Matchfile              # Certificate yönetimi
├── Gymfile                # Build ayarları
├── Snapfile               # Ekran görüntüsü ayarları
├── metadata/              # App Store metadata
│   ├── app_icon.jpg       # 1024x1024 app icon
│   ├── en-US/            # İngilizce metadata
│   └── tr/               # Türkçe metadata
└── screenshots/           # Ekran görüntüleri
    ├── en-US/            # İngilizce screenshots
    └── tr/               # Türkçe screenshots
```

## ⚠️ Önemli Notlar

1. **API Key Güvenliği**: `.p8` dosyasını asla git'e commit etmeyin
2. **Certificate Repository**: Private olmalı ve sadece gerekli kişilerin erişimi olmalı
3. **Bundle ID**: Xcode projesindeki Bundle ID ile eşleşmeli
4. **Team ID**: Apple Developer Portal'dan alınmalı
5. **URL'ler**: Gerçek web sitesi URL'lerini kullanın

## 🔧 Sorun Giderme

### Certificate Sorunları
```bash
# Certificate'ları yeniden oluştur
fastlane match nuke development
fastlane match nuke adhoc
fastlane match nuke appstore

# Yeniden kur
fastlane setup_certificates
```

### Build Sorunları
```bash
# Clean build
flutter clean
cd ios && pod install && cd ..
fastlane dev
```

### Metadata Sorunları
- URL'lerin çalışır durumda olduğundan emin olun
- Açıklama uzunluğunu kontrol edin (4000 karakter limit)
- Anahtar kelime sayısını kontrol edin (100 karakter limit)

## 📞 Destek

Herhangi bir sorun yaşarsanız:
1. Bu README'yi tekrar kontrol edin
2. Fastlane dokümantasyonunu inceleyin: https://docs.fastlane.tools
3. Log dosyalarını kontrol edin: `build_logs/` klasörü
