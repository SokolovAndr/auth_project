import 'package:auth_project/data/model/author_model.dart';
import 'package:auth_project/logic/bloc/author_bloc.dart';
import 'package:auth_project/logic/bloc/author_event.dart';
import 'package:auth_project/logic/bloc/author_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_author_screen.dart';
import 'update_author_screen.dart';

class AuthorsScreen extends StatefulWidget {
  const AuthorsScreen({super.key});

  @override
  State<AuthorsScreen> createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
  @override
  void initState() {
    context.read<AuthorBloc>().add(ReadAuthorEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Авторы"),
      ),
      body: _buildBody,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddAuthorScreen()));
            Future.delayed(const Duration(milliseconds: 5), () {
              context.read<AuthorBloc>().add(ReadAuthorEvent());
            });
          },
          child: const Icon(Icons.add)),
    );
  }

  Widget get _buildBody {
    return BlocBuilder<AuthorBloc, AuthorState>(builder: (context, state) {
      if (state is LogicInitializeState || state is LogicloadingState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is LogicErrorState) {
        String err = state.error;
        return Center(
          child: Text(err),
        );
      } else if (state is ReadAuthorState) {
        List<DataAuthor> authorList = state.authorModel.dataAuthor;
        var data = state.authorModel;
        return authorList.isNotEmpty
            ? _buildListView(data)
            : const Center(child: Text("Список пуст"));
      } else {
        return Container();
      }
    });
  }

  Widget _buildListView(AuthorModel authorModel) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AuthorBloc>().add(ReadAuthorEvent());
      },
      child: ListView.builder(
          itemCount: authorModel.dataAuthor.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return UpdateAuthorScreen(
                      id: authorModel.dataAuthor[index].id,
                      name: authorModel.dataAuthor[index].name);
                }));
              },
              child: ListTile(
                leading: Text(authorModel.dataAuthor[index].id.toString()),
                title: Text(authorModel.dataAuthor[index].name),
                trailing: IconButton(
                  onPressed: () async {
                    context.read<AuthorBloc>().add(DeleteAuthorEvent(
                        id: authorModel.dataAuthor[index].id.toString()));
                    context.read<AuthorBloc>().add(ReadAuthorEvent());
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
            );
          }),
    );
  }
}
