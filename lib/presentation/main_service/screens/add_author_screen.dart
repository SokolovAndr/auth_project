import 'package:auth_project/logic/bloc/author_bloc.dart';
import 'package:auth_project/logic/bloc/author_event.dart';
import 'package:auth_project/logic/bloc/author_state.dart';
import 'package:auth_project/services/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAuthorScreen extends StatefulWidget {
  const AddAuthorScreen({super.key});

  @override
  State<AddAuthorScreen> createState() => _AddAuthorScreenState();
}

class _AddAuthorScreenState extends State<AddAuthorScreen> {
  final TextEditingController _authorNameCtrl = TextEditingController();

  @override
  void dispose() {
    _authorNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Добавить автора',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _buildBody,
    );
  }

  Widget get _buildBody {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _authorNameCtrl,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Имя"),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(onPressed: () {
          if (_authorNameCtrl.text.isEmpty) {
            SnackBarService.showSnackBar(
              context,
              'Введите имя!',
              true,
            );
          } else {
            context.read<AuthorBloc>().add(
                AddAuthorEvent(name: _authorNameCtrl.text, context: context));
          }
        }, child:
            BlocBuilder<AuthorBloc, AuthorState>(builder: (context, state) {
          if (state is AddAuthorLoading) {
            bool isLoading = state.isLoading;
            return isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text("Добавить автора");
          } else {
            return const Text("Добавить автора");
          }
        }))
      ],
    );
  }
}
