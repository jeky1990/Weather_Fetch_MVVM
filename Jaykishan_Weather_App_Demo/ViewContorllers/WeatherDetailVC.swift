//
//  WeatherDetailVC.swift
//  Jaykishan_Weather_App_Demo
//
//  Created by Jaykishan Moradiya on 22/01/22.
//

import UIKit

class WeatherDetailVC: UIViewController {
    
    @IBOutlet weak var descLabel : UILabel!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var maxTempLabel : UILabel!
    @IBOutlet weak var minTempLabel : UILabel!
    
    var weatheData : WeatherData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpData()
    
    }
    
    func setUpData() {
        self.descLabel.text = self.weatheData?.weather?.first?.description
        self.nameLabel.text = self.weatheData?.name
        self.maxTempLabel.text = CommonFunction.temperatureFormatter(temp: self.weatheData?.main?.temp_max ?? 0.0)
        self.minTempLabel.text = CommonFunction.temperatureFormatter(temp: self.weatheData?.main?.temp_min ?? 0.0)
    }

}
