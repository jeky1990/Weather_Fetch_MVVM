//
//  NetworkConstant.swift
//  Jaykishan_Weather_App_Demo
//
//  Created by Chalo-MBP2 on 20/01/22.
//

import Foundation
import Moya

enum API {
    case fetchWeatherInfo(param: [String:Any])
}

extension API : TargetType {
    
    var headers: [String : String]? {
        return ["Content-Type":"application/json"]
    }
    
    var baseURL: URL {
        return URL(string: BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .fetchWeatherInfo:
            return "/data/2.5/find"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchWeatherInfo:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .fetchWeatherInfo(let param):
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        }
    }
}
