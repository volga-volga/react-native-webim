//
//  WebimSession.swift
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


// MARK: - WebimSession
@objc(WebimSession)
final class _ObjCWebimSession: NSObject {
    
    // MARK: - Properties
    private let webimSession: WebimSession
    
    
    // MARK: - Initializers
    init(webimSession: WebimSession) {
        self.webimSession = webimSession
    }
    
    
    // MARK: - Methods
    
    @objc(resume:)
    func resume() throws {
        try webimSession.resume()
    }
    
    @objc(pause:)
    func pause() throws {
        try webimSession.pause()
    }
    
    @objc(destroy:)
    func destry() throws {
        try webimSession.destroy()
    }
    
    @objc(destroyWithClearVisitorData:)
    func destroyWithClearVisitorData() throws {
        try webimSession.destroyWithClearVisitorData()
    }
    
    @objc(getStream)
    func getStream() -> _ObjCMessageStream {
        return _ObjCMessageStream(messageStream: webimSession.getStream())
    }
    
    @objc(changeLocation:error:)
    func change(location: String) throws {
        try webimSession.change(location: location)
    }
    
    @objc(setDeviceToken:error:)
    func set(deviceToken: String) throws {
        try webimSession.set(deviceToken: deviceToken)
    }
    
}
