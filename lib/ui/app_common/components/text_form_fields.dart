
import 'package:danapaniexpress/core/common_imports.dart';

class AppTextFormField extends StatefulWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator; // ✅ add validator

  const AppTextFormField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.textEditingController,
    this.validator,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = isDark;

    return TextFormField(
      controller: widget.textEditingController,
      validator: widget.validator, // ✅ wire it up
      cursorHeight: 16.0,
      obscureText: widget.isPassword ? _obscure : false,
      style: bodyTextStyle(),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: AppColors.materialButtonSkin(isDarkTheme))
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.materialButtonSkin(isDarkTheme),
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        )
            : null,
        hintStyle: textFormHintTextStyle(),
        filled: true,
        fillColor: AppColors.materialButtonSkin(isDarkTheme).withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.materialButtonSkin(isDarkTheme), width: 1.0),
        ),
      ),
    );
  }
}

