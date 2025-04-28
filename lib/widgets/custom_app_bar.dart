import 'package:financial_management_app/views/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function(String)? onCurrencyChanged;
  final VoidCallback? onProfileTap;
  final VoidCallback? onBackTap;
  final String initialCurrency;
  final bool showActions;
  final bool showNavigation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onCurrencyChanged,
    this.onProfileTap,
    this.onBackTap,
    this.initialCurrency = 'USD',
    this.showActions = true,
    this.showNavigation = true,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late String _selectedOption;
  final List<String> _options = ['USD', 'BRL', 'BTC', 'ETH'];

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.initialCurrency;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      leadingWidth: widget.showActions ? 140 : 100,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          children: [
            if (widget.showNavigation)
              IconButton(
                onPressed: widget.onBackTap ?? () => Get.back(),
                icon: const Icon(Icons.arrow_back),
              ),
            if (widget.showActions)
              DropdownButton<String>(
                value: _selectedOption,
                underline: const SizedBox(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedOption = value;
                    });
                    widget.onCurrencyChanged?.call(value);
                  }
                },
                items:
                    _options
                        .map(
                          (opt) =>
                              DropdownMenuItem(value: opt, child: Text(opt)),
                        )
                        .toList(),
              ),
          ],
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      actionsPadding: const EdgeInsets.only(right: 16.0),
      actions:
          widget.showActions
              ? [
                IconButton(
                  onPressed:
                      widget.onProfileTap ??
                      () => Get.to(() => const SettingsView()),
                  icon: const Icon(Icons.settings),
                  style: IconButton.styleFrom(
                    backgroundColor: Color(0xFFF8F8F8),
                    foregroundColor: Colors.black,
                  ),
                ),
              ]
              : null,
    );
  }
}
