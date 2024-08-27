
import 'package:auth_project/data/model/book_model.dart';
import 'package:auth_project/data/provider/book_provider.dart';

abstract class IBookRepository {
  Future<BookModel> getBooks();
}

class BookRepository implements IBookRepository {
  final BookProvider bookProvider;
  BookRepository(this.bookProvider);

  @override
  Future<BookModel> getBooks() {
    return bookProvider.readBookService();
  }
}
