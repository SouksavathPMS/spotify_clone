import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/core/theme/app_pallete.dart';
import 'package:spotify_clone/features/auth/views/pages/signin_page.dart';
import 'package:spotify_clone/features/auth/views/widgets/auth_gradient_button.dart';
import 'package:spotify_clone/features/auth/views/widgets/custom_field.dart';

class SignupPage extends StatefulWidget {
  static const routeName = "signup";
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // FIXME Move this to the Notifier then we can use this as Stateless widget
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final appBarHeight = AppBar().preferredSize.height;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: appBarHeight),
                      const Text(
                        "Sign up.",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomField(
                              name: "name",
                              hintText: "Name",
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(3),
                              ]),
                            ),
                            const SizedBox(height: 15),
                            CustomField(
                              name: "email",
                              hintText: "Email",
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ]),
                            ),
                            const SizedBox(height: 15),
                            CustomField(
                              name: "password",
                              hintText: "Password",
                              isObscureText: true,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(8),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const AuthGradientButton(title: "Sign up"),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => context.goNamed(SigninPage.routeName),
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account?",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: const [
                              TextSpan(
                                text: " Sign in",
                                style: TextStyle(
                                  color: Pallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
