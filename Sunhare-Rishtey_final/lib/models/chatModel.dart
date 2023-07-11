
class ChatModel implements Comparable {
  final String? uid;
  final String? message;
  final DateTime? date;
  final String? nameOfCustomer;
  final String? imageURL;
  String? messageID;
  String? likes;
  static String? currentUser;

  ChatModel({
    this.likes,
    this.uid,
    this.message,
    this.date,
    this.nameOfCustomer,
    this.imageURL,
    this.messageID,
  });

  @override
  int compareTo(other) {
    return date!.compareTo(other.date);
  }

}
