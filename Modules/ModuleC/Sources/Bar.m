#import "Bar.h"

#import <ModuleC/ModuleC-Swift.h>

@implementation ModuleCBar

- (BOOL)doSomething {	
	Foo *foo = [[Foo alloc] init];
	[foo doSomething];
	NSLog(@"Bar did something");

	return YES;
}

@end
