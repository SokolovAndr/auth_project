import 'package:auth_project/data/model/book_model.dart';

class BookDataModel {
  final Set<String> categories;
  final List<DataBook> books;
  BookDataModel({
    required this.categories,
    required this.books,
  });
}
