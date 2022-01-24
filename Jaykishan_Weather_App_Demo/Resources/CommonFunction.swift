//
//  ViewController.swift
//  Jaykishan_Weather_App_Demo
//
//  Created by Chalo-MBP2 on 20/01/22.
//

import Foundation
import UIKit
import Disk

struct urlParam : Codable {
    var lat : Double?
    var lng : Double?
}

let sharedInstanceCF = CommonFunction()

class CommonFunction : NSObject {
    
    var reachability:Reachability?
    
    class func isInternetAvailable() -> Bool
    {
        let reachability:Reachability = Reachability()!
        do {
            try reachability.startNotifier()
        } catch let err {
            print(err.localizedDescription)
        }
        return reachability.isReachable
    }
    
    class func showAlertMessageWithTitle(aStrTitle : String, aStrMessage : String, Oktitle : String, CancelTitle : String, cancelHide : Bool = false, aViewController : UIViewController, CancelActionTap :@escaping (_ cancelAction: AnyObject) -> (), OKActionTap :@escaping (_ OkAction: AnyObject) -> ()) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: (aStrTitle != "" ? aStrTitle : nil), message: (aStrMessage != "" ? aStrMessage : nil), preferredStyle: .alert)
            if #available(iOS 13.0, *) {
                alertController.overrideUserInterfaceStyle = .light
            } else {
                // Fallback on earlier versions
            }
            let CancelAction = UIAlertAction(title: CancelTitle, style: .destructive) { (action:UIAlertAction!) in
                CancelActionTap([:] as AnyObject)
            }
            
            let OKAction = UIAlertAction(title: Oktitle, style: .default) { (action:UIAlertAction!) in
                OKActionTap([:] as AnyObject)
            }
            if cancelHide == false {
                alertController.addAction(CancelAction)
            }
            alertController.addAction(OKAction)
            
            aViewController.present(alertController, animated: true, completion:nil)
        }
    }
    
    class func temperatureFormatter(temp: Double) -> String {
        let measurement = Measurement(value: temp, unit: UnitTemperature.celsius)

        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .medium
        measurementFormatter.numberFormatter.maximumFractionDigits = 1
        measurementFormatter.unitOptions = .providedUnit

        return measurementFormatter.string(from: measurement)
    }
    
    class func fetchDataFromLocalParam(completion : @escaping (_ data : weatherDataList?) -> ()) {
        do {
            let paramData = try? Disk.retrieve(WEATHER_PARAM_NAME, from: .documents, as: urlParam.self)
            
            if paramData != nil {
                if CommonFunction.isInternetAvailable() {
                    
                    SKActivityIndicator.show()
                    
                    let weatheVM = WeatherDataViewModel()
                    
                    let param = [ "lat" : paramData?.lat ?? 0.0,
                                  "lon" : paramData?.lng ?? 0.0,
                                  "units" : "metric",
                                  "cnt" : 15,
                                  "appid" : VALIDATE_API_KEY] as [String : Any]
                    
                    weatheVM.fetchWeatherInfoAPI(params: param) { status, msg in
                        DispatchQueue.main.async {
                            SKActivityIndicator.dismiss()
                            completion(weatheVM.weatherData)
                        }
                    }
                }
            }
        }
    }
}
