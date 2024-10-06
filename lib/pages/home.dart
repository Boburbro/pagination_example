import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/user/user_cubit.dart';
import '../data/model/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    var cubit = context.read<UserCubit>();
    cubit.loadData();
    super.initState();
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      if (maxScroll == scrollController.offset &&
          cubit.state.isAllPagesLoaded == false) {
        cubit.loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Title"),
        centerTitle: true,
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state.status == RequestStatus.failure) {
            ///Fail
          }
        },
        builder: (context, state) {
          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: state.users.length + 1,
            itemBuilder: (context, index) {
              if (index == state.users.length) {
                return Opacity(
                  opacity: state.isAllPagesLoaded ? 0 : 1,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text("Loading..."),
                    ],
                  ),
                );
              }
              UserModel user = state.users[index];
              return Card(
                child: ListTile(
                  title: Text("${index + 1} ${user.name}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
