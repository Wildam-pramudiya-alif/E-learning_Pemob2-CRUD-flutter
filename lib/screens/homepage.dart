import 'package:flutter/material.dart';
import '../models/mahasiswa_model.dart';
import '../services/firestore_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController kelasController = TextEditingController();

  void tampilkanForm(Mahasiswa? mhs) {
    if (mhs != null) {
      namaController.text = mhs.nama;
      nimController.text = mhs.nim;
      kelasController.text = mhs.kelas;
    } else {
      namaController.clear();
      nimController.clear();
      kelasController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(mhs == null ? "Tambah Mahasiswa" : "Edit Mahasiswa"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: namaController, decoration: InputDecoration(labelText: "Nama")),
            TextField(controller: nimController, decoration: InputDecoration(labelText: "NIM")),
            TextField(controller: kelasController, decoration: InputDecoration(labelText: "Kelas")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
          ElevatedButton(
            onPressed: () {
              if (mhs == null) {
                firestoreService.addMahasiswa(Mahasiswa(
                  id: '',
                  nama: namaController.text,
                  nim: nimController.text,
                  kelas: kelasController.text,
                ));
              } else {
                firestoreService.updateMahasiswa(Mahasiswa(
                  id: mhs.id,
                  nama: namaController.text,
                  nim: nimController.text,
                  kelas: kelasController.text,
                ));
              }
              Navigator.pop(context);
            },
            child: Text(mhs == null ? "Simpan" : "Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD Mahasiswa Firebase"), backgroundColor: Colors.deepOrange),
      floatingActionButton: FloatingActionButton(
        onPressed: () => tampilkanForm(null),
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<List<Mahasiswa>>(
        stream: firestoreService.getMahasiswa(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Terjadi kesalahan"));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final mhs = data[index];
              return ListTile(
                title: Text(mhs.nama),
                subtitle: Text("${mhs.nim} - ${mhs.kelas}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => tampilkanForm(mhs)),
                    IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => firestoreService.deleteMahasiswa(mhs.id)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}