//
//  PrayerTimeViewController.swift
//  KitabMubin
//
//  Created by Moamen Abd Elgawad on 16/10/2022.
//

import UIKit
import CoreLocation
import DropDown

class PrayerTimeViewController: BaseViewController, CLLocationManagerDelegate {
    
    // MARK: - init Module
    static func initModule() -> PrayerTimeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PrayerTimeViewController") as! PrayerTimeViewController
        return vc
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var countryTextField: CustomTextField!
    @IBOutlet weak var cityTextField: CustomTextField!
    
    @IBOutlet weak var countryArrowImageView: UIImageView!
    @IBOutlet weak var cityArrowImageView: UIImageView!
    
    // MARK: - Properties
    private var cityTitle: String?
    private var citiesDropDown = DropDown()
    private var countryDropDown = DropDown()
    private var countries = [CountriesModel]()
    
    private var viewModel: PrayerTimesViewModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func assignDelegates() {
        super.assignDelegates()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func registerCells() {
        super.registerCells()
        tableView.registerCellNib(cellClass: PrayerTimeTableViewCell.self)
    }
    
    override func setupAppearance() {
        super.setupAppearance()
        setUpDropDownList()
        
        countryArrowImageView.transform = .init(rotationAngle: -(.pi / 2))
        cityArrowImageView.transform = .init(rotationAngle: -(.pi / 2))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back-Nav")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(closeDidTap))
    }
    
}

// MARK: - View controller lifecycle methods
extension PrayerTimeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
//        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        loadCountries()
        loadForLastSelection()
    }
}

// MARK: - Private Methods
extension PrayerTimeViewController {
    private func loadData(country:String,city:String) {
//        let location = CLLocation(latitude: LocationService.shared.latitude, longitude: LocationService.shared.longitude)
//        location.fetchCity { [weak self] city, error in
//            guard let city = city, error == nil
//            else {
//                self?.hideLoadingIndicator()
//                self?.showAlertError(title: "حدث خطأ", body: "برجاء المحاولة في وقت لاحق")
//                return
//            }
//            print(city)
//            self?.cityTitle = city
//        }


//        location.fetchCountry { country, error in
            let country = country.replacingOccurrences(of: " ", with: "%20")
            let city = city.replacingOccurrences(of: " ", with: "%20")
        
//            print(country)
//            let country = "Palestine"
        showLoadingIndicator()
        NetworkManager.shared.fetchData(model: PrayerTimesEntityResponse.self, endpoint: .prayerTimes(address: "\(country)%20,%20\(city)"), method: .get) { [weak self] response in
                switch response {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.viewModel = PrayerTimesViewModel(dataSource: data?.data)
                        self?.hideLoadingIndicator()
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self?.hideLoadingIndicator()
                        if city != ""{
                            self?.showAlertError(title: "حدث خطأ", body: "برجاء المحاولة في وقت لاحق")
                        }
                    }
                }
            }
        
//        }
    }
    
    private func loadCountries(){
        JsonLoader.shared.loadJsonDataFromFile("countries") { data in
            if let jsonData = data {
                do {
                    let decodedData = try JSONDecoder().decode([CountriesModel].self, from: jsonData)
                    DispatchQueue.main.async { [weak self] in
                        self?.countries = decodedData
                        self?.countryDropDown.dataSource = decodedData.map{$0.name ?? ""}
                        self?.hideLoadingIndicator()
                        
                        let cities = self?.countries.first(where: {$0.name == UserDefaults.standard.string(forKey: "PrayerTimeSelectedCountry") ?? ""})?.citties ?? []
                        self?.citiesDropDown.dataSource = cities.map({$0.name ?? ""})
                    }
                }
                catch {
                    hideLoadingIndicator()
                    showMessage(message: error.localizedDescription)
                }
            }
        }
    }
    
    
    private func setUpDropDownList(){
        // citiesDropDown
        citiesDropDown.cornerRadius = 5
        citiesDropDown.anchorView = cityTextField
        citiesDropDown.bottomOffset = CGPoint(x: 0, y:(citiesDropDown.anchorView?.plainView.bounds.height)!)
         
        citiesDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            cityArrowImageView.transform = .init(rotationAngle: -(.pi / 2))
            cityTextField.text = item
            cityTitle = "\(countryTextField.text!),\(item)"
            UserDefaults.standard.set(item, forKey: "PrayerTimeSelectedCity")
            loadData(country: countryTextField.text!, city: item)
        }
        
        citiesDropDown.cancelAction = { [unowned self] in
            cityArrowImageView.transform = .init(rotationAngle: (.pi / 2))
        }
        
        cityTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(citiesAction)))
        
        
        // countryDropDown
        countryDropDown.cornerRadius = 5
        countryDropDown.anchorView = countryTextField
        countryDropDown.bottomOffset = CGPoint(x: 0, y:(countryDropDown.anchorView?.plainView.bounds.height)!)
        
        countryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            countryArrowImageView.transform = .init(rotationAngle: -(.pi / 2))
            countryTextField.text = item
            let cities = countries.first(where: {$0.name == item})?.citties ?? []
            citiesDropDown.dataSource = cities.map({$0.name ?? ""})
            cityTextField.text = ""
            cityTitle = item
            UserDefaults.standard.set(item, forKey: "PrayerTimeSelectedCountry")
            loadData(country: item, city: "")
        }
        
        countryDropDown.cancelAction = { [unowned self] in
            countryArrowImageView.transform = .init(rotationAngle: (.pi / 2))
        }
        
        countryTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(countryAction)))
    }
    
    private func loadForLastSelection(){
        let country = UserDefaults.standard.string(forKey: "PrayerTimeSelectedCountry") ?? ""
        let city = UserDefaults.standard.string(forKey: "PrayerTimeSelectedCity") ?? ""
        countryTextField.text = country
        cityTextField.text = city
        
        loadData(country: country, city: city)
    }
    
}

// MARK: - IBActions
extension PrayerTimeViewController {
}

extension PrayerTimeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel?.numberOfRowsInSection ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as PrayerTimeTableViewCell
        switch indexPath.section {
        case 0:
            cell.dataSource = PrayerTimeCellViewModel(title: cityTitle, subtitle: viewModel?.getCurrentDate(), iconName: "gps")
        default:
            cell.dataSource = viewModel?.dataSource(for: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 24
        }
    }
    
}

// MARK: - Selectors
extension PrayerTimeViewController {
    @objc
    private func closeDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func citiesAction(){
        self.cityArrowImageView.transform = .init(rotationAngle: (.pi / 2))
        self.citiesDropDown.show()
    }
    
    @objc
    private func countryAction(){
        self.countryArrowImageView.transform = .init(rotationAngle: (.pi / 2))
        self.countryDropDown.show()
    }
}
