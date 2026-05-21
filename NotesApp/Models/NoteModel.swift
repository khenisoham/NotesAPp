import Foundation
import FirebaseFirestore

struct NoteModel : Identifiable {
    
    var id : String
    var title : String
    var description : String
    var createdAt : Timestamp
    var updatedAt : Timestamp
       var isFavorite : Bool
}

