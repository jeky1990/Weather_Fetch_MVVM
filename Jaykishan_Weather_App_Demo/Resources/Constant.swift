//
//  Constant.swift
//  Jaykishan_Weather_App_Demo
//
//  Created by Chalo-MBP2 on 20/01/22.
//

import Foundation
import UIKit

let MAIN_STORYBOARD = UIStoryboard(name: "Main", bundle: nil)


//MARK:-VC Identifires
let HOME_VC_IDNET = "HomeScreenVC"
let PLACE_SEL_V_IDENT = "PlaceSelectionVC"
let WEATHER_DETAIL_VC_IDENT = "WeatherDetailVC"

//URL
let BASE_URL = "http://api.openweathermap.org"

//KEY
let VALIDATE_API_KEY = "ddaaf58d56715b6bd266e810e294ccc2"

let WEATHER_DATA_FILE_NAME = "weather_data.json"
let WEATHER_PARAM_NAME = "urlParameter.json"

let INTERNET_OBSERVER = Notification.Name(rawValue: "INTERNET.OBSERVER")
