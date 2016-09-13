//
//  MXStepper.h
//  gem
//
//  Created by admin on 15/11/5.
//  Copyright © 2015年 antsmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXStepper;

// called when value is changed
typedef void (^MXStepperValueChangedCallback)(MXStepper *stepper, float newValue);

// called when value is incremented
typedef BOOL (^MXStepperIncrementedCallback)(MXStepper *stepper, float newValue);

// called when value is decremented
typedef BOOL (^MXStepperDecrementedCallback)(MXStepper *stepper, float newValue);

@interface MXStepper : UIView

@property (nonatomic,assign) float value; // default: 0.0

@property (nonatomic,assign) float stepInterval; // default: 1.0
@property (nonatomic,assign) float minimum; // default: 0.0
@property (nonatomic,assign) float maximum; // default: 100.0

@property (nonatomic,assign) NSInteger afterPointPosition;//default: 0

@property (nonatomic,strong) MXStepperIncrementedCallback incrementedCallback;
@property (nonatomic,strong) MXStepperDecrementedCallback decrementedCallback;
@property (nonatomic,strong) MXStepperValueChangedCallback valueChangedCallback;

@end
