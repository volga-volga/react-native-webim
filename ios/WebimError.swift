//
//  WebimError.swift
//  WebimClientLibraryWrapper
//
//  Created by Nikita Lazarev-Zubov on 26.10.17.
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


// MARK: - WebimError
@objc(WebimError)
final class _ObjCWebimError: NSObject {
    
    // MARK: - Properties
    private let webimError: WebimError
    
    
    // MARK: - Initialization
    init(webimError: WebimError) {
        self.webimError = webimError
    }
    
    
    // MARK: - Methods
    
    @objc(getErrorType)
    func getErrorType() -> _ObjCFatalErrorType {
        switch webimError.getErrorType() {
        case .ACCOUNT_BLOCKED:
            return .ACCOUNT_BLOCKED
        case .PROVIDED_VISITOR_FIELDS_EXPIRED:
            return .PROVIDED_VISITOR_FIELDS_EXPIRED
        case .UNKNOWN:
            return .UNKNOWN
        case .VISITOR_BANNED:
            return .VISITOR_BANNED
        case .WRONG_PROVIDED_VISITOR_HASH:
            return .WRONG_PROVIDED_VISITOR_HASH
        }
    }
    
    @objc(getErrorString)
    func getErrorString() -> String {
        return webimError.getErrorString()
    }
    
}


// MARK: - FatalErrorType
@objc(FatalErrorType)
enum _ObjCFatalErrorType: Int {
    case ACCOUNT_BLOCKED
    case PROVIDED_VISITOR_FIELDS_EXPIRED
    case UNKNOWN
    case VISITOR_BANNED
    case WRONG_PROVIDED_VISITOR_HASH
}
