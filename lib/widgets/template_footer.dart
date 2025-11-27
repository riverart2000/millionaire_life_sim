import 'package:flutter/material.dart';

class TemplateFooter extends StatelessWidget {
  const TemplateFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 8,
        children: [
          Text(
            '© ${DateTime.now().year} Learning Hub Template',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Wrap(
            spacing: 16,
            children: const [
              _FooterLink(label: 'Terms'),
              _FooterLink(label: 'Privacy'),
              _FooterLink(label: 'Support'),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

