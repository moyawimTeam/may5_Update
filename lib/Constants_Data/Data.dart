import 'package:cloud_firestore/cloud_firestore.dart';

final jobsList = [];
getJobs() async {
  final QuerySnapshot result =
      await Firestore.instance.collection('Categories').getDocuments();
  final List<DocumentSnapshot> jobs = result.documents;
  jobs.forEach((data) {
    if (!jobsList.contains(data.documentID)) {
      jobsList.add(data.documentID);
    }
  });
}

var recentSearchHistory = [];

List<String> filterList = ["المنطقة", "الخبرة"];

List<String> cities = [
  'غير محدد',
  'بنت جبيل',
  'بعبدا',
  'بعلبك',
  'جزّين',
  'جونية',
  'الدامور',
  'دير القمر',
  'زحلة',
  'الشوف',
  'صور',
  'صيدا',
  'طرابلس',
  'عكار',
  'النبطيّة',
  'بيروت',
];

final firestoreCollections = [
  'Employers',
  'بلاط',
  'دهان',
  'وراق',
  'كهربائي منزل',
  'كهربائي سيارات',
  'عامل نظافة',
  'دلفري',
  'ميكانيكي',
  'حداد',
  'سكاف',
  'مزارع',
  'سنغري',
  'خادم منزل',
  'خياط',
  'حلاق',
  'نجار'
];
