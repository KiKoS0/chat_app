class ConversationModel {
  const ConversationModel({this.id, this.others});
  final List<String> others;
  final int id;

  Conversation toConversation() {
    return new Conversation(
      id: this.id,
      others: this.others
    );
  }

  factory ConversationModel.fromJson(Map<String, dynamic> data) {
    var others = data["others"];
    List<String> othersList = List<String>.from(others);
    return ConversationModel(
        id: data["convId"] as int, others: othersList);
  }
}

class Conversation {
  const Conversation({this.id, this.others});
  final List<String> others;
  final int id;
}
