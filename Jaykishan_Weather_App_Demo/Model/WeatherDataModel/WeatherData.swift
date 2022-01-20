//
//  ErrorModel.swift
//  Jaykishan_Weather_App_Demo
//
//  Created by Chalo-MBP2 on 20/01/22.
//

import Foundation
struct WeatherData : Codable {
	let weather : [Weather]?
	let main : Main?
	let id : Int?
	let name : String?

	enum CodingKeys: String, CodingKey {

		
		case weather = "weather"
		case main = "main"
		case id = "id"
		case name = "name"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
		main = try values.decodeIfPresent(Main.self, forKey: .main)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
	}

}
