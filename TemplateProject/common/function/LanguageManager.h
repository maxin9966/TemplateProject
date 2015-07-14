//
//  LanguageManager.h
//  LocalizationTest
//
//  Created by antsmen on 15-4-7.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 
 国际化
 
 */

typedef void(^LanguageBlock)();

@interface LanguageManager : NSObject

@property (nonatomic,strong) NSString *userLanguage;

+ (instancetype)sharedInstance;

- (void)executeLanguageChangedBlock:(LanguageBlock)block;

- (NSString*)titleForKey:(NSString*)key;

- (void)clear;

@end
