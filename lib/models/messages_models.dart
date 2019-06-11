
class Message {
  const Message({this.text, this.isMine,this.sentTime,this.user});
  final bool isMine;
  final String text;
  final String user;
  final DateTime sentTime;
}


class MessageModel{
  const MessageModel({this.text, this.user,this.sentTime,this.userId});
  final String text;
  final String user;
  final DateTime sentTime;
  final String userId;
  Message toMessage(String currentUserId) {
    return new Message(
      text: this.text,
      user: this.user,
      sentTime: this.sentTime,
      isMine: currentUserId==userId
    );
  }

    factory MessageModel.fromJson(Map<String, dynamic> data) {
    return MessageModel(
      text: data['t'],
      user: data['u'],
      sentTime:  DateTime.parse(data['st']),
      userId: data['ui']
    );
  }

}