//
//  ViewController.swift
//  Jaykishan_Weather_App_Demo
//
//  Created by Chalo-MBP2 on 20/01/22.
//

import UIKit

class HomeScreenVC : UIViewController {

    @IBOutlet weak var savedPlaceTableView: UITableView!
    
    var weatherDataList = [WeatherData]() {
        didSet {
            DispatchQueue.main.async {
                self.savedPlaceTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

//MARK:- TableView Delegate and DataSource
extension HomeScreenVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "savedPlaceCell") {
            
            if self.weatherDataList.count > indexPath.row {
                let wdata = self.weatherDataList[indexPath.row]
                cell.textLabel?.text = wdata.name
                cell.detailTextLabel?.text = CommonFunction.temperatureFormatter(temp: wdata.main?.temp ?? 0.0)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.weatherDataList.count > indexPath.row {
            let wdata = self.weatherDataList[indexPath.row]
            
            if let nav = MAIN_STORYBOARD.instantiateViewController(withIdentifier: WEATHER_DETAIL_VC_IDENT) as? WeatherDetailVC {
                
                nav.weatheData = wdata
                
                self.navigationController?.pushViewController(nav, animated: true)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- All Actions
extension HomeScreenVC {
    @IBAction func addPlaceButtonAction(_ sender : UIBarButtonItem) {
        if let nav = MAIN_STORYBOARD.instantiateViewController(withIdentifier: PLACE_SEL_V_IDENT) as? PlaceSelectionVC {
            nav.delegate = self
            self.navigationController?.pushViewController(nav, animated: true)
        }
    }
}

//MARK:- Place VC delegate
extension HomeScreenVC  : PlaceSelectionVCDelegate {
    func dataFatched(wData: weatherDataList?) {
        self.weatherDataList = wData?.list ?? []
    }
}

