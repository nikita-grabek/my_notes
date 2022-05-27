class CloudStorageException implements Exception {
  const CloudStorageException();
}

// CRUD exceptions
class CouldNotCreateNoteException extends CloudStorageException {}

class CouldNotGetAllNotesException extends CloudStorageException {}

class CouldNotUpdateNoteException extends CloudStorageException {}

class CouldNoteDeleteNoteException extends CloudStorageException {}
//
