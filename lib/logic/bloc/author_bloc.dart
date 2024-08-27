import 'package:auth_project/data/repository/author_repository.dart';
import 'package:auth_project/logic/bloc/author_event.dart';
import 'package:auth_project/logic/bloc/author_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthorBloc extends Bloc<AuthorEvent, AuthorState> {
  final AuthorRepository _authorRepository;

  AuthorBloc(this._authorRepository) : super(LogicInitializeState()) {
    on<AddAuthorEvent>((event, emit) async {
      emit(AddAuthorLoading(isLoading: true));
      await _authorRepository.authorProvider.addAuthorService(event.name).then((value) {
        emit(AddAuthorLoading(isLoading: false));
        /*Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(event.context);
        });*/
        Navigator.pop(event.context);
      }).onError((error, stackTrace) {
        emit(AddAuthorLoading(isLoading: false));
      });
    });

    on<ReadAuthorEvent>((event, emit) async {
      emit(LogicloadingState());
      await _authorRepository.authorProvider.readAuthorService().then((value) {
        emit(ReadAuthorState(authorModel: value));
      }).onError((error, stackTrace) {
        emit(LogicErrorState(error: error.toString()));
      });
    });

    on<UpdateAuthorEvent>((event, emit) async {
      emit(UpdateAuthorLoading(isLoading: true));
      //final Map<String, dynamic> data = {"id": event.id, "name": event.name};

      await _authorRepository.authorProvider.updateAuthorService(event.id, event.name).then((value) {
        emit(UpdateAuthorLoading(isLoading: false));
        //snackBar(event.context, "User has been updated");
        /*Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(event.context);
        });*/
        Navigator.pop(event.context);
      }).onError((error, stackTrace) {
        emit(UpdateAuthorLoading(isLoading: false));
      });
    });

    on<DeleteAuthorEvent>((event, emit) async {
      emit(DeleteAuthorLoading(isLoading: true));
      await _authorRepository.authorProvider.deleteAuthorService(event.id).then((value) {
        emit(DeleteAuthorLoading(isLoading: false));
      }).onError((error, stackTrace) {
        emit(DeleteAuthorLoading(isLoading: false));
      });
    });
  }
}
