//
//  WeatherDataViewModel.swift
//  Jaykishan_Weather_App_Demo
//
//  Created by Chalo-MBP2 on 20/01/22.
//

import Foundation

class WeatherDataViewModel {
    
    var weatherData : weatherDataList?
    
    func fetchWeatherInfoAPI(params : [String:Any],
                        completion: @escaping (Bool,String) -> Void) {
        NetworkManager.share.fetchWeatherInfo(param: params) { response in
            switch response {
            case .success(let resData) :
                self.weatherData = resData
                completion(true,"")
            case .failure(let err) :
                completion(false, err.localizedDescription)
            }
        }
    }
}
