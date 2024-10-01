class Ask {
  const Ask({
    required this.uid,
    required this.title,
    required this.description,
    required this.creatorUID,
    required this.deadlineDate,
    required this.targetDonationSum,
    required this.currentDonationSum,
  });

  final String uid;
  final String creatorUID;
  final String title;
  final String description;
  final String deadlineDate;
  final String targetDonationSum;
  final String currentDonationSum;
}