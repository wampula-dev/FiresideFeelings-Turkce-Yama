# Fireside Feelings - Türkçe Yama

**Fireside Feelings** oyunu için hazırlanmış Türkçe yerelleştirme yamasıdır.

Bu yama, oyundaki ana menü, ayarlar, ipuçları, FAQ ve tüm kamp ateşi sohbet konularını (yaklaşık 3.000 satır metin ve diyalog) kapsar.

---

## 📌 Özellikler

- **Kapsam:** Tüm UI (Arayüz) metinleri ve 20+ sohbet konusu Türkçe'ye çevrilmiştir.
- **Font Uyumluluğu (ASCII Dönüşümü):** Oyunun orijinal yazı tipleri Türkçe özel karakterleri (`ğ`, `ş`, `ı`, `ö`, `ç`, `ü`) desteklemediğinden, harflerin bozulmaması veya kutu şeklinde görünmemesi için tüm metinler uyumlu ASCII karakterlerine (`g`, `s`, `i`, `o`, `c`, `u`) dönüştürülmüştür.
- **Gizlilik & Sunucu Koruması (Yerel Kayıt):** Kamp ateşinde Türkçe olarak yazdığınız yanıtlar geliştiricilerin veritabanına gönderilmez, yalnızca kendi bilgisayarınızda yerel olarak saklanır. Böylece hem kişisel yanıtlarınızın gizliliği korunur hem de geliştiricilerin sunucusuna dil uyumsuzluğu yaşatılmaz.
- **Güvenli Kurulum:** Kurulumdan önce orijinal oyun dosyanız (`FiresideFeelings.exe.bak`) otomatik olarak yedeklenir. İstediğiniz an orijinal haline geri dönebilirsiniz.
- **Açık Kaynak:** Tüm çevrilmiş kaynak CSV dosyaları repo içerisinde `source_csv/` klasöründe yer almaktadır.

---

## 🚀 Kurulum

1. Bu depoyu indirin (**Code** > **Download ZIP**) ve arşivden çıkarın.
2. `Yama_Kurucu.bat` dosyasını çift tıklayarak çalıştırın.
3. Açılan menüden **1** tuşuna basarak kurulumu seçin.
4. Kurucu, oyunun kurulu olduğu konumu otomatik tespit etmeye çalışacaktır. Eğer farklı bir sürücüde veya dizindeyse, sizden `FiresideFeelings.exe` dosyasını sürükleyip bırakmanızı isteyecektir.
5. Kurulum birkaç saniye içinde tamamlanacaktır.
6. Oyunu açın, **Ayarlar (Options)** bölümünden dil seçeneğini **Turkce** olarak ayarlayın.

---

## 🔄 Yamayı Kaldırma (Orijinal Hale Dönme)

1. `Yama_Kurucu.bat` dosyasını çalıştırın.
2. Açılan menüden **2** tuşuna basarak **Yamayi Kaldir** seçeneğini seçin.
3. Kurucu, yedeklenen `FiresideFeelings.exe.bak` dosyasını geri yükleyerek oyunu orijinal haline döndürecektir.

---

## 📁 Proje Yapısı

```
FiresideFeelings-Turkce-Yama/
├── .gitignore                      # Git yoksayma kuralları
├── LICENSE                         # MIT Lisansı
├── README.md                       # Bu bilgilendirme dosyası
├── Yama_Kurucu.bat                 # Tek tıkla yama başlatıcı
├── scripts/
│   └── installer.ps1               # Otomatik kurulum ve geri alma betiği
├── patch_files/                    # Oyuna enjekte edilen ikili çeviri dosyaları
│   ├── project.binary              # Dil kayıtlarını içeren proje ayarları
│   ├── Project_Data.gdc            # Türkçe dil enumunu içeren bayt kodu
│   ├── Dialogue_Manager.gdc        # Yerel kayıt ve sunucu koruma modülü
│   ├── Tr_Localisation_Data.tres   # Türkçe dil verisi kaynağı
│   ├── Tr_Localisation_Data.res    # Derlenmiş ikili kaynak
│   ├── Tr_Localisation_Data.tres.remap
│   └── translations/               # Derlenmiş .tr.translation ikili dosyaları (23 adet)
└── source_csv/                     # Çevrilmiş ham metin CSV dosyaları (23 adet)
```

---

## 📜 Lisans

Bu proje [MIT Lisansı](LICENSE) altında paylaşılmıştır. Çeviriler üzerinde serbestçe düzenleme yapabilir veya geliştirebilirsiniz.

---

## ⚖️ Yasal Uyarı / Disclaimer

**Türkçe:**
Bu proje, **Fireside Feelings** oyunu için topluluk tarafından hazırlanmış tamamen bağımsız ve kâr amacı gütmeyen bir **hayran yerelleştirme (fan translation)** çalışmasıdır.
- Oyunun tüm fikri mülkiyeti, ticari hakları, hikayesi, grafikleri ve ses dosyaları **Team Empreintes** stüdyosuna aittir.
- Bu depo ve yama paketi **orijinal oyun dosyalarını veya çalıştırılabilir oyun dosyasını (`FiresideFeelings.exe`) dağıtmaz**.
- Yamayı kullanabilmek için oyunun Steam üzerinden yasal olarak satın alınmış bir kopyasına sahip olunması gerekmektedir.

**English:**
This project is an independent, non-commercial **fan localization** for *Fireside Feelings*.
- All intellectual property, trademarks, story, audio, and visual assets belong to **Team Empreintes**.
- This repository and patch do **not** distribute original game executables (`FiresideFeelings.exe`) or proprietary game files.
- Players must own a legitimate copy of the game on Steam to use this patch.
- We deeply admire the work of Team Empreintes and created this project solely to help Turkish-speaking players experience this heartfelt journey.
