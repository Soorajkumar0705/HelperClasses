//
//  AppDetails.swift
//  HelperClasses
//
//  Created by Meet Appmatictech on 25/03/24.
//

import Foundation

//MARK: - App Details From App Store

struct AppDetailsRes: Codable {
    var resultCount: Int? = nil
    var results: [AppDetails] = []
    
    static func parseData(disc: StringAnyDict) -> Self {
        var obj = Self()
        
        obj.resultCount = disc["resultCount"] as? Int
        obj.results = AppDetails.parseData(discs: (disc["results"] as? StringAnyDictArray) ?? [])
        
        return obj
    }
}

struct AppDetails: Codable {
    var screenshotUrls: [String]? = nil
    var ipadScreenshotUrls: [String]? = nil
    var appletvScreenshotUrls: [String]? = nil
    var artworkUrl60: String? = nil
    var artworkUrl512: String? = nil
    var artworkUrl100: String? = nil
    var artistViewURL: String? = nil
    var isGameCenterEnabled: Bool? = nil
    var features: [String]? = nil
    var advisories: [String]? = nil
    var supportedDevices: [String]? = nil
    var kind: String? = nil
    var averageUserRatingForCurrentVersion: Int? = nil
    var averageUserRating: Int? = nil
    var trackCensoredName: String? = nil
    var languageCodesISO2A: [String]? = nil
    var fileSizeBytes: String? = nil
    var sellerURL: String? = nil
    var formattedPrice: String? = nil
    var contentAdvisoryRating: String? = nil
    var userRatingCountForCurrentVersion: Int? = nil
    var trackViewURL: String? = nil
    var trackContentRating: String? = nil
    var minimumOSVersion: String? = nil
    var currentVersionReleaseDate: Date? = nil
    var artistID: Int? = nil
    var artistName: String? = nil
    var genres: [String]? = nil
    var price: Int? = nil
    var description: String? = nil
    var isVppDeviceBasedLicensingEnabled: Bool? = nil
    var primaryGenreName: String? = nil
    var primaryGenreID: Int? = nil
    var sellerName: String? = nil
    var trackID: Int? = nil
    var trackName: String? = nil
    var genreIDS: [String]? = nil
    var currency: String? = nil
    var releaseDate: String? = nil
    var bundleID: String? = nil
    var releaseNotes: String? = nil
    var version: String? = nil
    var wrapperType: String? = nil
    var userRatingCount: Int? = nil
    
    enum CodingKeys: String, CodingKey {
        case screenshotUrls, ipadScreenshotUrls, appletvScreenshotUrls, artworkUrl60, artworkUrl512, artworkUrl100
        case artistViewURL = "artistViewUrl"
        case isGameCenterEnabled, features, advisories, supportedDevices, kind, averageUserRatingForCurrentVersion, averageUserRating, trackCensoredName, languageCodesISO2A, fileSizeBytes
        case sellerURL = "sellerUrl"
        case formattedPrice, contentAdvisoryRating, userRatingCountForCurrentVersion
        case trackViewURL = "trackViewUrl"
        case trackContentRating
        case minimumOSVersion = "minimumOsVersion"
        case currentVersionReleaseDate
        case artistID = "artistId"
        case artistName, genres, price, description, isVppDeviceBasedLicensingEnabled, primaryGenreName
        case primaryGenreID = "primaryGenreId"
        case sellerName
        case trackID = "trackId"
        case trackName
        case genreIDS = "genreIds"
        case currency, releaseDate
        case bundleID = "bundleId"
        case releaseNotes, version, wrapperType, userRatingCount
    }
    
    static func parseData(disc: StringAnyDict) -> Self {
        var obj = Self()
        
        obj.screenshotUrls = disc["screenshotUrls"] as? [String]
        obj.ipadScreenshotUrls = disc["ipadScreenshotUrls"] as? [String]
        obj.appletvScreenshotUrls = disc["appletvScreenshotUrls"] as? [String]
        obj.artworkUrl60 = disc["artworkUrl60"] as? String
        obj.artworkUrl512 = disc["artworkUrl512"] as? String
        obj.artworkUrl100 = disc["artworkUrl100"] as? String
        obj.artistViewURL = disc["artistViewUrl"] as? String
        obj.isGameCenterEnabled = disc["isGameCenterEnabled"] as? Bool
        obj.features = disc["features"] as? [String]
        obj.advisories = disc["advisories"] as? [String]
        obj.supportedDevices = disc["supportedDevices"] as? [String]
        obj.kind = disc["kind"] as? String
        obj.averageUserRatingForCurrentVersion = disc["averageUserRatingForCurrentVersion"] as? Int
        obj.averageUserRating = disc["averageUserRating"] as? Int
        obj.trackCensoredName = disc["trackCensoredName"] as? String
        obj.languageCodesISO2A = disc["languageCodesISO2A"] as? [String]
        obj.fileSizeBytes = disc["fileSizeBytes"] as? String
        obj.sellerURL = disc["sellerUrl"] as? String
        obj.formattedPrice = disc["formattedPrice"] as? String
        obj.contentAdvisoryRating = disc["contentAdvisoryRating"] as? String
        obj.userRatingCountForCurrentVersion = disc["userRatingCountForCurrentVersion"] as? Int
        obj.trackViewURL = disc["trackViewUrl"] as? String
        obj.trackContentRating = disc["trackContentRating"] as? String
        obj.minimumOSVersion = disc["minimumOsVersion"] as? String
        obj.currentVersionReleaseDate = disc["currentVersionReleaseDate"] as? Date
        obj.artistID = disc["artistId"] as? Int
        obj.artistName = disc["artistName"] as? String
        obj.genres = disc["genres"] as? [String]
        obj.price = disc["price"] as? Int
        obj.description = disc["description"] as? String
        obj.isVppDeviceBasedLicensingEnabled = disc["isVppDeviceBasedLicensingEnabled"] as? Bool
        obj.primaryGenreName = disc["primaryGenreName"] as? String
        obj.primaryGenreID = disc["primaryGenreId"] as? Int
        obj.sellerName = disc["sellerName"] as? String
        obj.trackID = disc["trackId"] as? Int
        obj.trackName = disc["trackName"] as? String
        obj.genreIDS = disc["genreIds"] as? [String]
        obj.currency = disc["currency"] as? String
        obj.releaseDate = disc["releaseDate"] as? String
        obj.bundleID = disc["bundleId"] as? String
        obj.releaseNotes = disc["releaseNotes"] as? String
        obj.version = disc["version"] as? String
        obj.wrapperType = disc["wrapperType"] as? String
        obj.userRatingCount = disc["userRatingCount"] as? Int
        
        return obj
    }
    
    static func parseData(discs: StringAnyDictArray) -> [Self] {
        discs.compactMap({ Self.parseData(disc: $0) })
    }   // parseData
    
}   // Result

