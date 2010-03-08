#import <Foundation/Foundation.h>
#import "Block.h"
#import "Board.h"
#import "BlockFactory.h"

void checkBlock(Block *block, Board *board) {
	
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	BlockFactory* factory = [[BlockFactory sharedBlockFactory] init];
	
    // insert code here...
//    Block * block = [[Block alloc] init];
//	[block loadCubeWithX:0 Y:0 color:RED type:SOLID];
//	[block loadCubeWithX:0 Y:1 color:RED type:SOLID];
//	[block loadCubeWithX:0 Y:2 color:RED type:SOLID];
//	[block loadCubeWithX:1 Y:2 color:RED type:SOLID];
	
	//	[block printBlock];
	//	[block rotate];
	//	[block printBlock];
	//	[block rotate];
	//	[block printBlock];
	
	Block* block;
	block = [factory getRandomBlock];
	[block retain];
	[block printBlock];
	
	Board *board = [[Board alloc] init];
	
	[board validateBlock:block];
	[block moveDown];
//	[board validateBlock:block];
//	[block moveLeft];
	[board validateBlock:block];
	[block moveRight];
	[board validateBlock:block];
	
	
	while ([board validateBlock:block]) {
		[block moveDown];
	}
	[board landCurrentBlock];
	
	[block release];
	
	
	//GLfloat *ver = [board getCubeVertex:[[board.currentBlock getCubeSetToBoard] anyObject]];
	
	
	    Block * block2 = [[Block alloc] init];
	    [block2 loadCubeWithX:0 Y:0 color:RED type:SOLID];
		[block2 loadCubeWithX:0 Y:1 color:RED type:SOLID];
		[block2 loadCubeWithX:0 Y:2 color:RED type:SOLID];
		[block2 loadCubeWithX:1 Y:2 color:RED type:SOLID];
	
	[block2 release];
	
	block2 = [factory getRandomBlock];
	[block2 retain];
	
	[board validateBlock:block2];
	
	[block2 release];
	
	[board printNewBoard];
	
	GLfloat *ver = [board getCubeSetVerticesInBoard];
	
	NSMutableString *str = [NSMutableString stringWithString:@""];
	for (size_t i; ver[i]; ++i)
	{
		[str appendFormat:@"%f,",ver[i]];
	}
	NSLog(@"##########%@",str);
	
	

	[board release];
	
    [pool drain];
    return 0;
}
