import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';
import 'book_detail_screen.dart';

class BookListScreen extends StatefulWidget {
  static const routeName = '/book-list';

  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  void _showEditBookDialog(Book book) {
    showDialog(
      context: context,
      builder: (ctx) => AddBookDialog(book: book),
    );
  }

  void _confirmDelete(Book book) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Buku'),
        content:
            Text('Apakah Anda yakin ingin menghapus buku "${book.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop(); // Close dialog first
              try {
                await bookProvider.deleteBook(book.id);
                if (!mounted) return;
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Buku berhasil dihapus'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (error) {
                if (!mounted) return;
                final errorMessage =
                    error.toString().replaceAll('Exception: ', '');
                _showErrorDialog(errorMessage);
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String errorMessage) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (errorContext) => AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(errorContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary,
                colorScheme.primaryContainer.withValues(
                  alpha: (255 * 0.95).toDouble(),
                  red: colorScheme.primaryContainer.r,
                  green: colorScheme.primaryContainer.g,
                  blue: colorScheme.primaryContainer.b,
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showAddBookDialog(context),
          ),
        ],
      ),
      body: Consumer<BookProvider>(
        builder: (ctx, bookProvider, _) {
          final books = bookProvider.books;
          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books,
                    size: 80,
                    color: colorScheme.primary.withValues(
                      alpha: (255 * 0.1).toDouble(),
                      red: colorScheme.primary.r,
                      green: colorScheme.primary.g,
                      blue: colorScheme.primary.b,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Belum ada buku tersedia',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface.withValues(
                        alpha: (255 * 0.7).toDouble(),
                        red: colorScheme.onSurface.r,
                        green: colorScheme.onSurface.g,
                        blue: colorScheme.onSurface.b,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddBookDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Buku'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: (255 * 0.1).toDouble(),
                        red: Colors.black.r,
                        green: Colors.black.g,
                        blue: Colors.black.b,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                      child: Text(
                        'Informasi Koleksi',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoCard(
                          context,
                          'Total Buku',
                          books.length.toString(),
                          Icons.book,
                          colorScheme.primary,
                        ),
                        _buildInfoCard(
                          context,
                          'Tersedia',
                          books.where((b) => b.isAvailable).length.toString(),
                          Icons.check_circle,
                          Colors.green,
                        ),
                        _buildInfoCard(
                          context,
                          'Dipinjam',
                          books.where((b) => !b.isAvailable).length.toString(),
                          Icons.remove_circle,
                          Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: books.length,
                  itemBuilder: (ctx, i) => _buildBookCard(books[i], context),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBookDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Buku'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shadowColor: color.withValues(
        alpha: (255 * 0.3).toDouble(),
        red: color.r,
        green: color.g,
        blue: color.b,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(
                alpha: (255 * 0.1).toDouble(),
                red: color.r,
                green: color.g,
                blue: color.b,
              ),
              color.withValues(
                alpha: (255 * 0.05).toDouble(),
                red: color.r,
                green: color.g,
                blue: color.b,
              ),
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: (255 * 0.7).toDouble(),
                  red: theme.colorScheme.onSurface.r,
                  green: theme.colorScheme.onSurface.g,
                  blue: theme.colorScheme.onSurface.b,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(Book book, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          BookDetailScreen.routeName,
          arguments: book.id,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                colorScheme.surface.withValues(
                  alpha: (255 * 0.95).toDouble(),
                  red: colorScheme.surface.r,
                  green: colorScheme.surface.g,
                  blue: colorScheme.surface.b,
                ),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary.withValues(
                            alpha: (255 * 0.1).toDouble(),
                            red: colorScheme.primary.r,
                            green: colorScheme.primary.g,
                            blue: colorScheme.primary.b,
                          ),
                          colorScheme.primary.withValues(
                            alpha: (255 * 0.05).toDouble(),
                            red: colorScheme.primary.r,
                            green: colorScheme.primary.g,
                            blue: colorScheme.primary.b,
                          ),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: (255 * 0.1).toDouble(),
                            red: Colors.black.r,
                            green: Colors.black.g,
                            blue: Colors.black.b,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.book,
                        size: 56,
                        color: colorScheme.primary.withValues(
                          alpha: (255 * 0.5).toDouble(),
                          red: colorScheme.primary.r,
                          green: colorScheme.primary.g,
                          blue: colorScheme.primary.b,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          book.author,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(
                              alpha: (255 * 0.7).toDouble(),
                              red: colorScheme.onSurface.r,
                              green: colorScheme.onSurface.g,
                              blue: colorScheme.onSurface.b,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildInfoChip(
                              Icons.calendar_today,
                              book.publicationYear.toString(),
                              colorScheme.primary,
                            ),
                            _buildInfoChip(
                              Icons.category,
                              book.category,
                              colorScheme.secondary,
                            ),
                            _buildInfoChip(
                              Icons.inventory,
                              'Stok: ${book.stock}',
                              colorScheme.tertiary,
                            ),
                            _buildInfoChip(
                              book.isAvailable
                                  ? Icons.check_circle
                                  : Icons.remove_circle,
                              book.isAvailable ? 'Tersedia' : 'Tidak Tersedia',
                              book.isAvailable
                                  ? colorScheme.tertiary
                                  : colorScheme.error,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.edit, color: colorScheme.primary),
                    label: Text(
                      'Edit',
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    onPressed: () => _showEditBookDialog(book),
                  ),
                  const SizedBox(width: 16),
                  TextButton.icon(
                    icon: Icon(Icons.delete, color: colorScheme.error),
                    label: Text(
                      'Hapus',
                      style: TextStyle(color: colorScheme.error),
                    ),
                    onPressed: () => _confirmDelete(book),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: (255 * 0.1).toDouble(),
          red: color.r,
          green: color.g,
          blue: color.b,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(
            alpha: (255 * 0.2).toDouble(),
            red: color.r,
            green: color.g,
            blue: color.b,
          ),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBookDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const AddBookDialog(),
    );
  }
}

class AddBookDialog extends StatefulWidget {
  final Book? book;

  const AddBookDialog({super.key, this.book});

  @override
  State<AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<AddBookDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _author;
  late String _isbn;
  late String _publisher;
  late int _publicationYear;
  late int _stock;
  late String _category;
  late String _description;

  final List<String> _categories = [
    'Fiksi',
    'Non-Fiksi',
    'Pendidikan',
    'Sejarah',
    'Sains',
    'Teknologi',
    'Sastra',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _title = widget.book?.title ?? '';
    _author = widget.book?.author ?? '';
    _isbn = widget.book?.isbn ?? '';
    _publisher = widget.book?.publisher ?? '';
    _publicationYear = widget.book?.publicationYear ?? DateTime.now().year;
    _stock = widget.book?.stock ?? 1;
    _category = widget.book?.category ?? _categories.first;
    _description = widget.book?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.book == null ? 'Tambah Buku' : 'Edit Buku'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Judul harus diisi' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _author,
                decoration: const InputDecoration(labelText: 'Penulis'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Penulis harus diisi' : null,
                onSaved: (value) => _author = value!,
              ),
              TextFormField(
                initialValue: _isbn,
                decoration: const InputDecoration(labelText: 'ISBN'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'ISBN harus diisi' : null,
                onSaved: (value) => _isbn = value!,
              ),
              TextFormField(
                initialValue: _publisher,
                decoration: const InputDecoration(labelText: 'Penerbit'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Penerbit harus diisi' : null,
                onSaved: (value) => _publisher = value!,
              ),
              TextFormField(
                initialValue: _publicationYear.toString(),
                decoration: const InputDecoration(labelText: 'Tahun Terbit'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Tahun terbit harus diisi';
                  final year = int.tryParse(value!);
                  if (year == null) return 'Tahun harus berupa angka';
                  if (year < 1900 || year > DateTime.now().year) {
                    return 'Tahun tidak valid';
                  }
                  return null;
                },
                onSaved: (value) => _publicationYear = int.parse(value!),
              ),
              TextFormField(
                initialValue: _stock.toString(),
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Stok harus diisi';
                  final stock = int.tryParse(value!);
                  if (stock == null) return 'Stok harus berupa angka';
                  if (stock < 0) return 'Stok tidak boleh negatif';
                  return null;
                },
                onSaved: (value) => _stock = int.parse(value!),
              ),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Kategori'),
                onChanged: (value) => setState(() => _category = value!),
                validator: (value) =>
                    value == null ? 'Kategori harus dipilih' : null,
                items: _categories
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Deskripsi harus diisi' : null,
                onSaved: (value) => _description = value!,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: _saveBook,
          child: Text(widget.book == null ? 'Tambah' : 'Simpan'),
        ),
      ],
    );
  }

  void _saveBook() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    _formKey.currentState?.save();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    try {
      final book = Book(
        id: widget.book?.id ?? DateTime.now().toString(),
        title: _title,
        author: _author,
        isbn: _isbn,
        publisher: _publisher,
        publicationYear: _publicationYear,
        stock: _stock,
        isAvailable: widget.book?.isAvailable ?? true,
        category: _category,
        description: _description,
      );

      if (widget.book == null) {
        await bookProvider.addBook(book);
      } else {
        await bookProvider.updateBook(book);
      }

      if (!mounted) return;
      navigator.pop();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.book == null
                ? 'Buku berhasil ditambahkan'
                : 'Buku berhasil diperbarui',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      final errorMessage = error.toString().replaceAll('Exception: ', '');
      _showErrorDialog(errorMessage);
    }
  }

  void _showErrorDialog(String errorMessage) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (errorContext) => AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(errorContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
