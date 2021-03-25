//

//  UIConfiguration.h

//  MCPSDK

//

//  Created by Rehan Azhar on 21/02/2019.

//  Copyright © 2019 i2c Inc. All rights reserved.

//


 

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {

    PRELOAD = 0,

    LOAD_ON_SCREEN = 1

}LoadingOptions;


@interface UIConfiguration : NSObject


@property(nonatomic) BOOL hideNavigationbar;

@property(nonatomic, retain) UIColor * navBarTextColor;

@property(nonatomic, retain) UIColor * navBarBGColor;

@property(nonatomic, retain) NSString * navTitle;

@property(nonatomic) BOOL hideBackButton;

@property(nonatomic) BOOL canGoBack;

@property(nonatomic) LoadingOptions loadingOption;

@property(nonatomic) CGSize alertSize;

@property(nonatomic, retain) NSString * backBtnTxt;

@property(nonatomic, retain) UIImage *  backBtnImg;

@property(nonatomic, retain) UIImage *  dialogCloseImg;

@property(nonatomic, retain) UIColor * backgroundColor;

@property(nonatomic, retain) UIColor * loadingIndicatorColor;

 

- (instancetype) init;

- (instancetype) initWithHideNavbar:(BOOL)hideBar navBarTextColor:(UIColor *)textColor navBarBGColor:(UIColor *)bgColor navTitle:(NSString *)title hideBack:(BOOL)hideBackBtn  backText:(NSString *) bText backImage:(UIImage *) bImage dialogImage:(UIImage *) dialogueImage backgroundColor:(UIColor *) webviewBGColor loadingIndicatorColor:(UIColor *)activityIndicatorColor;

@end


 

NS_ASSUME_NONNULL_END
