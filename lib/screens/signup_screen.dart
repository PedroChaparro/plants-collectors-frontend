import 'package:flutter/material.dart';
import 'package:plants_collectors/components/custom_button.dart';
import 'package:plants_collectors/components/custom_form_input.dart';
import 'package:plants_collectors/services/user.services.dart';

final userService = UserServices();

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Create a form key to identify and validate the form
  final _formKey = GlobalKey<FormState>();

  // States
  String _username = '';
  String _email = '';
  String _password = '';

  // -- Validator functions
  String? _usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }

    if (value.length < 4 || value.length > 16) {
      return 'Username must be between 4 and 16 characters';
    }

    setState(() {
      _username = value;
    });

    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }

    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return 'Please enter a valid email';
    }

    setState(() {
      _email = value;
    });

    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    setState(() {
      _password = value;
    });

    return null;
  }

  // -- Fidget functions
  void _onSubmit() async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Call the user service to create the user
      final response = await userService.signup(_username, _email, _password);

      if (response["error"] == true || response["error"] == null) {
        // If there was an error, show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response["message"] ??
              "An error occured, please try again later"),
          backgroundColor: Colors.red,
        ));
      } else {
        // If the user was created, show a snackbar and redirect to the login page
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response["message"]),
          backgroundColor: Colors.green,
        ));

        Navigator.pushNamed(context, '/login');
      }
    }
  }

  // -- Ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            // Expanded needs a parent with a height (Eg. Column)
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // Expand to full width
      children: [
        // Screen backgound
        Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xff01d25a),
              // Inner spacing
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // Page content (centered)
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Centrer vertically
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 32.0),
                          child: const Text("CREATE AN ACCOUNT",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.white)),
                        ),
                        CustomFormInput(
                          label: "Username",
                          obscureText: false,
                          validator: _usernameValidator,
                        ),
                        CustomFormInput(
                          label: "Email",
                          obscureText: false,
                          validator: _emailValidator,
                        ),
                        CustomFormInput(
                          label: "Password",
                          obscureText: true,
                          validator: _passwordValidator,
                        ),
                        Row(
                            // Center horizontally
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Signup button
                              CustomButton(
                                  label: 'Signup',
                                  onPressedCallback: _onSubmit,
                                  buttonType: "primary"),
                              // Redirect to login button
                              CustomButton(
                                  label: 'Login',
                                  onPressedCallback: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  buttonType: "primaryOutline")
                            ]),
                      ],
                    )),
              ),
            ))
      ],
    )));
  }
}
