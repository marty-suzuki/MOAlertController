//
//  ViewController.m
//  MOAlertControllerExample
//
//  Created by 鈴木大貴 on 2014/12/10.
//  Copyright (c) 2014年 鈴木大貴. All rights reserved.
//

#import "ViewController.h"
#import "MOAlertController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MOAlertController *)createAlertControllerWithStyle:(MOAlertControllerStyle)style {
    MOAlertController *controller = [MOAlertController alertControllerWithTitle:@"MOAlertController" message:@"This is MOAlertController" preferredStyle:style];
    
    MOAlertAction *cancelAction = [MOAlertAction actionWithTitle:@"Cancel" style:MOAlertActionStyleCancel handler:^(MOAlertAction *action) {
        NSLog(@"cancelAction tapped");
    }];
    [controller addAction:cancelAction];
    
    MOAlertAction *destructiveAction = [MOAlertAction actionWithTitle:@"Destructive" style:MOAlertActionStyleDestructive handler:^(MOAlertAction *action) {
        NSLog(@"destructiveAction tapped");
    }];
    [controller addAction:destructiveAction];
    
    MOAlertAction *defaultAction = [MOAlertAction actionWithTitle:@"Default" style:MOAlertActionStyleDefault handler:^(MOAlertAction *action) {
        NSLog(@"defaultAction tapped");
    }];
    [controller addAction:defaultAction];
    
    return controller;
}

- (IBAction)showAlertTapped:(id)sender {
    MOAlertController *controller = [self createAlertControllerWithStyle:MOAlertControllerStyleAlert];
    [controller presentViewControllerWithCurrentViewController:self];
}

- (IBAction)showActionSheetTapped:(id)sender {
    MOAlertController *controller = [self createAlertControllerWithStyle:MOAlertControllerStyleActionSheet];
    [controller presentViewControllerWithCurrentViewController:self];
}

@end
