import 'package:app_example/navigation/route_generator.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Home View")),
        body: Center(
            child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                onPressed: () async => await Navigator.pushNamed(
                    context, RouteGenerator.routeTask),
                child: const Text("Go to Task View")),
            Container(height: 10),
            ElevatedButton(
                onPressed: () async => await Navigator.pushNamed(
                    context, RouteGenerator.routeTaskEdit),
                child: const Text("Go to Task Edit View")),
            Container(height: 10),
            ElevatedButton(
                onPressed: () async => await Navigator.pushNamed(
                    context, RouteGenerator.routeError),
                child: const Text("Go to Error View")),
          ]),
        )));
  }
}
