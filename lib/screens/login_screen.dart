import 'package:flutter/material.dart';
import 'package:plants_collectors/components/custom_button.dart';
import 'package:plants_collectors/components/custom_form_input.dart';
import 'package:plants_collectors/schemas/schemas.dart';
import 'package:plants_collectors/services/session.services.dart';
import 'package:plants_collectors/services/sqlite.services.dart';
import 'package:plants_collectors/services/user.services.dart';
import 'package:plants_collectors/utils/utils.dart';

final sessionServices = SessionServices();
final userServices = UserServices();
final sqliteServices = SqliteServices();
final utils = Utils();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // -- Create a form key to identify and validate the form
  final _formKey = GlobalKey<FormState>();

  // -- State
  String _username = '';
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

  // -- Submit function
  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final response = await sessionServices.login(_username, _password);

      if (response["error"] == true || response["error"] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"] ??
                "An error occured, please try again later"),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login successfully"),
            backgroundColor: Colors.green,
          ),
        );

        // Save the tokens in the shared preferences
        if (response["accessToken"] != null) {
          await utils.saveToSharedPreferences(
              'accessToken', response["accessToken"], 'string');
        }

        if (response["refreshToken"] != null) {
          await utils.saveToSharedPreferences(
              'refreshToken', response["refreshToken"], 'string');
        }

        // Get the user favorites and save them in sqlite
        final favorites = await userServices.getFavorites();
        await sqliteServices.deleteAllFavorites(); // Remove previous favorites

        if (favorites["error"] != null && favorites["error"] == false) {
          for (var favorite in favorites["favorites"]) {
            sqliteServices.insertFavorite(Plant(
                plandId: favorite["plant_id"],
                plantName: favorite["plant_name"],
                averageRate: favorite["average_rate"],
                ownerUsername: favorite["owner_username"],
                imageEndpoint: favorite["image_endpoint"]));
          }

          Navigator.pushNamed(context, "/home");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "An error ocurred while getting your favorites, please try again later."),
              backgroundColor: Colors.red,
            ),
          );
        }
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
                          child: const Text("LOG INTO YOUR ACCOUNT",
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
                                  label: 'Login',
                                  onPressedCallback: _onSubmit,
                                  buttonType: "primary"),
                              // Redirect to login button
                              CustomButton(
                                  label: 'Signup',
                                  onPressedCallback: () {
                                    Navigator.pushNamed(context, '/signup');
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
