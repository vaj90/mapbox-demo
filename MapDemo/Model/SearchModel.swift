//
//  SearchModel.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-04-22.
//

import Foundation


struct SearchModel: Codable {
    var searchOption: SearchOption?
}

struct SearchOption: Codable {
    var optionType: String?
    var rentBudget: Int?
    var buyBudget: Int?
    var noOfBedroom: Int?
}
