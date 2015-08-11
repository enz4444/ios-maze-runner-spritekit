//
//  MenuScene.h
//  SpeedMaze
//
//  Created by Enlan Zhou on 12/19/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>
#import "MazeAvatar.h"
#import "MazeScene.h"

@protocol MazeGameMenuDelegate;

@interface MenuScene : SKScene <UITextFieldDelegate>

@property (weak,nonatomic) id<MazeGameMenuDelegate> gameMenudelegate;

@property (weak,nonatomic) UITextField *mazeWidth;

-(instancetype)initMazeGameMenuWithSize:(CGSize)CGSize;

@end

@protocol MazeGameMenuDelegate <NSObject>
-(void)generateMazeWithWidth:(int)width andHeight:(int)height andAvatarType:(mazeAvatarType)avataType;

@end
