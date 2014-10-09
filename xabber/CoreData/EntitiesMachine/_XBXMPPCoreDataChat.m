// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XBXMPPCoreDataChat.m instead.

#import "_XBXMPPCoreDataChat.h"

const struct XBXMPPCoreDataChatAttributes XBXMPPCoreDataChatAttributes = {
	.negotiatorsName = @"negotiatorsName",
};

const struct XBXMPPCoreDataChatRelationships XBXMPPCoreDataChatRelationships = {
	.account = @"account",
	.messages = @"messages",
};

const struct XBXMPPCoreDataChatFetchedProperties XBXMPPCoreDataChatFetchedProperties = {
};

@implementation XBXMPPCoreDataChatID
@end

@implementation _XBXMPPCoreDataChat

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XBXMPPCoreDataChat" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XBXMPPCoreDataChat";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XBXMPPCoreDataChat" inManagedObjectContext:moc_];
}

- (XBXMPPCoreDataChatID*)objectID {
	return (XBXMPPCoreDataChatID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic negotiatorsName;






@dynamic account;

	

@dynamic messages;

	
- (NSMutableSet*)messagesSet {
	[self willAccessValueForKey:@"messages"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"messages"];
  
	[self didAccessValueForKey:@"messages"];
	return result;
}
	






@end
