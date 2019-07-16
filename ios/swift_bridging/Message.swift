//
//  Message.swift
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


// MARK: - Message
@objc(Message)
final class _ObjCMessage: NSObject {
    
    // MARK: - Properties
    private (set) var message: Message
    
    
    // MARK: - Initialization
    init(message: Message) {
        self.message = message
    }
    
    // MARK: - Methods
    
    @objc(getAttachment)
    func getAttachment() -> _ObjCMessageAttachment? {
        if let attachment = message.getAttachment() {
            return _ObjCMessageAttachment(messageAttachment: attachment)
        }
        
        return nil
    }
    
    @objc(getData)
    func getData() -> [String: Any]? {
        if let data = message.getData() {
            var objCData = [String: Any]()
            for key in data.keys {
                if let value = data[key] {
                    objCData[key] = value
                }
            }
            
            return objCData
        } else {
            return nil
        }
    }
    
    @objc(getID)
    func getID() -> String {
        return message.getID()
    }
    
    @objc(getOperatorID)
    func getOperatorID() -> String? {
        return message.getOperatorID()
    }
    
    @objc(getSenderAvatarFullURL)
    func getSenderAvatarFullURL() -> URL? {
        return message.getSenderAvatarFullURL()
    }
    
    @objc(getSenderName)
    func getSenderName() -> String {
        return message.getSenderName()
    }
    
    @objc(getSendStatus)
    func getSendStatus() -> _ObjCMessageSendStatus {
        switch message.getSendStatus() {
        case .SENDING:
            return .SENDING
        case .SENT:
            return .SENT
        }
    }
    
    @objc(getText)
    func getText() -> String {
        return message.getText()
    }
    
    @objc(getTime)
    func getTime() -> Date {
        return message.getTime()
    }
    
    @objc(getType)
    func getType() -> _ObjCMessageType {
        switch message.getType() {
        case .ACTION_REQUEST:
            return .ACTION_REQUEST
        case .CONTACTS_REQUEST:
            return .CONTACTS_REQUEST
        case .FILE_FROM_OPERATOR:
            return .FILE_FROM_OPERATOR
        case .FILE_FROM_VISITOR:
            return .FILE_FROM_VISITOR
        case .INFO:
            return .INFO
        case .OPERATOR:
            return .OPERATOR
        case .OPERATOR_BUSY:
            return .OPERATOR_BUSY
        case .VISITOR:
            return .VISITOR
        }
    }
    
    @objc(isEqualTo:)
    func isEqual(to message: _ObjCMessage) -> Bool {
        return self.message.isEqual(to: message.message)
    }
    
    @objc(isReadByOperator)
    func isReadByOperator() -> Bool {
        return message.isReadByOperator()
    }
    
    @objc(canBeEdited)
    func canBeEdited() -> Bool {
        return message.canBeEdited()
    }
    
}

// MARK: - MessageAttachment
@objc(MessageAttachment)
final class _ObjCMessageAttachment: NSObject {
    
    // MARK: - Properties
    private let messageAttachment: MessageAttachment
    
    
    // MARK: - Initialization
    init(messageAttachment: MessageAttachment) {
        self.messageAttachment = messageAttachment
    }
    
    
    // MARK: - Methods
    
    @objc(getContentType)
    func getContentType() -> String {
        return messageAttachment.getContentType()
    }
    
    @objc(getFileName)
    func getFileName() -> String {
        return messageAttachment.getFileName()
    }
    
    @objc(getImageInfo)
    func getImageInfo() -> _ObjCImageInfo? {
        if let imageInfo = messageAttachment.getImageInfo() {
            return _ObjCImageInfo(imageInfo: imageInfo)
        }
        
        return nil
    }
    
    @objc(getSize)
    func getSize() -> NSNumber? {
        return messageAttachment.getSize() as NSNumber?
    }
    
    @objc(getURL)
    func getURL() -> URL {
        return messageAttachment.getURL()
    }
    
}

// MARK: - ImageInfo
@objc(ImageInfo)
final class _ObjCImageInfo: NSObject {
    
    // MARK: - Properties
    private let imageInfo: ImageInfo
    
    
    // MARK: - Initialization
    init(imageInfo: ImageInfo) {
        self.imageInfo = imageInfo
    }
    
    
    // MARK: - Methods
    
    @objc(getThumbURLString)
    func getThumbURLString() -> URL {
        return imageInfo.getThumbURL()
    }
    
    @objc(getHeight)
    func getHeight() -> NSNumber? {
        return imageInfo.getHeight() as NSNumber?
    }
    
    @objc(getWidth)
    func getWidth() -> NSNumber? {
        return imageInfo.getWidth() as NSNumber?
    }
    
}


// MARK: - MessageType
@objc(MessageType)
enum _ObjCMessageType: Int {
    case ACTION_REQUEST
    case CONTACTS_REQUEST
    case FILE_FROM_OPERATOR
    case FILE_FROM_VISITOR
    case INFO
    case OPERATOR
    case OPERATOR_BUSY
    case VISITOR
}

// MARK: - MessageSendStatus
@objc(MessageSendStatus)
enum _ObjCMessageSendStatus: Int {
    case SENDING
    case SENT
}
