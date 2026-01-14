import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/appointment.dart';
import '../services/appointments_store.dart';

class AppointmentsScreen extends StatefulWidget {
  final AppointmentStatus? initialTab;

  const AppointmentsScreen({
    super.key,
    this.initialTab,
  });

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final initialStatus = widget.initialTab;
    if (initialStatus != null) {
      _tabController.index = _tabIndexForStatus(initialStatus);
    }
    _loadAppointments();
  }

  int _tabIndexForStatus(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.upcoming:
        return 0;
      case AppointmentStatus.completed:
        return 1;
      case AppointmentStatus.cancelled:
        return 2;
    }
  }

  Future<void> _loadAppointments() async {
    final loaded = await AppointmentsStore.ensureSeeded();
    if (!mounted) return;
    setState(() {
      _appointments = loaded;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Appointment> _appointments = [];

  List<Appointment> _getAppointmentsByStatus(AppointmentStatus status) {
    final filteredAppointments = _appointments.where((apt) => apt.status == status).toList();
    print('Getting appointments for status: ${status.displayName}, found: ${filteredAppointments.length}');
    return filteredAppointments;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                                  Icons.payments,
                                  size: 20,
                                  color: const Color(0xFF10B981),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'KSh ${appointment.price}',
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
                                    // Optimistic local update
                                    final appointmentIndex = _appointments.indexWhere(
                                      (apt) => apt.id == appointment.id,
                                    );
                                    if (appointmentIndex != -1) {
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
                                    }
                                  });
                                  AppointmentsStore.updateStatus(
                                    appointmentId: appointment.id,
                                    status: AppointmentStatus.cancelled,
                                  );
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
