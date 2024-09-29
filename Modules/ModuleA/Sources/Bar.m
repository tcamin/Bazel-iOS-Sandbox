#import "Bar.h"

#import <ModuleA/ModuleA-Swift.h>

@implementation ModuleABar

- (BOOL)doSomething {	
	Foo *foo = [[Foo alloc] init];
	[foo doSomething];
	NSLog(@"Bar did something");

	return YES;
}

@end
