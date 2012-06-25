//
// Created by SuperPappi on 25/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBotTurnEventHandler.h"
#import "SBPlayer.h"
#import "SBMatch.h"
#import "SBOpponentMobilityMinimisingMovePicker.h"
#import "SBBoard.h"
#import "SBMove.h"

@implementation SBBotTurnEventHandler


- (void)handleTurnEventForMatch:(SBMatch *)match viewController:(SBMatchViewController *)mvc {
    if (match.isGameOver)
        return;

    if (match.currentPlayer.isLocalHuman)
        return;

    SBOpponentMobilityMinimisingMovePicker *movePicker = [[SBOpponentMobilityMinimisingMovePicker alloc] init];
    SBMove *move = [movePicker moveForState:match.board];
    SBPiece *piece = [match.board pieceForLocation:move.from];
    [mvc movePiece:piece toLocation:move.to];
}

@end