//
//  BuildingDetails.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-06-02.
//

import Foundation
// MARK: - BuildingResponse
struct BuildingDetailsResponse: Codable {
    let returnCode: Int
    let data: BuildingDetails
    let errors: [String]?
}
// MARK: - BuildingDetails
struct BuildingDetails: Codable {
    let building: Building
    let properties: [Property]
}
// MARK: - Building
struct Building: Codable {
    let buildingID: Int
    let buildingName, address: String
    let latitude, longitude: Double
    let yearBuilt: Int
    let builder: String
    let thumbnail: String
    let description: String
    let aboutNeighbourhood: String?
    let media: [Media]
    let amenities: [Amenity]
}
// MARK: - Amenity
struct Amenity: Codable {
    let name: String
    let logoURL: String?
}
// MARK: - Media
struct Media: Codable {
    let url: String
    let type: Int
}
// MARK: - Property
struct Property: Codable {
    let propertyID, address: String
    let thumbnail: String
    let bedroom, bathroom: Int?
    let targetPrice: Int
    let area: String?
    let isLiked, isDisliked: Bool?
    let isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case propertyID = "propertyId"
        case address, thumbnail, bedroom, bathroom, targetPrice, area, isLiked, isDisliked, isFavorite
    }
}
