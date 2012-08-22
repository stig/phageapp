//
//  SBBoardView.m
//  Phage
//
//  Created by Stig Brautaset on 21/08/2012.
//
//

#import "SBBoardView.h"
#import "PhageModel.h"
#import "SBPieceView.h"

@interface SBBoardView () < SBPieceViewDelegate >

@property (copy, nonatomic) SBBoard *board;
@property (copy, nonatomic) NSArray *pieces;
@property (copy, nonatomic) NSDictionary *locs;

@end

@implementation SBBoardView


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder {
    self.board = [SBBoard board];

    [self setupLocations];
    [self setupPieces];

    [self setNeedsLayout];

    return [super awakeAfterUsingCoder:aDecoder];
}

- (void)setupPieces {
    NSMutableArray *pieces = [NSMutableArray array];

    for (NSArray *pp in self.board.pieces) {
        for (SBPiece *p in pp) {

            SBPieceView *pieceView = [SBPieceView objectWithPiece:p];
            pieceView.delegate = self;

            [pieces addObject:pieceView];
            [self addSubview:pieceView];
        }
    }

    self.pieces = pieces;
}

- (void)setupLocations {
    CGSize sz = CGSizeMake(self.bounds.size.width / 8.0, self.bounds.size.height / 8.0);

    NSMutableDictionary *locs = [NSMutableDictionary dictionary];

    [self.board enumerateLocationsUsingBlock:^(SBLocation *loc) {
        CGPoint p = CGPointMake((0.5 + loc.column) * sz.width, (0.5 + loc.row) * sz.height);
        [locs setObject:[NSValue valueWithCGPoint:p] forKey:loc];
    }];

    self.locs = locs;
}

- (void)layoutBoard:(SBBoard*)board {
    self.board = board;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    for (SBPieceView *p in self.pieces) {
        SBLocation *loc = [self.board locationForPiece:p.piece];
        p.center = [self.locs[loc] CGPointValue];
    }
}

- (BOOL)canSelectPiece:(SBPiece *)piece {
    return self.board.currentPlayerIndex == piece.owner;
}


@end
