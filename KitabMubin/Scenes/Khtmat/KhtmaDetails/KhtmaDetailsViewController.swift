//
//  KhtmaDetailsViewController.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 25/11/2022.
//

import UIKit
import RealmSwift

enum KhtmaType {
    case new
    case edit
}

class KhtmaDetailsViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Prperties
    private var type: KhtmaType?
    public weak var delegate: KhtmaDelegate?
    public var viewModel: KhtmaViewModel?
    var editAction : (()->Void)?
    
    init(type: KhtmaType) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupAppearance() {
        configureScene(type: type ?? .new)
        configure(type: type ?? .new)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back-Nav")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(closeDidTap))
    }
}

// MARK: - Private Methods
extension KhtmaDetailsViewController {
    private func configureScene(type: KhtmaType) {
        switch type {
        case .new:
            navigationItem.title = "إضافة خاتمة"
            saveButton.setTitle("إضافة", for: .normal)
            saveButton.addTarget(self, action: #selector(addKhtma), for: .touchUpInside)
            doneButton.isHidden = true
        case .edit:
            navigationItem.title = "تعديل الخاتمة"
            doneButton.isHidden = false
            saveButton.setTitle("حفظ التعديلات", for: .normal)
            doneButton.setTitle("إتمام الختمة", for: .normal)
            doneButton.addTarget(self, action: #selector(doneKhtma), for: .touchUpInside)
            saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        }
        nameTextField.addCornerRadius(8)
        durationTextField.addCornerRadius(8)
        saveButton.addCornerRadius(8)
        doneButton.addCornerRadius(8)
    }
    
    private func configure(type: KhtmaType) {
        switch type {
        case .new:
            break
        case .edit:
            if viewModel != nil {
                nameTextField.text = viewModel?.name
                durationTextField.text = "\(viewModel?.duration ?? 0)"
                datePicker.setDate(viewModel?.date ?? Date(), animated: true)
            }
        }
    }
}

// MARK: - Selectors
extension KhtmaDetailsViewController {
    @objc
    private func closeDidTap() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc
    private func addKhtma() {
        if nameTextField.text!.isBlank || durationTextField.text!.isBlank {
            self.showAlertError(title: "حدث خطأ", body: "عليك ادخال جميع البيانات المطلوبه")
        } else {
            
            let viewModel = KhtmaViewModel()
            viewModel.name = nameTextField.text
            viewModel.date = datePicker.date
            viewModel.duration = durationTextField.text?.toInt()
            viewModel.completed = false
            viewModel.notificaiton_id = UUID().uuidString
            RealmManager.sharedInstance.saveObject(viewModel)
            
            delegate?.addKtma(vm: viewModel)
            navigationController?.popViewController(animated: false)
        }
    }
    
    @objc
    private func doneKhtma() {
        if let realm = try? Realm() {
            try? realm.write {
                guard let viewModel else { return }
                viewModel.name = nameTextField.text
                viewModel.date = datePicker.date
                viewModel.duration = durationTextField.text?.toInt()
                viewModel.completed = true
                delegate?.addKtma(vm: viewModel)
                navigationController?.popViewController(animated: false)
            }
        }
    }
    
    @objc
    private func saveChanges() {
        if let realm = try? Realm() {
            try? realm.write {
                guard let viewModel else { return }
                viewModel.name = nameTextField.text
                viewModel.date = datePicker.date
                viewModel.duration = durationTextField.text?.toInt()
                viewModel.completed = false
                navigationController?.popViewController(animated: false)
                editAction?()
            }
        }
    }
}
