# 🕵️‍♂️ ANONYMZ
Website **chat anonim** untuk bersosialisasi tanpa mengungkap identitas. Cocok untuk pengguna publik yang ingin berbicara bebas tanpa takut diketahui siapa mereka.

<img src="https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white" alt="Next JS">

![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?logo=supabase&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/TailwindCSS-38B2AC?logo=tailwind-css&logoColor=white)
![Status](https://img.shields.io/badge/Status-Beta-orange)

---

## ✨ Fitur Utama
- **Quick Join** — Masuk ke ruang chat anonim hanya dengan satu klik.
- **Grup Anonim** — Buat dan gabung grup tanpa harus login atau mendaftar.
- **Presence Realtime** — Lihat siapa yang sedang online, join, atau leave secara langsung.

---

## 🛠️ Teknologi yang Digunakan
- **[Next.js](https://nextjs.org/)** — Framework React untuk frontend.
- **[Supabase Realtime](https://supabase.com/)** — Menangani fitur chat & presence secara realtime.
- **[Tailwind CSS](https://tailwindcss.com/)** — Styling cepat & responsif.

---

## 🚀 Instalasi & Menjalankan di Lokal
1. **Clone repository**
   ```bash
   git clone https://github.com/awanvirgi/anomyz-chat.git
   cd anonymz
   ```

2. **Install dependencies**
   ```bash
   npm install
   # atau
   yarn install
   ```

3. **Jalankan development server**
   ```bash
   npm run dev
   # atau
   yarn dev
   ```

4. **Buka di browser**
   ```
   http://localhost:3000
   ```

---

# Setup Supabase untuk Proyek Ini

Proyek ini menggunakan Supabase sebagai backend database. Untuk mempermudah setup, sudah disediakan file `backup.sql` yang berisi struktur tabel, data awal, dan fungsi yang dibutuhkan.

## 1. Prasyarat

Sebelum memulai, pastikan sudah menginstal:
- [Supabase CLI](https://supabase.com/docs/guides/cli)
- [PostgreSQL](https://www.postgresql.org/download/)
- [Node.js](https://nodejs.org/) (untuk Next.js)

---

## 2. Import `backup.sql` ke Supabase

### Opsi 1 — Menggunakan Supabase CLI (lokal)
1. Jalankan Supabase lokal:
   ```bash
   supabase start
2. Import file backup.sql:
   ```bash
   psql -h localhost -p 54322 -U postgres -d postgres -f backup.sql
Password default Supabase lokal: postgres

---
### Opsi 2 - Menggunakan Supabase Project Online
1. Login ke Supabase Dashboard
2. Pilih Project yang ingin digunakan
3. Buka Menu SQL Editor
4. Upload isi `backup.sql` atau salin isinya lalu jalankan Query

---

### Buat file environment
   Buat file `.env` dan isi dengan kredensial Supabase:
   ```env
 NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
   NEXT_PUBLIC_SUPABASE_KEY=your_supabase_anon_key
   NEXT_PUBLIC_SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role
   ```

## 📌 Status Proyek
⚠️ **Beta** — Sudah dapat digunakan, tapi masih dalam tahap pengujian dan perbaikan fitur.

---

