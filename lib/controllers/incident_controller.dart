import 'package:flutter/material.dart';
import 'package:incident_tracker/models/app_alerts.dart';
import 'package:incident_tracker/models/incident.dart';
import 'package:incident_tracker/services/image_services.dart';
import 'package:incident_tracker/utils/db_helper.dart';
import 'package:incident_tracker/utils/show_toast.dart';

class IncidentController extends ChangeNotifier {
  final incidentsTable = 'incidents';
  bool isLoading = false;
  List<Incident> _incidents = [];
  List<Incident> _filteredIncidents = [];
  String _filter = '';
  Incident? _selectedIncident;
  bool get getIsLoading => isLoading;

  String get getFilter => _filter;
  set setFilter(String value) {
    _filter = value;
    notifyListeners();
  }

  Incident? get selectedIncident => _selectedIncident;
  set selectedIncident(Incident? incident) {
    _selectedIncident = incident;
    notifyListeners();
  }

  set setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  List<Incident> get incidents => _incidents;

  IncidentController() {
    fetchIncidents();
  }

  List<Incident> get filteredIncidents => _filteredIncidents;

  void filterIncidents(String inFilter, String query) {
    setFilter = inFilter;
    if (query.isEmpty) {
      _filteredIncidents = _incidents;
    } else {
      if (inFilter == "search") {
        _filteredIncidents = _incidents
            .where((incident) =>
                incident.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (inFilter == "category") {
        _filteredIncidents =
            _incidents.where((incident) => incident.category == query).toList();
      } else if (inFilter == "status") {
        _filteredIncidents = _incidents
            .where((incident) =>
                incident.status.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (inFilter == "date") {
        _filteredIncidents = _incidents
            .where((incident) => incident.dateTime.contains(query))
            .toList();
      }
    }
  }

  void clearFilter() {
    setFilter = '';
    _filteredIncidents = _incidents;
  }

  // Incidents CRUD
  Future<void> fetchIncidents() async {
    try {
      setIsLoading = true;
      List<Map<String, dynamic>> incidents =
          await DBHelper.getAll(incidentsTable);
      _incidents =
          incidents.map((incident) => Incident.fromJson(incident)).toList();
      setIsLoading = false;
      notifyListeners();
    } catch (e) {
      setIsLoading = false;
      showToast(ErrorAlert(message: e.toString()));
    }
  }

  //get all Incidents
  Future<bool> addIncident(Incident newIncident) async {
    try {
      setIsLoading = true;
      await DBHelper.insert(incidentsTable, newIncident.toJson());
      showToast(SuccessAlert(message: 'Incident added successfully'));
      setIsLoading = false;
      fetchIncidents();
      return true;
    } catch (e) {
      setIsLoading = false;
      showToast(ErrorAlert(message: e.toString()));
      return false;
    }
  }

  Future<bool> updateIncident(Incident updatedIncident) async {
    try {
      await DBHelper.update(incidentsTable, updatedIncident.toJson(),
          {'id': updatedIncident.id!});
      showToast(SuccessAlert(message: 'Incident updated successfully'));
      selectedIncident = updatedIncident;
      await fetchIncidents();
      return true;
    } catch (e) {
      showToast(ErrorAlert(message: e.toString()));
      return false;
    }
  }

  Future<bool> deleteIncident(Incident incidentToDelete) async {
    try {
      // delete image first if it exists
      if (incidentToDelete.photo != null &&
          incidentToDelete.photo!.isNotEmpty) {
        await ImageService().deleteImage(incidentToDelete.photo!);
      }
      await DBHelper.delete(incidentsTable, {'id': incidentToDelete.id!});
      showToast(SuccessAlert(message: 'Incident deleted successfully'));
      fetchIncidents();
      return true;
    } catch (e) {
      showToast(ErrorAlert(message: e.toString()));
      return false;
    }
  }
}
