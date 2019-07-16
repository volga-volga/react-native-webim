//
//  MessageTracker.swift
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


// MARK: - MessageTracker
@objc(MessageTracker)
final class _ObjCMessageTracker: NSObject {
    
    // MARK: - Properties
    private let messageTracker: MessageTracker
    
    
    // MARK: - Initialization
    init(messageTracker: MessageTracker) {
        self.messageTracker = messageTracker
    }
    
    
    // MARK: - Methods
    
    @objc(getLastMessagesByLimit:completion:error:)
    func getLastMessages(byLimit limitOfMessages: Int,
                         completion: @escaping (_ result: [_ObjCMessage]) -> ()) throws {
        try messageTracker.getLastMessages(byLimit: limitOfMessages) { messages in
            var objCMessages = [_ObjCMessage]()
            for message in messages {
                objCMessages.append(_ObjCMessage(message: message))
            }
            completion(objCMessages)
        }
    }
    
    @objc(getNextMessagesByLimit:completion:error:)
    func getNextMessages(byLimit limitOfMessages: Int,
                         completion: @escaping ([_ObjCMessage]) -> ()) throws {
        try messageTracker.getNextMessages(byLimit: limitOfMessages) { messages in
            var objCMessages = [_ObjCMessage]()
            for message in messages {
                objCMessages.append(_ObjCMessage(message: message))
            }
            completion(objCMessages)
        }
    }
    
    @objc(getAllMessagesWithCompletion:error:)
    func getAllMessages(completion: @escaping (_ result: [_ObjCMessage]) -> ()) throws {
        try messageTracker.getAllMessages() { messages in
            var objCMessages = [_ObjCMessage]()
            for message in messages {
                objCMessages.append(_ObjCMessage(message: message))
            }
            completion(objCMessages)
        }
    }
    
    @objc(resetToMessage:error:)
    func resetTo(message: _ObjCMessage) throws {
        try messageTracker.resetTo(message: message.message)
    }
    
    @objc(destroy:)
    func destroy() throws {
        try messageTracker.destroy()
    }
    
}
