//
//  SDKCallBack.h
//  MCPSDK
//
//  Created by Rehan Azhar on 18/02/2019.
//  Copyright © 2019 i2c Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SDKCallBack_h
#define SDKCallBack_h

typedef enum : NSUInteger {
    Push = 0,
    Present = 1,
    Alert = 2
} navigationMethod;


@protocol MCPSDKCallBack <NSObject>

-(bool) onLoadingStarted;

@optional

-(void)onLoadingCompleted;
-(void)onSuccess:(NSDictionary *)responsePayload;
-(void)onError:(NSString *)errorCode errorDesc:(NSString *)errorDesc;
-(void)onCancel;

@end


#endif /* SDKCallBack_h */
