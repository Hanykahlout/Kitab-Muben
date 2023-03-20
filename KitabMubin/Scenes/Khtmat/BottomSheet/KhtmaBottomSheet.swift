//
//  AzkarNotificationViewController.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 30/10/2022.
//

import UIKit

protocol KhtmaModificationDelegate: AnyObject {
    func editKhatma(vm: KhtmaViewModel)
    func removeKhatma(vm: KhtmaViewModel)
}

class KhtmaBottomSheet: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: KhtmaModificationDelegate?
    private var viewModel: KhtmaViewModel?
    private var indexPath: IndexPath?
    
    // MARK: - Inits
    init(vm: KhtmaViewModel, indexPath: IndexPath) {
        super.init(nibName: nil, bundle: nil)
        viewModel = vm
        self.indexPath = indexPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    // MARK: - Methods
    override func setupAppearance() {
        titleLabel.textColor = UIColor.KMTextColor
        titleLabel.font = UIFont(name: "Tajawal-Bold", size: 24)
        titleLabel.text = "تعديل أو حذف الختمة"
        detailsLabel.text = "هناك حقيقة مثبته منذ زمن طويل وهي أن المحتوي المقروء لصفحة ما سيلهي القارئ"
        detailsLabel.textColor = UIColor.KMPlaceHolderTextColor1
        setupButtonRadiusAppearcne(button: editButton)
        setupButtonRadiusAppearcne(button: secondButton)
        editButton.setTitle("تعديل", for: .normal)
        secondButton.setTitle("حذف الختمة", for: .normal)
        secondButton.setTitleColor(UIColor.KMDeleteColor, for: .normal)
        editButton.setTitleColor(UIColor.KMTextColor, for: .normal)
    }
    
    private func setupButtonRadiusAppearcne(button: UIButton) {
        button.addCornerRadius(12)
        button.backgroundColor = .KMBackgroundLight2
        button.layer.borderWidth = 0.1
        button.layer.borderColor = UIColor.KMDisabledBackGround.cgColor
    }
    
    @IBAction func editTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            guard let viewModel = self?.viewModel else { return }
            self?.delegate?.editKhatma(vm: viewModel)
        }
    }
    
    /// delete button
    @IBAction func secondButtonTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            guard let viewModel = self?.viewModel ,let indexPath = self?.indexPath else { return }
            self?.delegate?.removeKhatma(vm: viewModel)
        }
    }
    
}
