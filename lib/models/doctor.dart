enum Specialty {
  CARDIOLOGY('Cardiology'),
  DERMATOLOGY('Dermatology'),
  PEDIATRICS('Pediatrics'),
  NEUROLOGY('Neurology'),
  ORTHOPEDICS('Orthopedics'),
  GENERAL('General Practice'),
  PSYCHIATRY('Psychiatry'),
  ONCOLOGY('Oncology');

  const Specialty(this.displayName);
  final String displayName;
}

class Doctor {
  final String id;
  final String name;
  final Specialty specialty;
  final int experience;
  final double rating;
  final int reviews;
  final int price; // in Kenyan Shillings
  final String about;
  final List<String> availability;
  final String image;
  final String hospital;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.about,
    required this.availability,
    required this.image,
    required this.hospital,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialty: Specialty.values.firstWhere(
        (s) => s.displayName == json['specialty'],
        orElse: () => Specialty.GENERAL,
      ),
      experience: json['experience'],
      rating: json['rating'].toDouble(),
      reviews: json['reviews'],
      price: json['price'],
      about: json['about'],
      availability: List<String>.from(json['availability']),
      image: json['image'],
      hospital: json['hospital'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty.displayName,
      'experience': experience,
      'rating': rating,
      'reviews': reviews,
      'price': price,
      'about': about,
      'availability': availability,
      'image': image,
      'hospital': hospital,
    };
  }
}

// Initial doctors data with Kenyan names and avatars
final List<Doctor> initialDoctors = [
  Doctor(
    id: '1',
    name: 'Dr. Amina Ochieng',
    specialty: Specialty.CARDIOLOGY,
    experience: 12,
    rating: 4.9,
    reviews: 124,
    price: 15000, // KES 15,000
    about: 'Experienced cardiologist specializing in heart failure and preventive cardiology. Graduated from University of Nairobi Medical School.',
    availability: ['09:00 AM', '10:30 AM', '02:00 PM', '04:30 PM'],
    image: 'avatar',
    hospital: 'Kenyatta National Hospital',
  ),
  Doctor(
    id: '2',
    name: 'Dr. Joseph Kamau',
    specialty: Specialty.DERMATOLOGY,
    experience: 8,
    rating: 4.8,
    reviews: 89,
    price: 12000, // KES 12,000
    about: 'Board-certified dermatologist focusing on medical and cosmetic skin treatments, including acne and skin cancer screenings.',
    availability: ['11:00 AM', '01:00 PM', '03:30 PM'],
    image: 'avatar',
    hospital: 'Nairobi Hospital',
  ),
  Doctor(
    id: '3',
    name: 'Dr. Grace Wanjiru',
    specialty: Specialty.PEDIATRICS,
    experience: 15,
    rating: 5.0,
    reviews: 210,
    price: 10000, // KES 10,000
    about: 'Dedicated pediatrician with a passion for child development and preventive healthcare for children of all ages.',
    availability: ['08:30 AM', '10:00 AM', '12:30 PM', '02:30 PM'],
    image: 'avatar',
    hospital: 'Mombasa Hospital',
  ),
  Doctor(
    id: '4',
    name: 'Dr. David Mutiso',
    specialty: Specialty.NEUROLOGY,
    experience: 10,
    rating: 4.7,
    reviews: 56,
    price: 18000, // KES 18,000
    about: 'Specialist in neurological disorders with a focus on migraines, epilepsy, and cognitive health.',
    availability: ['09:30 AM', '11:30 AM', '03:00 PM'],
    image: 'avatar',
    hospital: 'Aga Khan Hospital',
  ),
];
