import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:incident_tracker/components/loading_shimmer.dart';
import 'package:incident_tracker/utils/theme.dart';

Padding inputText({
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  String hint = "",
  String label = "",
  bool obscureText = false,
  bool loading = false,
  Function? validator,
  int maxLines = 1,
  bool required = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: loading
        ? const SizedBox(
            width: double.infinity,
            height: 50,
            child: LoadingShimmer(
              height: 10,
              width: double.infinity,
              borderRadius: 10,
            ),
          )
        : Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  label.isNotEmpty
                      ? Text(
                          label,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Container(),
                  required ? const SizedBox(width: 5) : Container(),
                  required
                      ? const Text("*", style: TextStyle(color: Colors.red))
                      : Container(),
                ],
              ),
              const SizedBox(height: 3),
              TextFormField(
                keyboardType: keyboardType,
                controller: controller,
                validator: (value) {
                  if (validator != null) {
                    return validator(value);
                  } else {
                    return null;
                  }
                },
                maxLines: maxLines,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: obscureText,
                decoration: InputDecoration(
                  // reduce vertical padding
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  isDense: true,
                  hintText: hint,
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  border: commonInputBorder,
                ),
              ),
            ],
          ),
  );
}

Padding passwordInput({
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  String hint = "",
  String label = "",
  bool obscureText = false,
  bool visibility = false,
  required Function toggleVisibility,
  Function? validator,
  bool required = true,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 5),
            label.isNotEmpty
                ? Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Container(),
            required ? const SizedBox(width: 5) : Container(),
            required
                ? const Text("•", style: TextStyle(color: Colors.red))
                : Container(),
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          obscureText: !visibility,
          validator: (s) {
            if (validator != null) {
              return validator(s);
            } else {
              return null;
            }
          },
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              suffixIcon: GestureDetector(
                  onTap: () => toggleVisibility(),
                  child: visibility
                      ? const Icon(Icons.visibility_off_rounded)
                      : const Icon(Icons.visibility_rounded)),
              border: commonInputBorder),
        ),
      ],
    ),
  );
}

Padding datePicker(BuildContext context,
    {required TextEditingController controller,
    Function? validator,
    bool required = true,
    String hint = "",
    String label = ""}) {
  return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 5),
              label.isNotEmpty
                  ? Text(
                      label,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Container(),
              required ? const SizedBox(width: 5) : Container(),
              required
                  ? const Text("•", style: TextStyle(color: Colors.red))
                  : Container(),
            ],
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.text,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (s) {
              if (validator != null) {
                return validator(s);
              }
              return null;
            },
            readOnly: true,
            onTap: () async {
              var t = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now(),
              );
              if (t != null) {
                String formattedDate = DateFormat('yyyy-MM-dd').format(t);
                controller.text = formattedDate;
              }
            },
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              suffixIcon: const Icon(
                Icons.calendar_today_outlined,
                size: 17,
                color: Colors.black,
              ),
              border: commonInputBorder,
            ),
          ),
        ],
      ));
}

Padding timePicker(BuildContext context,
    {required TextEditingController controller,
    Function? validator,
    bool required = true,
    String hint = "",
    String label = ""}) {
  return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 5),
              label.isNotEmpty
                  ? Text(
                      label,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Container(),
              required ? const SizedBox(width: 5) : Container(),
              required
                  ? const Text("•", style: TextStyle(color: Colors.red))
                  : Container(),
            ],
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.text,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (s) {
              if (validator != null) {
                return validator(s);
              }
              return null;
            },
            readOnly: true,
            onTap: () async {
              var t = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (t != null) {
                controller.text = t.format(context);
              }
            },
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              suffixIcon: const Icon(
                Icons.access_time_outlined,
                size: 17,
                color: Colors.black,
              ),
              border: commonInputBorder,
            ),
          ),
        ],
      ));
}

Padding select(
  String label,
  String? hint,
  String? value,
  List<dynamic> items,
  Function valueChangedHandler, {
  bool valid = true,
  bool loading = false,
  String errorText = "",
  bool required = true,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 5),
            label.isNotEmpty
                ? Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Container(),
            required ? const SizedBox(width: 5) : Container(),
            required
                ? const Text("•", style: TextStyle(color: Colors.red))
                : Container(),
          ],
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          items: [
            DropdownMenuItem(
              value: "",
              child: Text(hint ?? "Select"),
            ),
            ...items.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem(
                value: item.value,
                child: Text(item.name),
              );
            })
          ],
          onChanged: (value) {
            valueChangedHandler(value);
          },
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            isDense: true,
            // suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            border: commonInputBorder,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
        ),
      ],
    ),
  );
}

Widget searchInput(
    {required Function onChanged,
    required Function clearSearch,
    required TextEditingController controller,
    required double fontSize,
    double height = 40.0,
    bool numerical = false,
    bool enabled = true,
    bool valid = true,
    String hintText = "Search"}) {
  return Container(
    height: height,
    width: double.infinity,
    padding: const EdgeInsets.only(bottom: 4, left: 10, right: 10),
    margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        // border: Border.all(color: valid ? Colors.black54 : Colors.red),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3), // The offset of the shadow
          ),
        ]),
    child: TextField(
      style: TextStyle(fontSize: fontSize),
      textAlignVertical: TextAlignVertical.center,
      keyboardType: numerical ? TextInputType.number : TextInputType.text,
      onChanged: ((value) {
        onChanged(value);
      }),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              controller.text = "";
              clearSearch();
            }
          },
          icon: controller.text.isEmpty
              ? const Icon(Icons.search)
              : const Icon(Icons.close),
        ),
        hintText: hintText,
        enabled: enabled,
        hintStyle: TextStyle(fontSize: fontSize),
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.all(10.0),
      ),
      controller: controller,
    ),
  );
}
