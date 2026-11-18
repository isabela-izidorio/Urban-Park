import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  final _auth = MockAuthService();

  @override
  void dispose() {
    _name.dispose(); _email.dispose(); _password.dispose(); _confirm.dispose(); super.dispose();
  }

  Future<void> _register() async {
    if (!_key.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final created = await _auth.register(_name.text, _email.text, _password.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(created ? 'Cadastro realizado! Faça seu login.' : 'Este e-mail já está cadastrado.'),
      ));
      if (created) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Criar conta')),
    body: SafeArea(child: Center(child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 480),
        child: Form(key: _key, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('Cadastre-se no Urban Park', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 22),
          TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Nome completo', prefixIcon: Icon(Icons.person_outline)),
            validator: (v) => v == null || v.trim().length < 3 ? 'Informe seu nome' : null),
          const SizedBox(height: 14),
          TextFormField(controller: _email, keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email_outlined)),
            validator: (v) => v == null || !v.contains('@') ? 'Informe um e-mail válido' : null),
          const SizedBox(height: 14),
          TextFormField(controller: _password, obscureText: true,
            decoration: const InputDecoration(labelText: 'Senha (mínimo 6 caracteres)', prefixIcon: Icon(Icons.lock_outline)),
            validator: (v) => v == null || v.length < 6 ? 'A senha deve ter pelo menos 6 caracteres' : null),
          const SizedBox(height: 14),
          TextFormField(controller: _confirm, obscureText: true,
            decoration: const InputDecoration(labelText: 'Confirmar senha', prefixIcon: Icon(Icons.lock_reset)),
            validator: (v) => v != _password.text ? 'As senhas não coincidem' : null),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _loading ? null : _register,
            child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Confirmar cadastro')),
          const SizedBox(height: 10),
          const Text('Novas contas são cadastradas como usuário padrão.', textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey)),
        ])),
      ),
    ))),
  );
}
