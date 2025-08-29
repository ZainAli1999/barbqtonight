import 'package:barbqtonight/core/common_widgets/loading_progress.dart';
import 'package:barbqtonight/core/common_widgets/snack_bar.dart';
import 'package:barbqtonight/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:barbqtonight/core/common_widgets/country/country_model.dart';
import 'package:barbqtonight/core/common_widgets/country/show_custom_country_picker.dart';
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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _visiblePass = true;
  bool _confirmVisiblePass = true;

  CountryModel selectedCountry = CountryModel(
    name: 'Pakistan',
    code: '+92',
    flag: '🇵🇰',
  );
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
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

          return CustomScrollView(
            slivers: [
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  final scrolled = constraints.scrollOffset > 80;
                  return SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    centerTitle: true,
                    title: Text(scrolled ? "Hi there Register Yourself" : ""),
                    leading: CustomIconButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi there! \nRegister Yourself",
                          style: context.textTheme.headlineSmall?.bold,
                        ),
                        20.kH,
                        Center(
                          child: Image.asset(Constants.appLogo, height: 200),
                        ),
                        20.kH,
                        CustomTextField(
                          controller: _firstNameController,
                          validator: validateName,
                          hintText: "First Name",
                          filled: true,
                          fillColor: context.colorScheme.surface,
                          prefix: const Icon(Icons.person),
                        ),
                        20.kH,
                        CustomTextField(
                          controller: _lastNameController,
                          validator: validateName,
                          hintText: "Last Name",
                          filled: true,
                          fillColor: context.colorScheme.surface,
                          prefix: const Icon(Icons.person),
                        ),
                        20.kH,
                        CustomTextField(
                          controller: _phoneNumberController,
                          validator: validatePhone,
                          prefix: GestureDetector(
                            onTap: () {
                              showCustomCountryPicker(context, (
                                CountryModel country,
                              ) {
                                setState(() {
                                  selectedCountry = country;
                                });
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                selectedCountry.code,
                                style: context.textTheme.bodySmall?.bold,
                              ),
                            ),
                          ),
                          textInputType: TextInputType.phone,
                          hintText: "Phone Number",
                          filled: true,
                          fillColor: context.colorScheme.surface,
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 0,
                            minHeight: 0,
                          ),
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
                        20.kH,
                        CustomTextField(
                          controller: _confirmPasswordController,
                          validator: validatePassword,
                          hintText: "Confirm Password",
                          filled: true,
                          fillColor: context.colorScheme.surface,
                          prefix: const Icon(Icons.password),
                          obscureText: _confirmVisiblePass,
                          suffix: CustomIconButton(
                            onTap: () {
                              setState(() {
                                _confirmVisiblePass = !_confirmVisiblePass;
                              });
                            },
                            child: Icon(
                              _confirmVisiblePass == false
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
                            String phoneNumber =
                                _phoneNumberController.text.trim();
                            if (_formKey.currentState!.validate() &&
                                _passwordController.text ==
                                    _confirmPasswordController.text) {
                              context.read<AuthBloc>().add(
                                AuthSignUp(
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  phoneNumber: phoneNumber,
                                  address: _addressController.text,
                                  profileImage: "",
                                  status: 0,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                              );
                            } else if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              showSnackBar(context, 'Password does not match');
                            }
                          },
                          child: Text(
                            "Register",
                            style:
                                context
                                    .textTheme
                                    .bodyMedium
                                    ?.themeWhiteColor
                                    .bold,
                          ),
                        ),
                        20.kH,
                        Text(
                          "By clicking register you are clicking to the terms and conditions, privacy policy",
                          textAlign: TextAlign.center,
                          style:
                              context.textTheme.bodySmall?.themeGreyTextColor,
                        ),
                        50.kH,
                        Align(
                          alignment: Alignment.center,
                          child: Text.rich(
                            TextSpan(
                              text: "Already have an account? ",
                              style:
                                  context
                                      .textTheme
                                      .bodySmall
                                      ?.themeGreyTextColor,
                              children: [
                                TextSpan(
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap =
                                            () => Go.onNamedReplace(
                                              context,
                                              RouteName.loginPage,
                                            ),
                                  text: "Login",
                                  style:
                                      context
                                          .textTheme
                                          .bodySmall
                                          ?.themeColor
                                          .bold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
