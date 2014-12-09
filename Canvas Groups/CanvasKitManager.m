//
//  CanvasKitManager.m
//  Canvas Groups
//
//  Created by Rick Roberts on 12/3/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "CanvasKitManager.h"

@interface CanvasKitManager ()
@end

@implementation CanvasKitManager

+ (instancetype)sharedInstance {
    static CanvasKitManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.client = [[CKIClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://mobiledev.instructure.com"] token:@"1~s0xMEeJLqjL1D4eiBc9yQDfLnOVOpZ9RDiqZljRjpxLgBQp3QPi8t31PKmEBP7ZG"];
    });
    
    return sharedInstance;
}

@end
