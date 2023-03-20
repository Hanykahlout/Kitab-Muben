//
//  ReaderDetailViewController.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 08/08/2022.
//

import UIKit
import AVFoundation
class ReaderDetailViewController: BaseViewController {
    
    // MARK: - init Module
    static func initModule(transferedModel: ReaderTransferedDataModel) -> ReaderDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReaderDetailViewController") as! ReaderDetailViewController
        vc.readerTransferedModel = transferedModel
        return vc
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var pageNumber = 1
    private var totalPages = 1
    private var readerTransferedModel: ReaderTransferedDataModel?
    private var player: AVAudioPlayer?
    private var selectedIndex :Int?
    private var time : Float64 = 0.0
    private var maxValue : Float = 0.0
    
    private var viewModel: ReaderDetailsViewModel? {
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
        tableView.registerCellNib(cellClass: ReaderDetailTableViewCell.self)
        tableView.register(UINib(nibName: "TableViewHeaderView",bundle: nil), forHeaderFooterViewReuseIdentifier: "TableViewHeaderView")
    }
    
    override func setupLocalization() {
        super.setupLocalization()
        navigationItem.title = readerTransferedModel?.readerName
    }
    
    override func setupAppearance() {
        super.setupAppearance()
        searchBar.setPlaceholderText(placeholer: "البحث في أسماء السور")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back-Nav")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(closeDidTap))
    }
}

// MARK: - View controller lifecycle methods
extension ReaderDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        loadData(isFromBottom: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        //        print("SSSSSS:",AudioPlayerManager.shared().playerItem?.isPlaybackBufferFull)
    }
}

// MARK: - Private Methods
extension ReaderDetailViewController {
    private func loadData(isFromBottom:Bool) {
        guard let reciterId = readerTransferedModel?.readerId else { return }
        if !isFromBottom{
            pageNumber = 1
        }
        NetworkManager.shared.fetchData(model: ReaderDetailsResponse.self, endpoint: .audio(reciterId: reciterId,page: pageNumber), method: .get) { [weak self] response in
            switch response {
            case .success(let response):
                DispatchQueue.main.async { [weak self] in
                    guard let dataSource = response?.readerDetails?.readerData else { return }
                    
                    if isFromBottom{
                        self?.viewModel?.dataSource?.append(contentsOf: dataSource)
                        self?.viewModel?.updateModels()
                        self?.tableView.reloadData()
                    }else{
                        self?.viewModel = ReaderDetailsViewModel(dataSource: dataSource)
                    }
                    
                    
                    let total = Int((response?.readerDetails?.total ?? 1) / Int(response?.readerDetails?.perPage ?? 10))
                    self?.totalPages = total % 15 == 0 ? total : total + 1
                    self?.hideLoadingIndicator()
                }
            case .failure(let failure):
                DispatchQueue.main.async { [weak self] in
                    print(failure)
                    self?.hideLoadingIndicator()
                    self?.showMessage(message: failure.errorDescription ?? "حدث خطأ ما")
                }
            }
        }
    }
    
    
    private func downloadAudio(for indexPath: IndexPath, url: String) {
        guard let url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        if let audioUrl = URL(string: url) {
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let fileName = audioUrl.lastPathComponent
            let urlArr = audioUrl.absoluteString.components(separatedBy: "/")
            let readerName = urlArr[urlArr.count - 2]
            let destinationUrl = documentsDirectoryURL.appendingPathComponent("\(readerName)_\(fileName)")
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                DispatchQueue.main.async { [weak self] in
                    self?.showAlertSuccess(title: "تم التنزيل مسبقا")
                    UserDefaults.standard.setValue(true, forKey: "isDonwloaded")
                    if self?.viewModel?.filteredViewModels?.count != 0 {
                        self?.viewModel?.filteredViewModels?[indexPath.row].isDonwloaded = true
                    } else {
                        self?.viewModel?.viewModels[indexPath.row].isDonwloaded = true
                    }
                    self?.tableView.reloadData()
                }
                print("The file already exists at path")
                // if the file doesn't exist
            } else {
                // you can use NSURLSession.sharedSession to download the data asynchronously
                showLoadingIndicator()
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    DispatchQueue.main.async {
                        self.hideLoadingIndicator()
                    }
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        DispatchQueue.main.async { [weak self] in
                            self?.showAlertSuccess(title: "تم التنزيل بنجاح")
                            UserDefaults.standard.setValue(true, forKey: "isDonwloaded")
                            if self?.viewModel?.filteredViewModels?.count != 0 {
                                self?.viewModel?.filteredViewModels?[indexPath.row].isDonwloaded = true
                            } else {
                                self?.viewModel?.viewModels[indexPath.row].isDonwloaded = true
                            }
                            self?.tableView.reloadData()
                        }
                        print("File moved to documents folder")
                    } catch let error as NSError {
                        DispatchQueue.main.async { [weak self] in
                            self?.showAlertError(title: "حدث خطأ", body: "برجاء المحاولة في وقت لاحق")
                        }
                        print(error.localizedDescription)
                    }
                }).resume()
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.showAlertError(title: "حدث خطأ", body: "برجاء المحاولة في وقت لاحق")
                print("Invalid URL")
            }
        }
    }
    
    
}

// MARK: - IBActions
extension ReaderDetailViewController {
}

extension ReaderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ReaderDetailTableViewCell
        if viewModel?.filteredViewModels?.count != 0 {
            cell.dataSource = viewModel?.dataSourceForFiltered(for: indexPath)
        } else {
            cell.dataSource = viewModel?.dataSource(for: indexPath)
        }
        
        cell.slider.value = 0.0
        cell.playPauseButton.isSelected = selectedIndex == indexPath.row
        
        if indexPath.row == selectedIndex{
            trackPlayerWithCell(cell: cell)
        }
        
        cell.downloadedAudioUpdateAction = { [weak self] url in
            if self?.viewModel?.filteredViewModels?.count != 0 {
                self?.viewModel?.dataSourceForFiltered(for: indexPath)?.audioURL = url
            } else {
                self?.viewModel?.dataSource(for: indexPath).audioURL = url
            }
        }
        
        cell.downloadAudio = { [weak self] in
            if !cell.isDownloaded{
                if self?.viewModel?.filteredViewModels?.count != 0 {
                    guard let audioURL = self?.viewModel?.dataSourceForFiltered(for: indexPath)?.audioURL else { return }
                    self?.downloadAudio(for: indexPath, url: audioURL)
                } else {
                    guard let audioURL = self?.viewModel?.dataSource(for: indexPath).audioURL else { return }
                    self?.downloadAudio(for: indexPath, url: audioURL)
                }
                tableView.reloadData()
            }
        }
        
        cell.playPauseAction = { [weak self] url , isSelected in
            if isSelected {
                if AudioPlayerManager.shared().player == nil || url != AudioPlayerManager.shared().url{
                    AudioPlayerManager.shared().addLink(url: url)
                    self?.trackPlayerWithCell(cell: cell)
                }
                
                AudioPlayerManager.shared().play()
                if let selectedIndex = self?.selectedIndex {
                    let cell = (self?.tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0))) as? ReaderDetailTableViewCell
                    cell?.playPauseButton.isSelected = false
                }
                self?.selectedIndex = indexPath.row
            }else{
                AudioPlayerManager.shared().pause()
                self?.selectedIndex = nil
            }
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
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (viewModel?.numberOfRowsInSection ?? 0) - 1 {
            if pageNumber < totalPages{
                pageNumber += 1
                loadData(isFromBottom: true)
            }
        }
    }
    
    private func trackPlayerWithCell(cell:ReaderDetailTableViewCell){
        let duration : CMTime = AudioPlayerManager.shared().playerItem!.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        cell.slider.maximumValue = Float(seconds)
        AudioPlayerManager.shared().player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] (CMTime) -> Void in
            guard let player = AudioPlayerManager.shared().player else { return }
            self?.time = CMTimeGetSeconds(player.currentTime())
            if cell.dataSource?.audioURL == AudioPlayerManager.shared().url{
                if player.currentItem?.status == .readyToPlay {
                    cell.slider.value = Float ( self?.time ?? 0.0 );
                }
                
                let duration : CMTime = AudioPlayerManager.shared().playerItem!.asset.duration
                let durationFloat : Float64 = CMTimeGetSeconds(duration)
                if Int(durationFloat) == Int(self?.time ?? 0.0){
                    cell.playPauseButton.isSelected = false
                    cell.slider.value = 0.0
                    let seconds : Int64 = Int64(cell.slider.value)
                    let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
                    player.seek(to: targetTime)
                    AudioPlayerManager.shared().pause()
                    if let selectedIndex =  self?.selectedIndex{
                        if selectedIndex < (self?.viewModel?.dataSource?.count ?? 0) - 1{
                            self!.selectedIndex! += 1
                            DispatchQueue.main.async { [weak self] in
                                let cell = (self?.tableView.cellForRow(at: IndexPath(row: self!.selectedIndex!, section: 0))) as? ReaderDetailTableViewCell
                                cell?.playPuase(isSelected: true)
                                self?.tableView.reloadRows(at: [IndexPath(row: self!.selectedIndex!, section: 0)], with: .automatic)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func setup() {
        NotificationsCenterHelper.startListening(to: Notification.Name("isDonwloaded"), at: self, selector: #selector(updateUI))
    }
}

// MARK: - Selectors
extension ReaderDetailViewController {
    @objc
    private func closeDidTap() {
        AudioPlayerManager.shared().clear()
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func updateUI(for indexPath: IndexPath) {
        if viewModel?.filteredViewModels?.count != 0 {
            viewModel?.dataSourceForFiltered(for: indexPath)?.isDonwloaded = true
        } else {
            viewModel?.dataSource(for: indexPath).isDonwloaded = true
        }
    }
}

extension ReaderDetailViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filteredViewModels = searchText.isEmpty ? viewModel?.viewModels : viewModel?.viewModels.filter { $0.suraName!.contains(searchText) }
        tableView.reloadData()
    }
}



