import 'package:auth_project/data/model/author_model.dart';
import 'package:auth_project/data/provider/author_provider.dart';

abstract class IAuthorRepository {
  Future<AuthorModel> getAuthors();
}

class AuthorRepository implements IAuthorRepository {
  final AuthorProvider authorProvider;
  AuthorRepository(this.authorProvider);

  @override
  Future<AuthorModel> getAuthors() {
    return authorProvider.readAuthorService();
  }
}
