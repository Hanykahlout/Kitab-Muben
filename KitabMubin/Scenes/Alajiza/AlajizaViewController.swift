//
//  AlajizaViewController.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 05/08/2022.
//

import UIKit

class AlajizaViewController: BaseViewController {
    
    // MARK: - init Module
    static func initModule() -> AlajizaViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AlajizaViewController") as! AlajizaViewController
        return vc
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: AlajizaViewModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Methods
    override func assignDelegates() {
        super.assignDelegates()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func registerCells() {
        super.registerCells()
        tableView.registerCellNib(cellClass: AlajizaTableViewCell.self)
        tableView.register(UINib(nibName: "TableViewHeaderView",bundle: nil), forHeaderFooterViewReuseIdentifier: "TableViewHeaderView")
    }
    
    override func setupAppearance() {
        super.setupAppearance()
        searchBar.setPlaceholderText(placeholer: "البحث في الأجزاء")
    }
}

// MARK: - View controller lifecycle methods
extension AlajizaViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAjzaa()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - Private Methods
extension AlajizaViewController {
    private func loadAjzaa() {
        JsonLoader.shared.loadJsonDataFromFile("ajzaa") { data in
            if let jsonData = data {
                do {
                    let decodedData = try JSONDecoder().decode(JuzsResponse.self, from: jsonData)
                    let juzsModel = decodedData.juzs
                    viewModel = AlajizaViewModel(dataSource: juzsModel ?? [])
                }
                catch {
                    print(error)
                }
            }
        }
    }
}

// MARK: - IBActions
extension AlajizaViewController {
}

extension AlajizaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as AlajizaTableViewCell
        if viewModel?.filterdViewModels?.count != 0 {
            cell.dataSource = viewModel?.dataSourceForFiltered(for: indexPath)
        } else {
            cell.dataSource = viewModel?.dataSource(for: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "TableViewHeaderView") as? TableViewHeaderView else {
            return nil
        }
        headerView.dataSource = "الأجزاء"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel?.headerHeight ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectRow(at: indexPath)
        if viewModel?.filterdViewModels?.count != 0 {
            guard let page = viewModel?.dataSourceForFiltered(for: indexPath)?.pageNumber else { return }
            navigationController?.pushViewController(QuranViewController.initModule(page: page), animated: true)
        } else {
            guard let page = viewModel?.dataSource(for: indexPath).pageNumber else { return }
            navigationController?.pushViewController(QuranViewController.initModule(page: page), animated: true)
        }
        tableView.reloadData()
    }
}

extension AlajizaViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterdViewModels = searchText.isEmpty ? viewModel?.viewModels : viewModel?.viewModels.filter { $0.juzName!.contains(searchText) }
        tableView.reloadData()
    }
}
