//
//  Department.swift
//  ObjectiveCExample
//
//  Created by Nikita Lazarev-Zubov on 13.12.17.
//  Copyright © 2017 Webim. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import WebimClientLibrary

// MARK: - Department
@objc(Department)
final class _ObjCDepartment: NSObject {
    
    // MARK: - Properties
    private let department: Department
    
    
    // MARK: - Initialization
    init(department: Department) {
        self.department = department

    }
    
    
    // MARK: - Methods
    
    @objc(getKey)
    func getKey() -> String {
        return department.getKey()
    }
    
    @objc(getName)
    func getName() -> String {
        return department.getName()
    }
    
    @objc(getDepartmentOnlineStatus)
    func getDepartmentOnlineStatus() -> _ObjCDepartmentOnlineStatus {
        switch department.getDepartmentOnlineStatus() {
        case .BUSY_OFFLINE:
            return .BUSY_OFFLINE
        case .BUSY_ONLINE:
            return .BUSY_ONLINE
        case .OFFLINE:
            return .OFFLINE
        case .ONLINE:
            return .ONLINE
        case .UNKNOWN:
            return .UNKNOWN
        }
    }
    
    @objc(getOrder)
    func getOrder() -> Int {
        return department.getOrder()
    }
    
    @objc(getLocalizedNames)
    func getLocalizedNames() -> [String: String]? {
        return department.getLocalizedNames()
    }
    
    @objc(getLogoURL)
    func getLogoURL() -> URL? {
        return department.getLogoURL()
    }
    
}

// MARK: - DepartmentOnlineStatus
@objc(DepartmentOnlineStatus)
enum _ObjCDepartmentOnlineStatus: Int {
    case BUSY_OFFLINE
    case BUSY_ONLINE
    case OFFLINE
    case ONLINE
    case UNKNOWN
}
