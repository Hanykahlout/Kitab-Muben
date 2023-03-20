//
//  AboutAppViewController.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 24/10/2022.
//

import UIKit

class AboutAppViewController: BaseViewController {
    
    // MARK: - init Module
    static func initModule() -> AboutAppViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AboutAppViewController") as! AboutAppViewController
        return vc
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var descLabel: UILabel!
    // MARK: - Properties
    
    // MARK: - Method
    override func setupAppearance() {
        super.setupAppearance()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back-Nav")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(closeDidTap))
    }
    
    override func viewWillLayoutSubviews() {
        descLabel.sizeToFit()
    }
}

// MARK: - View controller lifecycle methods
extension AboutAppViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - Private Methods
extension AboutAppViewController {
    private func loadData() {
        NetworkManager.shared.fetchData(model: AboutAppModel.self, endpoint: .aboutApp, method: .get) { [weak self] response in
            switch response {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.hideLoadingIndicator()
                    self?.descLabel.text = data?.data?.desc_ar?.html2String
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.hideLoadingIndicator()
                    self?.showAlertError(title: "حدث خطأ", body: "برجاء المحاولة في وقت لاحق")
                }
            }
        }
    }
}

// MARK: - IBActions
extension AboutAppViewController {
}

// MARK: - Selectors
extension AboutAppViewController {
    @objc
    private func closeDidTap() {
        navigationController?.popViewController(animated: true)
    }
}
