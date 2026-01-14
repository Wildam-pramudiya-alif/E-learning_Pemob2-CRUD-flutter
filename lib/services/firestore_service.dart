import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mahasiswa_model.dart';

class FirestoreService {
  final CollectionReference mahasiswaCollection =
      FirebaseFirestore.instance.collection('mahasiswa');


  Future<void> addMahasiswa(Mahasiswa mhs) {
    return mahasiswaCollection.add(mhs.toMap());
  }

  Stream<List<Mahasiswa>> getMahasiswa() {
    return mahasiswaCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Mahasiswa.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> updateMahasiswa(Mahasiswa mhs) {
    return mahasiswaCollection.doc(mhs.id).update(mhs.toMap());
  }

  Future<void> deleteMahasiswa(String id) {
    return mahasiswaCollection.doc(id).delete();
  }
}