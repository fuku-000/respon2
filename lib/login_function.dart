import 'package:firebase_auth/firebase_auth.dart';

//ログイン間数
Future<bool> loginUser(String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user != null; // 成功した場合はtrueを返す
  } on FirebaseAuthException catch (e) {
    // エラーハンドリング
    print('エラー: $e');
    return false; // 失敗した場合はfalseを返す
  }
}

//アカウントを作成する間数
//database (firestore)にユーザー情報を登録するのは未実装
Future<bool> signupUser(String username, String email, String password) async {
  try {
    //
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    return userCredential.user != null; //成功した場合はTrueを返す
  } on FirebaseAuthException catch (e) {
    //エラーハンドリング
    print('エラー: $e');
    return false; //失敗してたらfalseを返す
  }
}
