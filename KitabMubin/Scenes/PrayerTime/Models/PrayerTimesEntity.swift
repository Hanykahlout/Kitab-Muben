//
//  PrayerTimesEntity.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 08/11/2022.
//

import Foundation

struct PrayerTimesEntityResponse: Decodable {
    let code: Int?
    let status: String?
    let data: PrayerTimesEntity?
}

struct PrayerTimesEntity: Decodable {
    let timings: Timings?
    let date: HijriDate?
}

struct Timings: Decodable {
    let Fajr: String?
    let Sunrise: String?
    let Dhuhr: String?
    let Asr: String?
    let Sunset: String?
    let Maghrib: String?
    let Isha: String?
    let Imsak: String?
    let Midnight: String?
    let Firstthird: String?
    let Lastthird: String?
}

struct HijriDate: Decodable {
    let hijri: HijriTime?
}

struct HijriTime: Decodable {
    let weekday: Weekday?
    let month: Month?
    let year: String?
}

struct Weekday: Decodable {
    let en: String?
    let ar: String?
}

struct Month: Decodable {
    let number: Int?
    let en: String?
    let ar: String?
}


