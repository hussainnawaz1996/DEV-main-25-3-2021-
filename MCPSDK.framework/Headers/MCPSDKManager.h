//
//  MCPManager.h
//  MCPSDK
//
//  Created by Rehan Azhar on 15/02/2019.
//  Copyright © 2019 i2c Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MCPSDKTask.h"
#import "UIConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^MCPCallBack)(MCPSDKTask * viewControler);

@interface MCPSDKManager : NSObject


+ (void) initSDK:(NSString *)AppId ApiKey:(NSString *)apiKey;
+ (void) startTask:(NSString *)taskID delegate:(id<MCPSDKCallBack>)delegate params:(NSDictionary *)params parentVC:(UIViewController *)parentVC viewNavigationStyle:(navigationMethod)navMethod callBack:(MCPCallBack)callBack;
+ (void) preloadTaskList:(NSDictionary *)params  MCPSDKCallback:( id<MCPSDKCallBack> _Nullable)delegate;
+ (void) startTask:(NSString *)taskID delegate:(id<MCPSDKCallBack>)delegate params:(NSDictionary *)params parentVC:(UIViewController *)parentVC viewNavigationStyle:(navigationMethod)navMethod UIConfiguration:(UIConfiguration *)config callBack:(MCPCallBack)callBack;

+ (void) setUIConfiguration:(UIConfiguration *)config;
+ (id) getAuthModel;
@end

NS_ASSUME_NONNULL_END
