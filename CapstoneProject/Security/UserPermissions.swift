//
//  UserPermissions.swift
//  CapstoneProject
//
//  Created by Kaleb on 10/22/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// Function to check if the current user has admin access
func checkUserAdminStatus(completion: @escaping (Bool?, Error?) -> Void) {
    guard let userId = Auth.auth().currentUser?.uid else {
        print("No user is currently signed in.")
        completion(nil, nil) // Return nil if no user is signed in
        return
    }
    
    let db = Firestore.firestore()
    
    // Fetch the user's document from Firestore
    db.collection("users").document(userId).getDocument { (document, error) in
        if let error = error {
            print("Error fetching document: \(error)")
            completion(nil, error) // Return the error if fetching fails
            return
        }
        
        if let document = document, document.exists {
            
            let isAdmin = document.data()?["isAdmin"] as? Bool ?? false
            
            completion(isAdmin, nil) // Return the admin status
            
        } else {
            print("Document does not exist.")
            
            completion(false, nil) // Return false if the document doesn't exist
        }
    }
}

//BELOW, COPY THE CODE TO USE THIS METHOD ANYWHERE IN THE PROJECT
//checkUserAdminStatus { isAdmin, error in
//    if let error = error {
//        print("Error checking admin status: \(error.localizedDescription)")
//    } else if let isAdmin = isAdmin {
//        if isAdmin {
//            print("User has admin access")
//            // Grant admin access in your app
//        } else {
//            print("User does not have admin access")
//            // Restrict access
//        }
//    }
//}
