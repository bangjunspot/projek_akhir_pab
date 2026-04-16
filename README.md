# BANGJUN SPOT 🍽️

Aplikasi kasir internal untuk UMKM Warung Makan BangJun di Samarinda.
Dibangun menggunakan Flutter + Supabase sebagai bagian dari Proyek Akhir PAB 2026.

---

## Deskripsi Aplikasi

BANGJUN SPOT adalah aplikasi Point of Sale (POS) yang dirancang khusus untuk membantu
pengelolaan transaksi, stok, dan pengguna di Warung Makan BangJun. Aplikasi dapat
dijalankan di Android (APK) maupun browser web (Chrome).

---

## Fitur Aplikasi

| Fitur | Role | Keterangan |
|---|---|---|
| Login | Admin & Kasir | Autentikasi via Supabase Auth |
| Kasir (POS) | Admin & Kasir | Input pesanan, keranjang, checkout |
| Dashboard | Admin | Grafik penjualan 7 hari & bulanan |
| Manajemen Produk | Admin | CRUD menu (nama, harga, kategori, status aktif) |
| Manajemen Stok | Admin & Kasir | Tambah/kurangi stok, riwayat pergerakan |
| Manajemen User | Admin | CRUD user via Supabase Edge Function |
| Notifikasi | Admin & Kasir | Notifikasi lokal saat transaksi berhasil |

---

## Widget yang Digunakan

### Layout & Structure
- `Scaffold` — struktur halaman utama
- `Row`, `Column` — layout horizontal & vertikal
- `IndexedStack` — switching halaman tanpa rebuild
- `ListView`, `ListView.builder` — daftar produk, stok, transaksi
- `ConstrainedBox` — batasan ukuran maksimal konten di web
- `SafeArea` — padding aman dari notch/home indicator

### Navigation
- `BottomNavigationBar` (custom pill) — navigasi mobile
- `NavigationRail` via sidebar custom — navigasi web/tablet
- `showDialog` — dialog konfirmasi, form tambah/edit

### Input & Forms
- `TextFormField` dalam `Form` + `GlobalKey<FormState>` — validasi input
- `DropdownButtonFormField` — pilih kategori & role
- `Switch` — toggle status aktif produk
- `TextEditingController` — kontrol nilai input

### Animation & Transition
- `AnimatedContainer` — animasi perubahan ukuran/warna
- `AnimatedScale` — efek tekan pada button & card
- `AnimatedRotation` — rotasi ikon chevron cart
- `SizeTransition` + `AnimationController` — expand/collapse cart panel
- `AnimatedBuilder` + `Transform.translate` + `Opacity` — fade-slide animation pada list item

### Display
- `ClayCard` (custom) — card dengan shadow neumorphic
- `ClayButton` (custom) — button gradient dengan efek hover & press
- `ClayInput` (custom) — input field dengan inner shadow & glow fokus
- `ClayBackground` (custom) — animated blob background dengan `BackdropFilter`
- `ClayFadeSlide` (custom) — fade + slide masuk per item list
- `ClayFab` (custom) — floating action button gradient
- `BarChart`, `LineChart` dari `fl_chart` — grafik penjualan
- `CircularProgressIndicator` — loading state
- `SnackBar` — feedback aksi pengguna
- `Selector` dari Provider — rebuild selektif widget cart badge

### Media Query & Responsive
- `MediaQuery.of(context).size.width` — adaptive layout web vs mobile
  - `< 720px` → bottom nav (Android)
  - `720–1099px` → sidebar icon-only
  - `≥ 1100px` → sidebar extended dengan label

---

## Package Tambahan (Nilai Tambah)

| Package | Fungsi |
|---|---|
| `fl_chart ^0.69.0` | Visualisasi grafik bar & line chart pada halaman dashboard |
| `google_fonts ^6.2.1` | Tipografi Nunito & DM Sans untuk UI yang konsisten |
| `flutter_local_notifications ^18.0.1` | Notifikasi lokal saat transaksi berhasil (Android & iOS) |

Package di atas tidak termasuk dalam daftar package yang diajarkan di praktikum.

Selain itu, aplikasi ini menggunakan **Supabase Edge Function** (Deno/TypeScript)
untuk fitur pembuatan user baru oleh admin secara aman di sisi server,
tanpa mengekspos `service_role` key ke client.

---

## Setup & Menjalankan

### Prasyarat
- Flutter SDK (stable, ≥ 3.10)
- Android Studio / VS Code dengan extension Flutter
- Akses ke Supabase project (minta ke tim pengembang)

### Langkah Setup

**1. Clone repository**
```bash
git clone https://github.com/mocharezky04/prototype_projek_akhir_pab.git
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

> Nilai `.env` tidak disertakan di repository karena alasan keamanan.
> Hubungi tim pengembang untuk mendapatkan nilai yang benar.

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

### Catatan Edge Function
Setelah deploy `create-user`, pastikan **Verify JWT = OFF** di:
Supabase Dashboard → Edge Functions → create-user → Settings.

---

### Akun Demo

| Role | Email | Password |
|---|---|---|
| Admin | admin@bangjun.id | (minta ke tim pengembang) |
| Kasir | kasir@bangjun.id | (minta ke tim pengembang) |

---

## Anggota Tim — Sidang Berapi

| Nama | NIM | Role |
|---|---|---|
| (isi nama) | (isi NIM) | Frontend / UI |
| (isi nama) | (isi NIM) | Backend / Supabase |
| (isi nama) | (isi NIM) | (isi role) |
| (isi nama) | (isi NIM) | (isi role) |

---

## Struktur Folder

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

## Revisi Fitur (v1.1.0)

| No | Fitur | Keterangan |
|---|---|---|
| 1 | **Notifikasi CRUD Menu** | SnackBar hijau/merah otomatis setelah tambah, edit, hapus menu |
| 2 | **Upload Gambar Produk** | Pilih gambar dari galeri → upload ke Supabase Storage (`product-images`) |
| 3 | **Format Harga Rupiah** | Input harga pakai `currency_text_input_formatter` (titik ribuan otomatis) + `intl` untuk tampil `Rp 10.000` |
| 4 | **Dashboard – Grafik Keuntungan** | Grafik bar keuntungan per bulan sepanjang tahun + filter bulan untuk detail harian |
| 5 | **Dashboard – Sumbu Grafik** | Label tanggal & nominal jelas, tooltip putih, Y-axis menampilkan nilai singkat (rb/jt) |
| 6 | **Stok – Auto Nonaktif** | Produk otomatis dinonaktifkan (bukan dihapus) jika stok mencapai 0; notif peringatan muncul |
| 7 | **Stok – Jarak Item** | Jarak antar baris stok diperbesar + indikator "Stok Habis" berwarna merah |
| 8 | **Create User – Reveal Password** | Tombol mata pada field password untuk show/hide; Edit User tampilkan field password opsional |
| 9 | **Notifikasi Logout** | Konfirmasi dialog sebelum logout + SnackBar "Berhasil logout" saat kembali ke login |
| 10 | **Notifikasi CRUD User** | SnackBar pada tambah, edit, hapus user |

### Package Tambahan (Revisi)

| Package | Fungsi |
|---|---|
| `currency_text_input_formatter ^2.1.1` | Titik ribuan otomatis pada input harga |
| `image_picker ^1.1.2` | Pilih gambar dari galeri untuk foto produk |
| `intl ^0.19.0` | Format Rupiah dengan separator ribuan |

### Catatan Setup Storage (Supabase)

Buat bucket `product-images` di Supabase Storage:
1. Supabase Dashboard → Storage → New Bucket → nama: `product-images`
2. Set **Public** agar URL gambar dapat diakses
3. Tambahkan policy INSERT untuk role `authenticated`

