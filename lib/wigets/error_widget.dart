import 'package:flutter/cupertino.dart';

class ErrorWidget extends StatelessWidget {
  final String errorMsg;

  const ErrorWidget(this.errorMsg, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(errorMsg));
  }
}
