//
//  LanguageManager.m
//  LocalizationTest
//
//  Created by antsmen on 15-4-7.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "LanguageManager.h"

@interface LanguageManager()
{
    NSMutableArray *blockArray;
    NSDictionary *currentDict;
}

@end

@implementation LanguageManager
@synthesize userLanguage;

+ (instancetype)sharedInstance
{
    static LanguageManager* sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if(self){
        blockArray = [NSMutableArray array];
        [self initCurrentLanguage];
    }
    return self;
}

- (void)initCurrentLanguage
{
    NSString *currentLanguage = [self userLanguage];
    //从当前语言对应的脚本文件中获取数据
    currentDict = nil;
}

- (NSString*)userLanguage
{
    static NSString *userLanguageKey = @"userLanguage";
    if(!userLanguage){
        userLanguage = [MyCommon getDataFromUserDefaultWithKey:userLanguageKey];
    }
    if(!userLanguage){
        //获取当前系统语言
        NSArray *languageList = [MyCommon getDataFromUserDefaultWithKey:@"AppleLanguages"];
        userLanguage = [languageList firstObject];
    }
    if(!userLanguage){
        //默认语言
        userLanguage = @"en";
    }
    return userLanguage;
}

- (void)setUserLanguage:(NSString *)language
{
    if(!language.length){
        return;
    }
    if([self.userLanguage isEqualToString:language]){
        return;
    }
    userLanguage = language;
    [self initCurrentLanguage];
    [self refreshAllTitle];
}

- (void)refreshAllTitle
{
    for(LanguageBlock block in blockArray){
        if(block){
            block();
        }
    }
}

- (void)executeLanguageChangedBlock:(LanguageBlock)block
{
    if(block){
        block();
    }else{
        return;
    }
    [blockArray addObject:block];
}

- (NSString*)titleForKey:(NSString*)key
{
    return [currentDict objectForKey:key];
}

- (void)clear
{
    [blockArray removeAllObjects];
}

@end
