#import "Bar.h"

#import <ModuleB/ModuleB-Swift.h>

@implementation ModuleBBar

- (BOOL)doSomething {	
	Foo *foo = [[Foo alloc] init];
	[foo doSomething];
	NSLog(@"Bar did something");

	return YES;
}

@end
