import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart'; // IMPORT BARU
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/screens/auth_selection_page.dart';
import '../../auth/widgets/auth_background.dart';
import '../../../data/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "Pelanggan";
  String userEmail = "-";
  String userPhone = "-";
  String userAddress = "-";
  String? profileFoto;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? "Pelanggan";
      userEmail = prefs.getString('email') ?? "email@example.com";
      userPhone = prefs.getString('phone') ?? "08xxxx";
      userAddress = prefs.getString('address') ?? "Belum diatur";
      profileFoto = prefs.getString('foto');
    });
  }

  // --- MENU GANTI FOTO ---
  void _showPhotoMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Color(0xFF0D1B3E)),
            title: const Text('Pilih dari Galeri'),
            onTap: () {
              Navigator.pop(context);
              _pickAndCropImage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text(
              'Hapus Foto',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              Navigator.pop(context);
              _deletePhoto();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- PROSES UPLOAD & CROP FOTO ---
  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // PROSES CROP GAMBAR SEPERTI WHATSAPP
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ), // Kunci 1:1 Kotak
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Atur Posisi Foto',
            toolbarColor: const Color(0xFF0D1B3E),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Atur Posisi Foto',
            aspectRatioLockEnabled: true,
          ),
          // 🔻 PERBAIKAN FINAL UNTUK VERSI IMAGE CROPPER 8.0.0 KE ATAS 🔻
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.dialog, // Penulisan baru di v8
            size: const CropperSize(
              width: 400,
              height: 400,
            ), // Boundary diubah jadi Size di v8
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() => _isUploading = true);
        final prefs = await SharedPreferences.getInstance();
        String userId = prefs.getString('user_id') ?? '0';

        final result = await AuthService.updateProfileFoto(
          userId,
          XFile(croppedFile.path),
        );

        if (result['success']) {
          setState(() => profileFoto = result['foto_url']);
          await prefs.setString('foto', result['foto_url']);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Foto profil diperbarui!")),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(result['message'])));
          }
        }
        setState(() => _isUploading = false);
      }
    }
  }

  // --- PROSES HAPUS FOTO ---
  Future<void> _deletePhoto() async {
    setState(() => _isUploading = true);
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '0';

    final result = await AuthService.deleteProfileFoto(userId);
    if (result['success']) {
      setState(() => profileFoto = null);
      await prefs.remove('foto');
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Foto profil dihapus!")));
    }
    setState(() => _isUploading = false);
  }

  // --- MENU EDIT DATA ---
  void _editData(String title, String fieldKey, String currentValue) {
    TextEditingController controller = TextEditingController(
      text: currentValue,
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Masukkan $title baru",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D1B3E),
            ),
            onPressed: () async {
              Navigator.pop(context);
              String newValue = controller.text.trim();
              if (newValue.isNotEmpty && newValue != currentValue) {
                // Siapkan data lama
                String n = fieldKey == 'name' ? newValue : userName;
                String e = fieldKey == 'email' ? newValue : userEmail;
                String h = fieldKey == 'phone' ? newValue : userPhone;
                String a = fieldKey == 'address' ? newValue : userAddress;

                final prefs = await SharedPreferences.getInstance();
                String userId = prefs.getString('user_id') ?? '0';

                final res = await AuthService.updateProfileData(
                  userId,
                  n,
                  e,
                  h,
                  a,
                );
                if (res['success']) {
                  setState(() {
                    if (fieldKey == 'name') userName = newValue;
                    if (fieldKey == 'email') userEmail = newValue;
                    if (fieldKey == 'phone') userPhone = newValue;
                    if (fieldKey == 'address') userAddress = newValue;
                  });
                  await prefs.setString(fieldKey, newValue);
                  if (mounted)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Data diperbarui!")),
                    );
                } else {
                  if (mounted)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Gagal memperbarui data.")),
                    );
                }
              }
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // PERBAIKAN: UKURAN FOTO PROFIL DIPERBESAR (140x140)
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 140, // DIPERBESAR
                        height: 140, // DIPERBESAR
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF0D1B3E),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          image: DecorationImage(
                            image:
                                profileFoto != null && profileFoto!.isNotEmpty
                                // 🔻 PERBAIKAN: Menggunakan AuthService.baseUrl agar otomatis menyesuaikan
                                ? NetworkImage(
                                    "${AuthService.baseUrl}/uploads/profiles/$profileFoto",
                                  )
                                : const NetworkImage(
                                    "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                                  ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: _isUploading
                            ? const CircularProgressIndicator()
                            : null,
                      ),
                      GestureDetector(
                        onTap: _showPhotoMenu,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC3933C),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D1B3E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Pelanggan",
                    style: TextStyle(
                      color: Color(0xFFC3933C),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // PERBAIKAN: BISA DI-KLIK UNTUK EDIT DATA
                  _buildProfileItem(
                    Icons.person_outline,
                    "Nama Lengkap",
                    userName,
                    () => _editData("Nama", "name", userName),
                  ),
                  _buildProfileItem(
                    Icons.email_outlined,
                    "Email",
                    userEmail,
                    () => _editData("Email", "email", userEmail),
                  ),
                  _buildProfileItem(
                    Icons.phone_outlined,
                    "Nomor Telepon",
                    userPhone,
                    () => _editData("Nomor HP", "phone", userPhone),
                  ),
                  _buildProfileItem(
                    Icons.location_on_outlined,
                    "Alamat",
                    userAddress,
                    () => _editData("Alamat", "address", userAddress),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        if (mounted)
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AuthSelectionPage(),
                            ),
                          );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        "Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    IconData icon,
    String label,
    String value,
    VoidCallback onEdit,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B3E).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0D1B3E)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D1B3E),
                  ),
                ),
              ],
            ),
          ),
          // TOMBOL EDIT
          IconButton(
            icon: const Icon(Icons.edit, size: 20, color: Color(0xFFC3933C)),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}
