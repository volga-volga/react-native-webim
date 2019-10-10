
#if __has_include("React/RCTBridgeModule.h")
#import "React/RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import <React/RCTEventEmitter.h>

#import "RNWebim-Swift.h"

@interface webim : RCTEventEmitter <UIImagePickerControllerDelegate, UINavigationControllerDelegate, RCTBridgeModule, MessageListener, SendFileCompletionHandler, RateOperatorCompletionHandler>

@end

//@class MessageListener;
//@class SendFileCompletionHandler;
//@class RateOperatorCompletionHandler;
//@protocol UIImagePickerControllerDelegate;
//@protocol UINavigationControllerDelegate;
//@protocol RCTBridgeModule;
//
//@interface MyObjcClass : RCTEventEmitter
//- (MessageListener *)returnSwiftClassInstance;
//- (SendFileCompletionHandler *)returnSwiftClassInstance2;
//- (RateOperatorCompletionHandler *)returnSwiftClassInstance3;
//- (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate, RCTBridgeModule>)returnInstanceAdoptingSwiftProtocol;
//@end
