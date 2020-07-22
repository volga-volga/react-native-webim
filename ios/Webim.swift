//
//  Webim.swift
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

// MARK: - Webim
@objc(Webim)
public final class _ObjCWebim: NSObject {
    
    // MARK: - Methods
    
    @objc
    public static func newSessionBuilder() -> _ObjCSessionBuilder {
        return _ObjCSessionBuilder(sessionBuilder: Webim.newSessionBuilder())
    }
    
    @objc(parseRemoteNotification:)
    public static func parse(remoteNotification: [AnyHashable: Any]) -> _ObjCWebimRemoteNotification? {
        if let webimRemoteNotification = Webim.parse(remoteNotification: remoteNotification) {
            return _ObjCWebimRemoteNotification(webimRemoteNotification: webimRemoteNotification)
        } else {
            return nil
        }
    }
    
    @objc(parseRemoteNotification:visitorId:)
    static func parse(remoteNotification: [AnyHashable: Any], visitorId: String) -> _ObjCWebimRemoteNotification? {
        if let webimRemoteNotification = Webim.parse(remoteNotification: remoteNotification, visitorId: visitorId) {
            return _ObjCWebimRemoteNotification(webimRemoteNotification: webimRemoteNotification)
        } else {
            return nil
        }
    }
    
    @objc(isWebimRemoteNotification:)
    static func isWebim(remoteNotification: [AnyHashable: Any]) -> NSNumber {
        return Webim.isWebim(remoteNotification: remoteNotification) as NSNumber
    }
    
    
    // MARK: - RemoteNotificationSystem
    @objc(RemoteNotificationSystem)
    public enum _ObjCRemoteNotificationSystem: Int {
        case APNS
        case NONE
    }
    
}

// MARK: - SessionBuilder
@objc(SessionBuilder)
public final class _ObjCSessionBuilder: NSObject {
    
    // MARK: - Properties
    private (set) var sessionBuilder: SessionBuilder
    private var webimLoggerWrapper: WebimLoggerWrapper?
    
    
    // MARK: - Initialization
    init(sessionBuilder: SessionBuilder) {
        self.sessionBuilder = sessionBuilder
    }
    
    
    // MARK: - Methods
    
    @objc(setAccountName:)
    public func set(accountName: String) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(accountName: accountName)
        
        return self
    }
    
    @objc(setLocation:)
    public func set(location: String) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(location: location)
        
        return self
    }
    
    @objc(setPrechat:)
    public func set(prechat: String) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(prechat: prechat)
        
        return self
    }
    
    @objc(setAppVersion:)
    public func set(appVersion: String) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(appVersion: appVersion)
        
        return self
    }
    
    @objc(setVisitorFieldsJSONString:)
    public func set(visitorFieldsJSONString: String) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(visitorFieldsJSONString: visitorFieldsJSONString)
        
        return self
    }
    
    @objc(setVisitorFieldsJSONData:)
    public func set(visitorFieldsJSONData: Data) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(visitorFieldsJSONData: visitorFieldsJSONData)
        
        return self
    }
    
    @objc(setProvidedAuthorizationTokenStateListener:providedAuthorizationToken:)
    public func set(providedAuthorizationTokenStateListener: _ObjCProvidedAuthorizationTokenStateListener,
             providedAuthorizationToken: String? = nil) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(providedAuthorizationTokenStateListener: ProvidedAuthorizationTokenStateListenerWrapper(providedAuthorizationTokenStateListener: providedAuthorizationTokenStateListener),
                                            providedAuthorizationToken: providedAuthorizationToken)
        
        return self
    }
    
    @objc(setPageTitle:)
    public func set(pageTitle: String) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(pageTitle: pageTitle)
        
        return self
    }
    
    @objc(setFatalErrorHandler:)
    public func set(fatalErrorHandler: _ObjCFatalErrorHandler) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(fatalErrorHandler: FatalErrorHandlerWrapper(fatalErrorHandler: fatalErrorHandler))
        
        return self
    }
    
    @objc(setRemoteNotificationSystem:)
    public func set(remoteNotificationSystem: _ObjCWebim._ObjCRemoteNotificationSystem) -> _ObjCSessionBuilder {
        var webimRemoteNotificationSystem: Webim.RemoteNotificationSystem?
        switch remoteNotificationSystem {
        case .APNS:
            webimRemoteNotificationSystem = .APNS
        default:
            webimRemoteNotificationSystem = .NONE
        }
        sessionBuilder = sessionBuilder.set(remoteNotificationSystem: webimRemoteNotificationSystem!)
        
        return self
    }
    
    @objc(setDeviceToken:)
    public func set(deviceToken: String?) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(deviceToken: deviceToken)
        
        return self
    }
    
    @objc(setIsLocalHistoryStoragingEnabled:)
    public func set(isLocalHistoryStoragingEnabled: Bool) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(isLocalHistoryStoragingEnabled: isLocalHistoryStoragingEnabled)
        
        return self
    }
    
    @objc(setIsVisitorDataClearingEnabled:)
    public func set(isVisitorDataClearingEnabled: Bool) -> _ObjCSessionBuilder {
        sessionBuilder = sessionBuilder.set(isVisitorDataClearingEnabled: isVisitorDataClearingEnabled)
        
        return self
    }
    
    @objc(setWebimLogger:verbosityLevel:)
    public func set(webimLogger: _ObjCWebimLogger,
             verbosityLevel: _ObjCWebimLoggerVerbosityLevel) -> _ObjCSessionBuilder {
        var internalVerbosityLevel: SessionBuilder.WebimLoggerVerbosityLevel?
        switch verbosityLevel {
        case .VERBOSE:
            internalVerbosityLevel = .VERBOSE
        case .DEBUG:
            internalVerbosityLevel = .DEBUG
        case .INFO:
            internalVerbosityLevel = .INFO
        case .WARNING:
            internalVerbosityLevel = .WARNING
        case .ERROR:
            internalVerbosityLevel = .ERROR
        }
        let wrapper = WebimLoggerWrapper(webimLogger: webimLogger)
        webimLoggerWrapper = wrapper
        sessionBuilder = sessionBuilder.set(webimLogger: wrapper,
                                            verbosityLevel: internalVerbosityLevel!)
        
        return self
    }
    
    @objc(build:)
    public func build() throws -> _ObjCWebimSession {
        return try _ObjCWebimSession(webimSession: sessionBuilder.build())
    }
    
    // MARK: -
    @objc(WebimLoggerVerbosityLevel)
    public enum _ObjCWebimLoggerVerbosityLevel: Int {
        case VERBOSE
        case DEBUG
        case INFO
        case WARNING
        case ERROR
    }
    
}


// MARK: - Protocols' wrappers
fileprivate final class FatalErrorHandlerWrapper: FatalErrorHandler {
    
    // MARK: - Properties
    private let fatalErrorHandler: _ObjCFatalErrorHandler
    
    // MARK: - Initialization
    init(fatalErrorHandler: _ObjCFatalErrorHandler) {
        self.fatalErrorHandler = fatalErrorHandler
    }
    
    // MARK: - Methods
    // MARK: FatalErrorHandler methods
    func on(error: WebimError) {
        fatalErrorHandler.on(error: _ObjCWebimError(webimError: error))
    }
    
}
