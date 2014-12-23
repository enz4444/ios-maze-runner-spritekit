//
//  GameScene.m
//  SpeedMaze
//
//  Created by littlebeef on 11/20/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    NSLog(@"%f, %f, %f, %f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    /* Setup your scene here */
    /*
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
     */
    /*
    SKShapeNode *wheel = [[SKShapeNode alloc]init];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0.0, 0.0)];
    [path addArcWithCenter:CGPointMake(0.0, 0.0) radius:50.0 startAngle:0.0 endAngle:(M_PI*2.0) clockwise:YES];
    wheel.path = path.CGPath;
    wheel.fillColor = [SKColor whiteColor];
    wheel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:wheel];

    
    SKShapeNode *square = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(100,  100)];
    UIBezierPath* topLeftBezierPath = [[UIBezierPath alloc] init];
    [topLeftBezierPath moveToPoint:CGPointMake(0.0, 0.0)];
    [topLeftBezierPath addLineToPoint:CGPointMake(0.0, 100.0)];
    [topLeftBezierPath addLineToPoint:CGPointMake(100.0, 100.0)];
    square.path = topLeftBezierPath.CGPath;
    square.lineWidth = 5;
    square.strokeColor = [UIColor greenColor];
    square.alpha = 1.0;
    NSLog(@"add one");
    [self addChild:square];
     */
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
    
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
