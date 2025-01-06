class Book {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final String publisher;
  final int publicationYear;
  final int stock;
  bool isAvailable;
  final String category;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.publisher,
    required this.publicationYear,
    required this.stock,
    this.isAvailable = true,
    required this.category,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'publisher': publisher,
      'publicationYear': publicationYear,
      'stock': stock,
      'isAvailable': isAvailable,
      'category': category,
      'description': description,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      isbn: json['isbn'],
      publisher: json['publisher'],
      publicationYear: json['publicationYear'],
      stock: json['stock'],
      isAvailable: json['isAvailable'],
      category: json['category'],
      description: json['description'],
    );
  }
}
