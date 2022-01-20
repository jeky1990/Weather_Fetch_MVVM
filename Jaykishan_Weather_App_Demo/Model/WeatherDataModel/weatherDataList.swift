//
//  ErrorModel.swift
//  Jaykishan_Weather_App_Demo
//
//  Created by Chalo-MBP2 on 20/01/22.
//

import Foundation
struct weatherDataList : Codable {
	let message : String?
	let cod : String?
	let count : Int?
	let list : [WeatherData]?

	enum CodingKeys: String, CodingKey {

		case message = "message"
		case cod = "cod"
		case count = "count"
		case list = "list"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		cod = try values.decodeIfPresent(String.self, forKey: .cod)
		count = try values.decodeIfPresent(Int.self, forKey: .count)
		list = try values.decodeIfPresent([WeatherData].self, forKey: .list)
	}

}
