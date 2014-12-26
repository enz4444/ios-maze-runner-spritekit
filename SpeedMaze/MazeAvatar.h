//
//  MazeAvatar.h
//  SpeedMaze
//
//  Created by Enlan Zhou on 12/19/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>
#import "MazeGraph.h"

typedef NS_ENUM(uint32_t, mazeAvatarType)
{
    // default avatar, with an undo button
    mazeAvatarBlackBox       = 0x1 << 0,
    
    // with long neck
    mazeAvatarGiraffe        = 0x1 << 1,
    
    // will leave track
    mazeAvatarSnail          = 0x1 << 2,
    
    // no mist
    mazeAvatarSunday         = 0x4 << 3,
    
    //undefined
    mazeAvatarUndefined              = 0x0
};

@protocol MazeAvatarAnimationDelegate;

@interface MazeAvatar : SKSpriteNode

@property (weak,nonatomic) id<MazeAvatarAnimationDelegate> animationDelegate;

@property (strong,readonly,nonatomic) NSMutableSet *snailTrailSet;

/**
 *  the type of avatar in currect maze
 */
@property (assign,nonatomic) mazeAvatarType avatarType;

@property (assign,readonly,nonatomic) float mazeAvatarSpeed;

@property (assign,readonly,nonatomic) BOOL isAnimating;


/**
 *  the MazeCell that avatar is at
 */
@property (strong,nonatomic) MazeCell *avatarMazeCell;


-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size;

-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size avatarType:(mazeAvatarType)avatarType;

/**
 *  animate the movement for avatar escept for blackbox
 *  Blackbox will use calculateAvatarNodePositionWithAvatarCell instead
 *
 *  @param squareLength the width of a tile
 */
-(void)animateAvatarNodePositionWithAvatarCell:(float)squareLength times:(int)times;

/**
 *  convert avatarMazeCell's coordination to SKSpriteNode's position
 *  this method does no animation, just change node's position
 *
 *  @param squareLength the width of a tile
 */
-(void)calculateAvatarNodePositionWithAvatarCell:(float)squareLength;

/**
 *  CAUTION! balck box is move like teleporting, a new cell means the
 *  final cell after it ends teleporting.
 *  call it everytime step into a new cell, no need to call when undo
 *  becuase the last object in array will be the cell is stepped on
 *
 *  @param atCell maze cell that avatar stand on top
 */
-(void)mazeAvatarBlackBoxStepAt:(MazeCell *)atCell;
-(void)mazeAvatarBlackBoxStepTo:(NSString *)atDirection;//use direction instead


/**
 *  black box perfrom an undo
 *
 *  @return return where it was, untiil back to the beginging.
 *          but never remove the first cell, since it stand at
 *          no less than the entrance.
 */
-(MazeCell *)mazeAvatarBlackBoxUndoACell;
-(NSString *)mazeAvatarBlackBoxUndoADirection;//use direction instead, already mirrored when return

/**
 *  add to this array for EVERY single tile of maze cell that snail walked in.
 *  Better invoke this for every tile snails pass
 *
 *  @param aCell maze cell
 */
-(void)mazeAvatarSnailAddAMazeCell:(MazeCell *)aCell;

/**
 *  Mark all trail maze cells to visible/no mist.
 *  Better invoke this before draw mist.
 */
-(void)mazeAvatarSnailMarkAllTrailMazeCellToVisiable;


@end

@protocol MazeAvatarAnimationDelegate <NSObject>

-(void)mazeAvatarAnimationDidFinishOneTileMovment;

-(void)mazeAvatarAnimationDidFinishRepeatMovement;

@end
