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

@protocol MazeSceneGameConditionDelegate;

@interface MazeScene : SKScene <MazeAvatarAnimationDelegate>

@property (weak,nonatomic) id<MazeSceneGameConditionDelegate> gameConditionDelegate;


/**
 *  all the codes and glory
 */
@property (strong,nonatomic) MazeGenerator *theMaze;

/**
 *  the maze walls. Draw all the walls a node with lines.
 *  use only once for textureFromNode
 */
@property (strong,nonatomic) SKSpriteNode *mazeLayout;

/**
 *  mist as a fat line, need to take out to avoid using
 *  SKShapeNode.
 */
@property (strong,nonatomic) SKShapeNode *mist;

/**
 *  opposite to mist. Mist is to cover the map, vision node
 *  is to crop a mask of visible area
 */
@property (strong,nonatomic) SKCropNode *visionNode;

/**
 *  use textureFromNode from self.mist
 *  such convert a SKShapNode to SKSpriteNode
 */
@property (strong,nonatomic) SKSpriteNode *mazeMap;

/**
 *  same size as mazeMap. Transparent. It holds all grid/square
 *  of corresponded hasMist cell. For masking purpose.
 */
@property (strong,nonatomic) SKSpriteNode *cropTileContainer;

/**
 *  Set of vision cells, those without mist.Use it to
 *  draw/re-draw mist. It stores MazeCell
 *  Caution! It's only about avatar's sight
 */
@property (strong,nonatomic) NSMutableSet *visionCells;

/**
 *  It's liked visibleCells. But this set is one to one
 *  relationship with cropTileContainer's children(SKSpriteNode)
 *  It stores MazeCell
 */
@property (strong,nonatomic) NSMutableSet *maskChildren;

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
 *  like above
 *
 *  @param maze
 *  @param screenSize 
 *  @param avatarType
 *
 *  @return
 */
-(instancetype)initWithMaze:(MazeGenerator *)maze andScreenSize:(CGSize)screenSize andAvatarType:(mazeAvatarType)avatarType;

/**
 *  when parent VC receive the delegate call, use this move
 *
 *  @param direction U L D R
 */
-(void)gamepadControlMoveTo:(NSString *)keyName;
@end

@protocol MazeSceneGameConditionDelegate <NSObject>

-(void)mazeSceneGameEnds:(NSString *)condition;

@end
