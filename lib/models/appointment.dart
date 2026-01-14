enum AppointmentStatus {
  upcoming('upcoming'),
  completed('completed'),
  cancelled('cancelled');

  const AppointmentStatus(this.displayName);
  final String displayName;
}

class Appointment {
  final String id;
  final String userId;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String date;
  final String time;
  final AppointmentStatus status;
  final int price; // in Kenyan Shillings

  Appointment({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.date,
    required this.time,
    required this.status,
    required this.price,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      userId: json['userId'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      doctorSpecialty: json['doctorSpecialty'],
      date: json['date'],
      time: json['time'],
      status: AppointmentStatus.values.firstWhere(
        (s) => s.displayName == json['status'],
        orElse: () => AppointmentStatus.upcoming,
      ),
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorSpecialty': doctorSpecialty,
      'date': date,
      'time': time,
      'status': status.displayName,
      'price': price,
    };
  }
}
