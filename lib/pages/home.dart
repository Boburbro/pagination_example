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
    context.read<UserCubit>().getItems();
    super.initState();

    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;

      if (maxScroll == scrollController.offset) {
        if (hasData) {
          context.read<UserCubit>().getMoreData();
        }
      }
    });
  }

  bool hasData = true;
  List users = [];
  bool isgetting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Title"),
        centerTitle: true,
      ),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            setState(() {
              users.addAll(state.users);
            });
            isgetting = false;
          }
          if (state is UserEmpty) {
            hasData = false;
            setState(() {});
          }

          if (state is UserLoading) {
            isgetting = true;
          }
        },
        child: ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: hasData ? users.length + 1 : users.length,
          itemBuilder: (context, index) {
            if (index == users.length) {
              return const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Bir daqiqa"),
                ],
              );
            }
            UserModel user = users[index];
            return Card(
              child: ListTile(
                title: Text("${index + 1} ${user.name}"),
              ),
            );
          },
        ),
      ),
    );
  }
}
