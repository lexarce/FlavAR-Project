//
//  UserInfo.swift
//  CapstoneProject
//
//  Created by Kaleb on 2/16/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

//Object for storing user data
struct UserInfo: Codable, Identifiable {
    var id: String
    var firstName: String
    var lastName: String
    var emailAddress: String
    var phoneNumber: String
    var isAdmin: Bool
}

class UserInfoManager: ObservableObject {
    @Published var userInfo: UserInfo?

    private var db = Firestore.firestore()

    func fetchUserInfo() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user is currently signed in.")
            return
        }
        
        db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }
            
            if let document = document, document.exists, let data = document.data() {
                let user = UserInfo(
                    id: userID,
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "",
                    emailAddress: data["emailAddress"] as? String ?? "",
                    phoneNumber: data["phoneNumber"] as? String ?? "",
                    isAdmin: data["isAdmin"] as? Bool ?? false
                )
                
                DispatchQueue.main.async {
                    self.userInfo = user
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
}
