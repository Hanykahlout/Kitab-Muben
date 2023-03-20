//
//  PrayerTimesViewModel.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 09/11/2022.
//

import Foundation

class PrayerTimesViewModel {
    
    var dataSource: PrayerTimesEntity?
    var viewModels: [PrayerTimeCellViewModel] = [PrayerTimeCellViewModel]()
    var citViewModel: PrayerTimeCellViewModel?
    
    init(dataSource: PrayerTimesEntity?) {
        self.dataSource = dataSource
        setupViewModels()
        
    }
    
    private func setupViewModels() {
        viewModels.append(PrayerTimeCellViewModel(title: "صلاة الفجر", subtitle: getFormattedDate(date: dataSource?.timings?.Fajr ?? ""), iconName: "Fajr"))
        viewModels.append(PrayerTimeCellViewModel(title: "الشروق", subtitle: getFormattedDate(date: dataSource?.timings?.Sunrise ?? ""), iconName: "Sunrise"))
        viewModels.append(PrayerTimeCellViewModel(title: "صلاة الظهر", subtitle: getFormattedDate(date: dataSource?.timings?.Dhuhr ?? ""), iconName: "Dhuhr"))
        viewModels.append(PrayerTimeCellViewModel(title: "صلاة العصر", subtitle: getFormattedDate(date: dataSource?.timings?.Asr ?? ""), iconName: "Asr"))
        viewModels.append(PrayerTimeCellViewModel(title: "صلاة المغرب", subtitle: getFormattedDate(date: dataSource?.timings?.Maghrib ?? ""), iconName: "Maghrib"))
        viewModels.append(PrayerTimeCellViewModel(title: "صلاة العشاء", subtitle: getFormattedDate(date: dataSource?.timings?.Isha ?? ""), iconName: "Isha"))
    }
    
//    func getCurrentDate() -> String {
//        let date = Date()
//        let arabicDay = dataSource?.date?.hijri?.weekday?.ar ?? ""
//        let numberDay = dataSource?.date?.hijri?.month?.number ?? 0
//        let month = dataSource?.date?.hijri?.month?.ar ?? ""
//        let year = dataSource?.date?.hijri?.year ?? ""
//
//       return "\(arabicDay) \(numberDay) \(month) \(year)"
//    }

    func getCurrentDate()->String{
//        let date = Date()
//        let islamic = NSCalendar(identifier:NSCalendar.Identifier(rawValue: NSCalendar.Identifier.islamicCivil.rawValue))!
//        let components = islamic.components(NSCalendar.Unit(rawValue: UInt.max), from: date)
//        let month = "\(components.month ?? 0)".count == 1 ? "0\(components.month ?? 0)" : "\(components.month ?? 0)"
//        let day = "\(components.day ?? 0)".count == 1 ? "0\(components.day ?? 0)" : "\(components.day ?? 0)"
//        return "\(components.year ?? 0)/\(month)/\(day)"
        let dateFor = DateFormatter()

         let hijriCalendar = Calendar.init(identifier: Calendar.Identifier.islamicCivil)
         dateFor.locale = Locale.init(identifier: "ar")
         dateFor.calendar = hijriCalendar

         dateFor.dateFormat = "EEEE d MMMM YYYY"
         
        return dateFor.string(from: Date())
        
    }
    
    private func getFormattedDate(date:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = .init(identifier: "en")
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.locale = .init(identifier: "ar")
        return dateFormatter.string(from: date)
    }
    
    var numberOfRowsInSection: Int {
        return viewModels.count
    }
    
    var numberOfSections: Int {
        return 2
    }
    
    var headerHeight: CGFloat {
        return 56
    }
    
    func dataSource(for indexPath: IndexPath) -> PrayerTimeCellViewModel {
        return viewModels[indexPath.row]
    }
}
