import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<String> addQuizData(
      Map<String, dynamic> quizData, String quizId) async {
    DocumentReference quizDocumentReference =
        await FirebaseFirestore.instance.collection("Quiz").add(quizData);
    // update the members
    await quizDocumentReference.update({
      "quizId": quizDocumentReference.id,
    });
    return quizDocumentReference.id;
  }

  Future<void> addQuestionData(
      Map<String, dynamic> questionData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addPostQuestionData(
      Map<String, dynamic> questionData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("PostQNA")
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getQuizData() async {
    return FirebaseFirestore.instance.collection("Quiz").snapshots();
  }

  getsQuizData(String quizId) async {
    return FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }

  getsQuizVideo(String quizId) async {
    return FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("VIDEO")
        .get();
  }

  getsPostQuizData(String quizId) async {
    return FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("PostQNA")
        .get();
  }

  getReelsData() async {
    return FirebaseFirestore.instance.collection("reels").snapshots();
  }
}
