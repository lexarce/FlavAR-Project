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
