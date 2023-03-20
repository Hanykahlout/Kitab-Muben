//
//  AzkarNotificationViewController.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 30/10/2022.
//

import UIKit
import RealmSwift

enum NotificationState {
    case new
    case edit
}

class AzkarNotificationViewController: UIViewController {
    
    public var notificationState: NotificationState = .edit
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var stepperContainerView: UIView!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    var model:ZekrModel!
    private var isEdit = false
    // MARK: - Inits
    init(notificationState: NotificationState) {
        super.init(nibName: nil, bundle: nil)
        self.notificationState = notificationState
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        configure(notification: notificationState)
    }
    
    
    
    private func setupAppearance() {
        titleLabel.textColor = UIColor.KMTextColor
        titleLabel.font = UIFont(name: "Tajawal-Bold", size: 24)
        detailsLabel.textColor = UIColor.KMPlaceHolderTextColor1
    }
    
    private func configure(notification type: NotificationState) {
        switch type {
        case .new:
            setUpForNewReminder()
        case .edit:
            setUpForEditReminder()
        }
    }
    
    
    private func setUpForNewReminder(){
        editButton.isHidden = true
        stepperContainerView.isHidden = false
        titleLabel.text = "تفعيل التنبيهات"
        detailsLabel.text = "هناك حقيقة مثبته منذ زمن طويل وهي أن المحتوي المقروء لصفحة ما سيلهي القارئ"
        secondButton.setTitle("حفظ", for: .normal)
        secondButton.setTitleColor(UIColor.KMWhiteBackGround, for: .normal)
        secondButton.backgroundColor = UIColor.KMGreanBackGround
        secondButton.addCornerRadius(12)
    }
    
    private func setUpForEditReminder(){
        editButton.isHidden = false
        stepperContainerView.isHidden = true
        titleLabel.text = "تعديل أو حذف التنبيه"
        detailsLabel.text = "هناك حقيقة مثبته منذ زمن طويل وهي أن المحتوي المقروء لصفحة ما سيلهي القارئ"
        editButton.setTitle("تعديل", for: .normal)
        editButton.setTitleColor(UIColor.KMTextColor, for: .normal)
        secondButton.setTitle("حذف التنبيه", for: .normal)
        secondButton.setTitleColor(UIColor.KMDeleteColor, for: .normal)
        setupButtonRadiusAppearcne(button: editButton)
        setupButtonRadiusAppearcne(button: secondButton)
    }
    
    private func setupButtonRadiusAppearcne(button: UIButton) {
        button.addCornerRadius(12)
        button.backgroundColor = .KMBackgroundLight2
        button.layer.borderWidth = 0.1
        button.layer.borderColor = UIColor.KMDisabledBackGround.cgColor
    }
    
    private func addAzkarReminder(){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = model.name
        content.sound = .default
        content.categoryIdentifier = "Azkar"
        
        /// Setup trigger time
        var trigger: UNNotificationTrigger?
        
        trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents(
                [.day, .month, .year, .hour, .minute],
                from: datePicker.date),
            repeats: true)
        
        
        /// Create request
        let uniqueID = UUID().uuidString
        
        /// Update Ream Status
        let realm = try! Realm()
        try! realm.write {
            let zekr = ZekrModel()
            zekr.id = model.id
            zekr.name = model.name
            zekr.notification_id = uniqueID
            zekr.date = datePicker.date
            zekr.descriptions = model.descriptions
            realm.add(zekr, update: .modified)
        }
        
        let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
        center.add(request)
    }
    
    private func removeAzkarReminder(){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [model.notification_id ?? ""])
            
        let realm = try! Realm()
        try! realm.write {
            let zekr = ZekrModel()
            zekr.id = model.id
            zekr.name = model.name
            zekr.notification_id = nil
            zekr.date = nil
            zekr.descriptions = model.descriptions
            realm.add(zekr, update: .modified)
        }

    }
    
    /// edit the notification
    @IBAction func editTapped(_ sender: Any) {
        setUpForNewReminder()
        datePicker.setDate(model.date ?? Date(), animated: true)
        isEdit = true
    }
    
    /// Delete or save
    /// Two actions based on the state
    @IBAction func secondButtonTapped(_ sender: Any) {
        if notificationState == .new{
            // ADD
            addAzkarReminder()
        }else{
            // DELETE
            if !isEdit{
                removeAzkarReminder()
            }else{
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [model.notification_id ?? ""])
                addAzkarReminder()
            }
        }
        NotificationCenter.default.post(name: .init("ReloadAzkar"), object: nil)
        NotificationCenter.default.post(name: .init("has_notification"), object: model.notification_id != nil)
        
        dismiss(animated: true)
    }
    
    
}
