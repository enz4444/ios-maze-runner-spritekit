//
//  GamepadScene.m
//  SpeedMaze
//
//  Created by Enlan Zhou on 12/12/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import "GamepadScene.h"

@interface GamepadScene()

@property (strong,nonatomic) SKSpriteNode *up;
@property (strong,nonatomic) SKSpriteNode *left;
@property (strong,nonatomic) SKSpriteNode *down;
@property (strong,nonatomic) SKSpriteNode *right;
@property (strong,nonatomic) SKSpriteNode *skill;

@end

@implementation GamepadScene
static CGFloat gamepadButtonWidth;
static CGPoint gamepadCenter;

-(void)didMoveToView:(SKView *)view {
    NSLog(@"GamepadScene:didMoveToView:%f, %f, %f, %f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);

    gamepadButtonWidth = self.frame.size.height / 2;
    gamepadCenter = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self setupGamepadButton];

}

-(void)setupGamepadButton{
    //↑ ← ↓ → ↺
    //    SKLabelNode *up = [SKLabelNode labelNodeWithText:@"↑"];
    //    SKLabelNode *left = [SKLabelNode labelNodeWithText:@"←"];
    //    SKLabelNode *down = [SKLabelNode labelNodeWithText:@"↓"];
    //    SKLabelNode *right = [SKLabelNode labelNodeWithText:@"→"];
    //    SKLabelNode *back = [SKLabelNode labelNodeWithText:@"↺"];
    
    
    SKSpriteNode *up = [[SKSpriteNode alloc] initWithColor:[UIColor whiteColor] size:CGSizeMake(gamepadButtonWidth, gamepadButtonWidth)];
    up.position = CGPointMake(gamepadCenter.x, gamepadCenter.y + gamepadButtonWidth/2);
    up.name = @"U";
    [self addChild:up];
    
    SKSpriteNode *left = [[SKSpriteNode alloc] initWithColor:[UIColor grayColor] size:CGSizeMake(gamepadButtonWidth, gamepadButtonWidth)];
    left.position = CGPointMake(gamepadCenter.x - gamepadButtonWidth, gamepadCenter.y );
    left.name = @"L";
    [self addChild:left];
    
    SKSpriteNode *down = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(gamepadButtonWidth, gamepadButtonWidth)];
    down.position = CGPointMake(gamepadCenter.x, gamepadCenter.y - gamepadButtonWidth/2);
    down.name = @"D";
    [self addChild:down];
    
    SKSpriteNode *right = [[SKSpriteNode alloc] initWithColor:[UIColor blueColor] size:CGSizeMake(gamepadButtonWidth, gamepadButtonWidth)];
    right.name = @"R";
    right.position = CGPointMake(gamepadCenter.x + gamepadButtonWidth, gamepadCenter.y);
    [self addChild:right];
    
    //special, skill key
    SKSpriteNode *skill = [[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(gamepadButtonWidth, gamepadButtonWidth)];
    skill.name = @"S";
    skill.position = CGPointMake( gamepadButtonWidth/2, gamepadCenter.y);
    [self addChild:skill];
    
    self.up = up;
    self.right = right;
    self.down = down;
    self.left = left;
    self.skill = skill;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:positionInScene];
    id<GamepadSceneDelegate>delegate = self.gamepadDelegate;
    if ([delegate respondsToSelector:@selector(gamepadKeyTouched:)]) {
        [delegate gamepadKeyTouched:touchedNode.name];
    }
    /*
    if ([touchedNode.name isEqualToString:@"U"]) {
        NSLog(@"pressed up");
    }
    if ([touchedNode.name isEqualToString:@"L"]) {
        NSLog(@"pressed left");
    }
    if ([touchedNode.name isEqualToString:@"D"]) {
        NSLog(@"pressed down");
    }
    if ([touchedNode.name isEqualToString:@"R"]) {
        NSLog(@"pressed right");
    }
     */
    /*
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
     
        NSLog(@"touch in gamepad scene");
    }*/
    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        SKShapeNode *square = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(location.x,  location.y)];
//        UIBezierPath* topLeftBezierPath = [[UIBezierPath alloc] init];
//        [topLeftBezierPath moveToPoint:CGPointMake(0.0, 0.0)];
//        [topLeftBezierPath addLineToPoint:CGPointMake(0.0, 10.0)];
//        [topLeftBezierPath addLineToPoint:CGPointMake(10.0, 10.0)];
//        square.path = topLeftBezierPath.CGPath;
//        square.position = location;
//        square.fillColor = [SKColor redColor];
//        square.lineWidth = 2;
//        square.strokeColor = [UIColor greenColor];
//        square.alpha = 1.0;
//        NSLog(@"add one");
//        [self addChild:square];
    
        
//        SKShapeNode *square2 = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(50,50)];
//        //square2.
//        square2.position = location;
//        //square2.frame = CGRectMake(100, 100, 200, 200);
//        square2.lineWidth = 5;
//        square2.fillColor = [UIColor blackColor];
//        square2.strokeColor = [UIColor redColor];
//        [self addChild:square2];
//        NSLog(@"%f, %f, %f, %f",square2.frame.origin.x,square2.frame.origin.y,square2.frame.size.width,square2.frame.size.height);
//    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
