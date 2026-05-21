import SwiftUI
import FirebaseFirestore

struct HomeView: View {
    
    @State private var notes : [NoteModel] = []
    @State private var goToAddNote = false
    
    var body: some View {
        NavigationStack
        {
            ZStack(alignment: .bottomTrailing)
            {
                Color.black
                    .ignoresSafeArea()
                
                VStack(alignment: .leading)
                {
                    HStack
                    {
                        Text("Notes")
                            .frame(maxWidth: .infinity)
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .padding()
                    }
                    ScrollView
                    {
                        VStack(spacing: 15)
                        {
                            ForEach(notes) { note in
                                
                                NavigationLink
                                {
                                    AddNoteView(note: note)
                                    
                                } label: {
                                    
                                    VStack(alignment: .leading, spacing: 10)
                                    {
                                        Text(note.title)
                                            .font(.title3.bold())
                                            .foregroundColor(.white)
                                        
                                        Text(formatDate(note.updatedAt.dateValue()))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(20)
                                    .padding(.horizontal)
                                }
                                .contextMenu {
                                    
                                    Button(role: .destructive) {
                                        
                                        deleteNote(noteId: note.id)
                                        
                                    } label: {
                                        
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    BannerAdView()
                        .frame(height: 50)
                }
                Button {

                    InterstitialAdManager.shared.showAd {

                        goToAddNote = true
                    }

                } label: {

                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.black)
                        .frame(width: 60, height: 60)
                        .background(Color.yellow)
                        .clipShape(Circle())
                        .padding()
                }
            }
            .onAppear
            {
                FetchNotes()
                
                InterstitialAdManager.shared.loadAd()
            }
            NavigationLink("", isActive: $goToAddNote) {
                AddNoteView()
            }
            
        }
    }
    func FetchNotes()
    {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document("demoUser")
            .collection("notes")
            .addSnapshotListener { snapshot, error in
                
                if let error = error
                {
                    print(error.localizedDescription)
                    return
                }
                guard let documents = snapshot?.documents else
                {
                    return
                }
                notes.removeAll()
                
                documents.forEach { doc in
                    
                    let data = doc.data()
                    
                    let note = NoteModel(
                        id: doc.documentID,
                        title: data["title"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        createdAt: data["createdAt"] as? Timestamp ?? Timestamp(),
                        updatedAt: data["updatedAt"] as? Timestamp ?? Timestamp(),
                        isFavorite: data["isFavorite"] as? Bool ?? false
                    )
                    notes.append(note)
                }
            }
    }
    func deleteNote(noteId : String)
    {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document("demoUser")
            .collection("notes")
            .document(noteId)
            .delete { error in
                
                if let error = error
                {
                    print(error.localizedDescription)
                    return
                }
                print("Note Deleted")
            }
    }
    func formatDate(_ date: Date) -> String
    {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
}
#Preview {
    HomeView()
}
