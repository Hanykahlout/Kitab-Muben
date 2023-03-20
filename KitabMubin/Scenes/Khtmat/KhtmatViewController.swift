//
//  KhtmatViewController.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 22/11/2022.
//

import UIKit
import FittedSheets

protocol KhtmaDelegate: AnyObject {
    func addKtma(vm: KhtmaViewModel)
}

class KhtmatViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var viewModels: [KhtmaViewModel]? = [KhtmaViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCachedKhtmat()
    }
    
    override func setupAppearance() {
        navigationItem.title = "الختمات"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back-Nav")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(closeDidTap))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "PlusGroup")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(plusDidTap))
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13, *) {
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13, *) {
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    override func registerCells() {
        super.registerCells()
        tableView.registerCellNib(cellClass: KhtmatTableViewCell.self)
    }
    
    override func assignDelegates() {
        super.assignDelegates()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - Selectors
extension KhtmatViewController {
    @objc
    private func closeDidTap() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc
    private func plusDidTap() {
        let vc = KhtmaDetailsViewController(type: .new)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func fetchCachedKhtmat() {
        guard let results = RealmManager.sharedInstance.fetchObjects(KhtmaViewModel.self) else { return }
        if !results.isEmpty {
            viewModels = results
        } else {
            viewModels = []
        }
        tableView.reloadData()
    }
}

extension KhtmatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as KhtmatTableViewCell
        cell.dataSource = viewModels?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModels?[indexPath.row] else { return }
        let vc = KhtmaBottomSheet(vm: viewModel, indexPath: indexPath)
        vc.delegate = self
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(400)], options: nil)
        present(sheetController, animated: true, completion: nil)
    }
}

extension KhtmatViewController: KhtmaDelegate {
    func addKtma(vm: KhtmaViewModel) {
        let indexPath = IndexPath(row: ((viewModels?.count ?? 0)), section: 0)
        viewModels?.append(vm)
        tableView.insertRows(at: [indexPath], with: .fade)
        setupNotification(vm: vm)
    }
}

extension KhtmatViewController: KhtmaModificationDelegate {
    func removeKhatma(vm: KhtmaViewModel) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [vm.notificaiton_id ?? ""])
        RealmManager.sharedInstance.removeObject(vm)
        fetchCachedKhtmat()
    }
    
    func editKhatma(vm: KhtmaViewModel) {
        let vc = KhtmaDetailsViewController(type: .edit)
        vc.viewModel = vm
        vc.editAction = { [weak self] in
            self?.setupNotification(vm: vm)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension KhtmatViewController {
    private func setupNotification(vm: KhtmaViewModel) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "الموعد اليومي للتلاوة"
        content.subtitle = vm.name ?? ""
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "Khtma"
        
        /// Setup trigger tx    ime
        var trigger: UNNotificationTrigger?
        if let date = vm.date {
            
            var dateComp = DateComponents()
            dateComp.hour = Calendar.current.component(.hour, from: date)
            dateComp.minute = Calendar.current.component(.minute, from: date)
            
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp,repeats: true)
            
        }
        
        /// Create request
        let request = UNNotificationRequest(identifier: vm.notificaiton_id ?? UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}


extension Date {
    public var isDateInThisWeek: Bool {
        guard let lastDayInPerviousWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
            return false
        }
        return self > lastDayInPerviousWeek
    }
}


