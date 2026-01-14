import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/appointment.dart';
import '../models/doctor.dart';

class AppointmentsStore {
  static const String _key = 'appointments';

  static Future<List<Appointment>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return [];
    }

    return decoded
        .whereType<Map>()
        .map((e) => Appointment.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  static Future<void> save(List<Appointment> appointments) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(appointments.map((a) => a.toJson()).toList());
    await prefs.setString(_key, raw);
  }

  static Future<List<Appointment>> ensureSeeded() async {
    final existing = await load();
    if (existing.isNotEmpty) {
      return existing;
    }

    final seeded = <Appointment>[
      Appointment(
        id: '1',
        userId: '1',
        doctorId: '1',
        doctorName: 'Dr. Amina Ochieng',
        doctorSpecialty: 'Cardiology',
        date: '2024-01-15',
        time: '10:30 AM',
        status: AppointmentStatus.upcoming,
        price: 15000,
      ),
      Appointment(
        id: '2',
        userId: '1',
        doctorId: '2',
        doctorName: 'Dr. Joseph Kamau',
        doctorSpecialty: 'Dermatology',
        date: '2024-01-10',
        time: '02:00 PM',
        status: AppointmentStatus.completed,
        price: 12000,
      ),
      Appointment(
        id: '3',
        userId: '1',
        doctorId: '3',
        doctorName: 'Dr. Grace Wanjiru',
        doctorSpecialty: 'Pediatrics',
        date: '2024-01-20',
        time: '11:00 AM',
        status: AppointmentStatus.upcoming,
        price: 10000,
      ),
      Appointment(
        id: '4',
        userId: '1',
        doctorId: '4',
        doctorName: 'Dr. David Mutiso',
        doctorSpecialty: 'Neurology',
        date: '2024-01-25',
        time: '09:00 AM',
        status: AppointmentStatus.upcoming,
        price: 18000,
      ),
    ];

    await save(seeded);
    return seeded;
  }

  static Future<void> addFromDoctor({
    required Doctor doctor,
    required String date,
    required String time,
    String userId = '1',
  }) async {
    final appointments = await load();
    final newAppointment = Appointment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: userId,
      doctorId: doctor.id,
      doctorName: doctor.name,
      doctorSpecialty: doctor.specialty.displayName,
      date: date,
      time: time,
      status: AppointmentStatus.upcoming,
      price: doctor.price,
    );

    appointments.insert(0, newAppointment);
    await save(appointments);
  }

  static Future<void> updateStatus({
    required String appointmentId,
    required AppointmentStatus status,
  }) async {
    final appointments = await load();
    final idx = appointments.indexWhere((a) => a.id == appointmentId);
    if (idx == -1) {
      return;
    }

    final a = appointments[idx];
    appointments[idx] = Appointment(
      id: a.id,
      userId: a.userId,
      doctorId: a.doctorId,
      doctorName: a.doctorName,
      doctorSpecialty: a.doctorSpecialty,
      date: a.date,
      time: a.time,
      status: status,
      price: a.price,
    );

    await save(appointments);
  }
}
