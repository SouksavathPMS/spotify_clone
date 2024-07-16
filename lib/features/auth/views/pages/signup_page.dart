import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify_clone/core/theme/app_pallete.dart';
import 'package:spotify_clone/core/widgets/custom_field.dart';
import 'package:spotify_clone/core/widgets/loading_widget.dart';
import 'package:spotify_clone/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:spotify_clone/features/auth/views/pages/signin_page.dart';
import 'package:spotify_clone/features/auth/views/widgets/auth_gradient_button.dart';

import '../../../../core/utils.dart';

class SignupPage extends ConsumerStatefulWidget {
  static const routeName = "signup";
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final appBarHeight = AppBar().preferredSize.height;
    final isLoading = ref.watch(
        authViewModelProvider.select((value) => value?.isLoading == true));

    ref.listen(
      authViewModelProvider,
      (_, next) {
        next?.when(
            data: (data) {
              showSnackbar(context, content: "User created, Please sigin!");
              context.goNamed(SigninPage.routeName);
            },
            error: (error, stackTrace) {
              showSnackbar(context, content: error.toString());
            },
            loading: () {});
      },
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                                textInputType: TextInputType.emailAddress,
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
                        isLoading
                            ? const LoadingWidget()
                            : AuthGradientButton(
                                title: "Sign up",
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    final name = _formKey
                                        .currentState?.fields["name"]?.value;
                                    final email = _formKey
                                        .currentState?.fields["email"]?.value;
                                    final password = _formKey.currentState
                                        ?.fields["password"]?.value;
                                    ref
                                        .read(authViewModelProvider.notifier)
                                        .signUp(
                                          name: name,
                                          email: email,
                                          password: password,
                                        );
                                  } else {
                                    showSnackbar(context,
                                        content: "Missing field!");
                                  }
                                },
                              ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: isLoading
                              ? null
                              : () => context.goNamed(SigninPage.routeName),
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
      ),
    );
  }
}
