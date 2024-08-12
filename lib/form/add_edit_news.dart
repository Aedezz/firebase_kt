import 'package:firebase_kt/db/news_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEditNews extends StatefulWidget {
  final NewsDB? news;

  const AddEditNews({super.key, this.news});

  @override
  // ignore: library_private_types_in_public_api
  _AddEditNews createState() => _AddEditNews();
}

class _AddEditNews extends State<AddEditNews> {
  final _formKey = GlobalKey<FormState>();
  late String _judulBerita;
  late String _gambarBerita;
  late String _deskripsiBerita;
  late DateTime _tanggalBerita;
  final CollectionReference newsCollection =
      FirebaseFirestore.instance.collection('news');

  @override
  void initState() {
    super.initState();
    if (widget.news != null) {
      _judulBerita = widget.news!.judulBerita;
      _gambarBerita = widget.news!.gambarBerita;
      _deskripsiBerita = widget.news!.deskripsiBerita;
      _tanggalBerita = widget.news!.tanggalBerita;
    } else {
      _judulBerita = '';
      _gambarBerita = '';
      _deskripsiBerita = '';
      _tanggalBerita = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.news == null ? 'Add News' : 'Edit News'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _judulBerita,
                decoration: const InputDecoration(labelText: 'Judul Berita'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please taruh title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _judulBerita = value!;
                },
              ),
              TextFormField(
                initialValue: _gambarBerita,
                decoration: const InputDecoration(labelText: 'Gambar Berita URL'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please taruh image URL';
                  }
                  return null;
                },
                onSaved: (value) {
                  _gambarBerita = value!;
                },
              ),
              TextFormField(
                initialValue: _deskripsiBerita,
                decoration: const InputDecoration(labelText: 'Deskripsi Berita'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please taruh description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _deskripsiBerita = value!;
                },
              ),
              TextFormField(
                initialValue: _tanggalBerita.toString().split(' ')[0],
                decoration: const InputDecoration(labelText: 'Tanggal Berita (YYYY-MM-DD)'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please input the date';
                  }
                  return null;
                },
                onSaved: (value) {
                  _tanggalBerita = DateTime.parse(value!);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveNews,
                child: Text(widget.news == null ? 'Add News' : 'Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNews() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      CollectionReference newsCollection =
          FirebaseFirestore.instance.collection('news');
      
      if (widget.news == null) {
        // Tambahan Data
        newsCollection.add({
          'judul_berita': _judulBerita,
          'gambar_berita': _gambarBerita,
          'deskripsi_berita': _deskripsiBerita,
          'tanggal_berita': _tanggalBerita,
        });
      } else {
        // Pengubahan Data
        newsCollection.doc(widget.news!.id).update({
          'judul_berita': _judulBerita,
          'gambar_berita': _gambarBerita,
          'deskripsi_berita': _deskripsiBerita,
          'tanggal_berita': _tanggalBerita,
        });
      }

      Navigator.pop(context);
    }
  }
}
