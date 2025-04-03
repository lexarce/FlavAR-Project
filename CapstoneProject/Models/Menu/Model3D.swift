//
//  Model3D.swift
//  CapstoneProject
//
//  Created by kimi on 4/3/25.
//


import Foundation

struct Model3D: Identifiable, Codable {
    var id = UUID().uuidString
    var name: String
    var fileURL: String
    var dateCreated: Date
}
