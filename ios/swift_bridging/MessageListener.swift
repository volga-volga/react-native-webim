//
//  MessageListener.swift
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


// MARK: - MessageListener
@objc(MessageListener)
protocol _ObjCMessageListener {
    
    @objc(addedMessage:after:)
    func added(message newMessage: _ObjCMessage,
               after previousMessage: _ObjCMessage?)
    
    @objc(removedMessage:)
    func removed(message: _ObjCMessage)
    
    @objc(removedAllMessages)
    func removedAllMessages()
    
    @objc(changedMessage:to:)
    func changed(message oldVersion: _ObjCMessage,
                 to newVersion: _ObjCMessage)
    
}


// MARK: - Protocols' wrappers
// MARK: - MessageListener
final class MessageListenerWrapper: MessageListener {
    
    // MARK: - Properties
    private weak var messageListener: _ObjCMessageListener?
    
    
    // MARK: - Initialization
    init(messageListener: _ObjCMessageListener) {
        self.messageListener = messageListener
    }
    
    
    // MARK: - Methods
    // MARK: MessageListener methods
    
    func added(message newMessage: Message,
               after previousMessage: Message?) {
        messageListener?.added(message: _ObjCMessage(message: newMessage),
                              after: ((previousMessage == nil) ? nil : _ObjCMessage(message: previousMessage!)))
    }
    
    func removed(message: Message) {
        messageListener?.removed(message: _ObjCMessage(message: message))
    }
    
    func removedAllMessages() {
        messageListener?.removedAllMessages()
    }
    
    func changed(message oldVersion: Message,
                 to newVersion: Message) {
        messageListener?.changed(message: _ObjCMessage(message: oldVersion),
                                to: _ObjCMessage(message: newVersion))
    }
    
}
