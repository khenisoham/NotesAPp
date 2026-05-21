import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct AddNoteView: View {
    
    @State private var title = ""
    @State private var description = ""
    var note : NoteModel?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
                TextField("Title", text: $title)
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                TextEditor(text: $description)
                    .scrollContentBackground(.hidden)
                    .foregroundColor(.white)
                    .frame(height: 300)
                
                Spacer()
                
                Button {
                    
                    if note == nil {
                           
                           saveNote()
                           
                       } else {
                           
                           updateNote()
                       }
                    
                } label: {
                    
                    Text(note == nil ? "Save Note" : "Update Note")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(15)
                }
            }
            .padding()
        }
        .onAppear
        {
            if let note = note
            {
                title = note.title
                description = note.description
            }
        }
    }
    func saveNote()
    {
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document("demoUser")
            .collection("notes")
            .addDocument(data: [
                
                "title" : title,
                "description" : description,
                "createdAt" : Timestamp(),
                "updatedAt" : Timestamp(),
                "isFavorite" : false
            ]) { error in
            
            if error == nil
            {
                dismiss()
            }
        }
    }
    func updateNote()
    {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document("demoUser")
            .collection("notes")
            .document(note?.id ?? "")
            .updateData([
                
                "title" : title,
                "description" : description,
                "updatedAt" : Timestamp()
            ]) { error in
                
                if error == nil
                {
                    dismiss()
                }
            }
    }
}
#Preview {
    AddNoteView()
}
