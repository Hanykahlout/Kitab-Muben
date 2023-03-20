//
//  Target.swift
//  KitabMubin
//
//  Created by Ibrahim Abdul Aziz on 25/10/2022.
//

import Foundation

enum Endpoint {
    case reciter
    case audio(reciterId: Int,page: Int)
    case aboutApp
    case contactUs
    case prayerTimes(address: String)
    case phoneNumber
    case reciterWith(page: Int)
}

extension Endpoint {
    
    var baseURL: String {
        switch self {
        case .prayerTimes:
            return "http://api.aladhan.com"
        default:
            return "http://api.kitabmuben.com"
        }
    }
    
    var path: String {
        switch self {
        case .reciter:
            return "/api/reciter?with_paginate=yes"
        case .audio(let reciterId,let page):
            return "/api/reciter/\(reciterId)?page=\(page)&with_paginate=yes"
        case .aboutApp:
            return "/api/about/app"
        case .contactUs:
            return "/api/support/send"
        case .prayerTimes(let address):
            return "/v1/timingsByAddress?address=\(address)"
        case .phoneNumber:
            return "/api/help/data"
        case .reciterWith(let page):
            return "/api/reciter?page=\(page)&with_paginate=yes"
        }
    }
    
    var url: URL? {
//        switch self {
//        default:
        return URL(string: "\(baseURL)\(path)")
//        }
    }
}


protocol APITarget {
    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: APIHTTPMethod { get }

    /// Provides stub data for use in testing.
    var sampleData: Data { get }

    /// The type of HTTP task to be performed.
    var task: APITask { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}

extension APITarget {
    var method: APIHTTPMethod {
        .get
    }

    var task: APITask {
        .requestPlain
    }
}

public struct APIHTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = APIHTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = APIHTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = APIHTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = APIHTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = APIHTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = APIHTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = APIHTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = APIHTTPMethod(rawValue: "PUT")
    /// `TRACE` method.
    public static let trace = APIHTTPMethod(rawValue: "TRACE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}



public enum APITask {

    /// A request with no additional data.
    case requestPlain

    /// A requests body set with data.
    case requestData(Data)

    /// A request body set with `Encodable` type
    case requestJSONEncodable(Encodable)

    /// A request body set with `Encodable` type and custom encoder
    case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)

    /// A requests body set with encoded parameters.
//    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)

    /// A requests body set with data, combined with url parameters.
    case requestCompositeData(bodyData: Data, urlParameters: [String: Any])

    /// A requests body set with encoded parameters combined with url parameters.
//    case requestCompositeParameters(bodyParameters: [String: Any], bodyEncoding: ParameterEncoding, urlParameters: [String: Any])

    /// A file upload task.
    case uploadFile(URL)
}
