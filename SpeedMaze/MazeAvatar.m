//
//  MazeAvatar.m
//  SpeedMaze
//
//  Created by littlebeef on 12/19/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import "MazeAvatar.h"

@interface MazeAvatar()

@property (assign,readwrite,nonatomic) float mazeAvatarSpeed;

@property (assign,readwrite,nonatomic) BOOL isAnimating;

@property (strong,nonatomic) NSMutableArray *undoStepArray;
@property (strong,nonatomic) NSMutableArray *undoDirectionArray;
@property (strong,nonatomic) NSMutableSet *snailTrailSet;


@end

@implementation MazeAvatar

-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size{
    self = [super initWithColor:color size:size];
    if (self == nil) {
        return nil;
    }
    self.avatarType = mazeAvatarUndefined;
    self.undoStepArray = nil;
    self.mazeAvatarSpeed = 1.0;
    self.isAnimating = NO;
    return  self;
}

-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size avatarType:(mazeAvatarType)avatarType{
    self = [self initWithColor:color size:size];
    self.avatarType = avatarType;
    if (self.avatarType == mazeAvatarBlackBox) {
        NSLog(@"avatar is blackbox");
        //init an array of maze cells for undo button
        self.undoStepArray = [NSMutableArray array];
        self.undoDirectionArray = [NSMutableArray array];
        self.color = [SKColor blackColor];
    }
    else if(self.avatarType == mazeAvatarGiraffe) {
        NSLog(@"avatar is giraffe");
        //do nothing, giraffe has only passive skill
        self.color = [SKColor brownColor];
        self.mazeAvatarSpeed = 10.0;
    }
    else if(self.avatarType == mazeAvatarSnail){
        NSLog(@"avatar is snail");
        self.snailTrailSet = [NSMutableSet set];
        self.color = [SKColor whiteColor];
        self.mazeAvatarSpeed = 5.0;
    }
    else if (self.avatarType == mazeAvatarSunday){
        self.color = [SKColor yellowColor];
        self.mazeAvatarSpeed = 8.0;
    }
    return self;
}


-(void)mazeAvatarBlackBoxStepAt:(MazeCell *)atCell{
    NSAssert(self.avatarType == mazeAvatarBlackBox, ([NSString stringWithFormat:@"The black box action should not perform on this avatar type: %i", self.avatarType]));
    
    [self.undoStepArray addObject:atCell];
}

-(MazeCell *)mazeAvatarBlackBoxUndoACell{
    NSAssert(self.avatarType == mazeAvatarBlackBox, ([NSString stringWithFormat:@"The black box action should not perform on this avatar type: %i", self.avatarType]));
    MazeCell *returnCell = [self.undoStepArray lastObject];
    if (self.undoStepArray.count == 1) {
        return returnCell;
    }
    [self.undoStepArray removeLastObject];
    return returnCell;
}

-(void)mazeAvatarBlackBoxStepTo:(NSString *)atDirection{
    NSAssert(self.avatarType == mazeAvatarBlackBox, ([NSString stringWithFormat:@"The black box action should not perform on this avatar type: %i", self.avatarType]));
    
    [self.undoDirectionArray addObject:atDirection];
}

-(NSString *)mazeAvatarBlackBoxUndoADirection{
    NSAssert(self.avatarType == mazeAvatarBlackBox, ([NSString stringWithFormat:@"The black box action should not perform on this avatar type: %i", self.avatarType]));
    if (self.undoStepArray.count == 0) {
        return nil;
    }
    NSString *returnDirection = [self.undoStepArray lastObject];
    if ([returnDirection isEqualToString:@"U"]) {
        returnDirection = @"D";
    }
    else if ([returnDirection isEqualToString:@"L"]) {
        returnDirection = @"R";
    }
    else if ([returnDirection isEqualToString:@"D"]) {
        returnDirection = @"U";
    }
    else if ([returnDirection isEqualToString:@"R"]) {
        returnDirection = @"L";
    }
    else{
        NSLog(@"direction should be only direction but receive: %@",returnDirection);
    }
    [self.undoStepArray removeLastObject];
    return returnDirection;
}

-(void)mazeAvatarSnailAddAMazeCell:(MazeCell *)aCell{
    NSAssert(self.avatarType == mazeAvatarSnail, ([NSString stringWithFormat:@"The bnail action should not perform on this avatar type: %i", self.avatarType]));
    if (![self.snailTrailSet containsObject:aCell]) {
        [self.snailTrailSet addObject:aCell];
    }
    else{
        //already contain a trail, later can reset time counter to vaporize this cell
    }
    //NSLog(@"snail trail amount:%lu",self.snailTrailSet.count);
}

-(void)mazeAvatarSnailMarkAllTrailMazeCellToVisiable{
    NSAssert(self.avatarType == mazeAvatarSnail, ([NSString stringWithFormat:@"The snail action should not perform on this avatar type: %i", self.avatarType]));
    for (MazeCell *cell in self.snailTrailSet) {
        cell.hasMist = NO;
    }
    //NSLog(@"snail trail amount:%lu",self.snailTrailSet.count);
}

/**
 *  convert avatarMazeCell's coordination to SKSpriteNode's position
 *
 *  @param squareLength the width of a tile
 */
-(void)calculateAvatarNodePositionWithAvatarCell:(float)squareLength{
    self.position = CGPointMake(squareLength/2 + self.avatarMazeCell.x * squareLength, squareLength/2 + self.avatarMazeCell.y * squareLength);
    /*
    if (self.avatarType == mazeAvatarBlackBox) {
        self.position = CGPointMake(squareLength/2 + self.avatarMazeCell.x * squareLength, squareLength/2 + self.avatarMazeCell.y * squareLength);// avatar's position is at lower left corner
    }
    else{
        self.position = CGPointMake(ZenSW / 2 + self.avatarMazeCell.x * squareLength, ZenSW / 2 + squareLength/2 + self.avatarMazeCell.y * squareLength); // try to place it at center, not work in BlackBox
    }
     */
}

/**
 *  animate the movement for avatar except for blackbox
 *  Blackbox will use calculateAvatarNodePositionWithAvatarCell instead
 *
 *  @param squareLength the width of a tile
 */
-(void)animateAvatarNodePositionWithAvatarCell:(float)squareLength times:(int)times{
    //use SKAction to animte the movement action
    //delta x or y is self.avatarMazeCell's position(new) minus self.postion(old)
    float deltaX = ((squareLength/2 + self.avatarMazeCell.x * squareLength) - self.position.x) / times;
    float deltaY = ((squareLength/2 + self.avatarMazeCell.y * squareLength) - self.position.y)/times;
    SKAction *beforeAnimation = [SKAction runBlock:^{
        self.isAnimating = YES;
    }];
    SKAction *afterAnimation = [SKAction runBlock:^{
        self.isAnimating = NO;
    }];
    SKAction *callDelegate = [SKAction runBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            id<MazeAvatarAnimationDelegate>delegate = self.animationDelegate;
            if ([delegate respondsToSelector:@selector(mazeAvatarAnimationDidFinishOneTileMovment)]) {
                if (false) {
                    [delegate mazeAvatarAnimationDidFinishOneTileMovment];
                }
                else{
                    [delegate mazeAvatarAnimationDidFinishRepeatMovement];
                }
            }
        });
    }];
    
    SKAction *moveTo = [SKAction moveByX:deltaX y:deltaY duration:1.0];
    moveTo.speed = self.mazeAvatarSpeed;
    
    SKAction *moveRepeat = [SKAction repeatAction:moveTo count:times];
    SKAction *moveGroup = [SKAction sequence:@[moveRepeat,callDelegate]];
    SKAction *actionSet = [SKAction sequence:@[beforeAnimation,moveGroup,afterAnimation]];

    [self runAction:actionSet];
}

// maze map moves but the avatar stay
-(void)animateAvatarNodePositionWithAvatarCell:(float)squareLength times:(int)times mazeMap:(SKSpriteNode *)mazeMap cropTileContainer:(SKSpriteNode *)cropTileContainer{
    //use SKAction to animte the movement action
    //delta x or y is self.avatarMazeCell's position(new) minus self.postion(old)
    float deltaX = (self.avatarMazeCell.x * squareLength + (mazeMap.position.x + squareLength/2)) / times;
    float deltaY = (self.avatarMazeCell.y * squareLength + (mazeMap.position.y + squareLength/2)) / times;
    //NSLog(@"mazeMap position: %f,%f", mazeMap.position.x,mazeMap.position.y);
    //NSLog(@"mazeMap delta: %f,%f", deltaX,deltaY);

    SKAction *beforeAnimation = [SKAction runBlock:^{
        self.isAnimating = YES;
    }];
    SKAction *afterAnimation = [SKAction runBlock:^{
        self.isAnimating = NO;
    }];
    SKAction *callDelegate = [SKAction runBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            id<MazeAvatarAnimationDelegate>delegate = self.animationDelegate;
            if ([delegate respondsToSelector:@selector(mazeAvatarAnimationDidFinishOneTileMovment)]) {
                if (false) {
                    [delegate mazeAvatarAnimationDidFinishOneTileMovment];
                }
                else{
                    [delegate mazeAvatarAnimationDidFinishRepeatMovement];
                }
            }
        });
    }];
    SKAction *moveTo2 = [SKAction moveByX:deltaX y:deltaY duration:1.0];
    moveTo2.speed = self.mazeAvatarSpeed;
    SKAction *moveTo = [moveTo2 reversedAction];
    
    SKAction *moveRepeat = [SKAction repeatAction:moveTo count:times];
    SKAction *moveGroup = [SKAction sequence:@[moveRepeat,callDelegate]];
    SKAction *actionSet = [SKAction sequence:@[beforeAnimation,moveGroup,afterAnimation]];
    
    [mazeMap runAction:actionSet]; //avatar move?
    //[self runAction:actionSet]; //map move?
}


@end