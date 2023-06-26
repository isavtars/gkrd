import 'package:flutter/material.dart';

import '../../styles/color.dart';
import '../widgets/drawer.dart';

//homepage/dashboard
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kKarobarcolor,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: kKarobarcolor,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kKarobarcolor,
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Modal BottomSheet'),
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        return Container(
            color: Colors.white,
            width: constraints.maxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: kKarobarcolor,
                  child: const Text("Reminder"),
                )
              ],
            ));
      })),
    );
  }
}
