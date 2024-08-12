import 'package:cloud_firestore/cloud_firestore.dart';

class NewsDB {
  String id;
  String judulBerita;
  String gambarBerita;
  String deskripsiBerita;
  DateTime tanggalBerita;

  NewsDB({
    required this.id,
    required this.judulBerita,
    required this.gambarBerita,
    required this.deskripsiBerita,
    required this.tanggalBerita,
  });

  factory NewsDB.fromDocument(DocumentSnapshot doc) {
    return NewsDB(
      id: doc.id,
      judulBerita: doc['judul_berita'],
      gambarBerita: doc['gambar_berita'],
      deskripsiBerita: doc['deskripsi_berita'],
      tanggalBerita: (doc['tanggal_berita'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judul_berita': judulBerita,
      'gambar_berita': gambarBerita,
      'deskripsi_berita': deskripsiBerita,
      'tanggal_berita': tanggalBerita,
    };
  }
}