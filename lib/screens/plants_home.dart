import 'package:flutter/material.dart';
import 'package:plants_collectors/services/session.services.dart';
import 'package:plants_collectors/utils/utils.dart';

final utils = Utils();
final sessionService = SessionServices();

class PlanstHome extends StatefulWidget {
  const PlanstHome({super.key});

  @override
  State<PlanstHome> createState() => _PlanstHomeState();
}

class _PlanstHomeState extends State<PlanstHome> {
  Future<void> _redirectToLogin() {
    return Navigator.pushNamed(context, '/login');
  }

  Future<void> _checkIfUserIsLoggedIn() async {
    // Verify the access token
    final response = await sessionService.verify();

    if (response['error'] != null && response['error'] == true) {
      _redirectToLogin();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Plants Home'),
      ),
    );
  }
}
