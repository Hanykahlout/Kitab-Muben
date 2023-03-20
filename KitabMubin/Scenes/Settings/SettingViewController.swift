//
//  SettingViewController.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 06/08/2022.
//

import UIKit
import StoreKit

class SettingViewController: BaseViewController {
    
    // MARK: - init Module
    static func initModule() -> SettingViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        return vc
    }
    
    // MARK: - IBOutlets
    //    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quranView: UIView!
    @IBOutlet weak var suraNameLabel: UILabel!
    @IBOutlet weak var suraPageNumberLabel: UILabel!
    @IBOutlet weak var readerView: UIView!
    @IBOutlet weak var prayerTimesView: UIView!
    @IBOutlet weak var khatmatView: UIView!
    @IBOutlet weak var DirectionView: UIView!
    @IBOutlet weak var askarView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var shapView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var contactUsView: UIView!
    @IBOutlet weak var rateView: UIView!
    
    
    
    
    // MARK: - Properties
    var viewModel: SettingViewModelProtocol?
    var current_page_number = 1
    //    override func assignDelegates() {
    //        super.assignDelegates()
    //        tableView.delegate = self
    //        tableView.dataSource = self
    //    }
    //
    //    override func registerCells() {
    //        super.registerCells()
    //        tableView.registerCellNib(cellClass: SettingTableViewCell.self)
    //        tableView.register(UINib(nibName: "SettingTableHeaderView",bundle: nil), forHeaderFooterViewReuseIdentifier: "SettingTableHeaderView")
    //    }
    
    override func setupAppearance() {
        super.setupAppearance()
    }
}

// MARK: - View controller lifecycle methods
extension SettingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewsActions()
        shapView.isHidden = true
        quranView.isUserInteractionEnabled = true
        quranView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(goToQuranVC)))
        viewModel = SettingViewModel()
        getQuranPage()
        NotificationCenter.default.addObserver(forName: .init("ReloadQuranPage"), object: nil, queue: .main) { [weak self] notify in
            self?.getQuranPage()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func getQuranPage(){
        let current_sura_name = UserDefaults.standard.string(forKey: "current_sura_name") ?? ""
        let pageNumber = UserDefaults.standard.integer(forKey: "current_page_number")
        current_page_number = pageNumber == 0 ? 1 : pageNumber
        suraNameLabel.text = current_sura_name
        suraPageNumberLabel.text = " رقمها \(current_page_number)"
    }
}

// MARK: - Private Methods
extension SettingViewController {
    private func shareApp(sender: UIView) {
        // MARK: - ToDo URL of the bundle id in the app Store
        let secondActivityItem : NSURL = NSURL(string: "https://apps.apple.com/us/app/%D9%83%D8%AA%D8%A7%D8%A8-%D9%85-%D8%A8%D9%8A%D9%86/id6445818278")!
        let activityViewController = UIActivityViewController(activityItems: [secondActivityItem], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        activityViewController.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
        activityViewController.isModalInPresentation = false
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func setUpViewsActions(){
        readerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(readerViewAction)))
        prayerTimesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(prayerTimesViewAction)))
        khatmatView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(khatmatViewAction)))
        DirectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DirectionViewAction)))
        askarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(askarViewAction)))
        aboutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(aboutViewAction)))
        shapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shapViewAction)))
        
        shareView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareViewAction)))
        contactUsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contactUsViewAction)))
        rateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rateViewAction)))
    }
    
    @objc private func goToQuranVC(){
        let vc = QuranViewController.initModule(page: current_page_number)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc private func readerViewAction(){
        let vc = ReaderViewController.initModule()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func prayerTimesViewAction(){
        let vc = PrayerTimeViewController.initModule()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func khatmatViewAction(){
        let vc = KhtmatViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func DirectionViewAction(){
        let vc = CompassDirectionViewController.initModule()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func askarViewAction(){
        let vc = AzkarViewController.initModule()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func aboutViewAction(){
        let vc = AboutAppViewController.initModule()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func shapViewAction(){
        
    }
    
    @objc private func shareViewAction(){
        
        shareApp(sender: shareView)
        
    }
    
    @objc private func contactUsViewAction(){
        let vc = ContactUSViewController.initModule()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func rateViewAction(){
        if #available(iOS 14, *) {
            guard let windowScene = view.window?.windowScene else { return }
            SKStoreReviewController.requestReview(in: windowScene)
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
}

// MARK: - IBActions
extension SettingViewController {
}

//extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return viewModel?.numberOfSection ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel?.numberOfRowsInSection ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeue() as SettingTableViewCell
//        cell.dataSource = viewModel?.dataSourceForIndex(at: indexPath)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(
//            withIdentifier: "SettingTableHeaderView") as? SettingTableHeaderView else {
//            return nil
//        }
//        headerView.viewModel = SettingTableHeaderViewModel()
//        headerView.delegate = self
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return viewModel?.headerHeight ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let model = viewModel?.didSelectItem(at: indexPath) else { return }
//        switch model.settingId {
//        case "mosque":
//            let vc = PrayerTimeViewController.initModule()
//            navigationController?.pushViewController(vc, animated: true)
//            break
//        case "compass":
//            let vc = CompassDirectionViewController.initModule()
//            navigationController?.pushViewController(vc, animated: true)
//            break
//        case "aboutapp":
//            let vc = AboutAppViewController.initModule()
//            navigationController?.pushViewController(vc, animated: true)
//            break
//        case "devicetheme":
//            break
//        case "contuctus" :
//            let vc = ContactUSViewController.initModule()
//            navigationController?.pushViewController(vc, animated: true)
//        case "shareapp":
//            guard let sender = tableView.cellForRow(at: indexPath) else { return }
//            shareApp(sender: sender)
//        case "rateapp":
//            if #available(iOS 14, *) {
//                guard let windowScene = view.window?.windowScene else { return }
//                SKStoreReviewController.requestReview(in: windowScene)
//            } else {
//                SKStoreReviewController.requestReview()
//            }
//        default:
//            break
//        }
//    }
//}

//extension SettingViewController: SettingHeaderViewProtocol {
//    func didSelectItem(item: SettingDataModel) {
//        switch item.settingId {
//        case "readers":
//            let vc = ReaderViewController.initModule()
//            navigationController?.pushViewController(vc, animated: true)
//        case "alkhatmat":
//            let vc = KhtmatViewController()
//            navigationController?.pushViewController(vc, animated: true)
//        case "azkar":
//            let vc = AzkarViewController.initModule()
//            navigationController?.pushViewController(vc, animated: true)
//        default:
//            break
//        }
//    }
//}
