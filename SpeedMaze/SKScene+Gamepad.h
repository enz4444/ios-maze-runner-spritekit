//
//  SKScene+Gamepad.h
//  SpeedMaze
//
//  Created by Enlan Zhou on 12/12/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@protocol SKSceneGamepadDelegate;

@interface SKScene (Gamepad)
//add delegate, calling, callback
@property (weak, nonatomic) id <SKSceneGamepadDelegate> delegate;


@end

@protocol SKSceneGamepadDelegate <NSObject>
@optional
-(void)gamepadFeedback:(SKScene *)sender;

@end