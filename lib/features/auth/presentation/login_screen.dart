import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:place_finder_app/core/widget/custom_text_form_field.dart';
import '../domain/entity/user_entity.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_event.dart';
import 'bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLogin(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final user = UserEntity(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    context.read<LoginBloc>().add(LoginSubmitted(user));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login Successful")),
            );
            Navigator.pushReplacementNamed(context, '/home');
          }

          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;

          return SafeArea(
            child: Center(
              child: SizedBox(
                width: size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back",
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.08,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          "Login with your email and password",
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.035,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        CustomTextFormField(
                          controller: emailController,
                          labelText: "Email",
                          hintText: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                          isStar: true,

                        ),
                        SizedBox(height: size.height * 0.025),
                        CustomTextFormField(
                          controller: passwordController,
                          labelText: "Password",
                          hintText: "Enter password",
                          obscureText: obscurePassword,
                          isStar: true,
                          suffixIcon: obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },

                        ),
                        SizedBox(height: size.height * 0.05),
                        SizedBox(
                          width: double.infinity,
                          height: size.height * 0.06,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () => _onLogin(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "Login",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: size.width * 0.04,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/register');
                            },
                            child: Text(
                              "Don't have an account? Register",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: size.width * 0.035,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
