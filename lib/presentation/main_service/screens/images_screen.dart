import 'package:auth_project/data/model/image_model.dart';
import 'package:auth_project/logic/bloc/image_bloc.dart';
import 'package:auth_project/logic/bloc/image_state.dart';
import 'package:auth_project/presentation/screens/add_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/image_event.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  @override
  void initState() {
    context.read<ImageBloc>().add(ReadImageEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Изображения"),
      ),
      body: _buildBody,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddImageScreen()));
            Future.delayed(const Duration(milliseconds: 5), () {
              context.read<ImageBloc>().add(ReadImageEvent());
            });
          },
          child: const Icon(Icons.add)),
    );
  }

  Widget get _buildBody {
    return BlocBuilder<ImageBloc, ImageState>(builder: (context, state) {
      if (state is LogicInitializeState || state is LogicloadingState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is LogicErrorState) {
        String err = state.error;
        return Center(
          child: Text(err),
        );
      } else if (state is ReadImageState) {
        List<DataImage> imageList = state.imageModel.dataImage;
        var data = state.imageModel;
        return imageList.isNotEmpty
            ? _buildListView(data)
            : const Center(child: Text("Список пуст"));
      } else {
        return Container();
      }
    });
  }

  Widget _buildListView(ImageModel imageModel) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ImageBloc>().add(ReadImageEvent());
      },
      child: ListView.builder(
          itemCount: imageModel.dataImage.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text(imageModel.dataImage[index].id.toString()),
              title: Text(imageModel.dataImage[index].name),
              subtitle: Text(imageModel.dataImage[index].type),
              trailing: IconButton(
                onPressed: () async {
                  context.read<ImageBloc>().add(DeleteImageEvent(
                      id: imageModel.dataImage[index].id.toString()));
                  context.read<ImageBloc>().add(ReadImageEvent());
                },
                icon: const Icon(Icons.delete_outline),
              ),
            );
          }),
    );
  }
}
