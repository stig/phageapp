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

@interface SBBoardView ()

@property (strong, nonatomic) SBBoard *board;
@property (strong, nonatomic) NSMutableDictionary *pieces;
@property (strong, nonatomic) NSMutableDictionary *locs;

@end

@implementation SBBoardView


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder {
    self.board = [SBBoard board];

    CGSize sz = CGSizeMake(self.bounds.size.width / 8.0, self.bounds.size.height / 8.0);

    self.locs = [NSMutableDictionary dictionary];
    [self.board enumerateLocationsUsingBlock:^(SBLocation *loc) {
        CGPoint p = CGPointMake((0.5 + loc.column) * sz.width, (0.5 + loc.row) * sz.height);
        [self.locs setObject:[NSValue valueWithCGPoint:p] forKey:loc];
    }];

    self.pieces = [NSMutableDictionary dictionary];

    for (NSArray *pp in self.board.pieces) {
        for (SBPiece *p in pp) {
            NSString *prefix = p.owner == 0 ? @"South" : @"North";
            NSString *suffix = [NSStringFromClass([p class]) substringFromIndex:2];
            UIImage *img = [UIImage imageNamed:[prefix stringByAppendingString:suffix]];

            SBPieceView *iv = [[SBPieceView alloc] initWithImage:img];
            self.pieces[p] = iv;

            [self addSubview:iv];
        }
    }
    
    [self setNeedsLayout];

    return [super awakeAfterUsingCoder:aDecoder];
}

- (void)layoutBoard:(SBBoard*)board {
    self.board = board;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    for (SBPiece *p in self.pieces) {
        SBLocation *loc = [self.board locationForPiece:p];
        UIImageView *iv = self.pieces[p];
        iv.center = [self.locs[loc] CGPointValue];
    }
}

@end
