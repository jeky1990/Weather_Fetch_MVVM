//
//  NetworkManager.swift
//  Jaykishan_Weather_App_Demo
//
//  Created by Chalo-MBP2 on 20/01/22.
//

import Foundation
import Moya

class NetworkManager : NSObject {
    
    static let share = NetworkManager()
    let provider = MoyaProvider<API>()
    
    func handleDecode<T>(result : Result<Moya.Response,MoyaError>,valueToDecode : @escaping (Result<T,Error>)->Void) where T: Codable {
        switch result {
        case .success(let response):
            do{
                print(try response.mapJSON())
                let json = try JSONDecoder().decode(T.self, from: response.data)
                switch response.statusCode {
                case 200...299:
                    valueToDecode(.success(json)).self
                    break
                case 300...599:
                    let jsonData = try JSONDecoder().decode(ErrorModel.self, from: response.data)
                    let data = handleError(data: jsonData)
                    valueToDecode(.failure(data))
                    break
                default:
                    break
                }
            } catch {
                valueToDecode(.failure(error))
            }
        case .failure(let error):
            valueToDecode(.failure(error))
            break
        }
    }
    
    func handleError(data : ErrorModel?) -> MoyaError {
        let errror = NSError.init(domain: "com.remuda", code: 0, userInfo: [NSLocalizedDescriptionKey: data?.message ?? ""])
        let error = MoyaError.underlying(errror, nil)
        return error
    }
    
    func fetchWeatherInfo(param: [String:Any],
                       completion:@escaping(Result<weatherDataList,Error>)->Void) {
        provider.request(.fetchWeatherInfo(param: param)) { result in
            self.handleDecode(result: result, valueToDecode: completion)
        }
    }
}
