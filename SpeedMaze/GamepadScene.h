//
//  GamepadScene
//  SpeedMaze
//
//  Created by Enlan Zhou on 12/12/14
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

/**
 *  send touch action
 */
@protocol GamepadSceneDelegate;

@interface GamepadScene : SKScene

@property (weak,nonatomic) id<GamepadSceneDelegate> gamepadDelegate;

@end

@protocol GamepadSceneDelegate <NSObject>
-(void)gamepadKeyTouched:(NSString *)keyName;

@end
