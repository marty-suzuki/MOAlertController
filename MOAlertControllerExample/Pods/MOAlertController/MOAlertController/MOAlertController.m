//
//  MOAlertController.m
//  MOAlertController
//
//  Created by 鈴木大貴 on 2014/12/08.
//  Copyright (c) 2014年 鈴木大貴. All rights reserved.
//

#import "MOAlertController.h"
#import <objc/runtime.h>

@implementation UIAlertView (Blocks)

- (id)initWithTitle:(NSString *)title message:(NSString *)message completion:(void(^)(NSInteger buttonIndex))completion cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    
    if (self) {
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
            [self addButtonWithTitle:arg];
        }
        va_end(args);
        self.completion = completion;
    }
    
    return self;
}

- (void)setCompletion:(void (^)(NSInteger))completion {
    objc_setAssociatedObject(self, @selector(completion), completion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void(^)(NSInteger))completion {
    return objc_getAssociatedObject(self, @selector(completion));
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.completion(buttonIndex);
}

@end

@implementation UIActionSheet (Blocks)

- (id)initWithTitle:(NSString *)title completion:(void(^)(NSInteger buttonIndex))completion  cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [self initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    
    if (self) {
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
            [self addButtonWithTitle:arg];
        }
        va_end(args);
        self.completion = completion;
    }
    
    return self;
}

- (void)setCompletion:(void (^)(NSInteger))completion {
    objc_setAssociatedObject(self, @selector(completion), completion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void(^)(NSInteger))completion {
    return objc_getAssociatedObject(self, @selector(completion));
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.completion(buttonIndex);
}

@end

@interface MOAlertAction ()

@property (assign, nonatomic, readwrite) MOAlertActionStyle style;
@property (copy, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite) void(^handler)(MOAlertAction *);

@end

@implementation MOAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(MOAlertActionStyle)style handler:(void(^)(MOAlertAction *))handler {
    return [[[self class] alloc] initWithTitle:title style:style handler:handler];
}

- (id)initWithTitle:(NSString *)title style:(MOAlertActionStyle)style handler:(void(^)(MOAlertAction *))handler {
    self = [super init];
    if (self) {
        _title = title;
        _style = style;
        _handler = handler;
    }
    return self;
}

@end

@interface MOAlertController ()

@property (assign, nonatomic, readwrite) MOAlertControllerStyle style;
@property (copy, nonatomic, readwrite) NSString *message;
@property (copy, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic) NSMutableArray *actionList;
@property (strong, nonatomic) NSMutableArray *textFieldList;
@property (strong, nonatomic) id alertController;
@property (assign, nonatomic) BOOL hasCancelAction;

@end

@implementation MOAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(MOAlertControllerStyle)style {
    return [[[self class] alloc] initWithTitle:title message:message preferredStyle:style];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(MOAlertControllerStyle)style {
    self = [super init];
    if (self) {
        _style = style;
        
        if (NSStringFromClass([UIAlertController class])) {
            UIAlertControllerStyle style;
            switch (self.style) {
                case MOAlertControllerStyleAlert:
                    style = UIAlertControllerStyleAlert;
                    break;
                    
                case MOAlertControllerStyleActionSheet: {
                    style = UIAlertControllerStyleActionSheet;
                    break;
                }
            }
            _alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
        } else {
            _message = message;
            _title = title;
            _actionList = [NSMutableArray array];
            _textFieldList = [NSMutableArray array];
            _hasCancelAction = NO;
        }
    }
    return self;
}

- (void)cancelException {
    [NSException raise:@"NSInternalInconsistencyException" format:@"MOAlertController can only have one action with a style of MOAlertActionStyleCancel"];
}

- (NSString *)title {
    if (NSStringFromClass([UIAlertController class])) {
        UIAlertController *controller = self.alertController;
        return controller.title;
    }
    
    return _title;
}


- (NSString *)message {
    if (NSStringFromClass([UIAlertController class])) {
        UIAlertController *controller = self.alertController;
        return controller.message;
    }
    
    return _message;
}

- (NSArray *)actions {
    if (NSStringFromClass([UIAlertController class])) {
        UIAlertController *controller = self.alertController;
        return controller.actions;
    }
    
    return self.actionList.copy;
}

- (NSArray *)textFields {
    if (NSStringFromClass([UIAlertController class])) {
        UIAlertController *controller = self.alertController;
        return controller.textFields;
    }
    
    return self.textFieldList.copy;
}

- (void)addAction:(MOAlertAction *)action {
    if (NSStringFromClass([UIAlertController class])) {
        UIAlertController *controller = self.alertController;
        UIAlertActionStyle style;
        switch (action.style) {
            case MOAlertActionStyleCancel: {
                if (self.hasCancelAction) {
                    [self cancelException];
                }
                self.hasCancelAction = YES;
                style = UIAlertActionStyleCancel;
                break;
            }
            case MOAlertActionStyleDefault:
                style = UIAlertActionStyleDefault;
                break;
                
            case MOAlertActionStyleDestructive:
                style = UIAlertActionStyleDestructive;
                break;
        }
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:action.title style:style handler:^(UIAlertAction *alertAction) {
            if (action.handler) {
                action.handler(action);
            }
        }];
        
        [controller addAction:alertAction];
        return;
    }
    
    [self.actionList addObject:action];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *))configurationHandler {
    void (^exception)() = ^(void) {
        [NSException raise:@"NSInternalInconsistencyException" format:@"Text fields can only be added to an alert controller of style MOAlertControllerStyleAlert"];
    };
    
    if (NSStringFromClass([UIAlertController class])) {
        UIAlertController *controller = self.alertController;
        if (self.style == MOAlertControllerStyleActionSheet) {
            exception();
        }
        
        [controller addTextFieldWithConfigurationHandler:configurationHandler];
        return;
    }
    
    if (self.style == MOAlertControllerStyleActionSheet) {
        exception();
    }
    UITextField *textField = [[UITextField alloc] init];
    [self.textFieldList addObject:textField];
    configurationHandler(textField);
}

- (void)presentViewControllerWithCurrentViewController:(UIViewController *)viewController {
    if (NSStringFromClass([UIAlertController class])) {
        UIAlertController *controller = self.alertController;
        [viewController presentViewController:controller animated:YES completion:nil];
    } else {
        void(^completion)(NSInteger) = ^(NSInteger buttonIndex) {
            MOAlertAction *action = [self.actionList objectAtIndex:buttonIndex];
            if (action.handler) {
                action.handler(action);
            }
        };
        
        switch (self.style) {
            case MOAlertControllerStyleAlert: {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.title message:self.message completion:completion cancelButtonTitle:nil otherButtonTitles:nil];
                
                [self.actionList enumerateObjectsUsingBlock:^(MOAlertAction *alertAction, NSUInteger index, BOOL *stop) {
                    [alertView addButtonWithTitle:alertAction.title];
                    switch (alertAction.style) {
                        case MOAlertActionStyleCancel: {
                            if (alertView.cancelButtonIndex != -1) {
                                [self cancelException];
                            }
                            alertView.cancelButtonIndex = index;
                            break;
                        }
                        case MOAlertActionStyleDefault:
                        case MOAlertActionStyleDestructive:
                            break;
                    }
                }];
                
                if (self.textFields.count > 0) {
                    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                    UITextField *textField = [alertView textFieldAtIndex:0];
                    UITextField *tf = self.textFields.firstObject;
                    textField.delegate = tf.delegate;
                }
                    
                [alertView show];
                
                return;
            }
            case MOAlertControllerStyleActionSheet: {
                NSString *title = nil;
                if (self.title.length && self.title && self.message.length && self.message) {
                    title = [NSString stringWithFormat:@"%@\n%@", self.title, self.message];
                } else if (self.title.length && self.title) {
                    title = self.title;
                } else if (self.message.length && self.message) {
                    title = self.message;
                }
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title completion:completion cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                
                __block MOAlertAction *cancelAction = nil;
                [self.actions enumerateObjectsUsingBlock:^(MOAlertAction *alertAction, NSUInteger index, BOOL *stop) {
                    switch (alertAction.style) {
                        case MOAlertActionStyleDestructive: {
                            NSInteger destructiveButtonIndex = index;
                            if (cancelAction) {
                                destructiveButtonIndex--;
                            }
                            actionSheet.destructiveButtonIndex = destructiveButtonIndex;
                            break;
                        }
                        case MOAlertActionStyleCancel: {
                            if (cancelAction) {
                                [self cancelException];
                            }
                            cancelAction = alertAction;
                            return;
                        }
                        case MOAlertActionStyleDefault:
                            break;
                    }
                    [actionSheet addButtonWithTitle:alertAction.title];
                }];
                
                if (cancelAction) {
                    [actionSheet addButtonWithTitle:cancelAction.title];
                    actionSheet.cancelButtonIndex = self.actionList.count - 1;
                }
                
                [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
                return;
            }
        }
    }
}

@end
