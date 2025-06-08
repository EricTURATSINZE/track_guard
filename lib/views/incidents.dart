import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:incident_tracker/components/category_card.dart';
import 'package:incident_tracker/components/inputs.dart';
import 'package:incident_tracker/components/loading_shimmer.dart';
import 'package:incident_tracker/controllers/incident_controller.dart';
import 'package:incident_tracker/controllers/user_controller.dart';
import 'package:incident_tracker/models/incident.dart';
import 'package:incident_tracker/router/index.dart';
import 'package:incident_tracker/utils/helper_functions.dart';
import 'package:incident_tracker/utils/theme.dart';
import 'package:provider/provider.dart';

class IncidentsPage extends StatefulWidget {
  const IncidentsPage({super.key});

  @override
  State<IncidentsPage> createState() => _IncidentsPageState();
}

class _IncidentsPageState extends State<IncidentsPage> {
  final _searchText = TextEditingController();
  Timer? _debounce;
  final Duration _debounceDuration = const Duration(seconds: 1);

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<IncidentController>(context, listen: false).fetchIncidents();
  //   });
  // }

  @override
  void dispose() {
    _searchText.dispose();
    super.dispose();
  }

  _onSearch(String searchText) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    if (searchText.isNotEmpty) {
      _debounce = Timer(_debounceDuration, () {
        Provider.of<IncidentController>(context, listen: false)
            .filterIncidents("search", searchText);
      });
    } else {
      Provider.of<IncidentController>(context, listen: false).clearFilter();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Incident> incidents =
        Provider.of<IncidentController>(context).incidents;
    IncidentController incidentController =
        Provider.of<IncidentController>(context);
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.04),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: "Welcome, ",
                    children: [
                      TextSpan(
                          text: Provider.of<AuthController>(context)
                              .user!
                              .firstName,
                          style: const TextStyle(color: primaryColor))
                    ],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.notifications_outlined)
              ],
            ),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Expanded(
                  child: searchInput(
                    onChanged: (value) {
                      _onSearch(value);
                    },
                    clearSearch: () {
                      incidentController.clearFilter();
                    },
                    controller: _searchText,
                    fontSize: 14,
                    height: 50,
                    hintText: "Search incidents",
                  ),
                ),
                PopupMenuButton<int>(
                  offset: Offset(0, height * 0.04),
                  color: Colors.white,
                  onSelected: (value) {
                    if (value == 3) {
                      incidentController.clearFilter();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.filter_list_outlined,
                      color: primaryColor,
                      size: 35,
                    ),
                  ),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 1,
                      child: PopupMenuButton<String>(
                          color: Colors.white,
                          onSelected: (value) {
                            incidentController.filterIncidents("status", value);
                            Navigator.of(context).pop();
                          },
                          itemBuilder: (_) => [
                                const PopupMenuItem(
                                  value: "Open",
                                  child: Text("Open"),
                                ),
                                const PopupMenuItem(
                                  value: "Closed",
                                  child: Text("Closed"),
                                ),
                              ],
                          child: const Text("Filter by Status")),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: PopupMenuButton<String>(
                          color: Colors.white,
                          onSelected: (value) {
                            incidentController.filterIncidents(
                                "category", value);
                            Navigator.of(context).pop();
                          },
                          itemBuilder: (_) => [
                                const PopupMenuItem(
                                  value: "High priority",
                                  child: Text("High"),
                                ),
                                const PopupMenuItem(
                                  value: "Priority",
                                  child: Text("Medium"),
                                ),
                                const PopupMenuItem(
                                  value: "Low Priority",
                                  child: Text("Low"),
                                ),
                              ],
                          child: const Text("Filter by Category")),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text("Clear Filters"),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Text(
                "Incidents (${incidentController.getFilter.isEmpty ? incidents.length : incidentController.filteredIncidents.length})",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: height * 0.02),
            incidentController.isLoading
                ? const Column(
                    children: [
                      LoadingShimmer(
                        height: 70,
                        width: double.infinity,
                      )
                    ],
                  )
                : Expanded(
                    child: ((incidentController.getFilter.isEmpty &&
                                incidents.isEmpty) ||
                            (incidentController.getFilter.isNotEmpty &&
                                incidentController.filteredIncidents.isEmpty))
                        ? ListView(
                            children: [
                              SizedBox(height: height * 0.1),
                              SizedBox(
                                  height: height * 0.3,
                                  width: double.infinity,
                                  child:
                                      Image.asset("assets/images/no_data.png")),
                              const Text(
                                "No incidents found",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: incidentController.getFilter.isEmpty
                                ? incidents.length
                                : incidentController.filteredIncidents.length,
                            itemBuilder: (context, index) {
                              var incident = incidentController
                                      .getFilter.isEmpty
                                  ? incidents[index]
                                  : incidentController.filteredIncidents[index];
                              return GestureDetector(
                                onTap: () {
                                  Provider.of<IncidentController>(context,
                                          listen: false)
                                      .selectedIncident = incident;
                                  context.push(AppRoutes.incidentDetailsScreen);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: primaryGrey2,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: primaryGrey3),
                                        ),
                                        child: incident.photo != ""
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.file(
                                                  File(incident.photo!),
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                    initials(
                                                      incident.title,
                                                    ),
                                                    style: const TextStyle(
                                                        color: splashColor,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              incident.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CategoryCard(
                                                          category:
                                                              incident.category,
                                                          color: incident
                                                                      .category ==
                                                                  "High priority"
                                                              ? Colors.red
                                                              : incident.category ==
                                                                      "Priority"
                                                                  ? Colors
                                                                      .orange
                                                                  : Colors
                                                                      .green),
                                                      const SizedBox(width: 5),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    incident.dateTime
                                                        .substring(0, 10),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
