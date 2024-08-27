import 'package:auth_project/presentation/screens/genres_screen.dart';
import 'package:auth_project/presentation/screens/images_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubit/navigation_cubit.dart';
import '../screens/books_screen.dart';

import '../screens/authors_screen.dart';

class NavigationMenuWidget extends StatelessWidget {
  const NavigationMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 25,
                offset: const Offset(8, 20))
          ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.redAccent,
              unselectedItemColor: Colors.black,
              showUnselectedLabels: true,
              currentIndex: state.index,
              onTap: (index) {
                if (index == 0) {
                  context.read<NavigationCubit>().goToBooksScreen();
                } else if (index == 1) {
                  context.read<NavigationCubit>().goToAuthorsScreen();
                } else if (index == 2) {
                  context.read<NavigationCubit>().goToGenresScreen();
                } else if (index == 3) {
                  context.read<NavigationCubit>().goToImagesScreen();
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Книги',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Авторы',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: 'Жанры',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.image),
                  label: 'Изображения',
                ),
              ],
            ),
          ),
        );
      }),
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (_, state) {
          if (state is StateA) {
            return const BooksScreen();
          } else if (state is StateC) {
            return const AuthorsScreen();
          } else if (state is StateD) {
            return const GenresScreen();
          } else if (state is StateE) {
            return const ImagesScreen();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
