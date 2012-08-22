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

@property (nonatomic) CGSize cellSize;
@property (weak, nonatomic) SBPieceView *selected;

@property (copy, nonatomic) SBBoard *board;
@property (copy, nonatomic) NSArray *pieces;
@property (copy, nonatomic) NSDictionary *locations;

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
    self.cellSize = CGSizeMake(self.bounds.size.width / 8.0, self.bounds.size.height / 8.0);

    NSMutableDictionary *locations = [NSMutableDictionary dictionary];

    [self.board enumerateLocationsUsingBlock:^(SBLocation *loc) {
        CGPoint p = CGPointMake((0.5 + loc.column) * self.cellSize.width, (0.5 + loc.row) * self.cellSize.height);
        [locations setObject:[NSValue valueWithCGPoint:p] forKey:loc];
    }];

    self.locations = locations;
}

- (void)layoutBoard:(SBBoard*)board {
    self.board = board;
    self.selected = nil;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    for (SBPieceView *p in self.pieces) {
        SBLocation *loc = [self.board locationForPiece:p.piece];
        p.center = [self.locations[loc] CGPointValue];
    }
}

- (BOOL)canSelectPieceView:(SBPieceView *)pieceView {
    return self.board.currentPlayerIndex == pieceView.piece.owner;
}

- (void)didSelectPieceView:(SBPieceView *)pieceView {
    self.selected = pieceView;
}

- (void)setSelected:(SBPieceView *)selected {
    if (_selected) _selected.highlighted = NO;
    _selected = selected;
    if (_selected) _selected.highlighted = YES;

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    if (!self.selected) {
        NSLog(@"Touches ended but no piece selected; nothing to do");
        return;
    }

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    SBLocation *destination = [self locationInGridFromPoint:point];

    SBLocation *source = [self.board locationForPiece:self.selected.piece];
    SBMove *move = [SBMove moveWithFrom:source to:destination];

    if ([self.board isLegalMove:move]) {
        [self.delegate performMove:move];
    }
}

- (SBLocation *)locationInGridFromPoint:(CGPoint)point {
    NSUInteger col = (NSUInteger)(point.x / self.cellSize.width);
    NSUInteger row = (NSUInteger)(point.y / self.cellSize.height);
    return [SBLocation locationWithColumn:col row:row];
}

@end
