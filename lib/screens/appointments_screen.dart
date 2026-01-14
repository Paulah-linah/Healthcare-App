import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/appointment.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Mock appointments data
  List<Appointment> _appointments = [
    Appointment(
      id: '1',
      userId: '1',
      doctorId: '1',
      doctorName: 'Dr. Sarah Wilson',
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
      doctorName: 'Dr. James Miller',
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
      doctorName: 'Dr. Emily Brown',
      doctorSpecialty: 'Pediatrics',
      date: '2024-01-20',
      time: '11:00 AM',
      status: AppointmentStatus.upcoming,
      price: 10000,
    ),
  ];

  List<Appointment> _getAppointmentsByStatus(AppointmentStatus status) {
    final filteredAppointments = _appointments.where((apt) => apt.status == status).toList();
    print('Getting appointments for status: ${status.displayName}, found: ${filteredAppointments.length}');
    return filteredAppointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        title: Text(
          'My Schedules',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF6366F1),
          unselectedLabelColor: const Color(0xFF94A3B8),
          indicatorColor: const Color(0xFF6366F1),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentsList(AppointmentStatus.upcoming),
          _buildAppointmentsList(AppointmentStatus.completed),
          _buildAppointmentsList(AppointmentStatus.cancelled),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(AppointmentStatus status) {
    final appointments = _getAppointmentsByStatus(status);

    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: const Color(0xFFCBD5E1),
            ),
            const SizedBox(height: 16),
            Text(
              'No ${status.displayName} appointments',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 400),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.local_hospital,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment.doctorName,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  appointment.doctorSpecialty,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                  color: const Color(0xFF6366F1),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appointment.date,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: const Color(0xFF6366F1),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appointment.time,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  size: 20,
                                  color: const Color(0xFF10B981),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'KES ${appointment.price}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (appointment.status == AppointmentStatus.upcoming) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    // Find and update appointment status to cancelled
                                    final appointmentIndex = _appointments.indexWhere((apt) => apt.id == appointment.id);
                                    if (appointmentIndex != -1) {
                                      print('Cancelling appointment: ${appointment.id}, current status: ${_appointments[appointmentIndex].status.displayName}');
                                      _appointments[appointmentIndex] = Appointment(
                                        id: appointment.id,
                                        userId: appointment.userId,
                                        doctorId: appointment.doctorId,
                                        doctorName: appointment.doctorName,
                                        doctorSpecialty: appointment.doctorSpecialty,
                                        date: appointment.date,
                                        time: appointment.time,
                                        status: AppointmentStatus.cancelled,
                                        price: appointment.price,
                                      );
                                      print('Updated appointment status to: ${_appointments[appointmentIndex].status.displayName}');
                                    }
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Appointment cancelled'),
                                      backgroundColor: Color(0xFFEF4444),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFEF4444)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Color(0xFFEF4444)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Appointment rescheduled'),
                                      backgroundColor: Color(0xFF6366F1),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6366F1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Reschedule'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
