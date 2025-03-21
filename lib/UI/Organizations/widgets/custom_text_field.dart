import 'package:flutter/material.dart';

class DropdownTextField extends StatefulWidget {
  final List<String> items;
  final TextEditingController controller;
  final String itemName;

  const DropdownTextField({
    Key? key,
    required this.items,
    required this.controller,
    required this.itemName,
  }) : super(key: key);

  @override
  _DropdownTextFieldState createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: widget.items.map((item) {
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    widget.controller.text = item;
                    _hideOverlay();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideOverlay();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: "Enter organization " + widget.itemName + " here",
          hintStyle: TextStyle(fontSize: 20),
          prefixIcon: widget.itemName == "category"
              ? Icon(Icons.queue)
              : Icon(Icons.flag_outlined),
          contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        onTap: () {
          if (_overlayEntry == null) {
            _showOverlay();
          } else {
            _hideOverlay();
          }
        },
        onChanged: (value) {
          if (value.isEmpty) {
            _hideOverlay();
          }
        },
      ),
    );
  }
}
