//
//  MazeScene.m
//  SpeedMaze
//
//  Created by Enlan Zhou on 12/7/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import "MazeScene.h"

@interface MazeScene ()

@property (assign,atomic) BOOL mazeSceneAvatarIsMoving;

/**
 *  indication a movement loop if an avtar can continue move in 
 *  a direction without user's control. U L D R are direction key.
 *  'N' is not applicable, means no next movement or will stop movement.
 */
@property (strong,atomic) NSString *mazeSceneAvatarCanContintuelyMoveInDirection;

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

/**
 *  need to run these method accordinglyl to have the
 *  effect of mazeAvatar. These method need to indentify
 *  avatar type. and will grab the necessary property frome
 *  interface
 */
-(void)mazeAvatarBeforeMove; //before leaving the tile it was stood on
-(void)mazeAvatarIsMoving; //for every tile it passes
-(void)mazeAvatarDidMove; //after it stop, arrives the destination
-(void)mazeAvatarInvokeSkill; // pressed 'S'


/**
 *  Do this everythime after avatar done moving, to re-caculate sight and
 *  re-draw mist. After node of mist is added to view, all cell.hasMist
 *  should return to YES;(restore the state after finishing adding mist)
 *
 *  @param avatarMazeCell location of avatar
 */
-(void)drawMistAsOneNodeWithItsSightWithAvatarMazeCell:(MazeCell *)avatarMazeCell;

/**
 *  replacement of 
 *  -(void)drawMistWithUIBezierPath;
 *  to avoid using SKShapeNode
 */
-(void)drawMistWithSKSpriteNodeAsMask;

/**
 *  need a new method to replace this method, currently it draw black stroke with
 *  UIBezierPath and SKShapeNode. A new method should caculate and create a mask
 *  to be used in SKCropNode
 *
 *  Loop throught all cells, if its hasMist == YES, then draw a square stroke on top of it
 *  Use one path to draw all mists
 *  It was used in drawMistAsOneNodeWithItsSightWithAvatarMazeCell:
 *  replace by drawMistWithSKSpriteNodeAsMask to avoid using SKShapeNode
 */
-(void)drawMistWithUIBezierPath;

/**
 *  if the wall in that driection is open, move avatar accoring to its type, one tile at
 *  a time
 *  @param avatar   avatar
 *  @param mazeCell the mazeCell that avatar is at
 *  @param keyName  U L D R
 */
-(void)moveAvatarAccordingToMazeCell:(SKSpriteNode *)avatar mazeCell:(MazeCell *)mazeCell inDirection:(NSString *)keyName;

/**
 *  if the wall in that driection is open, and the destination cell is tubeType, keep going
 *
 *  @param avatar   avatar
 *  @param mazeCell the mazeCell that avatar is at
 *  @param keyName  U L D R
 */
-(void)moveAvatarAccordingToMazeCellSkipTubeShapeTile:(SKSpriteNode *)avatar mazeCell:(MazeCell *)mazeCell inDirection:(NSString *)keyName;

/**
 *  It's like moveAvatarAccordingToMazeCellSkipTubeShapeTile but with animation
 *  @param avatar   avatar
 *  @param mazeCell the mazeCell that avatar is at
 *  @param keyName  U L D R
 */
-(void)moveAvatarAccordingToMazeCellRepeatAnimation:(SKSpriteNode *)avatar mazeCell:(MazeCell *)mazeCell inDirection:(NSString *)keyName;
    
@end

@implementation MazeScene

static float squareLength;
static float squareWallThickness;
static float worldWidth;
static int cnt;

-(void)didMoveToView:(SKView *)view{
    [super didMoveToView:view];
    self.backgroundColor = [SKColor blueColor];//ZenMyGreen;
    if (ZenDebug>=2) {
        NSLog(@"MazeScene didMoveToView");
    }
    NSLog(@"didMoveToView: %f, %f, %f, %f",self.size.width,self.size.height,self.frame.size.width,self.frame.size.height);
    NSLog(@"square length and thickness: %f, %f", squareLength, squareWallThickness);
    
    [self drawAllWallsAsOneNode];
    cnt =0;
    
    //[self.view addGestureRecognizer:];
    
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
            if ((cell.wallOpenBitMask & RightWallOpen)) {
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
            if ((cell.wallOpenBitMask & LeftWallOpen)) {
                [wallPath moveToPoint:CGPointMake(squareLength*col,squareLength*row)];
            }
            else{
                [wallPath addLineToPoint:CGPointMake(squareLength*col,squareLength*row)];
            }

            
        }
    }
    square.path = [wallPath CGPath];
    
    //thickness of walls
    square.lineWidth = squareLength / 5.0;
    square.lineCap = kCGLineCapSquare;
    square.strokeColor = [SKColor whiteColor];
    //square.fillColor = [SKColor clearColor];
    SKSpriteNode *back = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:square.frame.size];
    back.anchorPoint = CGPointMake(0,0);
    [back addChild:square];
    self.mazeLayout = back;
    
    NSLog(@"drawAllWallsAsOneNode: %f, %f, %f, %f",square.frame.origin.x,square.frame.origin.y,square.frame.size.width,square.frame.size.height);
    
    [self addChild:self.mazeLayout];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    /*
    for (UITouch *touch in touches) {
        //testing, add red bound black square onto touch location
        CGPoint location = [touch locationInNode:self];
        SKShapeNode *square2 = [SKShapeNode shapeNodeWithRect:CGRectMake(0,0,squareLength,squareLength)];
        //square2.
        square2.position = location;
        square2.lineWidth = 5;
        square2.fillColor = [SKColor blackColor];
        square2.strokeColor = [SKColor redColor];
        [self addChild:square2];
        NSLog(@"touchesBegan: %f, %f, %f, %f",square2.frame.origin.x,square2.frame.origin.y,square2.frame.size.width,square2.frame.size.height);
        }
    */
}

-(instancetype)initWithMaze:(MazeGenerator *)maze andScreenSize:(CGSize)screenSize{
    self = [super initWithSize:screenSize];
    if(self == nil){
        return nil;
    }
    self.theMaze = maze;
    self.visionCells = [NSMutableSet set];
    self.maskChildren = [NSMutableSet set];
    /*
     * squareLength is no longer than screenSize/15, can be less but can't be more
     */
    if (maze.mazeGraph.width <= 15) {
        worldWidth = screenSize.width;
        squareLength = screenSize.width / self.theMaze.mazeGraph.width;
        squareWallThickness = squareLength / 10.0;
    }
    else{
        // world width is > 15
        squareLength = screenSize.width / 15;
        squareWallThickness = squareLength / 10.0;
        worldWidth = squareLength * self.theMaze.mazeGraph.width;
        NSLog(@"initwithmaze: %f %f",squareLength,worldWidth);
    }
    
    return self;
}

-(instancetype)initWithMaze:(MazeGenerator *)maze andScreenSize:(CGSize)screenSize andAvatarType:(mazeAvatarType)avatarType{
    self = [self initWithMaze:maze andScreenSize:screenSize];
    if (self == nil) {
        return self;
    }
    self.mazeAvatar = [[MazeAvatar alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(squareLength*0.6, squareLength*0.6) avatarType:avatarType];
    self.mazeAvatar.animationDelegate = self;
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



-(void)centerOnNode:(SKNode *)node{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x,                                       node.parent.position.y - cameraPositionInScene.y);
}

- (void)setViewpointCenter:(CGPoint)position {
    //NSInteger x = MAX(position.x, self.size.width / 2);
    //NSInteger y = MAX(position.y, self.size.height / 2);
    //x = MIN(x, (self.map.mapSize.width * self.map.tileSize.width) - self.size.width / 2);
    //y = MIN(y, (self.map.mapSize.height * self.map.tileSize.height) - self.size.height / 2);
    //CGPoint actualPosition = CGPointMake(x, y);
    //CGPoint centerOfView = CGPointMake(self.size.width/2, self.size.height/2);
    //CGPoint viewPoint = CGPointSubtract(centerOfView, actualPosition);
    //self.map.position = viewPoint;
}

-(void)update:(NSTimeInterval)currentTime{

    /*
     
     */
    if (cnt == 1) // can be cnt == 0 on XCode 6.0
    {
        //below codes was from didMoveToView, but need to "textureFromNode" so
        //move them to here
        //[self drawAllWallsAsOneNode];
        //[self drawAllWallsWithCellWallTypes];
        //[self drawSolutionPath];
        
        //get texture
        /*
         SKTexture *cacheTexture =[ self.view textureFromNode:container];
         canvas.texture = cacheTexture;
         [canvas setSize:CGSizeMake(canvas.texture.size.width, canvas.texture.size.height)];
         canvas.anchorPoint = CGPointMake(0, 0);
         */
        SKTexture *cacheTexture =[self.view textureFromNode:self.mazeLayout];
        SKSpriteNode *mazeMap = [[SKSpriteNode alloc] initWithTexture:cacheTexture color:[UIColor clearColor] size:CGSizeMake(worldWidth, worldWidth)];//self.size];
        mazeMap.anchorPoint = CGPointMake(0, 0);
        self.mazeMap = mazeMap;
        [self.mazeLayout removeFromParent];
        self.mazeLayout = nil;
        self.mazeMap.zPosition = 0;
        //[self addChild:self.mazeMap]; //comment out for testing SKCropNode
        
        SKSpriteNode *cropTileContainer = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(worldWidth, worldWidth)];//self.size];
        NSLog(@"testing size0: %f", squareLength);
        NSLog(@"testing size: %f ", self.size.width);
        cropTileContainer.anchorPoint = CGPointMake(0, 0);
        self.cropTileContainer = cropTileContainer;
        NSLog(@"testing size2: %f %f", self.cropTileContainer.size.width, self.size.width);

        
        /*//testing, add mask tile/grid to cropTileContrainer
        SKSpriteNode *tile5_5 = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(squareLength, squareLength*5)];
        tile5_5.anchorPoint = CGPointMake(0, 0); //was anchor at center, now is (0,0) for better replacement according to maze's coordination and grids
        tile5_5.position = CGPointMake(squareLength*4, squareLength*4);
        [self.cropTileContainer addChild:tile5_5];
        */
         
        self.backgroundColor = [SKColor blackColor];
        
        if (self.mazeAvatar == nil) {
            NSLog(@"MazeScene: avatar is nil");
            self.mazeAvatar = [[MazeAvatar alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(squareLength*0.6, squareLength*0.6) avatarType:mazeAvatarBlackBox];
            self.mazeAvatar.animationDelegate = self;
        }
        // mark the original maze cell that avatar is at
        self.mazeAvatar.avatarMazeCell = [self.theMaze.mazeGraph getCellAtX:0 y:0];
        //place avatar at (0,0)
        [self.mazeAvatar calculateAvatarNodePositionWithAvatarCell:squareLength];
        self.mazeAvatar.zPosition = 2;
        [self addChild:self.mazeAvatar];
        //[self.mazeMap addChild:self.mazeAvatar];
        
        //test for SKCropNode
        SKCropNode *visionNode = [SKCropNode node];
        [visionNode addChild:self.mazeMap];
        [visionNode setMaskNode:self.cropTileContainer];
        self.visionNode = visionNode;
        self.visionNode.zPosition = 1;
        [self addChild:visionNode];
        
        self.mazeSceneAvatarIsMoving = NO;
        self.mazeSceneAvatarCanContintuelyMoveInDirection = @"N";
        
        //setup avatar type and its basic
        //just default for testing
        //self.mazeAvatar = [[MazeAvatar alloc] initWithAvatarType:mazeAvatarBlackBox];
        // testing giraffe
        //self.mazeAvatar = [[MazeAvatar alloc] initWithAvatarType:mazeAvatarGiraffe];
        // testing snail
        //self.mazeAvatar = [[MazeAvatar alloc] initWithAvatarType:mazeAvatarSnail];
        
        
        /*
         *  must place this block inside didMoveToView, because it can't set mist
         *  or other properties before they are initialized. Init the mazeAvatar's
         *  property according to their types, and push the initial cell to array
         *  accordingly
         */
        if (self.mazeAvatar.avatarType == mazeAvatarBlackBox) {
            [self.mazeAvatar mazeAvatarBlackBoxStepAt:self.mazeAvatar.avatarMazeCell];
            // draw mist after initial placement of avatar
            [self drawMistAsOneNodeWithItsSightWithAvatarMazeCell:self.mazeAvatar.avatarMazeCell];
        }
        else if(self.mazeAvatar.avatarType == mazeAvatarGiraffe){
            // draw mist after initial placement of avatar
            //visionRangeMask is 3x3 visible area like Giraffe. Use for testing purpose on Sunday, or
            // for giraffe's vision
            SKSpriteNode *visionRangeMask = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:CGSizeMake(squareLength*3, squareLength*3)];
            //[self.cropTileContainer addChild:visionRangeMask];
            [visionRangeMask addChild:self.cropTileContainer];
            [visionNode setMaskNode:visionRangeMask];
            [self drawMistAsOneNodeWithItsSightWithAvatarMazeCell:self.mazeAvatar.avatarMazeCell];
        }
        else if (self.mazeAvatar.avatarType == mazeAvatarSnail){
            [self.mazeAvatar mazeAvatarSnailAddAMazeCell:self.mazeAvatar.avatarMazeCell];
            [self drawMistAsOneNodeWithItsSightWithAvatarMazeCell:self.mazeAvatar.avatarMazeCell];
        }
        else if (self.mazeAvatar.avatarType == mazeAvatarSunday){
            self.mazeAvatar.color = [UIColor redColor];
            self.cropTileContainer.color = [UIColor blackColor];
        }
        
    }
    //self.view.layer.mask
    //SkCropNode movement
    float deltaX = self.mazeAvatar.position.x - self.visionNode.position.x;
    float deltaY = self.mazeAvatar.position.y - self.visionNode.position.y;
    self.visionNode.position = self.mazeAvatar.position;
    self.mazeMap.position = CGPointMake(self.mazeMap.position.x - deltaX, self.mazeMap.position.y - deltaY);
    self.cropTileContainer.position = self.mazeMap.position; //these two position should be synchronize, to acheive the tile shadow/masking/mist effect
    ++cnt;
    //[self centerOnNode:self.mazeAvatar];
}

/**
 *  delegate method, to play with maze
 *
 *  @param keyName from the other SKView that has gamepad
 */
-(void)gamepadControlMoveTo:(NSString *)keyName{
    if (ZenDebug>=3) {
        NSLog(@"avatarCell x:%i,y:%i",self.mazeAvatar.avatarMazeCell.x,self.mazeAvatar.avatarMazeCell.y);
    }
    
    // detect skill, and filter out those have only passive skill
    if ([keyName isEqualToString:@"S"] && self.mazeAvatar.avatarType != mazeAvatarGiraffe) {
        [self mazeAvatarInvokeSkill];
    }
    else if(!self.mazeAvatar.isAnimating){
        //record the direction passed in
        self.directionWasPressed = keyName;
        
        //MazeAvatar, do something to the mazeAvatar here, when it needs action before moving
        
        if (self.mazeAvatar.avatarType != mazeAvatarBlackBox) {
            // move avatar(node and cell) according to key stroke
            if (!self.mazeSceneAvatarIsMoving) {
                [self moveAvatarAccordingToMazeCellRepeatAnimation:self.mazeAvatar mazeCell:self.mazeAvatar.avatarMazeCell inDirection:keyName];
            }
        }
        else{
            [self moveAvatarAccordingToMazeCellSkipTubeShapeTile:self.mazeAvatar mazeCell:self.mazeAvatar.avatarMazeCell inDirection:keyName];
        }
    }
}

/**
 *  if the wall in that driection is open, move avatar accoring to its type, except
 *  blackbox type
 *
 *  @param avatar   avatar
 *  @param mazeCell the mazeCell that avatar is at
 *  @param keyName  U L D R
 */
-(void)moveAvatarAccordingToMazeCell:(SKSpriteNode *)avatar mazeCell:(MazeCell *)mazeCell inDirection:(NSString *)keyName{
    NSLog(@"Depleted");
    if (ZenDebug>=3) {
        [mazeCell printCellOpenWallBitMask];
    }
    MazeCell *fromCell = mazeCell;
    
    if ([keyName isEqualToString:@"U"]) {
        if ((mazeCell.wallOpenBitMask & TopWallOpen)) {
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x y:mazeCell.y+1];
            self.mazeAvatar.avatarMazeCell = mazeCell;
            if (mazeCell.wallShapeBitMask == wallVerticalTubeShapeType) {
                self.mazeSceneAvatarCanContintuelyMoveInDirection = keyName;
            }
            else{
                self.mazeSceneAvatarCanContintuelyMoveInDirection = @"N";
            }
        }
    }
    else if ([keyName isEqualToString:@"L"]) {
        if ((mazeCell.wallOpenBitMask & LeftWallOpen) ) {
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x-1 y:mazeCell.y];
            self.mazeAvatar.avatarMazeCell = mazeCell;
            if (mazeCell.wallShapeBitMask == wallHorizontalTubeShapeType) {
                self.mazeSceneAvatarCanContintuelyMoveInDirection = keyName;
            }
            else{
                self.mazeSceneAvatarCanContintuelyMoveInDirection = @"N";
            }
        }
    }
    else if ([keyName isEqualToString:@"D"]) {
        if ((mazeCell.wallOpenBitMask & BottomWallOpen) ) {
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x y:mazeCell.y-1];
            self.mazeAvatar.avatarMazeCell = mazeCell;
            if (mazeCell.wallShapeBitMask == wallVerticalTubeShapeType) {
                self.mazeSceneAvatarCanContintuelyMoveInDirection = keyName;
            }
            else{
                self.mazeSceneAvatarCanContintuelyMoveInDirection = @"N";
            }

        }
    }
    else if ([keyName isEqualToString:@"R"]) {
        if ((mazeCell.wallOpenBitMask & RightWallOpen) ) {
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x+1 y:mazeCell.y];
            self.mazeAvatar.avatarMazeCell = mazeCell;
            if (mazeCell.wallShapeBitMask == wallHorizontalTubeShapeType) {
                self.mazeSceneAvatarCanContintuelyMoveInDirection = keyName;
            }
            else{
                self.mazeSceneAvatarCanContintuelyMoveInDirection = @"N";
            }
        }
    }
    
    if (fromCell != self.mazeAvatar.avatarMazeCell) {
        [self mazeAvatarIsMoving];
        [self.mazeAvatar animateAvatarNodePositionWithAvatarCell:squareLength times:1];
    }
}

/**
 *  if the wall in that driection is open, and the destination cell is tubeType,
 *  keep going. This is only for blackbox type
 *  Unlike moveAvatarAccordingToMazeCell, this method runs a repeated animation
 *  Unlike moveAvatarAccordingToMazeCellSkipTubeShapeTile, this method animates the node
 *
 *  @param avatar   avatar
 *  @param mazeCell the mazeCell that avatar is at
 *  @param keyName  U L D R
 */
-(void)moveAvatarAccordingToMazeCellRepeatAnimation:(SKSpriteNode *)avatar mazeCell:(MazeCell *)mazeCell inDirection:(NSString *)keyName{
    if (ZenDebug>=3) {
        [mazeCell printCellOpenWallBitMask];
    }
    MazeCell *fromCell = mazeCell;
    int times = 0;
    
    if ([keyName isEqualToString:@"U"]) {
        while ((mazeCell.wallOpenBitMask & TopWallOpen)) {
            //avatar.position = CGPointMake(avatar.position.x, avatar.position.y + squareLength);
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x y:mazeCell.y+1];
            self.mazeAvatar.avatarMazeCell = mazeCell;
            ++times;
            [self mazeAvatarIsMoving];
            if (mazeCell.wallShapeBitMask != wallVerticalTubeShapeType) {
                break;
            }
        }
    }
    else if ([keyName isEqualToString:@"L"]) {
        while ((mazeCell.wallOpenBitMask & LeftWallOpen) ) {
            //avatar.position = CGPointMake(avatar.position.x - squareLength, avatar.position.y);
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x-1 y:mazeCell.y];
            self.mazeAvatar.avatarMazeCell = mazeCell;
            ++times;
            [self mazeAvatarIsMoving];
            if (mazeCell.wallShapeBitMask != wallHorizontalTubeShapeType) {
                break;
            }
        }
    }
    else if ([keyName isEqualToString:@"D"]) {
        while ((mazeCell.wallOpenBitMask & BottomWallOpen) ) {
            //avatar.position = CGPointMake(avatar.position.x, avatar.position.y - squareLength);
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x y:mazeCell.y-1];
            self.mazeAvatar.avatarMazeCell = mazeCell;
            ++times;
            [self mazeAvatarIsMoving];
            if (mazeCell.wallShapeBitMask != wallVerticalTubeShapeType) {
                break;
            }
        }
    }
    else if ([keyName isEqualToString:@"R"]) {
        while ((mazeCell.wallOpenBitMask & RightWallOpen) ) {
            //avatar.position = CGPointMake(avatar.position.x + squareLength, avatar.position.y);
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x+1 y:mazeCell.y];
            self.mazeAvatar.avatarMazeCell = mazeCell;
            ++times;
            [self mazeAvatarIsMoving];
            if (mazeCell.wallShapeBitMask != wallHorizontalTubeShapeType) {
                break;
            }
        }
    }
    
    if (fromCell != self.mazeAvatar.avatarMazeCell) {
        [self.mazeAvatar animateAvatarNodePositionWithAvatarCell:squareLength times:times];
    }
}


/**
 *  if the wall in that driection is open, and the destination cell is tubeType, 
 *  keep going. This is only for blackbox type
 *
 *  @param avatar   avatar
 *  @param mazeCell the mazeCell that avatar is at
 *  @param keyName  U L D R
 */
-(void)moveAvatarAccordingToMazeCellSkipTubeShapeTile:(SKSpriteNode *)avatar mazeCell:(MazeCell *)mazeCell inDirection:(NSString *)keyName{
    if (ZenDebug>=3) {
        [mazeCell printCellOpenWallBitMask];
    }
    MazeCell *fromCell = mazeCell;
    
    if ([keyName isEqualToString:@"U"]) {
        while ((mazeCell.wallOpenBitMask & TopWallOpen)) {
            NSLog(@"walling in %@",keyName);
            //avatar.position = CGPointMake(avatar.position.x, avatar.position.y + squareLength);
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x y:mazeCell.y+1];
            self.mazeAvatar.avatarMazeCell = mazeCell;
            [self mazeAvatarIsMoving];
            [self.mazeAvatar calculateAvatarNodePositionWithAvatarCell:squareLength];
            NSLog(@"move avatarCell end at x:%i,y:%i",self.mazeAvatar.avatarMazeCell.x,self.mazeAvatar.avatarMazeCell.y);
            if (mazeCell.wallShapeBitMask != wallVerticalTubeShapeType) {
                break;
            }
        }
    }
    else if ([keyName isEqualToString:@"L"]) {
        while ((mazeCell.wallOpenBitMask & LeftWallOpen) ) {
            NSLog(@"walling in %@",keyName);
            //avatar.position = CGPointMake(avatar.position.x - squareLength, avatar.position.y);
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x-1 y:mazeCell.y];
            self.mazeAvatar.avatarMazeCell = mazeCell;
            [self mazeAvatarIsMoving];
            [self.mazeAvatar calculateAvatarNodePositionWithAvatarCell:squareLength];
            if (mazeCell.wallShapeBitMask != wallHorizontalTubeShapeType) {
                break;
            }
        }
    }
    else if ([keyName isEqualToString:@"D"]) {
        while ((mazeCell.wallOpenBitMask & BottomWallOpen) ) {
            NSLog(@"walling in %@",keyName);
            //avatar.position = CGPointMake(avatar.position.x, avatar.position.y - squareLength);
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x y:mazeCell.y-1];
            self.mazeAvatar.avatarMazeCell = mazeCell;
            [self mazeAvatarIsMoving];
            [self.mazeAvatar calculateAvatarNodePositionWithAvatarCell:squareLength];
            if (mazeCell.wallShapeBitMask != wallVerticalTubeShapeType) {
                break;
            }
        }
    }
    else if ([keyName isEqualToString:@"R"]) {
        while ((mazeCell.wallOpenBitMask & RightWallOpen) ) {
            NSLog(@"walling in %@",keyName);
            //avatar.position = CGPointMake(avatar.position.x + squareLength, avatar.position.y);
            mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x+1 y:mazeCell.y];
            self.mazeAvatar.avatarMazeCell = mazeCell;
            [self mazeAvatarIsMoving];
            [self.mazeAvatar calculateAvatarNodePositionWithAvatarCell:squareLength];
            if (mazeCell.wallShapeBitMask != wallHorizontalTubeShapeType) {
                break;
            }
        }
    }
    
    if (fromCell != self.mazeAvatar.avatarMazeCell) {
        [self mazeAvatarDidMove];
    }
}

/**
 *  Do this everythime after avatar done moving, to re-caculate sight and 
 *  re-draw mist. After node of mist is added to view, all cell.hasMist
 *  should return to YES;(restore the state after finishing adding mist)
 *
 *  @param avatarMazeCell location of avatar
 */
-(void)drawMistAsOneNodeWithItsSightWithAvatarMazeCell:(MazeCell *)avatarMazeCell{
    if (self.mazeAvatar.avatarType == mazeAvatarBlackBox){
        [self straightSightOfAvatar:avatarMazeCell];
    }
    else if(self.mazeAvatar.avatarType == mazeAvatarGiraffe){
        //[self specialSightOfGiraffe:avatarMazeCell]; //use 3x3 mask instead
        [self straightSightOfAvatar:avatarMazeCell];
    }
    else if(self.mazeAvatar.avatarType == mazeAvatarSnail){
        [self straightSightOfAvatar:avatarMazeCell];
        [self.mazeAvatar mazeAvatarSnailMarkAllTrailMazeCellToVisiable];
        [self.visionCells unionSet:self.mazeAvatar.snailTrailSet];
        
    }
    else if(self.mazeAvatar.avatarType == mazeAvatarSunday){
        //do nothing, dont draw maze
        return;
    }
    
    if (self.mist != nil) {
        [self.mist removeFromParent];
        self.mist = nil;
    }
    //[self drawMistWithUIBezierPath]; //take it out,avoid SKShapeNode
    //self.mist.zPosition = 2;
    [self drawMistWithSKSpriteNodeAsMask];//replace drawMistWithUIBezierPath
    [self restoreMist:self.visionCells];
}

/**
 *  replacement of
 *  -(void)drawMistWithUIBezierPath;
 *  to avoid using SKShapeNode
 *
 *  for each cell.hasMist == YES. Create a SKSpriteNode square with squareLenght as width
 *  then add to cropTileContainer as child to be used in SKCropNode
 *  Need method to detect each node if the corespondent MazeCell is still hasMist == YES
 *  Need an array to store, fetch, release the nodes
 */
-(void)drawMistWithSKSpriteNodeAsMask{
    //NSLog(@"set amount: %lu, %lu",self.visionCells.count,self.maskChildren.count);
    //1st, detect if a node is already crerated, by checking visionCells
    //2nd, add and remove nodes
    // set to add = visionCells - maskChildren
    // set to remove = maskChildren - visionCells
    // at last, after all the works, self.maskChildren = self.visionCells
    NSMutableSet *setToAdd = [NSMutableSet setWithSet:self.visionCells];
    [setToAdd minusSet:self.maskChildren];
    for (MazeCell *cell in setToAdd) {
        [self addSKSpriteNodeToCropTileContainerAsMaskFrom:cell];
    }
    
    NSMutableSet *setToRemove = [NSMutableSet setWithSet:self.maskChildren];
    [setToRemove minusSet:self.visionCells];
    for (MazeCell *cell in setToRemove) {
        [self removeSKSpriteNodeToCropTileContainerAsMaskFrom:cell];
    }
    
    [self.maskChildren setSet:self.visionCells];
}

/**
 *  this two methods are to add/remove masking to/from cropTileContainer
 *
 *  @param cell this cell is related to the SKSpriteNode
 */
-(void)addSKSpriteNodeToCropTileContainerAsMaskFrom:(MazeCell *)cell{
    NSString *nodeName = [self convertToSKNodeNameFromMazeCellXYLocation:cell];
    if (![self.cropTileContainer childNodeWithName:nodeName]) {
        //create a node and add to container
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(squareLength, squareLength)];
        node.anchorPoint = CGPointMake(0, 0);
        node.position = CGPointMake(cell.x*squareLength, cell.y*squareLength);
        node.name = nodeName;
        [self.cropTileContainer addChild:node];
    }
}
-(void)removeSKSpriteNodeToCropTileContainerAsMaskFrom:(MazeCell *)cell{
    NSString *nodeName = [self convertToSKNodeNameFromMazeCellXYLocation:cell];
    SKSpriteNode *node = (SKSpriteNode *)[self.cropTileContainer childNodeWithName:nodeName];
    if (node) {
        [node removeFromParent];
    }
}

/**
 *  These two methods create a relation between SKNode and MazeCell
 *
 */
-(NSString *)convertToSKNodeNameFromMazeCellXYLocation:(MazeCell *)cell{
    NSString *nodeName = [NSString stringWithFormat:@"%i,%i",cell.x,cell.y];
    return nodeName;
}
-(MazeCell *)convertToMazeCellFromSKNodeNameString:(NSString *)name{
    //no use yet
    return nil;
}

/**
 *  Loop throught all cells, if its hasMist == YES, then draw a square stroke on top of it
 *  Use one path to draw all mists
 */
-(void)drawMistWithUIBezierPath{
    SKShapeNode *square = [SKShapeNode node];
    UIBezierPath* wallPath = [[UIBezierPath alloc] init];
    //from origin point, draw bottom line
    
    MazeCell *temp;
    for (int h = 0; h < self.theMaze.mazeGraph.height; h++) {
        for (int w = 0; w < self.theMaze.mazeGraph.width; w++) {
            // move the drawing head to the center point locate on this cell (w,h)
            [wallPath moveToPoint:
                CGPointMake( w * squareLength, squareLength/2 + h * squareLength)
             ];
            temp = [self.theMaze.mazeGraph getCellAtX:w y:h];
            if (temp.hasMist == YES) {
                //draw a dot here, a fatty path like a square that covers a maze cell
                [wallPath addLineToPoint:
                    CGPointMake(squareLength + w * squareLength, squareLength/2 + h * squareLength)
                 ];
            }
        }
    }
    square.path = [wallPath CGPath];
    square.lineWidth = squareLength*1.1;
    square.strokeColor = [SKColor blackColor];
    self.mist = square;
    [self addChild:self.mist];

}

-(void)restoreMist:(NSMutableSet *)visionCells{
    for (MazeCell *cell in visionCells) {
        cell.hasMist = YES;
    }
    [visionCells removeAllObjects];
}

/**
 *  calculate the sight of avatar at its location, mark all the visable aera with cell.hasMist = YES
 *
 *  @param avatarMazeCell location of avatar, avatarMazeCell
 */
-(void)straightSightOfAvatar:(MazeCell *)avatarMazeCell{
    avatarMazeCell.hasMist = NO;
    [self.visionCells addObject:avatarMazeCell];
    
    // every direction need to re-assign the pointer to origin(avatarMazeCell)
    MazeCell *mazeCell = avatarMazeCell;
    while ((mazeCell.wallOpenBitMask & TopWallOpen)) {
        mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x y:mazeCell.y+1];
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
        if (!(mazeCell.wallOpenBitMask & TopWallOpen)) {
            break;
        }
    }
    
    mazeCell = avatarMazeCell;
    while ((mazeCell.wallOpenBitMask & LeftWallOpen) ) {
        mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x-1 y:mazeCell.y];
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
        if (!(mazeCell.wallOpenBitMask & LeftWallOpen)) {
            break;
        }
    }
    
    mazeCell = avatarMazeCell;
    while ((mazeCell.wallOpenBitMask & BottomWallOpen) ) {
        mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x y:mazeCell.y-1];
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
        if (!(mazeCell.wallOpenBitMask & BottomWallOpen)) {
            break;
        }
    }
    mazeCell = avatarMazeCell;
    while ((mazeCell.wallOpenBitMask & RightWallOpen) ) {
        mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x+1 y:mazeCell.y];
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
        if (!(mazeCell.wallOpenBitMask & RightWallOpen)) {
            break;
        }
    }
    
}

/**
 *  need to use a 3x3 SKCropNode mask to replace this
 */
-(void)specialSightOfGiraffe:(MazeCell *)avatarMazeCell{
    avatarMazeCell.hasMist = NO;
    [self.visionCells removeAllObjects];
    [self.visionCells addObject:avatarMazeCell];
    
    // every direction need to re-assign the pointer to origin(avatarMazeCell)
    MazeCell *mazeCell = avatarMazeCell;
    while ((mazeCell.wallOpenBitMask & TopWallOpen)) {
        mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x y:mazeCell.y+1];
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
        if (!(mazeCell.wallOpenBitMask & TopWallOpen)) {
            break;
        }
    }
    
    mazeCell = avatarMazeCell;
    while ((mazeCell.wallOpenBitMask & LeftWallOpen) ) {
        mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x-1 y:mazeCell.y];
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
        if (!(mazeCell.wallOpenBitMask & LeftWallOpen)) {
            break;
        }
    }
    
    mazeCell = avatarMazeCell;
    while ((mazeCell.wallOpenBitMask & BottomWallOpen) ) {
        mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x y:mazeCell.y-1];
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
        if (!(mazeCell.wallOpenBitMask & BottomWallOpen)) {
            break;
        }
    }
    mazeCell = avatarMazeCell;
    while ((mazeCell.wallOpenBitMask & RightWallOpen) ) {
        mazeCell =  [self.theMaze.mazeGraph getCellAtX:mazeCell.x+1 y:mazeCell.y];
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
        if (!(mazeCell.wallOpenBitMask & RightWallOpen)) {
            break;
        }
    }
    
    //finally, different from the default straight sight, calculate surround vision, 8 total for now
    // up
    mazeCell =  [self.theMaze.mazeGraph getCellAtX:avatarMazeCell.x y:avatarMazeCell.y+1];
    if (mazeCell) {
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
    }
    
    // up-left
    mazeCell =  [self.theMaze.mazeGraph getCellAtX:avatarMazeCell.x-1 y:avatarMazeCell.y+1];
    if (mazeCell) {
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
    }
    
    // left
    mazeCell =  [self.theMaze.mazeGraph getCellAtX:avatarMazeCell.x-1 y:avatarMazeCell.y];
    if (mazeCell) {
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
    }
    
    // left-down
    mazeCell =  [self.theMaze.mazeGraph getCellAtX:avatarMazeCell.x-1 y:avatarMazeCell.y-1];
    if (mazeCell) {
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
    }
    
    // down
    mazeCell =  [self.theMaze.mazeGraph getCellAtX:avatarMazeCell.x y:avatarMazeCell.y-1];
    if (mazeCell) {
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
    }
    
    // down-right
    mazeCell =  [self.theMaze.mazeGraph getCellAtX:avatarMazeCell.x+1 y:avatarMazeCell.y-1];
    if (mazeCell) {
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
    }
    
    // right
    mazeCell =  [self.theMaze.mazeGraph getCellAtX:avatarMazeCell.x+1 y:avatarMazeCell.y];
    if (mazeCell) {
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
    }
    
    // right-up
    mazeCell =  [self.theMaze.mazeGraph getCellAtX:avatarMazeCell.x+1 y:avatarMazeCell.y+1];
    if (mazeCell) {
        mazeCell.hasMist = NO;
        [self.visionCells addObject:mazeCell];
    }
}

-(void)mazeAvatarBeforeMove{
    if (self.mazeAvatar.avatarType == mazeAvatarBlackBox) {
    }
}
-(void)mazeAvatarIsMoving{
    if (self.mazeAvatar.avatarType == mazeAvatarBlackBox) {
        // self.mazeAvatar mazeAvatarBlackBoxStepAt:
    }
    else if(self.mazeAvatar.avatarType == mazeAvatarSnail){
        [self.mazeAvatar mazeAvatarSnailAddAMazeCell:self.mazeAvatar.avatarMazeCell];
    }
    
    self.mazeSceneAvatarIsMoving = YES;
}
-(void)mazeAvatarDidMove{
    if (ZenDebug >= 3) {
        NSLog(@"MazeScene:mazeAvatarDidMove: (%i, %i)", self.mazeAvatar.avatarMazeCell.x, self.mazeAvatar.avatarMazeCell.y);
    }
    
    if (self.mazeAvatar.avatarMazeCell.x == self.theMaze.mazeGraph.width - 1 && self.mazeAvatar.avatarMazeCell.y == self.theMaze.mazeGraph.height-1) {
        // game ends
        [self mazeGameEnd];
        
    }
    
    if (self.mazeAvatar.avatarType == mazeAvatarBlackBox) {
        [self.mazeAvatar mazeAvatarBlackBoxStepAt:self.mazeAvatar.avatarMazeCell];
    }
    
    [self drawMistAsOneNodeWithItsSightWithAvatarMazeCell:self.mazeAvatar.avatarMazeCell];
}
-(void)mazeAvatarInvokeSkill{
    if (self.mazeAvatar.avatarType == mazeAvatarBlackBox) {
        self.mazeAvatar.avatarMazeCell = [self.mazeAvatar mazeAvatarBlackBoxUndoACell];
        [self.mazeAvatar calculateAvatarNodePositionWithAvatarCell:squareLength];
        [self drawMistAsOneNodeWithItsSightWithAvatarMazeCell:self.mazeAvatar.avatarMazeCell];
    }
}

/**
 *  call delegate when game reaches ending condition
 */
-(void)mazeGameEnd{
    id<MazeSceneGameConditionDelegate> delegate = self.gameConditionDelegate;
    NSLog(@"mazeGameEnd delegate");
    if ([delegate respondsToSelector:@selector(mazeSceneGameEnds:)]) {
        NSLog(@"responds to selector");
        [delegate mazeSceneGameEnds:@"Game Over"];
    }
}

/**
 *  MazeAvatarAnimationDelegate, not responsible to blackbox because it
 *  has no animation
 */
-(void)mazeAvatarAnimationDidFinishOneTileMovment{
    NSLog(@"DEPLETE");
    [self mazeAvatarDidMove];
    self.mazeSceneAvatarIsMoving = NO;
    if (![self.mazeSceneAvatarCanContintuelyMoveInDirection isEqualToString:@"N"]) {
        [self moveAvatarAccordingToMazeCell:self.mazeAvatar mazeCell:self.mazeAvatar.avatarMazeCell inDirection:self.mazeSceneAvatarCanContintuelyMoveInDirection];
    }
}
-(void)mazeAvatarAnimationDidFinishRepeatMovement{
    [self mazeAvatarDidMove];
    self.mazeSceneAvatarIsMoving = NO;
}

@end