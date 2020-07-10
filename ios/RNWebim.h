
#if __has_include("React/RCTBridgeModule.h")
#import "React/RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import <React/RCTEventEmitter.h>

@interface RNWebim : RCTEventEmitter <UIImagePickerControllerDelegate, UINavigationControllerDelegate, RCTBridgeModule>
@end
