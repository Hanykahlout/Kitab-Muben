//
//  ContactUSViewController.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 10/08/2022.
//

import UIKit

class ContactUSViewController: BaseViewController {
    
    // MARK: - init Module
    static func initModule() -> ContactUSViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContactUSViewController") as! ContactUSViewController
        return vc
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var whatsAppButton: UIButton!
    
    // MARK: - Properties
    private var phoneNumber: String?
    
    // MARK: - Method
    override func setupAppearance() {
        super.setupAppearance()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back-Nav")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(closeDidTap))
        navigationItem.title = nil
        nameTextField.addCornerRadius(8)
        emailTextField.addCornerRadius(8)
        messageTextView.addCornerRadius(8)
        sendButton.addCornerRadius(8)
        whatsAppButton.addBorderWith(width: 1, color: .KMGreanBackGround)
        whatsAppButton.addCornerRadius(8)
    }
}

// MARK: - View controller lifecycle methods
extension ContactUSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        whatsAppButton.isHidden = true
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - Private Methods
extension ContactUSViewController {
    private func loadData() {
        NetworkManager.shared.fetchData(model: PhoneNumberResponse.self, endpoint: .phoneNumber, method: .get) { [weak self] response in
            switch response {
            case .success(let success):
                DispatchQueue.main.async {
                    self?.hideLoadingIndicator()
                    self?.phoneNumber = success?.data?[0].value
                    self?.whatsAppButton.isHidden = false
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.whatsAppButton.isHidden = true
                    self?.hideLoadingIndicator()
                    self?.showAlertError(title: "حدث خطأ", body: "برجاء المحاولة في وقت لاحق")
                }
            }
        }
    }
    
    private func sendRequest() {
        let parameters: [String: Any] = [
            "name": nameTextField.text ?? "",
            "email": emailTextField.text ?? "",
            "msg": messageTextView.text ?? ""
        ]
        
        if nameTextField.text!.isBlank || emailTextField.text!.isBlank || messageTextView.text!.isBlank {
            hideLoadingIndicator()
            self.showAlertError(title: "حدث خطأ", body: "عليك ادخال جميع البيانات المطلوبه")
        } else {
            NetworkManager.shared.fetchData(model: ContactUsModel.self, endpoint: .contactUs, method: .post, parameters: parameters) { [weak self] response in
                switch response {
                case .success(let success):
                    if success?.code != 200 {
                        DispatchQueue.main.async {
                            self?.showAlertError(title: "حدث خطأ", body: "عليك ادخال البيانات بشكل صحيح")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showAlertSuccess(title: "تم الارسال بنجاح", body: "نشكرك علي اهتمامك")
                        }
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        self?.showAlertError(title: "حدث خطأ", body: failure.errorDescription ?? "هناك مشكلة، حاول في وقت لاحق")
                    }
                    print(failure)
                }
                DispatchQueue.main.async {
                    self?.hideLoadingIndicator()
                }
            }
        }
    }
    
    private func contactViaWhatsApp(number: String) {
        guard let url = NSURL(string: "https://wa.me/\(number)") else { return }
        if UIApplication.shared.canOpenURL(url as URL) {
            // Open Whatsapp
            UIApplication.shared.open(url as URL, options: [:]){ [weak self] (success) in
                if success {
                    print("WhatsApp accessed successfully")
                } else {
                    self?.showAlertError(title: "", body: "أنت لا تمتلك تطبيق الواتساب")
                }
            }
        } else {
            self.showAlertError(title: "", body: "حدث خطأ")
        }
    }
}

// MARK: - Selectors
extension ContactUSViewController {
    @objc
    private func closeDidTap() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - IBActions
extension ContactUSViewController {
    @IBAction func sendButtonDidTap(_ sender: Any) {
        showLoadingIndicator()
        sendRequest()
    }
    
    @IBAction func whatsAppButtonDidTap(_ sender: Any) {
        guard let phoneNumber = phoneNumber?.replacingOccurrences(of: "+", with: "") else {
            self.showAlertError(title: "", body: "حدث خطأ")
            return
        }
        print(phoneNumber)
        contactViaWhatsApp(number: phoneNumber)
    }
}
