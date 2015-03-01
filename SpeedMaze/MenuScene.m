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
    NSScanner *scanner = [NSScanner scannerWithString:self.mazeWidth.text];
    BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
    if (!isNumeric) {
        self.mazeWidth.text = @"10";
    }
    NSAssert(isNumeric,  ([NSString stringWithFormat:@"input value must be numbers"]));
    if ([self.mazeWidth.text integerValue] < 5) {
        self.mazeWidth.text = @"5";
    }
    if ([self.mazeWidth.text integerValue] > 50) {
        self.mazeWidth.text = @"50";
    }
    int width = (int)[self.mazeWidth.text integerValue];
    if ([node.name isEqualToString:@"BlackBox"]) {
        id<MazeGameMenuDelegate> delegate = self.gameMenudelegate;
        if ([delegate respondsToSelector:@selector(generateMazeWithWidth:andHeight:andAvatarType:)]) {
            [delegate generateMazeWithWidth:width andHeight:width andAvatarType:mazeAvatarBlackBox];
        }
    }
    else if ([node.name isEqualToString:@"Giraffe"]) {
        id<MazeGameMenuDelegate> delegate = self.gameMenudelegate;
        if ([delegate respondsToSelector:@selector(generateMazeWithWidth:andHeight:andAvatarType:)]) {
            [delegate generateMazeWithWidth:width andHeight:width andAvatarType:mazeAvatarGiraffe];
        }
    }else if ([node.name isEqualToString:@"Snail"]) {
        id<MazeGameMenuDelegate> delegate = self.gameMenudelegate;
        if ([delegate respondsToSelector:@selector(generateMazeWithWidth:andHeight:andAvatarType:)]) {
            [delegate generateMazeWithWidth:width andHeight:width andAvatarType:mazeAvatarSnail];
        }
    }else if ([node.name isEqualToString:@"Sunday"]) {
        id<MazeGameMenuDelegate> delegate = self.gameMenudelegate;
        if ([delegate respondsToSelector:@selector(generateMazeWithWidth:andHeight:andAvatarType:)]) {
            [delegate generateMazeWithWidth:width andHeight:width andAvatarType:mazeAvatarSunday];
        }
    }
    
}

-(void)didMoveToView:(SKView *)view {
    /*
    NSLog(@"Michael's interview question:");
    NSString *inputString = @"The quick brown fox jumped over the lazy brown dog’s back";
    NSArray *words = [inputString componentsSeparatedByString: @" "];
    NSMutableDictionary *collection = [NSMutableDictionary dictionary];
    
    //NSMutableSet *temp = [NSMutableSet set];
    //NSMutableSet *wordLengthCollection = [NSMutableSet set];
    for (NSString *aWord in words) {
        // if not in collection
        if (![collection valueForKey:aWord]) {
            [collection setValue:[NSNumber numberWithLong:1] forKey:aWord];
        }
        // if exists, increame the count
        else{
            NSNumber *get = [collection valueForKey:aWord];
            long result = [get integerValue] + 1;
            NSNumber *back = [NSNumber numberWithLong:result];
            [collection setValue:back forKey:aWord];
            
            // atomicInt = get(...)
            // atomicInt++
        }
        
        
    }
    [wordLengthCollection unionSet:temp];
    NSLog(@"1: Dictionary contains: %@ \nwordLengthCollection: %@", collection, wordLengthCollection);
    */
    
    // 10% : $0 to $20,000 //20k -> 10%
    // 15% : $20,000 to $40,000// 40k -> ?% $35 CEILING floor
    // 20% : $40,000 and over
    // 5% : $10,000 to $42,000
    //naming
    // percentage: leftBractek to rightBractek,diff <-set or array of dictionary
//    e.g, assume brackets are ordered, not intercept each other
//    B.bracket = 40000
//    B.percent = 20
//    income = 10k
//    tax = 0
//    while (there is a bracket B, income > B.backet) {
//        tax += (income -= B.bracket) * B.percent
//    }
//    ---------------------------------
    // 10% : $0 to $20,000
    // 15% : $20,000 to (income > $20,000)? income - $20,000 : 0
    // 20% : $40,000 and (income > $40,000)? income - $40,000 : 0

    
    
    
    
    NSLog(@"menu scene: %f, %f, %f, %f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    UITextField *mazeWidth = [[UITextField alloc]initWithFrame:CGRectMake(0,0, 100, 40)];
    mazeWidth.center = CGPointMake(160, 240);
    mazeWidth.text = @"10";
    mazeWidth.keyboardType = UIKeyboardTypeNumberPad;
    mazeWidth.backgroundColor = [UIColor whiteColor];
    mazeWidth.layer.zPosition = 3;
    mazeWidth.delegate = self;
    mazeWidth.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.mazeWidth = mazeWidth;
    //mazeWidth.delegate = self.delegate;
    [self.view addSubview:mazeWidth];
    
    /*
    SKSpriteNode *avatar = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(20, 20)];
    avatar.color = [SKColor whiteColor];
    [self addChild:avatar];
    SKAction *moveRight = [SKAction moveByX:50 y:50 duration:1];
    [avatar runAction:moveRight completion:^{
        [avatar runAction:moveRight];
    }];
     */
    
    /*//SKCropNode
    SKSpriteNode *picFrame = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(300, 300)];
    picFrame.position = CGPointMake(160, 160);
    
    // the part I want to run action on
    SKSpriteNode *pic = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor] size:CGSizeMake(100, 100)];
    SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:CGSizeMake(20, 80)];
    
    SKCropNode *cropNode = [SKCropNode node];
    [cropNode addChild:pic];
    [cropNode setMaskNode:mask];
    [picFrame addChild:cropNode];
    [self addChild:picFrame];
     */
    
    /* //SKLightNode
    //Setup a background
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background.png" normalMapped:TRUE];
    background.size = self.size;
    background.zPosition = 0;
    background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    background.lightingBitMask = 1;
    [self addChild:background];
    
    
    //Setup some stone objects with different positions
    for (int i=1; i<4; i++) {
        SKSpriteNode *stone = [SKSpriteNode spriteNodeWithImageNamed:@"stone.png"];
        stone.position = CGPointMake(i*250, self.frame.size.height/2);
        [stone setScale:0.6];
        stone.zPosition = 1;
        stone.shadowCastBitMask = 1;
        [self addChild:stone];
    }
    
    
    //Setup a LightNode
    SKLightNode* light = [[SKLightNode alloc] init];
    light.categoryBitMask = 1;
    light.falloff = 1;
    light.ambientColor = [UIColor whiteColor];
    light.lightColor = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:0.0 alpha:0.5];
    light.shadowColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    [self addChild:light];
      */
}

-(void)willMoveFromView:(SKView *)view{
    [self.mazeWidth removeFromSuperview];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered])&&(newLength <= 2));
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
@end
