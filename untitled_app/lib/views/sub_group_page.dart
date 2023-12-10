import 'package:flutter/material.dart';
import '../models/group_handler.dart';

class SubGroupPage extends StatelessWidget {
   final Group? group;
   final String id;
  const SubGroupPage({super.key, 
   required this.group, 
   required this.id
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _Header(),);
  }
}

class _Header extends StatelessWidget {
  const _Header({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
