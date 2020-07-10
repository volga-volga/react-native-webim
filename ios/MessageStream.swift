//
//  MessageStream.swift
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


// MARK: - MessageStream
@objc(MessageStream)
public final class _ObjCMessageStream: NSObject {
    
    // MARK: - Properties
    private let messageStream: MessageStream
    
    private var dataMessageCompletionHandlerWrapper: DataMessageCompletionHandlerWrapper?
    private var rateOperatorCompletionHandlerWrapper: RateOperatorCompletionHandlerWrapper?
    private var sendFileCompletionHandlerWrapper: SendFileCompletionHandlerWrapper?
    private var chatStateListenerWrapper: ChatStateListenerWrapper?
    private var departmentListChangeListenerWrapper: DepartmentListChangeListenerWrapper?
    private var currentOperatorChangeListenerWrapper: CurrentOperatorChangeListenerWrapper?
    private var locationSettingsChangeListenerWrapper: LocationSettingsChangeListenerWrapper?
    private var operatorTypingListenerWrapper: OperatorTypingListenerWrapper?
    private var onlineStatusChangeListenerWrapper: OnlineStatusChangeListenerWrapper?
    private var visitSessionStateListenerWrapper: VisitSessionStateListenerWrapper?
    private var messageListenerWrapper: MessageListenerWrapper?
    private var unreadByOperatorTimestampChangeListenerWrapper: UnreadByOperatorTimestampChangeListenerWrapper?
    private var unreadByVisitorTimestampChangeListenerWrapper: UnreadByVisitorTimestampChangeListenerWrapper?
    private var unreadByVisitorMessageCountChangeListenerWrapper: UnreadByVisitorMessageCountChangeListenerWrapper?
    
    
    // MARK: - Initialization
    init(messageStream: MessageStream) {
        self.messageStream = messageStream
    }
    
    
    // MARK: - Methods
    
    @objc(getVisitSessionState)
    public func getVisitSessionState() -> _ObjCVisitSessionState {
        switch messageStream.getVisitSessionState() {
        case .CHAT:
            return .CHAT
        case .DEPARTMENT_SELECTION:
            return .DEPARTMENT_SELECTION
        case .IDLE:
            return .IDLE
        case .IDLE_AFTER_CHAT:
            return .IDLE_AFTER_CHAT
        case .OFFLINE_MESSAGE:
            return .OFFLINE_MESSAGE
        case .UNKNOWN:
            return .UNKNOWN
        }
    }
    
    @objc(getChatState)
    public func getChatState() -> _ObjCChatState {
        switch messageStream.getChatState() {
        case .CHATTING:
            return .CHATTING
        case .CHATTING_WITH_ROBOT:
            return .CHATTING_WITH_ROBOT
        case .CLOSED_BY_OPERATOR:
            return .CLOSED_BY_OPERATOR
        case .CLOSED_BY_VISITOR:
            return .CLOSED_BY_VISITOR
        case .INVITATION:
            return .INVITATION
        case .NONE:
            return .NONE
        case .QUEUE:
            return .QUEUE
        default:
            return .UNKNOWN
        }
    }
    
    @objc(getUnreadByOperatorTimestamp)
    public func getUnreadByOperatorTimestamp() -> Date? {
        return messageStream.getUnreadByOperatorTimestamp()
    }
    
    @objc(getUnreadByVisitorTimestamp)
    public func getUnreadByVisitorTimestamp() -> Date? {
        return messageStream.getUnreadByVisitorTimestamp()
    }
    
    @objc(getDepartmentList)
    public func getDepartmentList() -> [_ObjCDepartment]? {
        if let departmentList = messageStream.getDepartmentList() {
            var objCDepartmentList = [_ObjCDepartment]()
            for department in departmentList {
                let objCDepartment = _ObjCDepartment(department: department)
                objCDepartmentList.append(objCDepartment)
            }
            
            return objCDepartmentList
        }
        
        return nil
    }
    
    @objc(getLocationSettings)
    public func getLocationSettings() -> _ObjCLocationSettings {
        return _ObjCLocationSettings(locationSettings: messageStream.getLocationSettings())
    }
    
    @objc(getCurrentOperator)
    public func getCurrentOperator() -> _ObjCOperator? {
        if let `operator` = messageStream.getCurrentOperator() {
            return _ObjCOperator(operator: `operator`)
        }
        
        return nil
    }
    
    @objc(getLastRatingOfOperatorWithID:)
    public func getLastRatingOfOperatorWith(id: String) -> Int {
        return messageStream.getLastRatingOfOperatorWith(id: id)
    }
    
    @objc(rateOperatorWithID:byRating:completionHandler:error:)
    public func rateOperatorWith(id: String?,
                          byRating rating: Int,
                          completionHandler: _ObjCRateOperatorCompletionHandler) throws {
        try messageStream.rateOperatorWith(id: id,
                                           byRating: rating,
                                           completionHandler: RateOperatorCompletionHandlerWrapper(rateOperatorCompletionHandler: completionHandler))
    }
    
    @objc(respondSentryCall:error:)
    public func respondSentryCall(id: String) throws {
        try respondSentryCall(id: id)
        
    }
    
    @objc(startChat:)
    public func startChat() throws {
        try messageStream.startChat()
    }
    
    @objc(startChatWithDepartmentKey:error:)
    public func startChat(departmentKey: String?) throws {
        try messageStream.startChat(departmentKey: departmentKey)
    }
    
    @objc(startChatWithCustomFields:error:)
    public func startChat(customFields: String?) throws {
        try messageStream.startChat(customFields: customFields)
    }
    
    
    @objc(startChatWithFirstQuestion:error:)
    public func startChat(firstQuestion: String?) throws {
        try messageStream.startChat(firstQuestion: firstQuestion)
    }
    
    @objc(startChatWithDepartmentKey:firstQuestion:error:)
    public func startChat(departmentKey: String?,
                   firstQuestion: String?) throws {
        try messageStream.startChat(departmentKey: departmentKey,
                                    firstQuestion: firstQuestion)
    }
    
    @objc(startChatWithFirstQuestion:customFields:error:)
    public func startChat(firstQuestion: String?,
                   customFields: String?) throws {
        try messageStream.startChat(firstQuestion: firstQuestion,
                                    customFields: customFields)
    }
    
    @objc(startChatWithDepartmentKey:customFields:error:)
    public func startChat(departmentKey: String?,
                   customFields: String?) throws {
        try messageStream.startChat(departmentKey: departmentKey,
                                    customFields: customFields)
    }
    
    @objc(startChatWithDepartmentKey:firstQuestion:customFields:error:)
    public func startChat(departmentKey: String?,
                   firstQuestion: String?,
                   customFields: String?) throws {
        try messageStream.startChat(departmentKey: departmentKey,
                                    firstQuestion: firstQuestion,
                                    customFields: customFields)
    }
    
    @objc(closeChat:)
    public func closeChat() throws {
        try messageStream.closeChat()
    }
    
    @objc(setVisitorTypingDraftMessage:error:)
    public func setVisitorTyping(draftMessage: String?) throws {
        try messageStream.setVisitorTyping(draftMessage: draftMessage)
    }
    
    @objc(setPrechatFields:error:)
    public func set(prechatFields: String) throws {
        try messageStream.set(prechatFields: prechatFields)
    }
    
    @objc(sendMessage:error:)
    public func send(message: String) throws -> String {
        return try messageStream.send(message: message)
    }
    
    @objc(sendMessage:data:completionHandler:error:)
    public func send(message: String,
              data: [String: Any]?,
              completionHandler: _ObjCDataMessageCompletionHandler?) throws -> String {
        return try messageStream.send(message: message,
                                      data: data,
                                      completionHandler: ((completionHandler == nil) ? nil : DataMessageCompletionHandlerWrapper(dataMessageCompletionHandler: completionHandler!)))
    }
    
    @objc(sendMessage:isHintQuestion:error:)
    public func send(message: String,
              isHintQuestion: Bool) throws -> String {
        return try messageStream.send(message: message,
                                      isHintQuestion: isHintQuestion)
    }
    
    @objc(sendFile:filename:mimeType:completionHandler:error:)
    public func send(file: Data,
              filename: String,
              mimeType: String,
              completionHandler: _ObjCSendFileCompletionHandler?) throws -> String {
        return try messageStream.send(file: file,
                                      filename: filename,
                                      mimeType: mimeType,
                                      completionHandler: ((completionHandler == nil) ? nil : SendFileCompletionHandlerWrapper(sendFileCompletionHandler: completionHandler!)))
    }
    
    @objc(editMessage:text:completionHandler:error:)
    public func edit(message: _ObjCMessage,
              text: String,
              completionHandler: _ObjCEditMessageCompletionHandler?) throws -> NSNumber {
        let canBeEdited = try messageStream.edit(message: message.message,
                                                 text: text,
                                                 completionHandler: ((completionHandler == nil) ? nil : EditMessageCompletionHandlerWrapper(editMessageCompletionHandler: completionHandler!)))
        if canBeEdited {
            return 1
        } else {
            return 0
        }
    }
    
    @objc(deleteMessage:completionHandler:error:)
    public func delete(message: _ObjCMessage,
                completionHandler: _ObjCDeleteMessageCompletionHandler?) throws -> NSNumber {
        let canBeEdited = try messageStream.delete(message: message.message,
                                               completionHandler: ((completionHandler == nil) ? nil : DeleteMessageCompletionHandlerWrapper(deleteMessageCompletionHandler: completionHandler!)))
        if canBeEdited {
            return 1
        } else {
            return 0
        }
    }
    
    @objc(setChatRead:)
    public func setChatRead() throws {
        try messageStream.setChatRead()
    }
    
    @objc(newMessageTrackerWithMessageListener:error:)
    public func newMessageTracker(messageListener: _ObjCMessageListener) throws -> _ObjCMessageTracker {
        let wrapper = MessageListenerWrapper(messageListener: messageListener)
        messageListenerWrapper = wrapper
        return try _ObjCMessageTracker(messageTracker: messageStream.newMessageTracker(messageListener: wrapper))
    }
    
    @objc(setVisitSessionStateListener:)
    public func set(visitSessionStateListener: _ObjCVisitSessionStateListener) {
        let wrapper = VisitSessionStateListenerWrapper(visitSessionStateListener: visitSessionStateListener)
        visitSessionStateListenerWrapper = wrapper
        messageStream.set(visitSessionStateListener: wrapper)
    }
    
    @objc(setChatStateListener:)
    public func set(chatStateListener: _ObjCChatStateListener) {
        let wrapper = ChatStateListenerWrapper(chatStateListener: chatStateListener)
        chatStateListenerWrapper = wrapper
        messageStream.set(chatStateListener: wrapper)
    }
    
    @objc(setCurrentOperatorChangeListener:)
    public func set(currentOperatorChangeListener: _ObjCCurrentOperatorChangeListener) {
        let wrapper = CurrentOperatorChangeListenerWrapper(currentOperatorChangeListener: currentOperatorChangeListener)
        currentOperatorChangeListenerWrapper = wrapper
        messageStream.set(currentOperatorChangeListener: wrapper)
    }
    
    @objc(setDepartmentListChangeListener:)
    public func set(departmentListChangeListener: _ObjCDepartmentListChangeListener) {
        let wrapper = DepartmentListChangeListenerWrapper(departmentListChangeListener: departmentListChangeListener)
        departmentListChangeListenerWrapper = wrapper
        messageStream.set(departmentListChangeListener: wrapper)
    }
    
    @objc(LocationSettingsChangeListener:)
    public func set(locationSettingsChangeListener: _ObjCLocationSettingsChangeListener) {
        let wrapper = LocationSettingsChangeListenerWrapper(locationSettingsChangeListener: locationSettingsChangeListener)
        locationSettingsChangeListenerWrapper = wrapper
        messageStream.set(locationSettingsChangeListener: wrapper)
    }
    
    @objc(setOperatorTypingListener:)
    public func set(operatorTypingListener: _ObjCOperatorTypingListener) {
        let wrapper = OperatorTypingListenerWrapper(operatorTypingListener: operatorTypingListener)
        operatorTypingListenerWrapper = wrapper
        messageStream.set(operatorTypingListener: wrapper)
    }
    
    @objc(setOnlineStatusChangeListener:)
    public func set(onlineStatusChangeListener: _ObjCOnlineStatusChangeListener) {
        let wrapper = OnlineStatusChangeListenerWrapper(onlineStatusChangeListener: onlineStatusChangeListener)
        onlineStatusChangeListenerWrapper = wrapper
        messageStream.set(onlineStatusChangeListener: wrapper)
    }
    
    @objc(setUnreadByOperatorTimestampChangeListener:)
    public func set(unreadByOperatorTimestampChangeListener: _ObjCUnreadByOperatorTimestampChangeListener) {
        let wrapper = UnreadByOperatorTimestampChangeListenerWrapper(unreadByOperatorTimestampChangeListener: unreadByOperatorTimestampChangeListener)
        unreadByOperatorTimestampChangeListenerWrapper = wrapper
        messageStream.set(unreadByOperatorTimestampChangeListener: wrapper)
    }
    
    @objc(setUnreadByVisitorTimestampChangeListener:)
    public func set(unreadByVisitorTimestampChangeListener: _ObjCUnreadByVisitorTimestampChangeListener) {
        let wrapper = UnreadByVisitorTimestampChangeListenerWrapper(unreadByVisitorTimestampChangeListener: unreadByVisitorTimestampChangeListener)
        unreadByVisitorTimestampChangeListenerWrapper = wrapper
        messageStream.set(unreadByVisitorTimestampChangeListener: wrapper)
    }
    
    @objc(setUnreadByVisitorMessageCountChangeListener:)
    public func set(unreadByVisitorMessageCountChangeListener: _ObjCUnreadByVisitorMessageCountChangeListener) {
        let wrapper = UnreadByVisitorMessageCountChangeListenerWrapper(unreadByVisitorMessageCountChangeListener: unreadByVisitorMessageCountChangeListener)
        unreadByVisitorMessageCountChangeListenerWrapper = wrapper
        messageStream.set(unreadByVisitorMessageCountChangeListener: wrapper)
    }
        
}

// MARK: - LocationSettings
@objc(LocationSettings)
public final class _ObjCLocationSettings: NSObject {
    
    // MARK: - Properties
    private let locationSettings: LocationSettings
    
    // MARK: - Initialization
    init(locationSettings: LocationSettings) {
        self.locationSettings = locationSettings
    }
    
    // MARK: - Methods
    @objc(areHintsEnabled)
    func areHintsEnabled() -> Bool {
        return locationSettings.areHintsEnabled()
    }
    
}


// MARK: - DataMessageCompletionHandler
@objc(DataMessageCompletionHandler)
public protocol _ObjCDataMessageCompletionHandler {
    
    @objc(onSuccessWithMessageID:)
    func onSuccess(messageID: String)
    
    @objc(onFailureWithMessageID:error:)
    func onFailure(messageID: String,
                   error: _ObjCDataMessageError)
    
}

// MARK: - EditMessageCompletionHandler
@objc(EditMessageCompletionHandler)
public protocol _ObjCEditMessageCompletionHandler {
    
    @objc(onSuccessWithMessageID:)
    func onSuccess(messageID: String)
    
    @objc(onFailureWithMessageID:error:)
    func onFailure(messageID: String,
                   error: _ObjCEditMessageError)
    
}

// MARK: - DeleteMessageCompletionHandler
@objc(DeleteMessageCompletionHandler)
public protocol _ObjCDeleteMessageCompletionHandler {
    
    @objc(onSuccessWithMessageID:)
    func onSuccess(messageID: String)
    
    @objc(onFailureWithMessageID:error:)
    func onFailure(messageID: String,
                   error: _ObjCDeleteMessageError)
    
}

// MARK: - SendFileCompletionHandler
@objc(SendFileCompletionHandler)
public protocol _ObjCSendFileCompletionHandler {
    
    @objc(onSuccessWithMessageID:)
    func onSuccess(messageID: String)
    
    @objc(onFailureWithMessageID:error:)
    func onFailure(messageID: String,
                   error: _ObjCSendFileError)
    
}

// MARK: - RateOperatorCompletionHandler
@objc(RateOperatorCompletionHandler)
public protocol _ObjCRateOperatorCompletionHandler {
    
    @objc(onSuccess)
    func onSuccess()
    
    @objc(onFailure:)
    func onFailure(error: _ObjCRateOperatorError)
    
}

// MARK: - VisitSessionStateListener
@objc(VisitSessionStateListener)
public protocol _ObjCVisitSessionStateListener {
    
    @objc(changedState:to:)
    func changed(state previousState: _ObjCVisitSessionState,
                 to newState: _ObjCVisitSessionState)
    
}

// MARK: - ChatStateListener
@objc(ChatStateListener)
public protocol _ObjCChatStateListener {
    
    @objc(changedState:to:)
    func changed(state previousState: _ObjCChatState,
                 to newState: _ObjCChatState)
    
}

// MARK: - CurrentOperatorChangeListener
@objc(CurrentOperatorChangeListener)
public protocol _ObjCCurrentOperatorChangeListener {
    
    @objc(changedOperator:to:)
    func changed(operator previousOperator: _ObjCOperator?,
                 to newOperator: _ObjCOperator?)
    
}

// MARK: - DepartmentListChangeListener
@objc(DepartmentListChangeListener)
public protocol _ObjCDepartmentListChangeListener {
    
    @objc(receivedDepartmentList:)
    func received(departmentList: [_ObjCDepartment])
    
}

// MARK: - LocationSettingsChangeListener
@objc(LocationSettingsChangeListener)
public protocol _ObjCLocationSettingsChangeListener {
    
    @objc(changedLocationSettings:to:)
    func changed(locationSettings previousLocationSettings: _ObjCLocationSettings,
                 to newLocationSettings: _ObjCLocationSettings)
    
}

// MARK: - OperatorTypingListener
@objc(OperatorTypingListener)
public protocol _ObjCOperatorTypingListener {
    
    @objc(onOperatorTypingStateChangedTo:)
    func onOperatorTypingStateChanged(isTyping: Bool)
    
}

// MARK: - OnlineStatusChangeListener
@objc(SessionOnlineStatusChangeListener)
public protocol _ObjCOnlineStatusChangeListener {
    
    @objc(changedOnlineStatus:to:)
    func changed(onlineStatus previousOnlineStatus: _ObjCOnlineStatus,
                 to newOnlineStatus: _ObjCOnlineStatus)
    
}

// MARK: - UnreadByOperatorTimestampChangeListener
@objc(UnreadByOperatorTimestampChangeListener)
public protocol _ObjCUnreadByOperatorTimestampChangeListener {
    
    @objc(changedUnreadByOperatorTimestampTo:)
    func changedUnreadByOperatorTimestampTo(newValue: Date?)
    
}

// MARK: - UnreadByVisitorTimestampChangeListener
@objc(UnreadByVisitorTimestampChangeListener)
public protocol _ObjCUnreadByVisitorTimestampChangeListener {
    
    @objc(changedUnreadByVisitorTimestampTo:)
    func changedUnreadByVisitorTimestampTo(newValue: Date?)
    
}

// MARK: - UnreadByVisitorMessageCountChangeListener
@objc(UnreadByVisitorMessageCountChangeListener)
public protocol _ObjCUnreadByVisitorMessageCountChangeListener {
    
    @objc(changedUnreadByVisitorMessageCountTo:)
    func changedUnreadByVisitorMessageCountTo(newValue: Int)
    
}

// MARK: - ChatState
@objc(ChatState)
public enum _ObjCChatState: Int {
    case CHATTING
    case CHATTING_WITH_ROBOT
    case CLOSED_BY_OPERATOR
    case CLOSED_BY_VISITOR
    case INVITATION
    case NONE
    case QUEUE
    case UNKNOWN
}

// MARK: - OnlineStatus
@objc(OnlineStatus)
public enum _ObjCOnlineStatus: Int {
    case BUSY_OFFLINE
    case BUSY_ONLINE
    case OFFLINE
    case ONLINE
    case UNKNOWN
}

// MARK: - VisitSessionState
@objc(VisitSessionState)
public enum _ObjCVisitSessionState: Int {
    case CHAT
    case DEPARTMENT_SELECTION
    case IDLE
    case IDLE_AFTER_CHAT
    case OFFLINE_MESSAGE
    case UNKNOWN
}

// MARK: - DataMessageError
@objc(DataMessageError)
public enum _ObjCDataMessageError: Int, Error {
    case QUOTED_MESSAGE_CANNOT_BE_REPLIED
    case QUOTED_MESSAGE_FROM_ANOTHER_VISITOR
    case QUOTED_MESSAGE_MULTIPLE_IDS
    case QUOTED_MESSAGE_REQUIRED_ARGUMENTS_MISSING
    case QUOTED_MESSAGE_WRONG_ID
    case UNKNOWN
}

// MARK: - EditMessageError
@objc(EditMessageError)
public enum _ObjCEditMessageError: Int, Error {
    case UNKNOWN
    case NOT_ALLOWED
    case MESSAGE_EMPTY
    case MESSAGE_NOT_OWNED
    case MAX_LENGTH_EXCEEDED
    case WRONG_MESSAGE_KIND
}

// MARK: - DeleteMessageError
@objc(DeleteMessageError)
public enum _ObjCDeleteMessageError: Int, Error {
    case UNKNOWN
    case NOT_ALLOWED
    case MESSAGE_NOT_OWNED
    case MESSAGE_NOT_FOUND
}

// MARK: - SendFileError
@objc(SendFileError)
public enum _ObjCSendFileError: Int, Error {
    case FILE_SIZE_EXCEEDED
    case FILE_TYPE_NOT_ALLOWED
    case UPLOADED_FILE_NOT_FOUND
    case UNKNOWN
}

// MARK: - RateOperatorError
@objc(RateOperatorError)
public enum _ObjCRateOperatorError: Int, Error {
    case NO_CHAT
    case WRONG_OPERATOR_ID
}


// MARK: - Protocols' wrappers

// MARK: - DataMessageCompletionHandler
fileprivate final class DataMessageCompletionHandlerWrapper: DataMessageCompletionHandler {
    
    // MARK: - Properties
    private weak var dataMessageCompletionHandler: _ObjCDataMessageCompletionHandler?
    
    
    // MARK: - Initialization
    init(dataMessageCompletionHandler: _ObjCDataMessageCompletionHandler) {
        self.dataMessageCompletionHandler = dataMessageCompletionHandler
    }
    
    
    // MARK: - Methods
    // MARK: DataMessageCompletionHandler protocol methods
    
    func onSuccess(messageID: String) {
        dataMessageCompletionHandler?.onSuccess(messageID: messageID)
    }
    
    func onFailure(messageID: String, error: DataMessageError) {
        var objCError: _ObjCDataMessageError?
        switch error {
        case .QUOTED_MESSAGE_CANNOT_BE_REPLIED:
            objCError = .QUOTED_MESSAGE_CANNOT_BE_REPLIED
        case .QUOTED_MESSAGE_FROM_ANOTHER_VISITOR:
            objCError = .QUOTED_MESSAGE_FROM_ANOTHER_VISITOR
        case .QUOTED_MESSAGE_MULTIPLE_IDS:
            objCError = .QUOTED_MESSAGE_MULTIPLE_IDS
        case .QUOTED_MESSAGE_REQUIRED_ARGUMENTS_MISSING:
            objCError = .QUOTED_MESSAGE_REQUIRED_ARGUMENTS_MISSING
        case .QUOTED_MESSAGE_WRONG_ID:
            objCError = .QUOTED_MESSAGE_WRONG_ID
        case .UNKNOWN:
            objCError = .UNKNOWN
        }
        
        dataMessageCompletionHandler?.onFailure(messageID: messageID,
                                               error: objCError!)
    }
    
}

// MARK: - EditMessageCompletionHandler
fileprivate final class EditMessageCompletionHandlerWrapper: EditMessageCompletionHandler {
    
    // MARK: - Properties
    private weak var editMessageCompletionHandler: _ObjCEditMessageCompletionHandler?
    
    
    // MARK: - Initialization
    init(editMessageCompletionHandler: _ObjCEditMessageCompletionHandler) {
        self.editMessageCompletionHandler = editMessageCompletionHandler
    }
    
    
    // MARK: - Methods
    // MARK: EditMessageCompletionHandler protocol methods
    
    func onSuccess(messageID: String) {
        editMessageCompletionHandler?.onSuccess(messageID: messageID)
    }
    
    func onFailure(messageID: String, error: EditMessageError) {
        var objCError: _ObjCEditMessageError?
        switch error {
        case .NOT_ALLOWED:
            objCError = .NOT_ALLOWED
        case .MESSAGE_EMPTY:
            objCError = .MESSAGE_EMPTY
        case .MESSAGE_NOT_OWNED:
            objCError = .MESSAGE_NOT_OWNED
        case .MAX_LENGTH_EXCEEDED:
            objCError = .MAX_LENGTH_EXCEEDED
        case .WRONG_MESSAGE_KIND:
            objCError = .WRONG_MESSAGE_KIND
        case .UNKNOWN:
            objCError = .UNKNOWN
        }
        
        editMessageCompletionHandler?.onFailure(messageID: messageID,
                                                error: objCError!)
    }
    
}

// MARK: - DeleteMessageCompletionHandler
fileprivate final class DeleteMessageCompletionHandlerWrapper: DeleteMessageCompletionHandler {
    
    // MARK: - Properties
    private weak var deleteMessageCompletionHandler: _ObjCDeleteMessageCompletionHandler?
    
    
    // MARK: - Initialization
    init(deleteMessageCompletionHandler: _ObjCDeleteMessageCompletionHandler) {
        self.deleteMessageCompletionHandler = deleteMessageCompletionHandler
    }
    
    
    // MARK: - Methods
    // MARK: DeleteMessageCompletionHandler protocol methods
    
    func onSuccess(messageID: String) {
        deleteMessageCompletionHandler?.onSuccess(messageID: messageID)
    }
    
    func onFailure(messageID: String, error: DeleteMessageError) {
        var objCError: _ObjCDeleteMessageError?
        switch error {
        case .UNKNOWN:
            objCError = .UNKNOWN
        case .NOT_ALLOWED:
            objCError = .NOT_ALLOWED
        case .MESSAGE_NOT_OWNED:
            objCError = .MESSAGE_NOT_OWNED
        case .MESSAGE_NOT_FOUND:
            objCError = .MESSAGE_NOT_FOUND
        }
        
        deleteMessageCompletionHandler?.onFailure(messageID: messageID,
                                                  error: objCError!)
    }
    
}

// MARK: - SendFileCompletionHandler
fileprivate final class SendFileCompletionHandlerWrapper: SendFileCompletionHandler {
    
    // MARK: - Properties
    private var sendFileCompletionHandler: _ObjCSendFileCompletionHandler?
    
    
    // MARK: - Initialization
    init(sendFileCompletionHandler: _ObjCSendFileCompletionHandler) {
        self.sendFileCompletionHandler = sendFileCompletionHandler
    }
    
    
    // MARK: - Methods
    // MARK: SendFileCompletionHandler protocol methods
    
    func onSuccess(messageID: String) {
        sendFileCompletionHandler?.onSuccess(messageID: messageID)
    }
    
    func onFailure(messageID: String,
                   error: SendFileError) {
        var objCError: _ObjCSendFileError?
        switch error {
        case .FILE_SIZE_EXCEEDED:
            objCError = .FILE_SIZE_EXCEEDED
        case .FILE_TYPE_NOT_ALLOWED:
            objCError = .FILE_TYPE_NOT_ALLOWED
        case .UPLOADED_FILE_NOT_FOUND:
            objCError = .UPLOADED_FILE_NOT_FOUND
        case .UNKNOWN:
            objCError = .UNKNOWN
        }
        
        sendFileCompletionHandler?.onFailure(messageID: messageID,
                                            error: objCError!)
    }
    
}

// MARK: - RateOperatorCompletionHandler
fileprivate final class RateOperatorCompletionHandlerWrapper: RateOperatorCompletionHandler {
    
    // MARK: - Properties
    private weak var rateOperatorCompletionHandler: _ObjCRateOperatorCompletionHandler?
    
    
    // MARK: - Initialization
    init(rateOperatorCompletionHandler: _ObjCRateOperatorCompletionHandler) {
        self.rateOperatorCompletionHandler = rateOperatorCompletionHandler
    }
    
    
    // MARK: - Methods
    // MARK: RateOperatorCompletionHandler protocol methods
    
    func onSuccess() {
        rateOperatorCompletionHandler?.onSuccess()
    }
    
    func onFailure(error: RateOperatorError) {
        var objCError: _ObjCRateOperatorError?
        switch error {
        case .NO_CHAT:
            objCError = .NO_CHAT
        case .WRONG_OPERATOR_ID:
            objCError = .WRONG_OPERATOR_ID
        }
        
        rateOperatorCompletionHandler?.onFailure(error: objCError!)
    }
    
}

// MARK: - VisitSessionStateListener
fileprivate final class VisitSessionStateListenerWrapper: VisitSessionStateListener {
    
    // MARK: - Properties
    private weak var visitSessionStateListener: _ObjCVisitSessionStateListener?
    
    // MARK: - Initialization
    init(visitSessionStateListener: _ObjCVisitSessionStateListener) {
        self.visitSessionStateListener = visitSessionStateListener
    }
    
    // MARK: - Methods
    // MARK: VisitSessionStateListener protocol methods
    func changed(state previousState: VisitSessionState,
                 to newState: VisitSessionState) {
        var previousObjCVisitSessionState: _ObjCVisitSessionState?
        switch previousState {
        case .CHAT:
            previousObjCVisitSessionState = .CHAT
        case .DEPARTMENT_SELECTION:
            previousObjCVisitSessionState = .DEPARTMENT_SELECTION
        case .IDLE:
            previousObjCVisitSessionState = .IDLE
        case .IDLE_AFTER_CHAT:
            previousObjCVisitSessionState = .IDLE_AFTER_CHAT
        case .OFFLINE_MESSAGE:
            previousObjCVisitSessionState = .OFFLINE_MESSAGE
        case .UNKNOWN:
            previousObjCVisitSessionState = .UNKNOWN
        }
        
        var newObjCVisitSessionState: _ObjCVisitSessionState?
        switch previousState {
        case .CHAT:
            newObjCVisitSessionState = .CHAT
        case .DEPARTMENT_SELECTION:
            newObjCVisitSessionState = .DEPARTMENT_SELECTION
        case .IDLE:
            newObjCVisitSessionState = .IDLE
        case .IDLE_AFTER_CHAT:
            newObjCVisitSessionState = .IDLE_AFTER_CHAT
        case .OFFLINE_MESSAGE:
            newObjCVisitSessionState = .OFFLINE_MESSAGE
        case .UNKNOWN:
            newObjCVisitSessionState = .UNKNOWN
        }
        
        visitSessionStateListener?.changed(state: previousObjCVisitSessionState!,
                                          to: newObjCVisitSessionState!)
    }
    
}

// MARK: - ChatStateListener
fileprivate final class ChatStateListenerWrapper: ChatStateListener {
    
    // MARK: - Properties
    private let chatStateListener: _ObjCChatStateListener
    
    // MARK: - Initialization
    init(chatStateListener: _ObjCChatStateListener) {
        self.chatStateListener = chatStateListener
    }
    
    // MARK: - Methods
    // MARK: ChatStateListener protocol methods
    func changed(state previousState: ChatState,
                 to newState: ChatState) {
        var previousObjCChatState: _ObjCChatState?
        switch previousState {
        case .CHATTING:
            previousObjCChatState = .CHATTING
        case .CHATTING_WITH_ROBOT:
            previousObjCChatState = .CHATTING_WITH_ROBOT
        case .CLOSED_BY_OPERATOR:
            previousObjCChatState = .CLOSED_BY_OPERATOR
        case .CLOSED_BY_VISITOR:
            previousObjCChatState = .CLOSED_BY_VISITOR
        case .INVITATION:
            previousObjCChatState = .INVITATION
        case .NONE:
            previousObjCChatState = .NONE
        case .QUEUE:
            previousObjCChatState = .QUEUE
        case .UNKNOWN:
            previousObjCChatState = .UNKNOWN
        }
        
        var newObjCChatState: _ObjCChatState?
        switch newState {
        case .CHATTING:
            newObjCChatState = .CHATTING
        case .CHATTING_WITH_ROBOT:
            newObjCChatState = .CHATTING_WITH_ROBOT
        case .CLOSED_BY_OPERATOR:
            newObjCChatState = .CLOSED_BY_OPERATOR
        case .CLOSED_BY_VISITOR:
            newObjCChatState = .CLOSED_BY_VISITOR
        case .INVITATION:
            newObjCChatState = .INVITATION
        case .NONE:
            newObjCChatState = .NONE
        case .QUEUE:
            newObjCChatState = .QUEUE
        case .UNKNOWN:
            newObjCChatState = .UNKNOWN
        }
        
        chatStateListener.changed(state: previousObjCChatState!,
                                  to: newObjCChatState!)
    }
    
}

// MARK: - CurrentOperatorChangeListener
fileprivate final class CurrentOperatorChangeListenerWrapper: CurrentOperatorChangeListener {
    
    // MARK: - Properties
    private weak var currentOperatorChangeListener: _ObjCCurrentOperatorChangeListener?
    
    // MARK: - Initialization
    init(currentOperatorChangeListener: _ObjCCurrentOperatorChangeListener) {
        self.currentOperatorChangeListener = currentOperatorChangeListener
    }
    
    // MARK: - Methods
    // MARK: - CurrentOperatorChangeListener protocol methods
    func changed(operator previousOperator: Operator?,
                 to newOperator: Operator?) {
        currentOperatorChangeListener?.changed(operator: ((previousOperator == nil) ? nil : _ObjCOperator(operator: previousOperator!)),
                                              to: ((newOperator == nil) ? nil : _ObjCOperator(operator: newOperator!)))
    }
    
}

// MARK: - DepartmentListChangeListener
fileprivate final class DepartmentListChangeListenerWrapper: DepartmentListChangeListener {
    
    // MARK: - Properties
    private weak var departmentListChangeListener: _ObjCDepartmentListChangeListener?
    
    // MARK: - Initialization
    init(departmentListChangeListener: _ObjCDepartmentListChangeListener) {
        self.departmentListChangeListener = departmentListChangeListener
    }
    
    // MARK: - Methods
    // MARK: DepartmentListChangeListener
    func received(departmentList: [Department]) {
        var objCDepartmentList = [_ObjCDepartment]()
        for department in departmentList {
            let objCDepartment = _ObjCDepartment(department: department)
            objCDepartmentList.append(objCDepartment)
        }
        
        departmentListChangeListener?.received(departmentList: objCDepartmentList)
    }
    
}

// MARK: - LocationSettingsChangeListener
fileprivate final class LocationSettingsChangeListenerWrapper: LocationSettingsChangeListener {
    
    // MARK: - Properties
    private weak var locationSettingsChangeListener: _ObjCLocationSettingsChangeListener?
    
    // MARK: - Initialization
    init(locationSettingsChangeListener: _ObjCLocationSettingsChangeListener) {
        self.locationSettingsChangeListener = locationSettingsChangeListener
    }
    
    // MARK: - Methods
    // MARK: LocationSettingsChangeListener protocol methods
    func changed(locationSettings previousLocationSettings: LocationSettings,
                 to newLocationSettings: LocationSettings) {
        locationSettingsChangeListener?.changed(locationSettings: _ObjCLocationSettings(locationSettings: previousLocationSettings),
                                               to: _ObjCLocationSettings(locationSettings: newLocationSettings))
    }
    
}

// MARK: - OperatorTypingListener
fileprivate final class OperatorTypingListenerWrapper: OperatorTypingListener {
    
    // MARK: - Properties
    private weak var operatorTypingListener: _ObjCOperatorTypingListener?
    
    // MARK: - Initialization
    init(operatorTypingListener: _ObjCOperatorTypingListener) {
        self.operatorTypingListener = operatorTypingListener
    }
    
    // MARK: - Methods
    // MARK: OperatorTypingListener protocol methods
    func onOperatorTypingStateChanged(isTyping: Bool) {
        operatorTypingListener?.onOperatorTypingStateChanged(isTyping: isTyping)
    }
    
}

// MARK: - OnlineStatusChangeListener
fileprivate final class OnlineStatusChangeListenerWrapper: OnlineStatusChangeListener {
    
    // MARK: - Properties
    private weak var onlineStatusChangeListener: _ObjCOnlineStatusChangeListener?
    
    // MARK: - Initialization
    init(onlineStatusChangeListener: _ObjCOnlineStatusChangeListener) {
        self.onlineStatusChangeListener = onlineStatusChangeListener
    }
    
    // MARK: - Methods
    // MARK: SessionOnlineStatusChangeListener protocol methods
    func changed(onlineStatus previousOnlineStatus: OnlineStatus,
                 to newOnlineStatus: OnlineStatus) {
        var previousObjCOnlineStatus: _ObjCOnlineStatus?
        switch previousOnlineStatus {
        case .BUSY_OFFLINE:
            previousObjCOnlineStatus = .BUSY_OFFLINE
        case .BUSY_ONLINE:
            previousObjCOnlineStatus = .BUSY_ONLINE
        case .OFFLINE:
            previousObjCOnlineStatus = .OFFLINE
        case .ONLINE:
            previousObjCOnlineStatus = .ONLINE
        case .UNKNOWN:
            previousObjCOnlineStatus = .UNKNOWN
        }
        
        var newObjCOnlineStatus: _ObjCOnlineStatus?
        switch newOnlineStatus {
        case .BUSY_OFFLINE:
            newObjCOnlineStatus = .BUSY_OFFLINE
        case .BUSY_ONLINE:
            newObjCOnlineStatus = .BUSY_ONLINE
        case .OFFLINE:
            newObjCOnlineStatus = .OFFLINE
        case .ONLINE:
            newObjCOnlineStatus = .ONLINE
        case .UNKNOWN:
            newObjCOnlineStatus = .UNKNOWN
        }
        
        onlineStatusChangeListener?.changed(onlineStatus: previousObjCOnlineStatus!,
                                           to: newObjCOnlineStatus!)
    }
    
    
}

// MARK: - UnreadByOperatorTimestampChangeListener
fileprivate final class UnreadByOperatorTimestampChangeListenerWrapper: UnreadByOperatorTimestampChangeListener {
    
    // MARK: - Properties
    private weak var unreadByOperatorTimestampChangeListener: _ObjCUnreadByOperatorTimestampChangeListener?
    
    // MARK: - Initialization
    init(unreadByOperatorTimestampChangeListener: _ObjCUnreadByOperatorTimestampChangeListener) {
        self.unreadByOperatorTimestampChangeListener = unreadByOperatorTimestampChangeListener
    }
    
    // MARK: - Methods
    // MARK: UnreadByOperatorTimestampChangeListener protocol methods
    func changedUnreadByOperatorTimestampTo(newValue: Date?) {
        unreadByOperatorTimestampChangeListener?.changedUnreadByOperatorTimestampTo(newValue: newValue)
    }
    
}

// MARK: - UnreadByVisitorTimestampChangeListener
fileprivate final class UnreadByVisitorTimestampChangeListenerWrapper: UnreadByVisitorTimestampChangeListener {
    
    // MARK: - Properties
    private weak var unreadByVisitorTimestampChangeListener: _ObjCUnreadByVisitorTimestampChangeListener?
    
    // MARK: - Initialization
    init(unreadByVisitorTimestampChangeListener: _ObjCUnreadByVisitorTimestampChangeListener) {
        self.unreadByVisitorTimestampChangeListener = unreadByVisitorTimestampChangeListener
    }
    
    // MARK: - Methods
    // MARK: - UnreadByVisitorTimestampChangeListener protocol methods
    func changedUnreadByVisitorTimestampTo(newValue: Date?) {
        unreadByVisitorTimestampChangeListener?.changedUnreadByVisitorTimestampTo(newValue: newValue)
    }
    
}

// MARK: - UnreadByVisitorMessageCountChangeListener
fileprivate final class UnreadByVisitorMessageCountChangeListenerWrapper: UnreadByVisitorMessageCountChangeListener {
    
    // MARK: - Properties
    private weak var unreadByVisitorMessageCountChangeListener: _ObjCUnreadByVisitorMessageCountChangeListener?
    
    // MARK: - Initialization
    init(unreadByVisitorMessageCountChangeListener: _ObjCUnreadByVisitorMessageCountChangeListener) {
        self.unreadByVisitorMessageCountChangeListener = unreadByVisitorMessageCountChangeListener
    }
    
    // MARK: - Methods
    // MARK: - UnreadByVisitorMessageCountChangeListener protocol methods
    func changedUnreadByVisitorMessageCountTo(newValue: Int) {
        unreadByVisitorMessageCountChangeListener?.changedUnreadByVisitorMessageCountTo(newValue: newValue)
    }
    
}
