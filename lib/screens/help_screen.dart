import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  static final Uri _supportUri = Uri.https(
    'mail.google.com',
    '/mail/',
    {
      'view': 'cm',
      'fs': '1',
      'to': 'suporte@urbanpark.com.br',
      'su': 'Suporte - Urban Park',
    },
  );

  Future<void> _openSupportEmail() async {
    final opened = await launchUrl(
      _supportUri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o Gmail neste dispositivo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajuda')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.support_agent,
                size: 68,
                color: AppTheme.primary,
              ),
              const SizedBox(height: 20),
              const Text(
                'Favor nos informe sobre o seu problema.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 18),
              TextButton.icon(
                onPressed: _openSupportEmail,
                icon: const Icon(Icons.email_outlined),
                label: const Text('suporte@urbanpark.com.br'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Toque no endereço para abrir uma mensagem de suporte no Gmail.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
