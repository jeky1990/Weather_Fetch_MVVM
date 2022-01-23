//
//  ViewController.swift
//  Jaykishan_Weather_App_Demo
//
//  Created by Chalo-MBP2 on 20/01/22.
//

import Foundation
import UIKit

let sharedInstanceCF = CommonFunction()

class CommonFunction : NSObject {
    
    var reachability:Reachability?
    
    class func isInternetAvailable() -> Bool
    {
        let reachability:Reachability = Reachability()!
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
}
