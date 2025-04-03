//
//  UserInfoManager.swift
//  CapstoneProject
//
//  Created by Kaleb
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserInfoManager {
    
    private let db = Firestore.firestore()

    // fetches user info from Firestore and returns it via a completion handler
    func fetchUserInfo(completion: @escaping (UserInfo?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user is currently signed in.")
            completion(nil)
            return
        }

        db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                completion(nil)
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
                completion(user)
            } else {
                print("Document does not exist.")
                completion(nil)
            }
        }
    }
}
