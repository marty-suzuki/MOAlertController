//
//  MOAlertController.h
//  MOAlertController
//
//  Created by 鈴木大貴 on 2014/12/08.
//  Copyright (c) 2014年 鈴木大貴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Blocks) <UIAlertViewDelegate>

@property (copy, nonatomic) void(^completion)(NSInteger buttonIndex);

- (id)initWithTitle:(NSString *)title message:(NSString *)message completion:(void(^)(NSInteger buttonIndex))completion cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end

@interface UIActionSheet (Blocks) <UIActionSheetDelegate>

@property (copy, nonatomic) void(^completion)(NSInteger buttonIndex);

- (id)initWithTitle:(NSString *)title completion:(void(^)(NSInteger buttonIndex))completion  cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end

@interface MOAlertAction : NSObject

typedef NS_ENUM(NSInteger, MOAlertActionStyle) {
    MOAlertActionStyleDefault = 0,
    MOAlertActionStyleCancel,
    MOAlertActionStyleDestructive
};

@property (assign, nonatomic, readonly) MOAlertActionStyle style;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) void(^handler)(MOAlertAction *);

+ (instancetype)actionWithTitle:(NSString *)title style:(MOAlertActionStyle)style handler:(void(^)(MOAlertAction *))handler;

@end

@interface MOAlertController : NSObject

typedef NS_ENUM(NSInteger, MOAlertControllerStyle) {
    MOAlertControllerStyleAlert = 0,
    MOAlertControllerStyleActionSheet
};

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(MOAlertControllerStyle)style;
- (void)presentViewControllerWithCurrentViewController:(UIViewController *)viewController;
- (void)dismissViewControllerFromCurrentViewController;
- (void)addAction:(MOAlertAction *)action;
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;


@property (assign, nonatomic, readonly) MOAlertControllerStyle style;
@property (copy, nonatomic, readonly) NSString *message;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSArray *actions;
@property (copy, nonatomic, readonly) NSArray *textFields;

@end
