import SwiftUI
import FirebaseCore
import GoogleMobileAds

@main
struct NotesAppApp: App {
    
    
    init()
    {
        FirebaseApp.configure()
        MobileAds.shared.start()
        print("firebase initilize successfully")
    }
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
