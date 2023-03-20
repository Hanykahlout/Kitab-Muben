//
//  AzkarViewController.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 27/10/2022.
//

import UIKit
import FittedSheets

class AzkarViewController: BaseViewController {
    // MARK: - init Module
    static func initModule() -> AzkarViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AzkarViewController") as! AzkarViewController
        return vc
    }
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: AzkarViewModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func setupAppearance() {
        super.setupAppearance()
        view.backgroundColor = .white
        searchBar.setPlaceholderText(placeholer: "البحث عن الأذكار")
        navigationItem.title = "الأذكار"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back-Nav")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(closeDidTap))
    }
    
    override func registerCells() {
        super.registerCells()
        tableView.registerCellNib(cellClass: AzkarTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13, *) {
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13, *) {
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    // MARK: - Methods
    override func assignDelegates() {
        super.assignDelegates()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        loadData()
        NotificationCenter.default.addObserver(forName: .init("ReloadAzkar"), object: nil, queue: .main) { [weak self] notif in
            self?.loadData()
        }
    }
    
    private func loadData() {
        let azkar = RealmManager.sharedInstance.fetchObjects(ZekrModel.self) ?? []
        if azkar.isEmpty{
            JsonLoader.shared.loadJsonDataFromFile("Azkar1") { data in
                if let jsonData = data {
                    do {
                        let decodedData = try JSONDecoder().decode(AzkarModel.self, from: jsonData)
                        var azkar = [ZekrModel]()
                        for jsonZekar in decodedData.azkar ?? []{
                            let zekrModel = ZekrModel()
                            zekrModel.id = jsonZekar.id
                            zekrModel.name = jsonZekar.title ?? ""
                            zekrModel.date = nil
                            zekrModel.notification_id = nil
                            for desc in jsonZekar.desc ?? []{
                                let zekrDesc = ZekrDescriptionModel()
                                zekrDesc.id = desc.id
                                zekrDesc.title = desc.title ?? ""
                                zekrDesc.text = desc.text ?? ""
                                zekrDesc.times = desc.times ?? ""
                                RealmManager.sharedInstance.saveObject(zekrDesc)
                                zekrModel.descriptions.append(zekrDesc)
                            }
                            RealmManager.sharedInstance.saveObject(zekrModel)
                            azkar.append(zekrModel)
                        }
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.hideLoadingIndicator()
                            self?.viewModel = AzkarViewModel(dataSource: azkar)
                        }
                    }
                    catch {
                        hideLoadingIndicator()
                        showMessage(message: error.localizedDescription)
                    }
                }
            }
        }else{
            hideLoadingIndicator()
            viewModel = AzkarViewModel(dataSource: azkar)
        }
    }
    
    
}

extension AzkarViewController: UITableViewDelegate, UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as AzkarTableViewCell
        if viewModel?.filteredViewModels?.count != 0 {
            cell.dataSource = viewModel?.dataSourceForFilter(for: indexPath)
        } else {
            cell.dataSource = viewModel?.dataSource(for: indexPath)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.rowHeight ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if viewModel?.filteredViewModels?.count != 0 {
            guard let viewModel = viewModel?.dataSourceForFilter(for: indexPath) else { return }
            let vc = AzkarDetailsViewController(viewModel: viewModel,hasNotification: viewModel.notification_id != nil)
            navigationController?.pushViewController(vc, animated: false)
        } else {
            guard let viewModel = viewModel?.dataSource(for: indexPath) else { return }
            let vc = AzkarDetailsViewController(viewModel: viewModel,hasNotification: viewModel.notification_id != nil)
            navigationController?.pushViewController(vc, animated: false)
        }
        tableView.reloadData()
    }
}

// MARK: - Selectors
extension AzkarViewController {
    @objc
    private func closeDidTap() {
        navigationController?.popViewController(animated: true)
    }
}

extension AzkarViewController: AzkarTableViewCellDelegate {
    func notificationTapped(model:ZekrModel?) {
        guard let model = model else { return }
        let azkarNotificationVC = AzkarNotificationViewController(notificationState: model.notification_id == nil ? .new : .edit)
        azkarNotificationVC.model = model
        let sheetController = SheetViewController(controller: azkarNotificationVC, sizes: [.fixed(500)], options: nil)
        present(sheetController, animated: true, completion: nil)
    }
}

extension AzkarViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filteredViewModels = searchText.isEmpty ? viewModel?.viewModels : viewModel?.viewModels.filter { $0.name.contains(searchText) }
        tableView.reloadData()
    }
}

