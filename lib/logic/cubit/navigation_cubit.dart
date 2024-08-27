import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_state.dart';
export 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(StateA());

  void goToBooksScreen() => emit(StateA());
  void goToAuthorsScreen() => emit(StateB());
  void goToGenresScreen() => emit(StateC());
  void goToImagesScreen() => emit(StateD());
}
