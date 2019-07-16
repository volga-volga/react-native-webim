
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import <React/RCTEventEmitter.h>
#import "RNWebim-Swift.h"

@interface webim : RCTEventEmitter <UIImagePickerControllerDelegate, UINavigationControllerDelegate, RCTBridgeModule, MessageListener, SendFileCompletionHandler, RateOperatorCompletionHandler>

@end
