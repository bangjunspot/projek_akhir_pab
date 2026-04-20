# 🍽️🔥 BANGJUN SPOT 🚀

Aplikasi kasir internal untuk UMKM Warung Makan BangJun di Samarinda 🍜
Dibangun menggunakan Flutter 📱 + Supabase ☁️ sebagai bagian dari Proyek Akhir PAB 2026 🎓

---

## 📝 Deskripsi Aplikasi

BANGJUN SPOT adalah aplikasi Point of Sale (POS) 💻 yang dirancang khusus untuk membantu
pengelolaan transaksi 💸, stok 📦, dan pengguna 👥 di Warung Makan BangJun. Aplikasi dapat
dijalankan di Android 📱 (APK) maupun browser web 🌐 (Chrome).

---

## Anggota Tim — Sidang Berapi

| Nama | NIM | Role |
|---|---|---|
| Sayid Rafi A'thaya | 2409116036 | Project Manager |
| (isi nama) | (isi NIM) | Backend / Supabase |
| (isi nama) | (isi NIM) | (Frontend / UI |
| (isi nama) | (isi NIM) | (isi role) |

---

## 🖼️✨ Tampilan Halaman

<img width="1919" height="1079" alt="Image" src="https://github.com/user-attachments/assets/1a1c2e19-b482-47d0-bdeb-986dc044cede" />  

---

<img width="1919" height="1079" alt="Image" src="https://github.com/user-attachments/assets/183ca465-bddc-43bf-a0bf-de87105769e0" />  

---

<img width="1919" height="1079" alt="Image" src="https://github.com/user-attachments/assets/ecaf1333-aaaa-47ac-8a86-411de9215b36" />  

---

<img width="1919" height="1079" alt="Image" src="https://github.com/user-attachments/assets/8146363a-ce2c-474a-85c3-cbe7602d3dc6" />  

---

<img width="1919" height="1079" alt="Image" src="https://github.com/user-attachments/assets/395ab076-95c2-404f-b1b1-8262b5f760e3" />  

---

<img width="1919" height="1079" alt="Image" src="https://github.com/user-attachments/assets/ce4dc2e2-f7c2-447c-a783-4f468f1c9461" />  

---

## ⚙️🔥 Fitur Aplikasi

| Fitur                             | Role          | Keterangan                                                                            |
| --------------------------------- | ------------- | ------------------------------------------------------------------------------------- |
| 🔐 Login                          | Admin & Kasir | Autentikasi via Supabase Auth                                                         |
| 🛒 Kasir (POS)                    | Admin & Kasir | Input pesanan, keranjang, checkout                                                    |
| 📊 Dashboard                      | Admin         | Grafik penjualan 7 hari & bulanan                                                     |
| 🍔 Manajemen Produk               | Admin         | CRUD menu (nama, harga, kategori, status aktif)                                       |
| 📦 Manajemen Stok                 | Admin & Kasir | Tambah/kurangi stok, riwayat pergerakan                                               |
| 👤 Manajemen User                 | Admin         | CRUD user via Supabase Edge Function                                                  |
| 🔔 Notifikasi                     | Admin & Kasir | Notifikasi lokal saat transaksi berhasil                                              |
| ✅ Notifikasi CRUD Menu            | Admin         | SnackBar hijau/merah otomatis setelah tambah, edit, hapus menu                        |
| 💰 Format Harga Rupiah            | Admin         | Input harga pakai `currency_text_input_formatter` + `intl` untuk tampilan `Rp 10.000` |
| 📈 Dashboard - Grafik Keuntungan  | Admin         | Grafik bar keuntungan per bulan + filter bulan untuk detail harian                    |
| 📉 Dashboard - Sumbu Grafik       | Admin         | Label tanggal & nominal jelas, tooltip putih, Y-axis nilai singkat (rb/jt)            |
| ⚠️ Stok - Auto Nonaktif           | Admin & Kasir | Produk otomatis dinonaktifkan (bukan dihapus) jika stok mencapai 0                    |
| 📏 Stok - Jarak Item              | Admin & Kasir | Jarak antar baris stok diperbesar + indikator "Stok Habis" merah                      |
| 👁️ Create User - Reveal Password | Admin         | Tombol mata untuk show/hide password di tambah/edit user                              |
| 🚪 Notifikasi Logout              | Admin & Kasir | Konfirmasi dialog logout + SnackBar "Berhasil logout"                                 |
| 👥 Notifikasi CRUD User           | Admin         | SnackBar saat tambah, edit, hapus user                                                |

---

## 🧩 Widget yang Digunakan

### 🏗️ Layout & Structure

* `Scaffold` — struktur halaman utama 🧱
* `Row`, `Column` — layout horizontal & vertikal ↔️↕️
* `IndexedStack` — switching halaman tanpa rebuild 🔄
* `ListView`, `ListView.builder` — daftar produk, stok, transaksi 📋
* `ConstrainedBox` — batasan ukuran maksimal konten di web 📐
* `SafeArea` — padding aman dari notch/home indicator 🛡️

### 🧭 Navigation

* `BottomNavigationBar` (custom pill) — navigasi mobile 📱
* `NavigationRail` via sidebar custom — navigasi web/tablet 💻
* `showDialog` — dialog konfirmasi, form tambah/edit 💬

### 📝 Input & Forms

* `TextFormField` dalam `Form` + `GlobalKey<FormState>` — validasi input ✔️
* `DropdownButtonFormField` — pilih kategori & role 🔽
* `Switch` — toggle status aktif produk 🔛
* `TextEditingController` — kontrol nilai input 🎛️

### ✨ Animation & Transition

* `AnimatedContainer` — animasi perubahan ukuran/warna 🎨
* `AnimatedScale` — efek tekan pada button & card 👆
* `AnimatedRotation` — rotasi ikon chevron cart 🔄
* `SizeTransition` + `AnimationController` — expand/collapse cart panel 📦
* `AnimatedBuilder` + `Transform.translate` + `Opacity` — fade-slide animation pada list item 🌫️➡️

### 🖥️ Display

* `ClayCard` (custom) — card dengan shadow neumorphic 🧊
* `ClayButton` (custom) — button gradient dengan efek hover & press 🎯
* `ClayInput` (custom) — input field dengan inner shadow & glow fokus ✨
* `ClayBackground` (custom) — animated blob background dengan `BackdropFilter` 🌈
* `ClayFadeSlide` (custom) — fade + slide masuk per item list 🚀
* `ClayFab` (custom) — floating action button gradient 🔘
* `BarChart`, `LineChart` dari `fl_chart` — grafik penjualan 📊
* `CircularProgressIndicator` — loading state ⏳
* `SnackBar` — feedback aksi pengguna 🍞
* `Selector` dari Provider — rebuild selektif widget cart badge 🎯

### 📱 Media Query & Responsive

* `MediaQuery.of(context).size.width` — adaptive layout web vs mobile 📏

  * `< 720px` → bottom nav (Android) 📱
  * `720–1099px` → sidebar icon-only 🧭
  * `≥ 1100px` → sidebar extended dengan label 💻

---

## 📦 Package Tambahan

| Package                                | Fungsi                                                        |
| -------------------------------------- | ------------------------------------------------------------- |
| `fl_chart ^0.69.0`                     | Visualisasi grafik bar & line chart pada halaman dashboard 📊 |
| `google_fonts ^6.2.1`                  | Tipografi Nunito & DM Sans untuk UI yang konsisten ✍️         |
| `flutter_local_notifications ^18.0.1`  | Notifikasi lokal saat transaksi berhasil (Android & iOS) 🔔   |
| `currency_text_input_formatter ^2.1.1` | Titik ribuan otomatis pada input harga 💰                     |
| `intl ^0.19.0`                         | Format Rupiah dengan separator ribuan 🇮🇩                    |

Package di atas tidak termasuk dalam daftar package yang diajarkan di praktikum ⚠️

Selain itu, aplikasi ini menggunakan **Supabase Edge Function** ⚡ (Deno/TypeScript)
untuk fitur pembuatan user baru oleh admin secara aman di sisi server 🔒,
tanpa mengekspos `service_role` key ke client.

---

## 🚀 Setup & Menjalankan

### ✅ Prasyarat

* Flutter SDK (stable, ≥ 3.10) 🐦
* Android Studio / VS Code dengan extension Flutter 💻
* Akses ke Supabase project (minta ke tim pengembang) 🔑

### 🛠️ Langkah Setup

**1. Clone repository**

```bash
git clone https://github.com/bangjunspot/projek_akhir_pab.git
cd projek_akhir_pab
```

**2. Install dependencies**

```bash
flutter pub get
```

**3. Buat file `.env`**

Salin file contoh:

```bash
cp assets/.env.example assets/.env
```

Lalu isi nilai `SUPABASE_URL` dan `SUPABASE_ANON_KEY` yang didapat dari tim pengembang:

```
SUPABASE_URL=https://xxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

> Nilai `.env` tidak disertakan di repository karena alasan keamanan 🔐
> Hubungi tim pengembang untuk mendapatkan nilai yang benar 🤝

**4. Jalankan aplikasi**

Web (Chrome):

```bash
flutter run -d chrome
```

Android (debug):

```bash
flutter run
```

Build APK:

```bash
flutter build apk --release
```

---

### ⚠️ Catatan Edge Function

Setelah deploy `create-user`, pastikan **Verify JWT = OFF** di:
Supabase Dashboard → Edge Functions → create-user → Settings.

---

### 👥 Akun Demo

| Role        | Email                                       | Password                  |
| ----------- | ------------------------------------------- | ------------------------- |
| 🧑‍💼 Admin | [admin@bangjun.id](mailto:admin@bangjun.id) | (minta ke tim pengembang) |
| 🧾 Kasir    | [kasir@bangjun.id](mailto:kasir@bangjun.id) | (minta ke tim pengembang) |

---

## 🔥 Anggota Tim — Sidang Berapi

| Nama       | NIM       | Role                  |
| ---------- | --------- | --------------------- |
| (isi nama) | (isi NIM) | Frontend / UI 🎨      |
| (isi nama) | (isi NIM) | Backend / Supabase ⚙️ |
| (isi nama) | (isi NIM) | (isi role) 🚀         |
| (isi nama) | (isi NIM) | (isi role) 💡         |

---

## 📁 Struktur Folder

```
lib/
├── core/
│   ├── services/       # Auth, Product, Stock, Transaction, Supabase service
│   └── utils/          # Currency formatter, date formatter, validators
├── features/
│   ├── auth/           # Login, Auth wrapper
│   ├── home/           # Home page (adaptive layout)
│   ├── kasir/          # Kasir/POS page
│   ├── dashboard/      # Dashboard & chart
│   ├── product/        # Manajemen produk
│   ├── stock/          # Manajemen stok
│   └── settings/       # CRUD User
├── models/             # Profile, Product, CartItem, StockMovement, Transaction
├── providers/          # Auth, Cart, Product, Stock, Transaction provider
├── theme/              # ClayColors, ClayShadows, ClayTheme
└── widgets/            # ClayCard, ClayButton, ClayInput, dll.

supabase/
├── functions/
│   └── create-user/    # Edge Function: buat user baru (server-side)
└── run_all.sql         # Setup schema, RLS, seed menu, setup users
```

---

