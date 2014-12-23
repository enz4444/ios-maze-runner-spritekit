//
//  MenuScene.m
//  SpeedMaze
//
//  Created by Enlan Zhou on 12/19/14.
//  Copyright (c) 2014 beefSama. All rights reserved.
//

#import "MenuScene.h"

@implementation MenuScene
-(instancetype)initMazeGameMenuWithSize:(CGSize)CGSize{
    self = [self initWithSize:CGSize];
    if (self == nil) {
        return nil;
    }
    self.backgroundColor = [SKColor colorWithRed:1.5 green:1.0 blue:0.5 alpha:0.0];
    
    SKLabelNode *blackBoxLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    blackBoxLabel.text = @"BlackBox";
    blackBoxLabel.fontSize = 25;
    blackBoxLabel.fontColor = [SKColor whiteColor];
    blackBoxLabel.position = CGPointMake(160, 240);
    blackBoxLabel.name = blackBoxLabel.text;
    [self addChild:blackBoxLabel];
    
    
    SKLabelNode *giraffeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    giraffeLabel.text = @"Giraffe";
    giraffeLabel.fontSize = 25;
    giraffeLabel.fontColor = [SKColor whiteColor];
    giraffeLabel.position = CGPointMake(160, 200);
    giraffeLabel.name = giraffeLabel.text;
    [self addChild:giraffeLabel];
    
    SKLabelNode *snailLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    snailLabel.text = @"Snail";
    snailLabel.fontSize = 25;
    snailLabel.fontColor = [SKColor whiteColor];
    snailLabel.position = CGPointMake(160, 160);
    snailLabel.name = snailLabel.text;
    [self addChild:snailLabel];
    
    SKLabelNode *sundayLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    sundayLabel.text = @"Sunday";
    sundayLabel.fontSize = 25;
    sundayLabel.fontColor = [SKColor whiteColor];
    sundayLabel.position = CGPointMake(160, 120);
    sundayLabel.name = sundayLabel.text;
    [self addChild:sundayLabel];
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];

    if ([node.name isEqualToString:@"BlackBox"]) {
        id<MazeGameMenuDelegate> delegate = self.gameMenudelegate;
        if ([delegate respondsToSelector:@selector(generateMazeWithWidth:andHeight:andAvatarType:)]) {
            [delegate generateMazeWithWidth:10 andHeight:10 andAvatarType:mazeAvatarBlackBox];
        }
    }
    else if ([node.name isEqualToString:@"Giraffe"]) {
        id<MazeGameMenuDelegate> delegate = self.gameMenudelegate;
        if ([delegate respondsToSelector:@selector(generateMazeWithWidth:andHeight:andAvatarType:)]) {
            [delegate generateMazeWithWidth:10 andHeight:10 andAvatarType:mazeAvatarGiraffe];
        }
    }else if ([node.name isEqualToString:@"Snail"]) {
        id<MazeGameMenuDelegate> delegate = self.gameMenudelegate;
        if ([delegate respondsToSelector:@selector(generateMazeWithWidth:andHeight:andAvatarType:)]) {
            [delegate generateMazeWithWidth:10 andHeight:10 andAvatarType:mazeAvatarSnail];
        }
    }else if ([node.name isEqualToString:@"Sunday"]) {
        id<MazeGameMenuDelegate> delegate = self.gameMenudelegate;
        if ([delegate respondsToSelector:@selector(generateMazeWithWidth:andHeight:andAvatarType:)]) {
            [delegate generateMazeWithWidth:10 andHeight:10 andAvatarType:mazeAvatarSunday];
        }
    }
    
}

-(void)didMoveToView:(SKView *)view {
    NSLog(@"menu scene: %f, %f, %f, %f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    SKSpriteNode *avatar = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(20, 20)];
    avatar.color = [SKColor whiteColor];
    [self addChild:avatar];

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, 50, 100);
    SKAction *followline = [SKAction followPath:path asOffset:YES orientToPath:NO duration:1.0];
    SKAction *reversedLine = [followline reversedAction];
    reversedLine.speed = 1;
    UIBezierPath *square = [UIBezierPath bezierPathWithRect:CGRectMake(100, 100, 300, 300)];
    SKAction *followSquare = [SKAction followPath:square.CGPath asOffset:YES orientToPath:NO duration:5.0];

    UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 200, 200) cornerRadius:200];
    SKAction *followCircle = [SKAction followPath:circle.CGPath asOffset:YES orientToPath:NO duration:5.0];
    SKAction *moveBottomLeft = [SKAction moveTo:CGPointMake(100,100) duration:2.0];
    SKAction *moveRight = [SKAction moveByX:50 y:50 duration:0.5];
    SKAction *sequence = [SKAction sequence:@[moveRight, moveBottomLeft]];
    SKAction *endlessAction = [SKAction repeatActionForever:sequence];
    
    //[avatar runAction:[SKAction sequence:@[followline, reversedLine, followSquare, followCircle,endlessAction]]];
    SKAction *test;
    __block int i = 5;
    SKAction *blockAction = [SKAction runBlock:^(void){
        while (i) {
            i--;
            [avatar runAction:[SKAction sequence:@[followline, reversedLine,blockAction]]];
        }
    }];
    test = [SKAction sequence:@[followline, reversedLine]];
    [avatar runAction:test completion:^(void){
        while (i) {
            i--;
            [avatar runAction:moveRight];
        }
    }];
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
