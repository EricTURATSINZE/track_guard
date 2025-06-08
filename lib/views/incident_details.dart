import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:incident_tracker/components/back_button.dart';
import 'package:incident_tracker/components/category_card.dart';
import 'package:incident_tracker/controllers/incident_controller.dart';
import 'package:incident_tracker/models/incident.dart';
import 'package:incident_tracker/router/index.dart';
import 'package:incident_tracker/utils/theme.dart';
import 'package:provider/provider.dart';

class IncidentDetailsScreen extends StatelessWidget {
  const IncidentDetailsScreen({super.key});

  deleteIncidentHandler(BuildContext context, Incident incident) async {
    final navigator = GoRouter.of(context);

    bool deleted = await Provider.of<IncidentController>(context, listen: false)
        .deleteIncident(incident);
    if (deleted) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Incident? incident =
        Provider.of<IncidentController>(context).selectedIncident;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              SizedBox(height: height * 0.01),
              Row(
                children: [
                  const CustomBackButton(),
                  const SizedBox(width: 10),
                  Text(incident!.title, style: const TextStyle(fontSize: 20)),
                  const Spacer(),
                  Row(children: [
                    GestureDetector(
                      onTap: () {
                        context.push(AppRoutes.updateIncidentScreen);
                      },
                      child: const Icon(
                        Icons.edit_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Confirm Deletion"),
                                  content: Text(
                                      "Are you sure you want to delete ${incident.title}?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          deleteIncidentHandler(
                                              context, incident);
                                          ();
                                        },
                                        child: const Text("Confirm"))
                                  ],
                                );
                              });
                        },
                        child: const Icon(Icons.delete_outlined,
                            color: Colors.red)),
                  ])
                ],
              ),
              SizedBox(height: height * 0.02),
              Container(
                width: double.infinity,
                height: height * 0.25,
                padding: incident.photo == "" ? const EdgeInsets.all(40) : null,
                margin: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                  color: primaryGrey3,
                ),
                child: incident.photo != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(incident.photo!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset("assets/images/default_image.png"),
              ),
              // detailsCard(Icons.sms, "Description", incident.description),
              Container(
                margin: const EdgeInsets.only(bottom: 13),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.sms, color: primaryColor, size: 20),
                        SizedBox(width: 5),
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      incident.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 13),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.roller_shades_closed_outlined,
                        color: primaryColor, size: 20),
                    const SizedBox(width: 5),
                    const Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    CategoryCard(
                        category: incident.category,
                        color: incident.category == "High priority"
                            ? Colors.red
                            : incident.category == "Priority"
                                ? Colors.orange
                                : Colors.green)
                  ],
                ),
              ),
              detailsCard(Icons.location_on, "Location", incident.location),
              detailsCard(Icons.calendar_today, "Date",
                  incident.dateTime.substring(0, 10)),
              detailsCard(Icons.access_time, "Time",
                  incident.dateTime.substring(11, 16)),
              Container(
                margin: const EdgeInsets.only(bottom: 13),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.roller_shades_closed_outlined,
                        color: primaryColor, size: 20),
                    const SizedBox(width: 5),
                    const Text(
                      "Status",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: incident.status == "Open"
                            ? Colors.green.shade100.withOpacity(0.5)
                            : Colors.red.shade100.withOpacity(0.5),
                      ),
                      child: Text(
                        incident.status,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: incident.status == "Open"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget detailsCard(IconData icon, String title, String value) {
  return Container(
    margin: const EdgeInsets.only(bottom: 13),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
