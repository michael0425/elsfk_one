#import <Foundation/Foundation.h>
#import "Block.h"
#import "Board.h"

void checkBlock(Block *block, Board *board) {
	
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
    // insert code here...
    Block * block = [[Block alloc] init];
	[block loadCubeWithX:0 Y:0 color:RED type:SOLID];
	[block loadCubeWithX:0 Y:1 color:RED type:SOLID];
	[block loadCubeWithX:0 Y:2 color:RED type:SOLID];
	[block loadCubeWithX:1 Y:2 color:RED type:SOLID];
	
	//	[block printBlock];
	//	[block rotate];
	//	[block printBlock];
	//	[block rotate];
	//	[block printBlock];
	
	Board *board = [[Board alloc] init];
	
	[board validateBlock:block];
	[block moveDown];
	[board validateBlock:block];
	[block moveLeft];
	[board validateBlock:block];
	[block moveRight];
	[board validateBlock:block];
	
	
	while ([board validateBlock:block]) {
		[block moveDown];
	}
	[board landCurrentBlock];
	
	[board printBoard];
	
	
	
	[block release];
	[board release];
	
    [pool drain];
    return 0;
}
