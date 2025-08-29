import 'package:barbqtonight/core/common_widgets/loading_progress.dart';
import 'package:barbqtonight/core/common_widgets/snack_bar.dart';
import 'package:barbqtonight/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:barbqtonight/core/extensions/text_style_extension.dart';
import 'package:barbqtonight/core/extensions/theme_extension.dart';
import 'package:barbqtonight/core/route_structure/go_navigator.dart';
import 'package:barbqtonight/core/route_structure/go_router.dart';
import 'package:barbqtonight/core/theme/colors.dart';
import 'package:barbqtonight/core/extensions/spacing_extension.dart';
import 'package:barbqtonight/core/common_widgets/custom_button.dart';
import 'package:barbqtonight/core/common_widgets/custom_icon_button.dart';
import 'package:barbqtonight/core/common_widgets/custom_text_field.dart';
import 'package:barbqtonight/core/utils/constants.dart';
import 'package:barbqtonight/core/utils/fields_validation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _visiblePass = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildPageBody());
  }

  Widget _buildPageBody() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showSnackBar(context, state.message);
        } else if (state is AuthSuccess) {
          Go.namedReplace(context, RouteName.homePage);
        }
      },

      builder: (context, state) {
        if (state is AuthLoading) {
          return LoadingProgress();
        }
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Image.asset(Constants.appLogo, height: 200)),
                20.kH,
                Text("Sign In", style: context.textTheme.titleMedium?.bold),
                Text(
                  "Please enter your details to sign in",
                  style: context.textTheme.bodySmall?.themeGreyTextColor.w500,
                ),
                20.kH,
                CustomTextField(
                  controller: _emailController,
                  validator: validateEmail,
                  hintText: "Email",
                  filled: true,
                  fillColor: context.colorScheme.surface,
                  prefix: const Icon(Icons.email),
                ),
                20.kH,
                CustomTextField(
                  controller: _passwordController,
                  validator: validatePassword,
                  hintText: "Password",
                  filled: true,
                  fillColor: context.colorScheme.surface,
                  prefix: const Icon(Icons.password),
                  obscureText: _visiblePass,
                  suffix: CustomIconButton(
                    onTap: () {
                      setState(() {
                        _visiblePass = !_visiblePass;
                      });
                    },
                    child: Icon(
                      _visiblePass == false
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Palette.themecolor,
                    ),
                  ),
                ),
                40.kH,
                CustomButton(
                  height: 55,
                  buttoncolor: Palette.themecolor,
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                        AuthLogin(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Login",
                    style: context.textTheme.bodyMedium?.themeWhiteColor.bold,
                  ),
                ),
                20.kH,
                Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      text: "Haven't registered yet? ",
                      style: context.textTheme.bodySmall?.themeGreyTextColor,
                      children: [
                        TextSpan(
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap =
                                    () => Go.onNamedReplace(
                                      context,
                                      RouteName.signupPage,
                                    ),
                          text: "Register",
                          style: context.textTheme.bodySmall?.themeColor.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
