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
public final class _ObjCWebimRemoteNotification: NSObject {
    
    // MARK: - Properties
    private let webimRemoteNotification: WebimRemoteNotification
    
    
    // MARK: - Initialization
    public init(webimRemoteNotification: WebimRemoteNotification) {
        self.webimRemoteNotification = webimRemoteNotification
    }
    
    
    // MARK: - Methods
    
    @objc(getType)
    public func getType() -> _ObjCNotificationType {
        switch webimRemoteNotification.getType() {
        case .contactInformationRequest:
            return .CONTACT_INFORMATION_REQUEST
        case .operatorAccepted:
            return .OPERATOR_ACCEPTED
        case .operatorFile:
            return .OPERATOR_FILE
        case .operatorMessage:
            return .OPERATOR_MESSAGE
        case .widget:
            return .WIDGET
        case .none:
            return .NONE
        }
    }
    
    @objc(getEvent)
    public func getEvent() -> _ObjCNotificationEvent {
        if let event = webimRemoteNotification.getEvent() {
            switch event {
            case .add:
                return .ADD
            case .delete:
                return .DELETE
            }
        }
        
        return .NONE
    }
    
    @objc(getParameters)
    public func getParameters() -> [String] {
        return webimRemoteNotification.getParameters()
    }
    
}


// MARK: - NotificationType
@objc(NotificationType)
public enum _ObjCNotificationType: Int {
    case CONTACT_INFORMATION_REQUEST
    case OPERATOR_ACCEPTED
    case OPERATOR_FILE
    case OPERATOR_MESSAGE
    case WIDGET
    case NONE
}

// MARK: - NotificationEvent
@objc(NotificationEvent)
public enum _ObjCNotificationEvent: Int {
    case NONE
    case ADD
    case DELETE
}
