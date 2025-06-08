import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:incident_tracker/components/back_button.dart';
import 'package:incident_tracker/components/button.dart';
import 'package:incident_tracker/components/image_source_dialog.dart';
import 'package:incident_tracker/components/inputs.dart';
import 'package:incident_tracker/controllers/incident_controller.dart';
import 'package:incident_tracker/models/incident.dart';
import 'package:incident_tracker/models/select_item.dart';
import 'package:incident_tracker/services/image_services.dart';
import 'package:incident_tracker/utils/theme.dart';
import 'package:provider/provider.dart';

class UpdateIncidentScreen extends StatefulWidget {
  const UpdateIncidentScreen({super.key});

  @override
  State<UpdateIncidentScreen> createState() => UpdatedIncidentScreenState();
}

class UpdatedIncidentScreenState extends State<UpdateIncidentScreen> {
  final _form1Key = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();
  var step = 1;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  var category = "";
  List<SelectItem> categories = [
    SelectItem(value: "High priority", name: "High priority"),
    SelectItem(value: "Priority", name: "Priority"),
    SelectItem(value: "Low Priority", name: "Low Priority"),
  ];
  var status = "";
  List<SelectItem> statuses = [
    SelectItem(value: "Open", name: "Open"),
    SelectItem(value: "Closed", name: "Closed"),
  ];
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  var photoController = TextEditingController();
  File? image;

  setImage(File imageTemporary) {
    setState(() {
      image = imageTemporary;
    });
  }

  @override
  void initState() {
    super.initState();
    Incident? incident = Provider.of<IncidentController>(context, listen: false)
        .selectedIncident;
    titleController.text = incident!.title;
    descriptionController.text = incident.description;
    category = incident.category;
    locationController.text = incident.location;
    dateController.text = incident.dateTime.substring(0, 10);
    timeController.text = incident.dateTime.substring(11, 16);
    status = incident.status;
    if (incident.photo != "") {
      image = File(incident.photo!);
    }
  }

  updateIncidentHandler() async {
    if (step == 1) {
      if (_form1Key.currentState!.validate()) {
        setState(() {
          step = 2;
        });
      }
    } else {
      if (_form2Key.currentState!.validate()) {
        final navigator = GoRouter.of(context);
        if (image != null) {
          photoController.text =
              await ImageService().saveImageToStorage(image!);
        } else {
          photoController.text = "";
        }
        var data = {
          "id": Provider.of<IncidentController>(context, listen: false)
              .selectedIncident!
              .id,
          "title": titleController.text,
          "description": descriptionController.text,
          "category": category,
          "location": locationController.text,
          "dateTime": "${dateController.text} ${timeController.text}",
          "status": status,
          "photo": photoController.text,
        };
        Incident incident = Incident.fromJson(data);
        bool incidentUpdated =
            await Provider.of<IncidentController>(context, listen: false)
                .updateIncident(incident);
        if (incidentUpdated) {
          navigator.pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(children: [
            const SizedBox(height: 30),
            const Row(
              children: [
                CustomBackButton(),
                SizedBox(width: 10),
                Text("Update Incident", style: TextStyle(fontSize: 20)),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: step == 1 ? splashColor : primaryGrey4,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: step == 2 ? splashColor : primaryGrey4,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
                child: SizedBox(
              height: double.infinity,
              child: ListView(
                children: [
                  if (step == 1)
                    Form(
                      key: _form1Key,
                      child: Column(children: [
                        inputText(
                          controller: titleController,
                          hint: "Enter Incident Title",
                          label: "Incident Title",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            if (value.length < 3) {
                              return 'Title must be at least 5 characters long';
                            }
                            if (value.length > 25) {
                              return 'Title must be less than 25 characters long';
                            }
                            return null;
                          },
                          required: true,
                        ),
                        inputText(
                          controller: descriptionController,
                          label: "Incident Description",
                          maxLines: 3,
                          required: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            if (value.length < 10) {
                              return 'Description must be at least 10 characters long';
                            }
                            if (value.length > 250) {
                              return 'Description must be less than 250 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(children: [
                          const SizedBox(width: 8),
                          const Text(
                            "Photo",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () async {
                              ImageSource? source =
                                  await showImageSourceDialog(context);
                              await ImageService().pickImage(
                                  source ?? ImageSource.gallery, setImage);
                            },
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.grey,
                              size: 24,
                            ),
                          ),
                          Visibility(
                            visible: image != null,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red.shade400,
                                  size: 26,
                                ),
                              ),
                            ),
                          )
                        ]),
                        Container(
                          width: double.infinity,
                          height: height * 0.25,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding:
                              image == null ? const EdgeInsets.all(40) : null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                            color: primaryGrey3,
                          ),
                          child: image == null
                              ? Image.asset("assets/images/default_image.png")
                              : Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                        )
                      ]),
                    ),
                  if (step == 2)
                    Form(
                      key: _form2Key,
                      child: Column(children: [
                        select(
                          "Category",
                          "Select Category",
                          category,
                          categories,
                          (value) {
                            setState(() {
                              category = value!;
                            });
                          },
                          required: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),
                        inputText(
                            controller: locationController,
                            hint: "Enter incident location",
                            label: "Location",
                            required: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a location';
                              }
                              return null;
                            }),
                        Row(
                          children: [
                            Expanded(
                              child: datePicker(context,
                                  hint: "Incident date",
                                  label: "Date",
                                  required: true,
                                  controller: dateController,
                                  validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a date';
                                }
                                return null;
                              }),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: timePicker(context,
                                  hint: "Incident time",
                                  label: "Time",
                                  required: true,
                                  controller: timeController,
                                  validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a time';
                                }
                                return null;
                              }),
                            ),
                          ],
                        ),
                        select(
                            "Status",
                            "Select status",
                            status,
                            statuses,
                            (value) {
                              setState(() {
                                status = value!;
                              });
                            },
                            required: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a status';
                              }
                              return null;
                            }),
                      ]),
                    ),
                ],
              ),
            )),
            const SizedBox(height: 20),
            Visibility(
              visible: !(MediaQuery.of(context).viewInsets.bottom > 0),
              child: step == 1
                  ? Button(
                      "Save & Continue",
                      () {
                        updateIncidentHandler();
                      },
                      context,
                      radius: 10,
                      weight: FontWeight.w500,
                      backgroundColor: splashColor,
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Button(
                            "Back",
                            () {
                              setState(() {
                                step = 1;
                              });
                            },
                            context,
                            hasBorder: true,
                            backgroundColor: primaryGrey2,
                            color: splashColor,
                            radius: 10,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Button(
                            "Submit",
                            () {
                              updateIncidentHandler();
                            },
                            context,
                            hasIcon: true,
                            hasBorder: true,
                            height: 50,
                            icon: Icons.save_outlined,
                            weight: FontWeight.w400,
                            radius: 10,
                            backgroundColor: splashColor,
                          ),
                        ),
                      ],
                    ),
            ),
            Visibility(
                visible: !(MediaQuery.of(context).viewInsets.bottom > 0),
                child: const SizedBox(height: 30)),
          ]),
        ),
      ),
    );
  }
}
