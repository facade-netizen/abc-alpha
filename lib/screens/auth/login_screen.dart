import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authBlocs/user_login_bloc.dart';
import '../../bloc/authBlocs/user_changed_bloc.dart';
import '../../localDb/login/login_credentials_box.dart';
import '../../localDb/login/login_credentials_model.dart';
import '../../reusable/button.dart';
import '../../reusable/colors.dart';
import '../../reusable/loading.dart';
import '../../reusable/navigators.dart';
import '../../reusable/sized_box_hw.dart';
import '../../reusable/snack_bar.dart';
import 'reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late LoginCredentialsModel loginDetails;
  bool obscurePassword = true;

  // Background animation
  late AnimationController _bgController;
  late Animation<Color?> _bgColorAnimation;

  @override
  void initState() {
    super.initState();

    LoginCredentialsModel? savedData = LoginCredentialsBox.loginCredentialsBox.fetchLoginCredentials;
    if (savedData != null && savedData.userId != null) {
      userNameController.text = savedData.userId!;
      passwordController.text = savedData.password!;
      loginDetails = savedData;
    } else {
      loginDetails = LoginCredentialsModel();
    }

    // Animate background colors
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat(reverse: true);
    _bgColorAnimation = ColorTween(
      begin: const Color.fromARGB(255, 175, 212, 243),
      end: const Color.fromARGB(255, 191, 196, 221),
    ).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocConsumer<UserLoginBloc, UserLoginState>(
      listener: (context, state) {
        if (state is UserLoginFailure) {
          showSnackBar(context, state.error, error: true);
        }
        if (state is UserLoginSuccess) {
          context.read<UserAuthChangesBloc>().add(StartUserChangeListener());
        }
        if (state is UserLoginResetPasswrodRequiredSuccess) {
          pushSimple(context, FirstTimeResetPasswordScreen(userName: state.userName));
        }
      },
      builder: (context, state) {
        return state is UserLoginProgress
            ? const LoadingScreen(message: "Logging in")
            : AnimatedBuilder(
                animation: _bgColorAnimation,
                builder: (context, child) {
                  return Scaffold(
                    backgroundColor: _bgColorAnimation.value,
                    body: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          width: size.width > 600 ? 450 : size.width * 0.9,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
                          ),
                          child: _buildLoginForm(context),
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Form(
      key: loginFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Welcome Back",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: blue),
          ),
          hb20,
          Text(
            "Please login to your account",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          hb25,
          // Username
          TextFormField(
            controller: userNameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "Username",
              prefixIcon: Icon(Icons.person_outline),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          hb20,
          // Password
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            obscuringCharacter: "*",
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Icon(Icons.lock_outline),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              suffixIcon: IconButton(
                icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey[600]),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
            ),
            onFieldSubmitted: (_) => _submitLogin(context),
          ),
          hb25,
          SizedBox(height: 48, child: CustomLoginButton(onPressed: () => _submitLogin(context))),
        ],
      ),
    );
  }

  void _submitLogin(BuildContext context) {
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      context.read<UserLoginBloc>().add(UserLogin(username: userNameController.text, password: passwordController.text));
    }
  }
}
