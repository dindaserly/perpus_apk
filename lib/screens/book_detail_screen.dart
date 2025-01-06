import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';
import 'book_list_screen.dart';

class BookDetailScreen extends StatelessWidget {
  static const routeName = '/book-detail';
  final String bookId;

  const BookDetailScreen({
    super.key,
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final book = bookProvider.findById(bookId);

    if (book == null) {
      return const Scaffold(
        body: Center(
          child: Text('Buku tidak ditemukan'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AddBookDialog(book: book),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, book),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Penulis: ${book.author}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Text('ISBN: ${book.isbn}'),
                    Text('Penerbit: ${book.publisher}'),
                    Text('Tahun Terbit: ${book.publicationYear}'),
                    Text('Kategori: ${book.category}'),
                    const SizedBox(height: 16),
                    const Text(
                      'Deskripsi:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(book.description),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status Buku',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: Icon(
                        book.isAvailable ? Icons.check_circle : Icons.cancel,
                        color: book.isAvailable ? Colors.green : Colors.red,
                      ),
                      title: Text(
                        book.isAvailable ? 'Tersedia' : 'Tidak Tersedia',
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.library_books),
                      title: Text('Stok: ${book.stock}'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Buku'),
        content:
            Text('Apakah Anda yakin ingin menghapus buku "${book.title}"?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Hapus'),
            onPressed: () {
              Provider.of<BookProvider>(context, listen: false)
                  .deleteBook(book.id);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
