//
//  AlfahrisViewController.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 05/08/2022.
//

import UIKit

class AlfahrisViewController: BaseViewController {
    
    // MARK: - init Module
    static func initModule() -> AlfahrisViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AlfahrisViewController") as! AlfahrisViewController
        return vc
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: AlfahrisViewModel? {
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
        tableView.registerCellNib(cellClass: AlfahrisTableViewCell.self)
        tableView.register(UINib(nibName: "TableViewHeaderView",bundle: nil), forHeaderFooterViewReuseIdentifier: "TableViewHeaderView")
    }
    
    override func setupAppearance() {
        super.setupAppearance()
        searchBar.setPlaceholderText(placeholer: "البحث في أسماء السور")
    }
}

// MARK: - View controller lifecycle methods
extension AlfahrisViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        JsonLoader.shared.loadJsonDataFromFile("suras") { data in
            if let jsonData = data {
                do {
                    let decodedData = try JSONDecoder().decode(SurasModel.self, from: jsonData)
                    let chapters = decodedData.chapters
                    viewModel = AlfahrisViewModel(dataSource: chapters ?? [])
                }
                catch {
                    print(error)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - Private Methods
extension AlfahrisViewController {
}

// MARK: - IBActions
extension AlfahrisViewController {
}

extension AlfahrisViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as AlfahrisTableViewCell
        if viewModel?.filterViewModels?.count != 0 {
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
        headerView.dataSource = "السور"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel?.headerHeight ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectRow(at: indexPath)
        if viewModel?.filterViewModels?.count != 0 {
            guard let page = viewModel?.dataSourceForFiltered(for: indexPath)?.firstPage else { return }
            navigationController?.pushViewController(QuranViewController.initModule(page: page), animated: true)
        } else {
            guard let page = viewModel?.dataSource(for: indexPath).firstPage else { return }
            navigationController?.pushViewController(QuranViewController.initModule(page: page), animated: true)
        }
        tableView.reloadData()
    }
}

extension AlfahrisViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterViewModels = searchText.isEmpty ? viewModel?.viewModels : viewModel?.viewModels.filter { $0.suraName!.contains(searchText) }
        tableView.reloadData()
    }
}

