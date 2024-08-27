import 'package:auth_project/data/repository/image_repository.dart';
import 'package:auth_project/logic/bloc/image_event.dart';
import 'package:auth_project/logic/bloc/image_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository _imageRepository;

  ImageBloc(this._imageRepository) : super(LogicInitializeState()) {
    on<AddImageEvent>((event, emit) async {
      emit(AddImageLoading(isLoading: true));
      await _imageRepository.imageProvider
          .addImageService(event.name, event.type)
          .then((value) {
        emit(AddImageLoading(isLoading: false));
        Navigator.pop(event.context);
      }).onError((error, stackTrace) {
        emit(AddImageLoading(isLoading: false));
      });
    });

    on<ReadImageEvent>((event, emit) async {
      emit(LogicloadingState());
      await _imageRepository.imageProvider.readImageService().then((value) {
        emit(ReadImageState(imageModel: value));
      }).onError((error, stackTrace) {
        emit(LogicErrorState(error: error.toString()));
      });
    });

    on<UpdateImageEvent>((event, emit) async {
      emit(UpdateImageLoading(isLoading: true));
      await _imageRepository.imageProvider
          .updateImageService(event.id, event.name, event.type)
          .then((value) {
        emit(UpdateImageLoading(isLoading: false));
        Navigator.pop(event.context);
      }).onError((error, stackTrace) {
        emit(UpdateImageLoading(isLoading: false));
      });
    });

    on<DeleteImageEvent>((event, emit) async {
      emit(DeleteImageLoading(isLoading: true));
      await _imageRepository.imageProvider
          .deleteImageService(event.id)
          .then((value) {
        emit(DeleteImageLoading(isLoading: false));
      }).onError((error, stackTrace) {
        emit(DeleteImageLoading(isLoading: false));
      });
    });
  }
}
