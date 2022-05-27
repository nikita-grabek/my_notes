import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:success_planner/services/cloud/cloud_note.dart';
import 'package:success_planner/services/cloud/cloud_storage_constants.dart';
import 'package:success_planner/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  // Makes this class a singleton
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
  //

  final notes = FirebaseFirestore.instance.collection("notes");

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNoteDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      notes.doc(documentId).update({
        textFieldName: text,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map(
            (event) => event.docs
                .map(
                  (doc) => CloudNote.fromSnapshot(doc),
                )
                .where((note) => note.ownerUserUd == ownerUserId),
          );

  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserId,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudNote(
                  documentId: doc.id,
                  ownerUserUd: doc.data()[ownerUserIdFieldName],
                  text: doc.data()[textFieldName],
                );
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }
}
