# BookRent — Aplikasi Penyewaan & Pembelian Buku (Flutter + Firebase + Riverpod)

Mini Project State Management — Mobile Apps Development Bootcamp  
Aplikasi ini memungkinkan user untuk **register/login**, mencari & melihat daftar buku dari **Buku Acak API**, melihat detail buku, melakukan **sewa buku (rent)** dengan durasi 1–7 hari (Rp 5.000/hari), serta melihat **daftar sewa realtime** dari **Firebase Firestore**.


## Demo
- Repo: `https://github.com/nmujahidin-aa/book-store`
- Demo (APK, and PPT): `https://drive.google.com/drive/folders/1Kb4LRISvz90hDsEvykzZJcgmjRnNgpvb?usp=sharing`

## Fitur Utama

### 1) Authentication (Firebase Authentication)
- Register (Name, Email, Password)
- Login (Email, Password)
- Forgot Password (reset email via Firebase)
- Validasi password (frontend & backend):
  - Minimal 8 karakter
  - Mengandung huruf dan angka
- Custom error message untuk FirebaseAuthException
- Loader overlay saat proses auth
- Redirect:
  - Register sukses → **Login**
  - Login sukses → **Home**

### 2) Book List (Buku Acak API)
- Fetch data dari API Buku Acak
- Tampilan grid 3 kolom (cover, judul, author)
- Search by keyword
- Filter: tahun & genre (client-side filter)
- Sort:
  - newest, oldest
  - titleAZ, titleZA
  - priceLowHigh, priceHighLow
- Pagination + Lazy Loading (server-side pagination)
- Empty state saat data kosong
- Error handling + UI retry

### 3) Detail Buku
- Menampilkan informasi lengkap:
  - Cover, Title, Author, Category, Publisher, Summary, Detail lainnya
  - Rent → menuju halaman Order Rent

### 4) Order Rent (Sewa Buku)
- Durasi sewa: 1–7 hari
- Harga sewa: Rp 5.000 / hari
- Total price dihitung otomatis
- Submit menyimpan data sewa ke Firestore
- Loader overlay saat submit + toast feedback

### 5) Rent List (Daftar Sewa)
- Menampilkan list data sewa dari Firestore (realtime)
- Jika masa sewa expired → tombol **Rent Again**
- Empty state saat belum ada data sewa


## Tech Stack
- **Flutter (latest stable)**
- **State Management:** Riverpod (Provider/Notifier/AsyncNotifier/StreamProvider)
- **Routing:** GoRouter (clean routing + auth guard)
- **Backend:**
  - Firebase Authentication
  - Cloud Firestore (rent data)
- **Networking:** Dio
- **Image:** CachedNetworkImage
- **Env:** flutter_dotenv
- **External Link:** url_launcher


## Arsitektur
Menggunakan **Clean Architecture + MVVM**:

- **presentation/**
  - pages (UI)
  - widgets (reusable UI)
  - viewmodels (Riverpod Notifier/AsyncNotifier)
- **domain/**
  - entities (pure model)
  - repositories (interface/contract)
  - usecases (business logic)
- **data/**
  - models (DTO: json/firestore)
  - datasources (Dio/Firebase)
  - repositories (implement domain repo)


## Struktur Folder (Ringkas)
lib/
  core/           # env, router, theme, utils, reusable widgets (toast/loader/empty)
  data/           # models, datasources (api/firebase), repositories impl
  domain/         # entities, repositories (contract), usecases
  presentation/   # pages, widgets, viewmodels (Riverpod)