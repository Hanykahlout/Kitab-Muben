//
//  FawasilViewController.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 06/08/2022.
//

import UIKit

class FawasilViewController: BaseViewController {
    
    // MARK: - init Module
    static func initModule() -> FawasilViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FawasilViewController") as! FawasilViewController
        return vc
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    var viewModel: FawasilViewModel? {
        didSet {
        }
    }
    
    // MARK: - Methods
    override func setupAppearance() {
        super.setupAppearance()
        tableView.contentInset = .init(top: 0, left: 0, bottom: 80, right: 0)
        deleteButton.addBorderWith(width: 1, color: .KMDeleteColor)
        deleteButton.addCornerRadius(10)
        NotificationsCenterHelper.startListening(to: Notification.Name("bookmarked"), at: self, selector: #selector(reloadData))
        NotificationsCenterHelper.startListening(to: .init("Open0"), at: self, selector: #selector(ayatAction))
        NotificationsCenterHelper.startListening(to: .init("Open1"), at: self, selector: #selector(pagesAction))
       
    }
    
    override func assignDelegates() {
        super.assignDelegates()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func registerCells() {
        super.registerCells()
        tableView.registerCellNib(cellClass: FawasilTableViewCell.self)
        tableView.register(UINib(nibName: "FawasilTableHeaderView",bundle: nil), forHeaderFooterViewReuseIdentifier: "FawasilTableHeaderView")
    }
}

// MARK: - View controller lifecycle methods
extension FawasilViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .init("ReloadFawasil"), object: nil, queue: .main) { [weak self] notify in
            self?.viewModel = .init(tag: 1)
            self?.tableView.reloadData()
        }
        viewModel = .init(tag: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - IBActions
extension FawasilViewController {
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        RealmManager.sharedInstance.removeAllObjectsOfType(SavedPage.self)
        viewModel = .init(tag: 1)
        tableView.reloadData()
    }
}

// MARK: - Selectors
extension FawasilViewController {
    @objc
    private func ayatAction() {
        viewModel = .init(tag: 0)
        reloadData()
    }
    
    @objc
    private  func pagesAction() {
        viewModel = .init(tag: 1)
        reloadData()
    }
    
    @objc
    private func reloadData() {
//        viewModel?.getFawasil()
        tableView.reloadData()
    }
}

extension FawasilViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as FawasilTableViewCell
        cell.dataSource = viewModel?.dataSource(for: indexPath)
//        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "FawasilTableHeaderView") as? FawasilTableHeaderView else {
            return nil
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = QuranViewController.initModule(page: viewModel?.pagesViewModels[indexPath.row].pageNumber ?? 1)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
                // delete the item here
                self?.viewModel?.removePage(at:indexPath)
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                NotificationCenter.default.post(name: .init("UpdateSavedStatus"), object: false)
                completionHandler(true)
            }
            deleteAction.image = UIImage(named: "delete_icon")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
}



