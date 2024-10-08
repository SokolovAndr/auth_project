import 'package:auth_project/data/model/author_model.dart';
import 'package:auth_project/data/model/genre_model.dart';
import 'package:auth_project/data/model/image_model.dart';
import 'package:auth_project/logic/bloc/book_bloc.dart';
import 'package:auth_project/logic/bloc/book_event.dart';
import 'package:auth_project/logic/bloc/book_state.dart';
import 'package:auth_project/presentation/main_service/screens/genres_choose_screen.dart';
import 'package:auth_project/presentation/main_service/screens/images_choose_screen.dart';
import 'package:auth_project/services/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authors_choose_screen.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController _bookTitleCtrl = TextEditingController();
  final TextEditingController _bookDescriptionCtrl = TextEditingController();
  final TextEditingController _bookAuthorCtrl = TextEditingController();
  final TextEditingController _bookGenreCtrl = TextEditingController();
  final TextEditingController _bookImageCtrl = TextEditingController();

  @override
  void dispose() {
    _bookTitleCtrl.dispose();
    _bookDescriptionCtrl.dispose();
    _bookAuthorCtrl.dispose();
    _bookGenreCtrl.dispose();
    _bookImageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Добавить книгу',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _buildBody,
    );
  }

  Widget get _buildBody {
    DataAuthor? author = DataAuthor(id: 0, name: "");
    DataGenre? genre = DataGenre(id: 0, name: "");
    DataImage? image = DataImage(id: 0, name: "", type: "");

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _bookTitleCtrl,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Название",
                labelText: "Название"),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _bookDescriptionCtrl,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Описание",
                labelText: "Описание"),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            readOnly: true,
            controller: _bookAuthorCtrl,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Автор",
                labelText: "Автор"),
            onTap: () async {
              author = await Navigator.push<DataAuthor>(context,
                  MaterialPageRoute(builder: (context) {
                return const AuthorsChooseScreen();
              }));
              _bookAuthorCtrl.text = author?.name ?? "";
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            readOnly: true,
            controller: _bookGenreCtrl,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Жанр",
                labelText: "Жанр"),
            onTap: () async {
              genre = await Navigator.push<DataGenre>(context,
                  MaterialPageRoute(builder: (context) {
                return const GenresChooseScreen();
              }));
              _bookGenreCtrl.text = genre?.name ?? "";
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            readOnly: true,
            controller: _bookImageCtrl,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Изображение",
                labelText: "Изображение"),
            onTap: () async {
              image = await Navigator.push<DataImage>(context,
                  MaterialPageRoute(builder: (context) {
                return const ImagesChooseScreen();
              }));
              _bookImageCtrl.text = image?.name ?? "";
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(onPressed: () {
          if (_bookTitleCtrl.text.isEmpty ||
              _bookDescriptionCtrl.text.isEmpty ||
              _bookAuthorCtrl.text.isEmpty ||
              _bookGenreCtrl.text.isEmpty ||
              _bookImageCtrl.text.isEmpty) {
            SnackBarService.showSnackBar(
              context,
              'Введите все данные!',
              true,
            );
          } else {
            context.read<BookBloc>().add(AddBookEvent(
                context: context,
                title: _bookTitleCtrl.text,
                description: _bookDescriptionCtrl.text,
                authorId: author!.id,
                genreId: genre!.id,
                imageId: image!.id,
                autorUi: author!,
                genreUi: genre!,
                imageUi: image!));
          }
        }, child: BlocBuilder<BookBloc, BookState>(builder: (context, state) {
          if (state is AddBookLoading) {
            bool isLoading = state.isLoading;
            return isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text("Добавить книгу");
          } else {
            return const Text("Добавить книгу");
          }
        }))
      ],
    );
  }
}
