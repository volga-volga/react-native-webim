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
public final class _ObjCMessage: NSObject {
    
    // MARK: - Properties
    private (set) var message: Message
    
    
    // MARK: - Initialization
    public init(message: Message) {
        self.message = message
    }
    
    // MARK: - Methods
    
    @objc(getAttachment)
    public func getAttachment() -> _ObjCMessageAttachment? {
        if let attachment = message.getData()?.getAttachment() {
            return _ObjCMessageAttachment(messageAttachment: attachment)
        }
        
        return nil
    }
    
    @objc(getData)
    public func getData() -> [String: Any]? {
        if let data = message.getRawData() {
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
    public func getID() -> String {
        return message.getID()
    }
    
    @objc(getOperatorID)
    public func getOperatorID() -> String? {
        return message.getOperatorID()
    }
    
    @objc(getSenderAvatarFullURL)
    public func getSenderAvatarFullURL() -> URL? {
        return message.getSenderAvatarFullURL()
    }
    
    @objc(getSenderName)
    public func getSenderName() -> String {
        return message.getSenderName()
    }
    
    @objc(getSendStatus)
    public func getSendStatus() -> _ObjCMessageSendStatus {
        switch message.getSendStatus() {
        case .sending:
            return .SENDING
        case .sent:
            return .SENT
        }
    }
    
    @objc(getText)
    public func getText() -> String {
        return message.getText()
    }
    
    @objc(getTime)
    public func getTime() -> Date {
        return message.getTime()
    }
    
    @objc(getType)
    public func getType() -> _ObjCMessageType {
        switch message.getType() {
        case .actionRequest:
            return .ACTION_REQUEST
        case .contactInformationRequest:
            return .CONTACTS_REQUEST
        case .fileFromOperator:
            return .FILE_FROM_OPERATOR
        case .fileFromVisitor:
            return .FILE_FROM_VISITOR
        case .info:
            return .INFO
        case .operatorMessage:
            return .OPERATOR
        case .operatorBusy:
            return .OPERATOR_BUSY
        case .visitorMessage:
            return .VISITOR
        case .keyboard:
            return .KEYBOARD
        case .keyboardResponse:
            return .KEYBOARD_RESPONSE
        case .stickerVisitor:
            return .STICKER_VISITOR
        }
    }
    
    @objc(isEqualTo:)
    public func isEqual(to message: _ObjCMessage) -> Bool {
        return self.message.isEqual(to: message.message)
    }
    
    @objc(isReadByOperator)
    public func isReadByOperator() -> Bool {
        return message.isReadByOperator()
    }
    
    @objc(canBeEdited)
    public func canBeEdited() -> Bool {
        return message.canBeEdited()
    }
    
}

// MARK: - MessageAttachment
@objc(MessageAttachment)
public final class _ObjCMessageAttachment: NSObject {
    
    // MARK: - Properties
    private let messageAttachment: MessageAttachment
    
    
    // MARK: - Initialization
    public init(messageAttachment: MessageAttachment) {
        self.messageAttachment = messageAttachment
    }
    
    
    // MARK: - Methods
    
    @objc(getContentType)
    public func getContentType() -> String? {
        return messageAttachment.getFileInfo().getContentType()
    }
    
    @objc(getFileName)
    public func getFileName() -> String {
        return messageAttachment.getFileInfo().getFileName()
    }
    
    @objc(getImageInfo)
    public func getImageInfo() -> _ObjCImageInfo? {
        if let imageInfo = messageAttachment.getFileInfo().getImageInfo() {
            return _ObjCImageInfo(imageInfo: imageInfo)
        }
        
        return nil
    }
    
    @objc(getSize)
    public func getSize() -> NSNumber? {
        return messageAttachment.getFileInfo().getSize() as NSNumber?
    }
    
    @objc(getURL)
    public func getURL() -> URL? {
        return messageAttachment.getFileInfo().getURL()
    }
    
}

// MARK: - ImageInfo
@objc(ImageInfo)
public final class _ObjCImageInfo: NSObject {
    
    // MARK: - Properties
    private let imageInfo: ImageInfo
    
    
    // MARK: - Initialization
    public init(imageInfo: ImageInfo) {
        self.imageInfo = imageInfo
    }
    
    
    // MARK: - Methods
    
    @objc(getThumbURLString)
    public func getThumbURLString() -> URL {
        return imageInfo.getThumbURL()
    }
    
    @objc(getHeight)
    public func getHeight() -> NSNumber? {
        return imageInfo.getHeight() as NSNumber?
    }
    
    @objc(getWidth)
    public func getWidth() -> NSNumber? {
        return imageInfo.getWidth() as NSNumber?
    }
    
}


// MARK: - MessageType
@objc(MessageType)
public enum _ObjCMessageType: Int {
    case ACTION_REQUEST
    case CONTACTS_REQUEST
    case FILE_FROM_OPERATOR
    case FILE_FROM_VISITOR
    case INFO
    case KEYBOARD
    case KEYBOARD_RESPONSE
    case OPERATOR
    case OPERATOR_BUSY
    case VISITOR
    case STICKER_VISITOR
}

// MARK: - MessageSendStatus
@objc(MessageSendStatus)
public enum _ObjCMessageSendStatus: Int {
    case SENDING
    case SENT
}
