//
//  MazeGenerator.m
//  speed-maze
//
//  Created by littlebeef on 11/19/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import "MazeGenerator.h"

#define MaxStepsBeforeBacktrace 10
#define MaxStepsBeforeBacktraceActive false

@interface MazeGenerator(){
    int currentSteps;
}

@property(strong,nonatomic) NSMutableArray *cellStack;

/**
 *  default grow a mze from 0,0 recusively
 *
 *  @param mazeCell
 */
-(void)defaultRecusiveGrowMaze:(MazeCell *)mazeCell;

/**
 *  default(original) method to grow a maze from a maze cell
 *
 *  @param mazeCell mazeCell at (0,0)
 */
-(void)defaultGenerateMaze;

/**
 *  render/filter the maze cell, get rid(or mark) of those are 'tube' shape
 */
-(void)defaultMazeCellFilter;

/**
 *  Similar to defaultRecusiveGrowMaze:, this method can generate a no circular path perfect maze. This method will replace the default generate algorithm, because the default one can't generate a maze with more "branches", it was too "smooth".
 *
 *  @param mazeCell
 */
-(void)perfectGrowMaze:(MazeCell *)mazeCell;
@end

@implementation MazeGenerator

-(instancetype)init{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    self.cellStack = [[NSMutableArray alloc] init];
    return self;
}

-(instancetype)initMazeWithWidth:(int)width height:(int)height{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    self.cellStack = [[NSMutableArray alloc] init];
    self.mazeGraph = [[MazeGraph alloc] initWithWidth:width height:height];
    return self;
}

-(void)defaultMaze{
    [self defaultGenerateMaze]; //or choose other generate methods
    [self defaultSolveMaze];
    [self defaultMazeCellFilter];
}

-(void)perfectMaze{
    
}

-(void)perfectGrowMaze:(MazeCell *)mazeCell{
    
}


-(void)defaultRecusiveGrowMaze:(MazeCell *)mazeCell{
    //NSLog(@"recursive at (%i,%i)",mazeCell.x,mazeCell.y);
    if (MaxStepsBeforeBacktraceActive) {
        currentSteps++;
    }
    [mazeCell visit];
    NSArray *neighbor = [self.mazeGraph cellUnvisitedNeighbors:mazeCell];

    /**
     *  (!MaxStepsBeforeBacktraceActive || currentSteps <= MaxStepsBeforeBacktrace))
     *
     *  This statement is always true when MaxStepsBeforeBacktraceActive = false. Such this statement will skip the latter part.
     *
     *  When MaxStepsBeforeBacktraceActive = true, the first statement is always false, so the latter part must be checked.
     *
     */
    if ((neighbor.count && neighbor.count > 0 ) && (!MaxStepsBeforeBacktraceActive || currentSteps <= MaxStepsBeforeBacktrace)) {
        MazeCell *randomNeighbor = neighbor[arc4random_uniform((int)neighbor.count)];
        [self.cellStack addObject:mazeCell];
        [self.mazeGraph removeEdgeBetween:mazeCell and:randomNeighbor];
        [self defaultRecusiveGrowMaze:randomNeighbor];
    }
    else{
        if (MaxStepsBeforeBacktraceActive) {
            // When a cell has no neighbour, or currentSteps is the max, reset this value for the use of next cell in self.cellStack
            currentSteps = 0;
        }
        if (self.cellStack.count) {
            //MazeCell *waitingCell = self.cellStack.lastObject;// backtrace here?
            //[self.cellStack removeLastObject];// and this
            MazeCell *waitingCell = [self kindOfBacktraceUsingRandomCellFromCellStackWithStyle:2];
            [self defaultRecusiveGrowMaze:waitingCell];
        }
        
    }
}

/**
 *  For example, if the algorithm always try to "fork" a branch from last cell in the stack, the maze will become very "smooth" and dont has much branches. Manipulate this method to generate different styles of Perfect Maze
 */
-(MazeCell *)kindOfBacktraceUsingRandomCellFromCellStackWithStyle:(int)style{
    MazeCell *returnCell;
    switch (style) {
        //case 1, always lastObject, smoothy?
        case 1:{
            returnCell = self.cellStack.lastObject;// backtrace here?
            [self.cellStack removeLastObject];// and this
            break;
        }
        //case 2, random from cellStack. fun maze
        case 2:{
            unsigned int randomIndex = arc4random_uniform((int)self.cellStack.count);
            returnCell = self.cellStack[randomIndex];
            [self.cellStack removeObjectAtIndex:randomIndex];
            break;
        }

        //case 3, always firstObject, branchy? meh..
        case 3:{
            returnCell = self.cellStack.firstObject;
            [self.cellStack removeObjectAtIndex:0];
            break;
        }
            
        // default is the origin method, which return lastOject
        default:{
            returnCell = self.cellStack.lastObject;// backtrace here?
            [self.cellStack removeLastObject];// and this
            break;
        }
    }
    
    return returnCell;
}

-(void)defaultSolveMaze{
    NSMutableArray *closedCells = [NSMutableArray array];
    MazeCell *startCell = [self.mazeGraph getCellAtX:0 y:0];
    MazeCell *endCell = [self.mazeGraph getCellAtX:(self.mazeGraph.width - 1) y:(self.mazeGraph.height - 1)];
    NSMutableArray *openCells = [NSMutableArray arrayWithObject:startCell];
    MazeCell *searchCell = startCell;
    while (openCells.count) {
        NSMutableArray *neighbors = [NSMutableArray arrayWithArray:[self.mazeGraph cellDisconnectedNeighbors:searchCell]];
        for (int i = 0; i < neighbors.count; i++) {
            MazeCell *neighbor = neighbors[i];
            if (neighbor == endCell) {
                neighbor.parent = searchCell;
                self.path = neighbor.pathToOrigin;
                [openCells removeAllObjects];
                return;
            }
            if (![closedCells containsObject:neighbor]) {
                if (![openCells containsObject:neighbor]) {
                    [openCells addObject:neighbor];
                    neighbor.parent = searchCell;
                    neighbor.discorver = [neighbor score] + [self.mazeGraph getCellDistanceBetween:neighbor and:endCell];
                }
            }
        }
        [closedCells addObject:searchCell];
        [openCells removeObject:searchCell];
        searchCell = nil;
        
        for(MazeCell *tempCell in openCells){
            if (!searchCell) {
                searchCell = tempCell;
            }
            else if (searchCell.discorver < tempCell.discorver){
                searchCell = tempCell;
            }
        }
        
    }
}

/**
 *  default(original) method to grow a maze from a maze cell
 *
 *  @param mazeCell mazeCell at (0,0)
 */
-(void)defaultGenerateMaze{
    //NSLog(@"defaultGernerateMaze");
    currentSteps = 0;
    [self defaultRecusiveGrowMaze:[[self mazeGraph] getCellAtX:0 y:0]];
}

/**
 *  render/filter the maze cell, get rid(or mark) of those are 'tube' shape
 */
-(void)defaultMazeCellFilter{
    for (int i = 0; i < self.mazeGraph.width; i++) {
        for (int j = 0; j < self.mazeGraph.height; j++) {
            MazeCell *thisCell = [self.mazeGraph getCellAtX:i y:j];
            if(thisCell.wallOpenBitMask == (TopWallOpen | BottomWallOpen)){
                thisCell.wallShapeBitMask = wallVerticalTubeShapeType;
            }
            else if (thisCell.wallOpenBitMask == (LeftWallOpen | RightWallOpen)) {
                thisCell.wallShapeBitMask = wallHorizontalTubeShapeType;
            }
            else{
                thisCell.wallShapeBitMask = wallUndefinedShape;
            }
        }
    }

}

@end