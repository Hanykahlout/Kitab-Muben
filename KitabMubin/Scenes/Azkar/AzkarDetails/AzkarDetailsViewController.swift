//
//  AzkarDetailsViewController.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 31/10/2022.
//

import UIKit
import FittedSheets
class AzkarDetailsViewController: BaseViewController {
    
    // MARK: - Properties
    private var hasNotification = false
    private var viewModel: AzkarDetailsViewModel?
    private var model: ZekrModel?
    private var rightButtonItem: UIBarButtonItem?
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Inits
    init(viewModel: ZekrModel,hasNotification:Bool) {
        super.init(nibName: nil, bundle: nil)
        self.model = viewModel
        self.viewModel = AzkarDetailsViewModel(dataSource: viewModel.descriptions.toArray())
        self.hasNotification = hasNotification
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func registerCells() {
        super.registerCells()
        tableView.registerCellNib(cellClass: AzkarDetailsTableViewCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .init("has_notification"), object: nil, queue: .main) { [weak self] notify in
            guard let hasNotification = notify.object as? Bool else { return }
            self?.rightButtonItem?.image = hasNotification ? UIImage(named: "notification_selected")?.withRenderingMode(.alwaysOriginal) : UIImage(named: "Noti-stop")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    override func assignDelegates() {
        super.assignDelegates()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func setupAppearance() {
        super.setupAppearance()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back-Nav")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(closeDidTap))
        let rightBarButtonImage = hasNotification ? UIImage(named: "notification_selected")?.withRenderingMode(.alwaysOriginal) : UIImage(named: "Noti-stop")?.withRenderingMode(.alwaysOriginal)
        rightButtonItem = UIBarButtonItem(image: rightBarButtonImage, style: .done, target: self, action: #selector(notificationTapped))
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationItem.title = viewModel?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13, *) {
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13, *) {
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    
    @objc func notificationTapped() {
        guard let model = model else { return }
        let azkarNotificationVC = AzkarNotificationViewController(notificationState: model.notification_id == nil ? .new : .edit)
        azkarNotificationVC.model = model
        let sheetController = SheetViewController(controller: azkarNotificationVC, sizes: [.fixed(500)], options: nil)
        present(sheetController, animated: true, completion: nil)
    }
    
}

// MARK: - Private Methods
extension AzkarDetailsViewController {
}

extension AzkarDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as AzkarDetailsTableViewCell
        cell.dataSource = viewModel?.dataSource(for: indexPath)
        return cell
    }
}

// MARK: - Selectors
extension AzkarDetailsViewController {
    @objc
    private func closeDidTap() {
        navigationController?.popViewController(animated: false)
    }
}
