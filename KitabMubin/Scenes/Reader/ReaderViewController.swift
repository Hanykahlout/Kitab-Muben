//
//  ReaderViewController.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 08/08/2022.
//

import UIKit

class ReaderViewController: BaseViewController {
    
    // MARK: - init Module
    static func initModule() -> ReaderViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReaderViewController") as! ReaderViewController
        return vc
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: ReadersViewModel? {
        didSet {
            tableView.reloadData()
        }
    }
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    
    // MARK: - Methods
    override func assignDelegates() {
        super.assignDelegates()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func registerCells() {
        super.registerCells()
        tableView.registerCellNib(cellClass: ReaderTableViewCell.self)
    }
    
    override func setupAppearance() {
        super.setupAppearance()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back-Nav")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(closeDidTap))
        searchBar.setPlaceholderText(placeholer: "البحث عن قارئ")
        navigationItem.title = "القراء"
    }
}

// MARK: - View controller lifecycle methods
extension ReaderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

// MARK: - Private Methods
extension ReaderViewController {
    private func loadData() {
        NetworkManager.shared.fetchData(model: ReaderModel.self, endpoint: .reciterWith(page: currentPage), method: .get) { [weak self] response in
            switch response {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    var dataSource:[ReaderData] = data?.readerDetails?.readerData ?? []
                    let isNewPage = (self?.currentPage ?? 0) > 1
                    if isNewPage{
                        self?.viewModel?.dataSource?.append(contentsOf: dataSource)
                        self?.viewModel?.updateModels()
                        self?.tableView.reloadData()
                    }else{
                        self?.viewModel = ReadersViewModel(dataSource: dataSource)
                    }
                    let total = Int((data?.readerDetails?.total ?? 1) / Int(data?.readerDetails?.perPage ?? 10))
                    self?.totalPages = total % 15 == 0 ? total : total + 1
                    self?.hideLoadingIndicator()
                    
                }
            case .failure(let failure):
                DispatchQueue.main.async { [weak self] in
                    self?.hideLoadingIndicator()
                    self?.showMessage(message: failure.errorDescription ?? "حدث خطأ ما")
                }
            }
        }
    }
}

// MARK: - IBActions
extension ReaderViewController {
    
}

extension ReaderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReaderTableViewCell
        if viewModel?.filterdViewModels?.count != 0 {
            cell.dataSource = viewModel?.dataSourceForFilterd(for: indexPath)
        } else {
            cell.dataSource = viewModel?.dataSource(for: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel?.filterdViewModels?.count != 0 {
            guard let readerName = viewModel?.dataSourceForFilterd(for: indexPath)?.readerName , let readerId = viewModel?.didSelectRow(at: indexPath).id else { return }
            let transferedData = ReaderTransferedDataModel(readerId: readerId, readerName: readerName)
            let vc = ReaderDetailViewController.initModule(transferedModel: transferedData)
            navigationController?.pushViewController(vc, animated: false)
        } else {
            guard let readerName = viewModel?.didSelectRow(at: indexPath).readerName , let readerId = viewModel?.didSelectRow(at: indexPath).id else { return }
            let transferedData = ReaderTransferedDataModel(readerId: readerId, readerName: readerName)
            let vc = ReaderDetailViewController.initModule(transferedModel: transferedData)
            navigationController?.pushViewController(vc, animated: false)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel!.viewModels.count - 1 {
            if currentPage < totalPages{
                showLoadingIndicator()
                currentPage += 1
                loadData()
            }
        }
    }
}

// MARK: - Selectors
extension ReaderViewController {
    @objc
    private func closeDidTap() {
        navigationController?.popViewController(animated: true)
    }
}

extension ReaderViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterdViewModels = searchText.isEmpty ? viewModel?.viewModels : viewModel?.viewModels.filter { $0.readerName!.contains(searchText) }
        tableView.reloadData()
    }
}

