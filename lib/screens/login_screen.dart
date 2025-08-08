import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasksandprojects/screens/projects_screen.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _loading = false;
  String? _error;
  bool _obscurePassword = true;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    _formKey.currentState!.save();
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.login(_email, _password);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProjectsScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Error al iniciar sesión';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: _LoginForm(
              formKey: _formKey,
              loading: _loading,
              error: _error,
              obscurePassword: _obscurePassword,
              onEmailSaved: (v) => _email = v!.trim(),
              onPasswordSaved: (v) => _password = v!.trim(),
              onTogglePassword: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              onSubmit: _submit,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool loading;
  final String? error;
  final bool obscurePassword;
  final FormFieldSetter<String> onEmailSaved;
  final FormFieldSetter<String> onPasswordSaved;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;

  const _LoginForm({
    required this.formKey,
    required this.loading,
    required this.error,
    required this.obscurePassword,
    required this.onEmailSaved,
    required this.onPasswordSaved,
    required this.onTogglePassword,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Bienvenido a Tasks & Projects',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            onSaved: onEmailSaved,
            validator: (v) =>
                v == null || v.isEmpty ? 'Ingrese su email' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Contraseña',
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: onTogglePassword,
              ),
            ),
            obscureText: obscurePassword,
            onSaved: onPasswordSaved,
            validator: (v) =>
                v == null || v.isEmpty ? 'Ingrese su contraseña' : null,
          ),
          const SizedBox(height: 24),
          if (error != null)
            Text(error!, style: const TextStyle(color: Colors.red)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : onSubmit,
              child: loading
                  ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Entrar'),
            ),
          ),
        ]
           ),
    );
  }
}