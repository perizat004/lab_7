import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants.dart';
import 'package:flutter_application_7/user.dart';
import 'package:flutter_application_7/user_info_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _storyController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  int _currentIndex = 0;

  void _changeLanguage(Locale locale) {
    context.setLocale(locale);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        story: _storyController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserInfoPage(user: user),
        ),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Invalid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone is required';
    if (!RegExp(r'^\+7\s\(\d{3}\)\s\d{3}-\d{4}$').hasMatch(value)) {
      return 'Invalid phone format';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('register_form')),
        actions: [
          PopupMenuButton<Locale>(
            icon: Icon(Icons.language),
            onSelected: _changeLanguage,
            itemBuilder: (context) => [
              PopupMenuItem(value: Locale('en'), child: Text('EN')),
              PopupMenuItem(value: Locale('ru'), child: Text('RU')),
              PopupMenuItem(value: Locale('kk'), child: Text('KZ')),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: inputDecoration(tr('full_name'), Icons.person),
                validator: (value) => value!.isEmpty ? tr('name_empty') : null,
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: _phoneController,
                decoration: inputDecoration(tr('phone_number'), Icons.phone),
                validator: _validatePhone,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  tr('phone_format'),
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: _emailController,
                decoration: inputDecoration(tr('email_address'), Icons.email),
                validator: _validateEmail,
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: _storyController,
                decoration: inputDecoration(tr('life_story'), Icons.book),
                maxLines: 3,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  tr('keep_it_short'),
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: tr('password'),
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: tr('confirm_password'),
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value != _passwordController.text)
                    return tr('password_mismatch');
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(tr('submit_form')),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: tr('register_form')),
          BottomNavigationBarItem(
              icon: Icon(Icons.info), label: tr('user_info')),
        ],
      ),
    );
  }
}
