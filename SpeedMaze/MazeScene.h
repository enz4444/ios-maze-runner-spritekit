//
//  MazeScene.h
//  SpeedMaze
//
//  Created by Enlan Zhou on 12/7/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>
#import "MazeGenerator.h"
#import "GamepadScene.h"

@interface MazeScene : SKScene

/**
 *  all the codes and glory
 */
@property (strong,nonatomic) MazeGenerator *theMaze;

/**
 *  the maze walls. Draw all the walls a node with lines.
 */
@property (strong,nonatomic) SKShapeNode *mazeLayout;

/**
 *  the avatar that explore the maze
 */
@property (strong,nonatomic) SKSpriteNode *avatar;

/**
 *  mist as a fat line
 */
@property (strong,nonatomic) SKShapeNode *mist;

/**
 *  Set of visible cells, those without mist.Use it to
 *  draw/re-draw mist.
 */
@property (strong,nonatomic) NSMutableSet *visibleCells;

/**
 *  the MazeCell that avatar is at
 */
@property (strong,nonatomic) MazeCell *avatarMazeCell;

/**
 *  everything else about avatar, e.g. its skill
 */
@property (strong,nonatomic) MazeAvatar *mazeAvatar;

@property (strong,nonatomic) NSString *directionWasPressed;

/**
 *  default init, need to pass in the screen size to 
 *  calculate some static vaules at
 *  the beginning.
 *
 *  @param maze       maze
 *  @param screenSize parent screen size, or whatever size
 *
 *  @return SKScene with whatever method invoked at the end of didMoveToView
 */
-(instancetype)initWithMaze:(MazeGenerator *)maze andScreenSize:(CGSize)screenSize;

/**
 *  when parent VC receive the delegate call, use this move
 *
 *  @param direction U L D R
 */
-(void)gamepadControlMoveTo:(NSString *)keyName;
@end
