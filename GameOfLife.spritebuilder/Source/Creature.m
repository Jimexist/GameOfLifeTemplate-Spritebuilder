//
//  Creature.m
//  GameOfLife
//
//  Created by Jiayu Liu on 1/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Creature.h"

@implementation Creature

- (id)initCreature {
    self = [super initWithImageNamed:@"GameOfLifeAsset/Asset/bubble.png"];
    if (self) {
        self.isAlive = NO;
    }
    return self;
}

- (void)setIsAlive:(BOOL)isAlive {
    _isAlive = isAlive;
    self.visible = _isAlive;
}

@end
