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
#import "SBCellView.h"

@interface SBBoardView () < SBPieceViewDelegate, SBCellViewDelegate >

@property (nonatomic) CGSize cellSize;
@property (weak, nonatomic) SBPieceView *selected;

@property (strong, nonatomic) NSDictionary *cells;
@property (strong, nonatomic) SBBoard *board;
@property (strong, nonatomic) NSArray *pieces;

@end

@implementation SBBoardView


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder {
    self.board = [SBBoard board];

    UIImage *grid = [UIImage imageNamed:@"board"];
    UIImageView *background = [[UIImageView alloc] initWithImage:grid];
    [self addSubview:background];

    self.cellSize = CGSizeMake(self.bounds.size.width / 8.0, self.bounds.size.height / 8.0);

    self.cells = [self setupCells];
    self.pieces = [self setupPieces];

    [self setNeedsLayout];

    return [super awakeAfterUsingCoder:aDecoder];
}

- (NSArray *)setupPieces {
    NSMutableArray *pieces = [NSMutableArray array];

    for (NSArray *pp in self.board.pieces) {
        for (SBPiece *p in pp) {

            SBPieceView *pieceView = [SBPieceView objectWithPiece:p];
            pieceView.delegate = self;

            SBCellView *cell = [self.cells objectForKey:[self.board locationForPiece:p]];
            pieceView.center = cell.center;

            [pieces addObject:pieceView];
            [self addSubview:pieceView];
        }
    }

    return pieces;
}

- (NSDictionary *)setupCells {
    NSMutableDictionary *cells = [NSMutableDictionary dictionary];

    [self.board enumerateLocationsUsingBlock:^(SBLocation *loc) {
        CGPoint p = CGPointMake((0.5 + loc.column) * self.cellSize.width, (0.5 + loc.row) * self.cellSize.height);

        SBCellView *cellView = [SBCellView objectWithLocation:loc];
        cellView.delegate = self;
        cellView.center = p;

        [cells setObject:cellView forKey:loc];
        [self addSubview:cellView];
    }];

    return cells;
}

- (void)layoutBoard:(SBBoard*)board {
    self.board = board;
    self.selected = nil;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [UIView animateWithDuration:ANIM_DURATION
                     animations:^{
        for (SBPieceView *pieceView in self.pieces) {
            SBLocation *loc = [self.board locationForPiece:pieceView.piece];
            SBCellView *cell = [self.cells objectForKey:loc];
            pieceView.center = cell.center;
            pieceView.movesLeft = [[self.board turnsLeftForPiece:pieceView.piece] unsignedIntegerValue];
        }

    }                completion:^(BOOL finished) {
        if (finished)
            [self.delegate didLayoutBoard];
    }];

    [self.board enumerateLocationsUsingBlock:^(SBLocation *loc) {
        SBCellView *cellView = [self.cells objectForKey:loc];
        cellView.blocked = [self.board wasLocationOccupied:loc];
    }];

}

- (BOOL)canSelectPieceView:(SBPieceView *)pieceView {
    if (self.board.currentPlayerIndex != pieceView.piece.owner)
        return NO;

    if (![self.delegate shouldAcceptUserInput])
        return NO;

    // OK, so it's the current player's piece;
    // The match is not over;
    // The current player is a human;
    // But does _this_ piece have any legal moves?
    __block BOOL canMove = NO;
    [self.board enumerateLegalDestinationsForPiece:pieceView.piece
                                         withBlock:^(SBLocation *location, BOOL *stop) {
                                             canMove = YES;
                                             *stop = YES;
                                         }];

    return canMove;
}

- (void)didSelectPieceView:(SBPieceView *)pieceView {
    if (self.selected != pieceView)
        self.selected = pieceView;
}

- (void)setSelected:(SBPieceView *)selected {
    if (_selected) _selected.highlighted = NO;
    _selected = selected;
    if (_selected) _selected.highlighted = YES;

}

- (void)touchEndedInCellView:(SBCellView *)cellView {
    if (!self.selected) {
        NSLog(@"Touches ended but no piece selected; nothing to do");
        return;
    }

    SBLocation *source = [self.board locationForPiece:self.selected.piece];
    SBLocation *destination = cellView.location;
    SBMove *move = [SBMove moveWithFrom:source to:destination];

    if ([self.board isLegalMove:move]) {
        [self.delegate performMove:move];
    }
}

@end
