//
//  MazeScene.m
//  SpeedMaze
//
//  Created by Enlan Zhou on 12/7/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import "MazeScene.h"

@interface MazeScene ()
/**
 *  draw the grid of maze
 */
-(void)drawAllWallsAsOneNode;

/**
 *  draw different types of cell walls. e.g. tube shape
 */
-(void)drawAllWallsWithCellWallTypes;

/**
 *  simple method to paint/draw the solution path
 */
-(void)drawSolutionPath;

@end

@implementation MazeScene

static float squareLength;
static float squareWallThickness;

-(void)didMoveToView:(SKView *)view{
    if (ZenDebug>=2) {
        NSLog(@"MazeScene didMoveToView");
    }
    NSLog(@"didMoveToView: %f, %f, %f, %f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    NSLog(@"square length and thickness: %f, %f", squareLength, squareWallThickness);
    
    [self drawAllWallsAsOneNode];
    //[self drawAllWallsWithCellWallTypes];
    //[self drawSolutionPath];
    
    
    SKSpriteNode *avatar = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(squareLength*0.7, squareLength*0.7)];
    self.avatar = avatar;
    
    //place avatar at (0,0)
    self.avatar.position = CGPointMake(squareLength/2,squareLength/2);
    [self addChild:self.avatar];
    
    self.avatarMazeCell = [self.theMaze.mazeGraph getCellAtX:0 y:0];
    
    /*
    SKShapeNode *square2 = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(squareLength, squareLength)];
    //square2.
    square2.position = nil;
    //square2.frame = CGRectMake(100, 100, 200, 200);
    square2.lineWidth = 5;
    square2.fillColor = [UIColor blackColor];
    square2.strokeColor = [UIColor redColor];
    [self addChild:square2];
    */
    
    /*
    float squareLength = self.frame.size.width / self.theMaze.mazeGraph.width;
    for (int row = 0; row < self.theMaze.mazeGraph.height; row++) {
        for (int col = 0; col < self.theMaze.mazeGraph.width; col++) {
            SKShapeNode *square = [SKShapeNode shapeNodeWithRect:CGRectMake(col*squareLength, row*squareLength, squareLength, squareLength)];
            square.path = [[self drawWallWithCell:[self.theMaze.mazeGraph getCellAtX:col y:row] withSquareLength:squareLength] CGPath];
            //square.position = CGPointMake(160, 160);
            square.lineWidth = squareLength / 10.0;
            square.strokeColor = [SKColor blueColor];
            square.fillColor = [SKColor clearColor];
            [self addChild:square];
            NSLog(@"%f, %f, %f, %f",square.frame.origin.x,square.frame.origin.y,square.frame.size.width,square.frame.size.height);
        }
    }
    */
    //self.backgroundColor = [SKColor greenColor];
    
    

    
}

-(void)drawAllWallsAsOneNode{
    SKShapeNode *square = [SKShapeNode node];
    UIBezierPath* wallPath = [[UIBezierPath alloc] init];
    //from origin point, draw bottom line
    [wallPath moveToPoint:CGPointMake(0.0, 0.0)];
    for (int row = 0; row < self.theMaze.mazeGraph.height; row++) {
        for (int col = 0; col < self.theMaze.mazeGraph.width; col++) {
            [wallPath moveToPoint:CGPointMake(squareLength*col, squareLength*row)];
            MazeCell *cell =[self.theMaze.mazeGraph getCellAtX:col y:row];
            
            /**
             *  draw bottom wall, skip the drawing of entrance
             */
            if ((cell.wallOpenBitMask & BottomWallOpen) || (col == 0 && row == 0)){
                [wallPath moveToPoint:CGPointMake(squareLength*col + squareLength ,squareLength*row)];
            }
            else{
                [wallPath addLineToPoint:CGPointMake(squareLength*col + squareLength ,squareLength*row)];
            }
            
            /**
             *  draw right wall, skip the drawing of exit
             */
            if ((cell.wallOpenBitMask & RightWallOpen) || (col == self.theMaze.mazeGraph.width -1 && row == self.theMaze.mazeGraph.height-1)) {
                [wallPath moveToPoint:CGPointMake(squareLength*col + squareLength ,squareLength*row + squareLength)];
            }
            else{
                [wallPath addLineToPoint:CGPointMake(squareLength*col + squareLength ,squareLength*row + squareLength)];
            }
            
            /**
             *  draw top wall,skip the drawing of exist
             */
            if ((cell.wallOpenBitMask & TopWallOpen) || (col == self.theMaze.mazeGraph.width -1 && row == self.theMaze.mazeGraph.height-1)) {
                [wallPath moveToPoint:CGPointMake(squareLength*col,squareLength*row + squareLength)];
            }
            else{
                [wallPath addLineToPoint:CGPointMake(squareLength*col,squareLength*row + squareLength)];
            }
            
            /**
             *  draw left wall,skip the drawing of entrance
             */
            if ((cell.wallOpenBitMask & LeftWallOpen) || (col == 0 && row == 0)) {
                [wallPath moveToPoint:CGPointMake(squareLength*col,squareLength*row)];
            }
            else{
                [wallPath addLineToPoint:CGPointMake(squareLength*col,squareLength*row)];
            }

            
        }
    }
    square.path = [wallPath CGPath];
    square.lineWidth = squareLength / 10.0;
    square.strokeColor = [SKColor blueColor];
    square.fillColor = [SKColor clearColor];
    [self addChild:square];
    NSLog(@"drawAllWallsAsOneNode: %f, %f, %f, %f",square.frame.origin.x,square.frame.origin.y,square.frame.size.width,square.frame.size.height);
}

-(UIBezierPath *)drawWallWithCell:(MazeCell *)cell withSquareLength:(float)squareLength{
    UIBezierPath* wallPath = [[UIBezierPath alloc] init];
    //from origin point, draw bottom line
    [wallPath moveToPoint:CGPointMake(0.0, 0.0)];
    [wallPath addLineToPoint:CGPointMake(30.0,30.0)];
    [wallPath moveToPoint:CGPointMake(100.0, 100.0)];
    [wallPath addLineToPoint:CGPointMake(130.0,130.0)];

    if (cell.wallOpenBitMask & BottomWallOpen) {
        NSLog(@"bootom wall open at %d,%d",cell.x,cell.y);
        
    }
    /*
    //from origin point, draw bottom line
    [wallPath moveToPoint:CGPointMake(0.0, 0.0)];
    if (cell.wallOpenBitMask & BottomWallOpen) {
        [wallPath addLineToPoint:CGPointMake(0.0,squareLength)];
    }
    
    //from origin point, draw bottom line
    [wallPath moveToPoint:CGPointMake(0.0, 0.0)];
    if (cell.wallOpenBitMask & BottomWallOpen) {
        [wallPath addLineToPoint:CGPointMake(0.0,squareLength)];
    }
    
    //from origin point, draw bottom line
    [wallPath moveToPoint:CGPointMake(0.0, 0.0)];
    if (cell.wallOpenBitMask & BottomWallOpen) {
        [wallPath addLineToPoint:CGPointMake(0.0,squareLength)];
    }
    
     */
    
    

    return wallPath;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKShapeNode *square2 = [SKShapeNode shapeNodeWithRect:CGRectMake(0,0,squareLength,squareLength)];
        //square2.
        square2.position = location;
        square2.lineWidth = 5;
        square2.fillColor = [SKColor blackColor];
        square2.strokeColor = [SKColor redColor];
        [self addChild:square2];
        NSLog(@"touchesBegan: %f, %f, %f, %f",square2.frame.origin.x,square2.frame.origin.y,square2.frame.size.width,square2.frame.size.height);
        
        /*
        //test
        SKShapeNode *square = [SKShapeNode node];
        UIBezierPath* wallPath = [[UIBezierPath alloc] init];
        //from origin point, draw bottom line
        [wallPath moveToPoint:CGPointMake(0.0, 0.0)];
        [wallPath addLineToPoint:CGPointMake(10.0,30.0)];
        [wallPath moveToPoint:CGPointMake(squareLength.0, 1squareLength.0)];
        [wallPath addLineToPoint:CGPointMake(100.0,300.0)];
        square.path = [wallPath CGPath];
        square.lineWidth = 2;
        square.strokeColor = [SKColor grayColor];
        [self addChild:square];
         */
    }
}

-(instancetype)initWithMaze:(MazeGenerator *)maze andScreenSize:(CGSize)screenSize{
    self = [super initWithSize:screenSize];
    if(self == nil){
        return nil;
    }
    self.theMaze = maze;
    squareLength = self.size.width / self.theMaze.mazeGraph.width;
    squareWallThickness = squareLength / 10.0;

    /*
    self.twoDSKNodes = [[NSMutableArray alloc] initWithCapacity:self.theMaze.mazeGraph.width];
    for (int i = 0; i < self.theMaze.mazeGraph.width; i++) {
        self.twoDSKNodes[i] = [[NSMutableArray alloc] initWithCapacity:self.theMaze.mazeGraph.height];
        for (int j = 0; j < self.theMaze.mazeGraph.height; j++) {
            self.twoDSKNodes[i][j] = [SKShapeNode node];
        }
    }
    */
    return self;
}

-(void)drawAllWallsWithCellWallTypes{
    for (int row = 0; row < self.theMaze.mazeGraph.height; row++) {
        for (int col = 0; col < self.theMaze.mazeGraph.width; col++) {
            MazeCell *thisCell =[self.theMaze.mazeGraph getCellAtX:col y:row];
            if (thisCell.wallShapeBitMask == wallVerticalTubeShapeType ||thisCell.wallShapeBitMask == wallHorizontalTubeShapeType) {
                //[self drawWallsWithTubeWallShapeTypeWithColumn:col andRow:row];
            }
            if (thisCell.wallShapeBitMask != wallVerticalTubeShapeType && thisCell.wallShapeBitMask != wallHorizontalTubeShapeType) {
                [self drawWallsWithDefaultWallShapeTypeWithColumn:col andRow:row];
            }
        }
    }
}

-(void)drawWallsWithDefaultWallShapeTypeWithColumn:(int)col andRow:(int)row{
    SKShapeNode *square = [SKShapeNode shapeNodeWithRect:CGRectMake(col*squareLength+squareLength*0.1,row*squareLength+squareLength*0.1,squareLength*0.8,squareLength*0.8)];
    //square.lineWidth = 5;
    //square.strokeColor = [SKColor redColor];
    square.fillColor = ZenMyBluenWithAlpha(0.5);
    [self addChild:square];
    if (ZenDebug>=3) {
        NSLog(@"TubeWall: %f, %f, %f, %f",square.frame.origin.x,square.frame.origin.y,square.frame.size.width,square.frame.size.height);
    }
}

-(void)drawWallsWithTubeWallShapeTypeWithColumn:(int)col andRow:(int)row{
    SKShapeNode *square = [SKShapeNode shapeNodeWithRect:CGRectMake(col*squareLength,row*squareLength,squareLength,squareLength)];
    //square.lineWidth = 5;
    //square.strokeColor = [SKColor redColor];
    square.fillColor = ZenMyGreenWithAlpha(0.5);
    [self addChild:square];
    if (ZenDebug>=3) {
        NSLog(@"TubeWall: %f, %f, %f, %f",square.frame.origin.x,square.frame.origin.y,square.frame.size.width,square.frame.size.height);
    }
}

-(void)drawSolutionPath{
    SKShapeNode *solutionPath = [SKShapeNode node];
    UIBezierPath* wallPath = [[UIBezierPath alloc] init];
    //move to the center of (0,0)
    [wallPath moveToPoint:CGPointMake(squareLength / 2, squareLength / 2)];
    for (MazeCell *step in self.theMaze.path) {
        CGRect thisNode = CGRectMake(step.x*squareLength,step.y*squareLength,squareLength,squareLength);
        [wallPath addLineToPoint:CGPointMake(CGRectGetMidX(thisNode), CGRectGetMidY(thisNode))];
        
        if (ZenDebug>=3) {
            NSString *B = (step.wallOpenBitMask & BottomWallOpen) ? @"Y" :@"N";
            NSString *R = (step.wallOpenBitMask & RightWallOpen) ? @"Y" :@"N";
            NSString *T = (step.wallOpenBitMask & TopWallOpen) ? @"Y" :@"N";
            NSString *L = (step.wallOpenBitMask & LeftWallOpen) ? @"Y" :@"N";
            NSLog(@"solutionPath: (%i, %i), OpenWall: B:%@ R:%@ T:%@ L:%@",step.x,step.y,B,R,T,L);
        }
    }
    solutionPath.path = [wallPath CGPath];
    solutionPath.lineWidth = squareLength * 8 / 10;
    solutionPath.strokeColor = [SKColor redColor];
    [self addChild:solutionPath];
}

-(void)update:(NSTimeInterval)currentTime{
    
}

-(void)gamepadControlMoveTo:(NSString *)keyName{
    NSLog(@"avatarCell x:%i,y:%i",self.avatarMazeCell.x,self.avatarMazeCell.y);
    [self moveAvatarAccordingToMazeCell:self.avatar mazeCell:self.avatarMazeCell inDirection:keyName];
    /*
    if ([keyName isEqualToString:@"U"]) {
        NSLog(@"maze scene receives key pressed up");
        self.avatar.position = CGPointMake(self.avatar.position.x, self.avatar.position.y + squareLength);
    }
    if ([keyName isEqualToString:@"L"]) {
        NSLog(@"maze scene receives key pressed left");
        self.avatar.position = CGPointMake(self.avatar.position.x - squareLength, self.avatar.position.y);
    }
    if ([keyName isEqualToString:@"D"]) {
        NSLog(@"maze scene receives key pressed down");
        self.avatar.position = CGPointMake(self.avatar.position.x, self.avatar.position.y - squareLength);
    }
    if ([keyName isEqualToString:@"R"]) {
        NSLog(@"maze scene receives key pressed right");
        self.avatar.position = CGPointMake(self.avatar.position.x + squareLength, self.avatar.position.y);
    }
     */
}

/**
 *  if the wall in that driection is open, and the destination cell is tubeType, keep going
 *
 *  @param avatar   avatar
 *  @param mazeCell the mazeCell that avatar is at
 *  @param keyName  U L D R
 */
-(void)moveAvatarAccordingToMazeCell:(SKSpriteNode *)avatar mazeCell:(MazeCell *)mazeCell inDirection:(NSString *)keyName{
    if ([keyName isEqualToString:@"U"]) {
        while ((mazeCell.wallOpenBitMask & TopWallOpen)) {
            NSLog(@"walling in %@",keyName);
            [mazeCell printCellOpenWallBitMask];
            avatar.position = CGPointMake(avatar.position.x, avatar.position.y + squareLength);
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x y:mazeCell.y+1];
            self.avatarMazeCell = mazeCell;
            NSLog(@"move avatarCell end at x:%i,y:%i",self.avatarMazeCell.x,self.avatarMazeCell.y);
            if (mazeCell.wallShapeBitMask != wallVerticalTubeShapeType) {
                break;
            }
        }
    }
    if ([keyName isEqualToString:@"L"]) {
        while ((mazeCell.wallOpenBitMask & LeftWallOpen) ) {
            NSLog(@"walling in %@",keyName);
            avatar.position = CGPointMake(avatar.position.x - squareLength, avatar.position.y);
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x-1 y:mazeCell.y];
            self.avatarMazeCell = mazeCell;
            if (mazeCell.wallShapeBitMask != wallHorizontalTubeShapeType) {
                break;
            }
        }
    }
    if ([keyName isEqualToString:@"D"]) {
        while ((mazeCell.wallOpenBitMask & BottomWallOpen) ) {
            NSLog(@"walling in %@",keyName);
            avatar.position = CGPointMake(avatar.position.x, avatar.position.y - squareLength);
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x y:mazeCell.y-1];
            self.avatarMazeCell = mazeCell;
            if (mazeCell.wallShapeBitMask != wallVerticalTubeShapeType) {
                break;
            }
        }
    }
    if ([keyName isEqualToString:@"R"]) {
        while ((mazeCell.wallOpenBitMask & RightWallOpen) ) {
            NSLog(@"walling in %@",keyName);
            avatar.position = CGPointMake(avatar.position.x + squareLength, avatar.position.y);
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x+1 y:mazeCell.y];
            self.avatarMazeCell = mazeCell;
            if (mazeCell.wallShapeBitMask != wallHorizontalTubeShapeType) {
                break;
            }
        }
    }
}

@end