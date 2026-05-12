import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:place_finder_app/core/widget/custom_text_form_field.dart';
import 'package:place_finder_app/core/utils/local_storage.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entity/user_entity.dart';
import 'bloc/registration_bloc.dart';
import 'bloc/registration_event.dart';
import 'bloc/registration_state.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password does not match")),
      );
      return;
    }

    final user = UserEntity(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    context.read<RegisterBloc>().add(RegisterSubmitted(user));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) async {
          if (state is RegisterSuccess) {
            await LocalStorage.setString('user_email', emailController.text.trim());
            await LocalStorage.setBool('is_registered', true);
            await LocalStorage.setBool('is_logged_in', false);
            await FirebaseAuth.instance.signOut();
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Successful")),
            );
            Navigator.pushReplacementNamed(context, '/login');
          }

          if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is RegisterLoading;

          return SafeArea(
            child: Center(
              child: SizedBox(
                width: size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.06,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create Account",
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.08,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: size.height * 0.01),

                        Text(
                          "Register using email and password",
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.035,
                            color: Colors.grey,
                          ),
                        ),

                        SizedBox(height: size.height * 0.05),

                        // EMAIL
                        CustomTextFormField(
                          controller: emailController,
                          labelText: "Email",
                          hintText: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                          isStar: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Email is required";
                            }

                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value.trim())) {
                              return "Enter valid email";
                            }

                            return null;
                          },
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
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Password is required";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: size.height * 0.025),


                        CustomTextFormField(
                          controller: confirmPasswordController,
                          labelText: "Confirm Password",
                          hintText: "Re-enter password",
                          obscureText: obscureConfirmPassword,
                          isStar: true,
                          suffixIcon: obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword =
                              !obscureConfirmPassword;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Confirm password is required";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: size.height * 0.05),


                        SizedBox(
                          width: double.infinity,
                          height: size.height * 0.06,
                          child: ElevatedButton(
                            onPressed:
                            isLoading ? null : () => _onRegister(context),
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
                              "Register",
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
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: Text(
                              "Already have an account? Login",
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
