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

/**
 *  idealy, return instance of an avatar according to type
 */
@interface MazeAvatar : NSObject

// the type of avatar in currect maze
@property (assign, nonatomic) mazeAvatarType avatarType;

-(instancetype)init;

-(instancetype)initWithAvatarType:(mazeAvatarType)avatarType;

//need method to effect the maze when avtar moves

//need method to effect the maze when avtar invokes skill

-(void)mazeAvatarMove:(MazeGraph *)mazeGraph inDirection:(NSString *)keyname fromLocation:(MazeCell *)avatarMazeCell toLocation:(MazeCell *)toCell;

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