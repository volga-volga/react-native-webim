#ifndef RNWebim_h
#define RNWebim_h

#import <React/RCTBridgeModule.h>

#import <React/RCTEventEmitter.h>

@interface RNWebim : RCTEventEmitter <UIImagePickerControllerDelegate, UINavigationControllerDelegate, RCTBridgeModule>
@end

#endif /* RNWebim_h */
