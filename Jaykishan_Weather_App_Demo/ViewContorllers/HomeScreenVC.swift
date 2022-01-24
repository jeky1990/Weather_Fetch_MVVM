//
//  ViewController.swift
//  Jaykishan_Weather_App_Demo
//
//  Created by Chalo-MBP2 on 20/01/22.
//

import UIKit
import Disk

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
        self.fetchData()
        self.setUpObserver()
    }
    
    func fetchData() {
        do {
            let local_Data = try? Disk.retrieve(WEATHER_DATA_FILE_NAME, from: .documents, as: [WeatherData].self)
            if local_Data != nil {
                self.weatherDataList = local_Data ?? []
                CommonFunction.fetchDataFromLocalParam { data in
                    DispatchQueue.main.async {
                        self.weatherDataList = data?.list ?? []
                    }
                }
            }
        }
    }
    
    func setUpObserver() {
        NotificationCenter.default.removeObserver(self, name: INTERNET_OBSERVER, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeInternet(notification:)), name: INTERNET_OBSERVER, object: nil)
    }
    
    @objc func changeInternet(notification: NSNotification) {
        if let info = notification.userInfo {
            if let availbele = info["availbele"] as? Bool {
                if availbele {
                    CommonFunction.fetchDataFromLocalParam { data in
                        DispatchQueue.main.async {
                            self.weatherDataList = data?.list ?? []
                        }
                    }
                }
            }
        }
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
    func dataFatched(wData: weatherDataList?, paramData : urlParam?) {
        self.weatherDataList = wData?.list ?? []
        do {
            try Disk.save(self.weatherDataList, to: .documents, as: WEATHER_DATA_FILE_NAME)
            try Disk.save(paramData, to: .documents, as: WEATHER_PARAM_NAME)
        } catch {
            print(error.localizedDescription)
        }
    }
}

