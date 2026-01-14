class Mahasiswa {
  String id;
  String nama;
  String nim;
  String kelas;

  Mahasiswa({
    required this.id,
    required this.nama,
    required this.nim,
    required this.kelas,
  });

  factory Mahasiswa.fromMap(Map<String, dynamic> data, String id) {
    return Mahasiswa(
      id: id,
      nama: data['nama'] ?? '',
      nim: data['nim'] ?? '',
      kelas: data['kelas'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'nim': nim,
      'kelas': kelas,
    };
  }
}