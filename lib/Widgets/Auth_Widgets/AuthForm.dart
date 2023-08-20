import 'package:flutter/material.dart';

import '../../Utils/Helpers.dart';

class AuthForm extends StatefulWidget {
  final Function submitFunc;
  final Function changeLogin;
  final bool isLoading;

  const AuthForm(this.submitFunc, this.changeLogin, this.isLoading,
      {super.key});
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _form = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  bool _islogin = true;
  bool _showPassword = true;
  Map<String, dynamic> userData = {
    "email": "",
    "password": "",
    "username": "",
  };

  void submitform() {
    var isValidate = _form.currentState!.validate();

    if (isValidate) {
      _form.currentState!.save();

      widget.submitFunc(userData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          TextFormField(
            key: UniqueKey(),
            controller: _emailController,
            decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                )),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Email is required.';
              } else if (!isEmailValid(val)) {
                return 'Please enter a valid email address.';
              }
              return null;
            },
            onSaved: (val) => userData["email"] = val,
          ),
          const SizedBox(height: 15),
          if (!_islogin)
            TextFormField(
              key: UniqueKey(),
              controller: _usernameController,
              decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  )),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Username is required.';
                } else if (!isUsernameValid(val)) {
                  return 'Username must be 3-16 characters long and can only contain letters, numbers, underscores, and dashes.';
                }
                return null;
              },
              onSaved: (val) => userData["username"] = val,
            ),
          const SizedBox(height: 15),
          TextFormField(
            key: UniqueKey(),
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(13)),
              ),
              suffix: GestureDetector(
                onTap: () => setState(() {
                  _showPassword = !_showPassword;
                }),
                child: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  size: 22,
                ),
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            obscureText: _showPassword,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Password is required.';
              } else if (!isPasswordValid(val)) {
                return 'Password must be at least 8 characters long and contain at least one letter and one number.';
              }
              return null;
            },
            onSaved: (val) => userData["password"] = val,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 130,
            height: 50,
            child: ElevatedButton(
              onPressed: submitform,
              child: widget.isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      _islogin ? "Login" : "Registration",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  _islogin = !_islogin;
                  widget.changeLogin(_islogin);
                });
              },
              child: Text(_islogin ? "Registration" : "Login"))
        ],
      ),
    );
  }
}
