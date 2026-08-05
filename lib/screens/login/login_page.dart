import 'package:flutter/material.dart';

import '../dashboard/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool hidePassword = true;

  void login() {

    if (usernameController.text == "admin" &&
        passwordController.text == "12345") {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login yoki parol noto'g'ri"),
          backgroundColor: Colors.red,
        ),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xff0D47A1),

      body: Center(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(30),

          child: Column(

            children: [

              Image.asset(
                "assets/images/logo.png",
                width: 180,
              ),

              const SizedBox(height: 20),

              const Text(
                "FitLife CRM",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Fitness Club Management System",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              Card(

                elevation: 10,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Padding(

                  padding: const EdgeInsets.all(20),

                  child: Column(

                    children: [

                      TextField(

                        controller: usernameController,

                        decoration: const InputDecoration(

                          labelText: "Username",

                          prefixIcon: Icon(Icons.person),

                          border: OutlineInputBorder(),

                        ),

                      ),

                      const SizedBox(height: 20),

                      TextField(

                        controller: passwordController,

                        obscureText: hidePassword,

                        decoration: InputDecoration(

                          labelText: "Password",

                          prefixIcon: const Icon(Icons.lock),

                          border: const OutlineInputBorder(),

                          suffixIcon: IconButton(

                            icon: Icon(

                              hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),

                            onPressed: () {

                              setState(() {

                                hidePassword = !hidePassword;

                              });

                            },

                          ),

                        ),

                      ),

                      const SizedBox(height: 30),

                      SizedBox(

                        width: double.infinity,

                        height: 50,

                        child: ElevatedButton(

                          onPressed: login,

                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),

                        ),

                      ),

                    ],

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}