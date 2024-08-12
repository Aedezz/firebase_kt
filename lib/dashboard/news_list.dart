import 'package:firebase_kt/db/news_model.dart';
import 'package:firebase_kt/form/add_edit_news.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsListScreen extends StatelessWidget {
  final CollectionReference newsCollection =
      FirebaseFirestore.instance.collection('news');

  NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: newsCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              NewsDB news = NewsDB.fromDocument(doc);
              return ListTile(
                title: Text(news.judulBerita),
                subtitle: Text(
                  'Deskripsi Berita: ${news.deskripsiBerita}, Tanggal Berita: ${news.tanggalBerita}',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditNews(news: news),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, news.id);
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditNews(),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String docid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Penghapusan'),
          content: const Text('Yakin kamu hapus?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () {
                newsCollection.doc(docid).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
