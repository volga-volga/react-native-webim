//
//  WebimRemoteNotification.swift
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

// MARK: - WebimRemoteNotification
@objc(WebimRemoteNotification)
final class _ObjCWebimRemoteNotification: NSObject {
    
    // MARK: - Properties
    private let webimRemoteNotification: WebimRemoteNotification
    
    
    // MARK: - Initialization
    init(webimRemoteNotification: WebimRemoteNotification) {
        self.webimRemoteNotification = webimRemoteNotification
    }
    
    
    // MARK: - Methods
    
    @objc(getType)
    func getType() -> _ObjCNotificationType {
        switch webimRemoteNotification.getType() {
        case .CONTACT_INFORMATION_REQUEST:
            return .CONTACT_INFORMATION_REQUEST
        case .OPERATOR_ACCEPTED:
            return .OPERATOR_ACCEPTED
        case .OPERATOR_FILE:
            return .OPERATOR_FILE
        case .OPERATOR_MESSAGE:
            return .OPERATOR_MESSAGE
        case .WIDGET:
            return .WIDGET
        }
    }
    
    @objc(getEvent)
    func getEvent() -> _ObjCNotificationEvent {
        if let event = webimRemoteNotification.getEvent() {
            switch event {
            case .ADD:
                return .ADD
            case .DELETE:
                return .DELETE
            }
        }
        
        return .NONE
    }
    
    @objc(getParameters)
    func getParameters() -> [String] {
        return webimRemoteNotification.getParameters()
    }
    
}


// MARK: - NotificationType
@objc(NotificationType)
enum _ObjCNotificationType: Int {
    case CONTACT_INFORMATION_REQUEST
    case OPERATOR_ACCEPTED
    case OPERATOR_FILE
    case OPERATOR_MESSAGE
    case WIDGET
}

// MARK: - NotificationEvent
@objc(NotificationEvent)
enum _ObjCNotificationEvent: Int {
    case NONE
    case ADD
    case DELETE
}
