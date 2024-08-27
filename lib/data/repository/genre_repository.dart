import 'package:auth_project/data/model/genre_model.dart';
import 'package:auth_project/data/provider/genre_provider.dart';

abstract class IGenreRepository {
  Future<GenreModel> getGenres();
}

class GenreRepository implements IGenreRepository {
  final GenreProvider genreProvider;
  GenreRepository(this.genreProvider);

  @override
  Future<GenreModel> getGenres() {
    return genreProvider.readGenreService();
  }
}
