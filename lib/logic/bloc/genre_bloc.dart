import 'package:auth_project/data/repository/genre_repository.dart';
import 'package:auth_project/logic/bloc/genre_event.dart';
import 'package:auth_project/logic/bloc/genre_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  final GenreRepository _genreRepository;

  GenreBloc(this._genreRepository) : super(LogicInitializeState()) {
    on<AddGenreEvent>((event, emit) async {
      emit(AddGenreLoading(isLoading: true));
      await _genreRepository.genreProvider
          .addGenreService(event.name)
          .then((value) {
        emit(AddGenreLoading(isLoading: false));
        Navigator.pop(event.context);
      }).onError((error, stackTrace) {
        emit(AddGenreLoading(isLoading: false));
      });
    });

    on<ReadGenreEvent>((event, emit) async {
      emit(LogicloadingState());
      await _genreRepository.genreProvider.readGenreService().then((value) {
        emit(ReadGenreState(genreModel: value));
      }).onError((error, stackTrace) {
        emit(LogicErrorState(error: error.toString()));
      });
    });

    on<UpdateGenreEvent>((event, emit) async {
      emit(UpdateGenreLoading(isLoading: true));

      await _genreRepository.genreProvider
          .updateGenreService(event.id, event.name)
          .then((value) {
        emit(UpdateGenreLoading(isLoading: false));
        Navigator.pop(event.context);
      }).onError((error, stackTrace) {
        emit(UpdateGenreLoading(isLoading: false));
      });
    });

    on<DeleteGenreEvent>((event, emit) async {
      emit(DeleteGenreLoading(isLoading: true));
      await _genreRepository.genreProvider
          .deleteGenreService(event.id)
          .then((value) {
        emit(DeleteGenreLoading(isLoading: false));
      }).onError((error, stackTrace) {
        emit(DeleteGenreLoading(isLoading: false));
      });
    });
  }
}
