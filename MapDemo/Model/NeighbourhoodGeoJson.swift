//
//  NeighbourhoodGeoJson.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-05-07.
//


struct GeoJsonModel:Codable {
    let type: String
    let features: [Feature]
}
// MARK: - Feature
struct Feature: Codable {
    let type: String
    let properties: Properties
    let geometry: Geometry
}
// MARK: - Properties
struct Properties: Codable{
    let propertyID: Int
    let title, description: String

    enum CodingKeys: String, CodingKey {
        case propertyID = "propertyId"
        case title, description
    }
}
// MARK: - Geometry
struct Geometry: Codable {
    let coordinates: [[[Double]]]
    let type: String
}
