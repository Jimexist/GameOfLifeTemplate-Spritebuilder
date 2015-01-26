//
//  Grid.m
//  GameOfLife
//
//  Created by Jiayu Liu on 1/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"

@implementation Grid {
    NSMutableArray *_gridArray;
    float _cellWidth;
    float _cellHeight;
}

static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;

- (void)onEnter
{
    [super onEnter];
    [self setupGrid];
    self.userInteractionEnabled = YES;
}

- (void)setupGrid
{
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;

    _gridArray = [NSMutableArray array];

    float y = 0.0;
    for (int i = 0; i < GRID_ROWS; ++i) {
        _gridArray[i] = [NSMutableArray array];

        float x = 0;
        for (int j = 0; j < GRID_COLUMNS; ++j) {
            Creature *creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0, 0);
            creature.position = ccp(x, y);
            [self addChild:creature];
            _gridArray[i][j] = creature;
            x += _cellWidth;
        }

        y += _cellHeight;
    }
}

- (Creature *)creatureForTouchPosition:(CGPoint)touchPosition
{
    //get the row and column that was touched, return the Creature inside the corresponding cell
    int row = touchPosition.y / _cellHeight;
    int column = touchPosition.x / _cellWidth;
    return _gridArray[row][column];
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];

    Creature *creature = [self creatureForTouchPosition:touchLocation];

    creature.isAlive = !creature.isAlive;
}

- (BOOL)isIndexValidForX:(int)x
                    andY:(int)y
{
    return x >= 0 && y >= 0 && x < GRID_ROWS && y < GRID_COLUMNS;
}

- (void)countNeighbors
{
    for (int i = 0; i < [_gridArray count]; ++i) {
        for (int j = 0; j < [_gridArray[i] count]; ++j) {
            Creature *currentCreature = _gridArray[i][j];
            currentCreature.livingNeighbors = 0;
            for (int x = (i-1); x <= (i+1); ++x) {
                for (int y = (j-1); y <= (j+1); ++y) {
                    BOOL isIndexValid = [self isIndexValidForX:x andY: y];
                    if (!((x == i) && (y == j)) && isIndexValid) {
                        Creature *neighbor = _gridArray[x][y];
                        if (neighbor.isAlive) {
                            currentCreature.livingNeighbors += 1;
                        }
                    }
                }
            }
        }
    }
}

- (void)updateCreatures
{
    int numAlive = 0;
    for (int i = 0; i < [_gridArray count]; ++i) {
        for (int j = 0; j < [_gridArray[i] count]; ++j) {
            Creature *currentCreature = _gridArray[i][j];
            if (currentCreature.livingNeighbors == 3) {
                currentCreature.isAlive = TRUE;
            } else if (currentCreature.livingNeighbors <= 1 || currentCreature.livingNeighbors >= 4) {
                currentCreature.isAlive = FALSE;
            }
            if (currentCreature.isAlive) {
                numAlive += 1;
            }
        }
    }
    _totalAlive = numAlive;
}

- (void)evolveStep
{
    [self countNeighbors];

    [self updateCreatures];

    _generation++;
}

@end
