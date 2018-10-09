# glueios
glue benbi versi ios

- Membuat navigation drawer, foto, nama & peran profile, fitur logout (dialog yes no, hapus user default),  seague ke menu2 terkait (news, member, chat, nearme)
- Membuat fitur login sesuai dengan perannya dan simpan di user default
- Membuat fitur daftar dengan pengecekan apakah sudah terdaftar, kemudian lengkapi biodata
- Membuat fitur edit biodata
- Membuat fitur edit akun (email, password)
- Peran : Admin, Pembina, Pengurus, Anggota
- Membuat listview news dengan image, desc, dll
- Membuat listview member genbi, dengan search bar nama
- Membuat peta sederhana di nearme
- Pengurus, pembina, admin ada menu tambah, filter berita di homenews
- Pengurus, pembina, admin memilih berita lari ke edit berita
- Di server membuat skema password reset dgn mengirim email
- Setiap biodata ada ishidden nya, sehingga bisa dihide untuk yang mau lihat
- Membuat fitur like dan comment
- Pembina menambah anggota dengan membuat nrp baru sesuai daerah pembinaannya, dan kemudian anggota mendaftar sendiri
- Pengurus mengelola news yang ia buat
- Pembina mengelola news dan akun yang pengurus2 daerahnya buat
- Admin pembina untuk seluruh daerah
- akun ftp dan mysql ios - keragenbi16
- akun pembina mirnayantijayasari@gmail.com - mirnayanti
- akun admin azkaa@admin.com - adminazkaa
- Kode 2016-16-01-002, 2016 tahun menerima, 16 jatim, 01 univ, 002 id

Role :
1. Administrator (adin)
2. Pembina (edin)
3. Pengurus GenBI (odin)
4. Anggota GenBI (udin)

Use Case

1. Udin bisa login dan logout
2. Udin bisa register. Note ga semua data user dimasukkan, hanya data parameter untuk identifikasi anggota.
3. (Khusus abis register) udin isi data diri full
4. Udin bisa change password
5. Udin bisa change profil. Note ada foto profil via camera atau galery
6. Udin bisa change data dirinya. Termasuk memilih data privasi untuk dihidden

6. Udin bisa lihat data-data anggota lain
7. Udin bisa dapat notifikasi berita baru
8. Udin bisa lihat berita2 terbaru
9. Odin bisa buat berita
10. Odin bisa edit berita
11. Edin bisa hapus berita
12. Edin bisa tambah, edit, dan hapus anggota

Yg bisa dilakukan udin, bisa dilakukan odin, edin, adin
Yg bisa dilakukan odin, bisa dilakukan edin, adin
Yg bisa dilakukan edin, bisa dilakukan adin

--------------------

Fitur yang belum jadi :
- Chat
- Reset password sudah namun di beda server, dideploy servernya mas udin ndak tau ndak bisa
