
#import "RNWebim.h"
#import <React/RCTLog.h>
#import <RNWebim/RNWebim-Swift.h> // If use see compile error at this line, to fix repeat compile second time

@implementation RNWebim

WebimSession *webimSession;
MessageStream *stream;
MessageTracker *tracker;

RCTResponseSenderBlock attachmentResolve;
RCTResponseSenderBlock attachmentReject;

RCTResponseSenderBlock attachmentSendingResolve;
RCTResponseSenderBlock attachmentSendingReject;

RCTResponseSenderBlock rateOperatorResolve;
RCTResponseSenderBlock rateOperatorReject;

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
    return @[@"newMessage", @"removeMessage", @"changedMessage", @"allMessagesRemoved", @"tokenUpdated", @"error"];
}

RCT_EXPORT_METHOD(resumeSession:(NSDictionary*) builderData reject:(RCTResponseSenderBlock) reject resolve:(RCTResponseSenderBlock) resolve) {
    NSError *error = nil;
    if (webimSession == nil) {
        SessionBuilder *sessionBuilder = [Webim newSessionBuilder];
        NSString* accountName = [builderData valueForKey:@"accountName"];
        NSString* location = [builderData valueForKey:@"location"];

        // optional
        NSString* accountJSON = [builderData valueForKey:@"accountJSON"];
        NSString* providedAuthorizationToken = [builderData valueForKey: @"providedAuthorizationToken"];
        NSString* appVersion = [builderData valueForKey:@"appVersion"];
        NSNumber* clearVisitorData = [builderData valueForKey:@"clearVisitorData"];
        NSNumber* storeHistoryLocally = [builderData valueForKey:@"storeHistoryLocally"];
        NSString* title = [builderData valueForKey:@"title"];
        NSString* pushToken = [builderData valueForKey:@"pushToken"];
        sessionBuilder = [sessionBuilder setAccountName:accountName];
        sessionBuilder = [sessionBuilder setLocation:location];
        sessionBuilder = [sessionBuilder setFatalErrorHandler:(id<FatalErrorHandler>)self];

        if (accountJSON != nil) {
            sessionBuilder = [sessionBuilder setVisitorFieldsJSONString:accountJSON];
        }
        if (providedAuthorizationToken != nil) {
            sessionBuilder = [sessionBuilder setProvidedAuthorizationTokenStateListener:(id<ProvidedAuthorizationTokenStateListener>)self providedAuthorizationToken:providedAuthorizationToken];
        }
        if (appVersion != nil) {
            sessionBuilder = [sessionBuilder setAppVersion:appVersion];
        }
        if (clearVisitorData != nil) {
            sessionBuilder = [sessionBuilder setIsVisitorDataClearingEnabled:[clearVisitorData boolValue]];
        }
        if (storeHistoryLocally != nil) {
            sessionBuilder = [sessionBuilder setIsLocalHistoryStoragingEnabled:[storeHistoryLocally boolValue]];
        }
        if (title != nil) {
            sessionBuilder = [sessionBuilder setPageTitle:title];
        }
        if (pushToken != nil) {
            sessionBuilder = [sessionBuilder setDeviceToken:pushToken];
            sessionBuilder = [sessionBuilder setRemoteNotificationSystem:0];
        }
        sessionBuilder = [sessionBuilder setIsVisitorDataClearingEnabled:true];
        sessionBuilder = [sessionBuilder setIsLocalHistoryStoragingEnabled:false];
        webimSession = [sessionBuilder build:&error];
        if (error) {
            reject(@[@{ @"message": [error localizedDescription]}]);
            return;
        }
    }
    [webimSession resume:&error];
    if (error) {
        reject(@[@{ @"message": [error localizedDescription]}]);
        return;
    }
    stream = [webimSession getStream];
    [stream setChatRead:&error];
    if (error) {
        reject(@[@{ @"message": [error localizedDescription]}]);
        return;
    }
    tracker = [stream newMessageTrackerWithMessageListener:(id<MessageListener>)self error:&error];
    if (error) {
        reject(@[@{ @"message": [error localizedDescription]}]);
        return;
    }
    [stream startChat:&error];
    if (error) {
        reject(@[@{ @"message": [error localizedDescription]}]);
        return;
    }
    resolve(@[@{}]);
}

RCT_EXPORT_METHOD(destroySession:(NSNumber*) clearUserData reject:(RCTResponseSenderBlock) reject resolve:(RCTResponseSenderBlock) resolve) {
    NSError *err = nil;
    if (stream) {
        [stream closeChat:&err];
    }
    if (err) {
        reject(@[@{ @"message": [err localizedDescription]}]);
        return;
    }
    stream = nil;
    if (webimSession) {
        if ([clearUserData boolValue]) {
            [webimSession destroyWithClearVisitorData:&err];
        } else {
            [webimSession destroy:&err];
        }
    }
    if (err) {
        reject(@[@{ @"message": [err localizedDescription]}]);
        return;
    }
    webimSession = nil;
    if (tracker) {
        [webimSession destroy:&err];
    }
    if (err) {
        reject(@[@{ @"message": [err localizedDescription]}]);
        return;
    }
    resolve(@[@{}]);
}

RCT_EXPORT_METHOD(getLastMessages:(nonnull NSNumber*)limit reject:(RCTResponseSenderBlock) reject resolve:(RCTResponseSenderBlock) resolve) {
    NSError *err = nil;
    [tracker getLastMessagesByLimit:[limit intValue]
                         completion:^(NSArray<Message *> * _Nonnull arr) {
                            resolve(@[@{@"messages": [self messagesToJsonArray:arr] }]);
                         } error:&err];
    if (err) {
        reject(@[@{@"message": [err localizedDescription]}]);
    }
}

RCT_EXPORT_METHOD(getNextMessages:(NSNumber*)limit reject:(RCTResponseSenderBlock) reject resolve:(RCTResponseSenderBlock) resolve)
{
    NSError *err = nil;
    [tracker getNextMessagesByLimit:[limit intValue] completion:^(NSArray<Message *> * _Nonnull arr) {
        resolve(@[@{@"messages": [self messagesToJsonArray:arr] }]);
    } error:&err];
    if (err) {
        reject(@[@{@"message": [err localizedDescription]}]);
    }
}


RCT_EXPORT_METHOD(getAllMessages:(RCTResponseSenderBlock) reject resolve:(RCTResponseSenderBlock) resolve)
{
    NSError *err = nil;
    [tracker getAllMessagesWithCompletion:^(NSArray<Message *> * _Nonnull arr) {
        resolve(@[@{@"messages": [self messagesToJsonArray:arr] }]);
    } error:&err];
    if (err) {
        reject(@[@{@"message": [err localizedDescription]}]);
    }
}

RCT_EXPORT_METHOD(rateOperator:(NSNumber*) rating reject:(RCTResponseSenderBlock) reject resolve:(RCTResponseSenderBlock) resolve) {
    if (stream) {
        NSError *err = nil;
        Operator* operator = [stream getCurrentOperator];
        [stream rateOperatorWithID: [operator getID] byRating:[rating intValue]
                 completionHandler:(id<RateOperatorCompletionHandler>)self error:&err];
        if (err) {
            reject(@[@{ @"message": [err localizedDescription] }]);
        } else {
            rateOperatorResolve = resolve;
            rateOperatorResolve = reject;
        }
    } else {
        reject(@[@{ @"message": @"has not valid session" }]);
    }
}

RCT_EXPORT_METHOD(tryAttachFile:(RCTResponseSenderBlock) reject resolve:(RCTResponseSenderBlock) resolve)
{
    attachmentReject = reject;
    attachmentResolve = resolve;
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = false;
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        [rootViewController presentViewController:imagePicker
                                         animated:YES
                                       completion:^{
                                       }];
    });
}

RCT_EXPORT_METHOD(sendFile:(NSString*) uri name:(NSString*) name mime:(NSString*) mime extention:(NSString*) extention :(RCTResponseSenderBlock) reject resolve:(RCTResponseSenderBlock) resolve) {
    attachmentSendingResolve = resolve;
    attachmentSendingReject = reject;
    NSData *imageData;
    UIImage *img = [UIImage imageNamed:uri];
    if ([extention isEqualToString:@"jpg"] || [extention isEqualToString:@"jpeg"]) {
        imageData = UIImageJPEGRepresentation(img, 1.0f);
    } else {
        imageData = UIImagePNGRepresentation(img);
    }
    NSError *err = nil;
    NSString *_id = [stream sendFile:imageData
                            filename:name
                            mimeType:mime
                   completionHandler:(id<SendFileCompletionHandler>) self
                               error:&err];
    if (err) {
        reject(@[@{ @"message": err.localizedDescription }]);
    }
}

RCT_EXPORT_METHOD(send:(NSString*) message reject:(RCTResponseSenderBlock) reject resolve:(RCTResponseSenderBlock) resolve) {
    NSError *err = nil;
    NSString *_id = [stream sendMessage:message
                                  error:&err];
    if (err) {
        reject(@[@{ message: err.localizedDescription}]);
    } else {
        resolve(@[@{ @"id": _id }]);
    }
}

- (void)addedMessage:(Message * _Nonnull)newMessage after:(Message * _Nullable)previousMessage {
    [self sendEventWithName:@"newMessage" body:@{@"msg": [self messageToJson:newMessage]}];
}

- (void)changedMessage:(Message * _Nonnull)oldVersion to:(Message * _Nonnull)newVersion {
    [self sendEventWithName:@"changedMessage" body:@{@"to": [self messageToJson:newVersion], @"from": [self messageToJson:oldVersion]}];
}

- (void)removedAllMessages {
    [self sendEventWithName:@"allMessagesRemoved" body:@{}];
}

- (void)removedMessage:(Message * _Nonnull)message {
    [self sendEventWithName:@"removeMessage" body:@{@"msg": [self messageToJson:message]}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    UIImagePickerControllerInfoKey pathKey = UIImagePickerControllerReferenceURL;
    if (@available(iOS 11.0, *)) {
        pathKey = UIImagePickerControllerImageURL;
    }
    NSURL* imageURL = [info valueForKey:pathKey];
    NSString* imageExtention = [[imageURL pathExtension] lowercaseString];
    NSString* imageName = [imageURL lastPathComponent];
    NSString* mime = [@"image/" stringByAppendingString:imageExtention];
    if (attachmentResolve) {
        attachmentResolve(@[@{
                                @"uri": [imageURL path],
                                @"name": imageName,
                                @"mime": mime,
                                @"extension": imageExtention
                                }]);
    }
    [self clearPickerResolvers];
    [picker dismissViewControllerAnimated:YES
                               completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (attachmentReject) {
        attachmentReject(@[@{ @"message": @"canceled" }]);
    }
    [self clearPickerResolvers];
    [picker dismissViewControllerAnimated:YES
                               completion:^{}];
}


- (void)onFailureWithMessageID:(NSString * _Nonnull)messageID error:(enum SendFileError)error {
    NSString *msg = @"";
    if (attachmentSendingReject) {
        switch (error) {
            case SendFileErrorFILE_SIZE_EXCEEDED:
                msg = @"file size exceeded";
                break;
            case SendFileErrorFILE_TYPE_NOT_ALLOWED:
                msg = @"type not allowed";
                break;
            case SendFileErrorUPLOADED_FILE_NOT_FOUND:
                msg = @"no file";
                break;
            case SendFileErrorUNKNOWN:
                msg = @"unknown";
                break;
        }
        attachmentSendingReject(@[@{ @"message": msg }]);
    }
    [self clearAttachmentSendingResolvers];
}

- (void)onSuccessWithMessageID:(NSString * _Nonnull)messageID {
    if (attachmentSendingResolve) {
        attachmentSendingResolve(@[ @{ @"id": messageID }]);
    }
    [self clearAttachmentSendingResolvers];
}

- (void)onFailure:(enum RateOperatorError)error {
    if (rateOperatorReject) {
        rateOperatorReject(@[@{ @"message": error == RateOperatorErrorNO_CHAT ? @"no chat" : @"wrong operator id" }]);
    }
    [self clearRateResolvers];
}

- (void)onSuccess {
    if (rateOperatorResolve) {
        rateOperatorResolve(@[@{}]);
    }
    [self clearRateResolvers];
}

- (NSString*)typeToString:(MessageType) type {
    switch (type) {
        case MessageTypeACTION_REQUEST:
            return @"ACTION_REQUEST";
        case MessageTypeCONTACTS_REQUEST:
            return @"CONTACTS_REQUEST";
        case MessageTypeFILE_FROM_OPERATOR:
            return @"FILE_FROM_OPERATOR";
        case MessageTypeFILE_FROM_VISITOR:
            return @"FILE_FROM_VISITOR";
        case MessageTypeINFO:
            return @"INFO";
        case MessageTypeOPERATOR:
            return @"OPERATOR";
        case MessageTypeOPERATOR_BUSY:
            return @"OPERATOR_BUSY";
        case MessageTypeVISITOR:
            return @"VISITOR";
        default:
            return @"";
    }
}

- (NSDictionary*) attachmentToJson: (MessageAttachment*) attachment {
    return @{
             @"contentType": [attachment getContentType],
             @"info": @"",
             @"name": [attachment getFileName],
             @"size": [attachment getSize],
             @"url": [[attachment getURL] absoluteString]
             };
}

- (NSString*) sendStatusToString:(MessageSendStatus) status {
    switch (status) {
        case MessageSendStatusSENDING:
            return @"SENDING";
        case MessageSendStatusSENT:
            return @"SENT";
        default:
            return @"";
    }
}

- (NSDictionary*)messageToJson: (Message*) msg {
    NSString* avatar = [[msg getSenderAvatarFullURL] absoluteString];
    MessageAttachment* attachment = [msg getAttachment];
    NSNumber* time = [NSNumber numberWithDouble:[[msg getTime] timeIntervalSince1970] * 1000];
    NSDictionary* result = @{
                             @"id": [msg getID],
                             @"time": time,
                             @"type": [self typeToString:[msg getType]],
                             @"text": [msg getText],
                             @"name": [msg getSenderName],
                             @"status": [self sendStatusToString: [msg getSendStatus]],
                             @"avatar": avatar ? avatar : [NSNull null],
                             @"read": [msg isReadByOperator] ? @YES : @NO,
                             @"canEdit": [msg canBeEdited] ? @YES : @NO,
                             @"attachment": attachment ? [self attachmentToJson:attachment] : [NSNull null]
                             };
    return result;
}

-(NSMutableArray<NSDictionary*>*)messagesToJsonArray: (NSArray<Message *>* _Nonnull) arr {
    NSMutableArray<NSDictionary*>* messages = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arr count]; ++i) {
        Message* msg = [arr objectAtIndex:i];
        [messages addObject:[self messageToJson: msg]];
    }
    return messages;
}

-(void)clearPickerResolvers {
    attachmentReject = nil;
    attachmentResolve = nil;
}

-(void)clearAttachmentSendingResolvers {
    attachmentSendingReject = nil;
    attachmentSendingResolve = nil;
}

-(void)clearRateResolvers {
    rateOperatorReject = nil;
    rateOperatorResolve = nil;
}

- (void)updateProvidedAuthorizationToken:(NSString * _Nonnull)providedAuthorizationToken {
    [self sendEventWithName:@"tokenUpdated" body:@{@"token": providedAuthorizationToken}];
}

- (void)onError:(WebimError * _Nonnull)error {
    [self sendEventWithName:@"error" body:@{@"message": @"err"}];
}

@end
