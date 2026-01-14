import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_button.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final List<String> _symptoms = [
    'Headache',
    'Fever',
    'Cough',
    'Fatigue',
    'Nausea',
    'Dizziness',
    'Chest Pain',
    'Shortness of Breath',
    'Other'
  ];

  final List<String> _selectedSymptoms = [];
  final TextEditingController _otherController = TextEditingController();

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  void _submitAssessment() {
    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one symptom'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Analyzing symptoms...'),
          ],
        ),
      ),
    );

    // Simulate AI analysis
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close loading dialog
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Assessment Complete'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Based on your symptoms:'),
              const SizedBox(height: 8),
              Text(
                _selectedSymptoms.join(', '),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Recommendation:'),
              const Text('• Consult a healthcare professional'),
              const Text('• Monitor your symptoms'),
              const Text('• Rest and stay hydrated'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to home
              },
              child: const Text('Book Appointment'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Assessment'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What symptoms are you experiencing?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select all that apply',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _symptoms.length,
                itemBuilder: (context, index) {
                  final symptom = _symptoms[index];
                  final isSelected = _selectedSymptoms.contains(symptom);
                  
                  return GestureDetector(
                    onTap: () => _toggleSymptom(symptom),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF6366F1) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          symptom,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF475569),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            if (_selectedSymptoms.contains('Other')) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _otherController,
                decoration: InputDecoration(
                  hintText: 'Please describe your symptoms',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF6366F1)),
                  ),
                ),
                maxLines: 3,
              ),
            ],
            
            const SizedBox(height: 24),
            
            CustomButton(
              text: 'Submit Assessment',
              onPressed: _submitAssessment,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
