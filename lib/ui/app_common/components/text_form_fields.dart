
import 'package:danapaniexpress/core/common_imports.dart';

class AppTextFormField extends StatefulWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final bool readOnly;
  final bool isConstant;
  final bool isDetail;
  final String? label;
  final TextInputType textInputType;
  final String? initialValue;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator; // ✅ add validator

  const AppTextFormField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.textEditingController,
    this.textInputType = TextInputType.text,
    this.validator, this.initialValue, this.readOnly = false, this.isConstant =false,  this.isDetail = false, this.label, this.onChanged, this.onSubmit
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool _obscure = true;
  TextDirection _textDirection = TextDirection.ltr;
  TextAlign _textAlign = TextAlign.left;
  late FocusNode _focusNode;

  void _handleTextChange() {
    final text = widget.textEditingController!.text.trim();
    if (text.isEmpty) return;

    final firstChar = text.codeUnitAt(0);
    final isUrdu = firstChar >= 0x0600 && firstChar <= 0x06FF;

    if (isUrdu && _textDirection != TextDirection.rtl) {
      setState(() {
        _textDirection = TextDirection.rtl;
        _textAlign = TextAlign.right;
      });
    } else if (!isUrdu && _textDirection != TextDirection.ltr) {
      setState(() {
        _textDirection = TextDirection.ltr;
        _textAlign = TextAlign.left;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {}); // rebuild when focus changes
    });
    widget.textEditingController!.addListener(_handleTextChange);
  }
  @override
  void dispose() {
    _focusNode.dispose();
    widget.textEditingController!.removeListener(_handleTextChange);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = isDark;

    return TextFormField(
      controller: widget.textEditingController,
      focusNode: _focusNode,
      validator: widget.validator, // ✅ wire it up
      readOnly: widget.readOnly,
      initialValue: widget.initialValue,
      cursorHeight: 16.0,
      maxLines: widget.isDetail ? null : 1 ,
      keyboardType: widget.textInputType,
      obscureText: widget.isPassword ? _obscure : false,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmit,
      style: editingFormTextStyle(text: widget.textEditingController!.text),
      textDirection: widget.isConstant ? TextDirection.ltr : _textDirection,
      textAlign: widget.isConstant ? TextAlign.start : _textAlign,
      decoration: InputDecoration(
        //  label: widget.label != null ? appText(text: widget.label, textStyle: itemTextStyle()) : null,
        labelText: _focusNode.hasFocus ? widget.label : null,
        labelStyle: secondaryTextStyle(),
        hint: Directionality(
          textDirection: setTextDirection(appLanguage),
          child: Text(
            widget.hintText ?? '',
            style: textFormHintTextStyle(),
          ),
        ),
        // hintText: widget.hintText,
        // hintTextDirection:  setTextDirection(appLanguage),
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
        fillColor: AppColors.materialButtonSkin(isDarkTheme).withValues(alpha: 0.1),
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

