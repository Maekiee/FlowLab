//
//  EndpointProtocol.swift
//  Cachu
//
//  Created by 박도원 on 12/19/25.
//

import Foundation

protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var body: [String: Any]? { get }
}
