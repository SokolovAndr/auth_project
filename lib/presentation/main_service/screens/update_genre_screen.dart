import 'package:auth_project/logic/bloc/genre_bloc.dart';
import 'package:auth_project/logic/bloc/genre_event.dart';
import 'package:auth_project/logic/bloc/genre_state.dart';
import 'package:auth_project/services/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateGenreScreen extends StatefulWidget {
  final int id;
  final String name;

  const UpdateGenreScreen({super.key, required this.id, required this.name});

  @override
  State<UpdateGenreScreen> createState() => _UpdateGenreScreenState();
}

class _UpdateGenreScreenState extends State<UpdateGenreScreen> {
  late final TextEditingController _genreNameCtrl;

  @override
  void initState() {
    _genreNameCtrl = TextEditingController(text: widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text("Обновить жанр", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: _genreNameCtrl,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Название жанра"),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () async {
              if (_genreNameCtrl.text.isEmpty) {
                SnackBarService.showSnackBar(
                  context,
                  'Введите все данные!',
                  true,
                );
              } else {
                context.read<GenreBloc>().add(UpdateGenreEvent(context,
                    id: widget.id.toString(), name: _genreNameCtrl.text));
                context.read<GenreBloc>().add(ReadGenreEvent());
              }
            },
            child: BlocBuilder<GenreBloc, GenreState>(
              builder: (context, state) {
                if (state is UpdateGenreLoading) {
                  bool isLoading = state.isLoading;
                  return isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Обновить жанр");
                } else {
                  return const Text("Обновить жанр");
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
