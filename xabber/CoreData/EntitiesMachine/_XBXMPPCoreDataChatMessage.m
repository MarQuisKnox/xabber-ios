// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XBXMPPCoreDataChatMessage.m instead.

#import "_XBXMPPCoreDataChatMessage.h"

const struct XBXMPPCoreDataChatMessageAttributes XBXMPPCoreDataChatMessageAttributes = {
	.isIncoming = @"isIncoming",
	.isService = @"isService",
	.messageText = @"messageText",
	.messageTimestamp = @"messageTimestamp",
};

const struct XBXMPPCoreDataChatMessageRelationships XBXMPPCoreDataChatMessageRelationships = {
	.chat = @"chat",
};

const struct XBXMPPCoreDataChatMessageFetchedProperties XBXMPPCoreDataChatMessageFetchedProperties = {
};

@implementation XBXMPPCoreDataChatMessageID
@end

@implementation _XBXMPPCoreDataChatMessage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XBXMPPCoreDataChatMessage" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XBXMPPCoreDataChatMessage";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XBXMPPCoreDataChatMessage" inManagedObjectContext:moc_];
}

- (XBXMPPCoreDataChatMessageID*)objectID {
	return (XBXMPPCoreDataChatMessageID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isIncomingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isIncoming"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isServiceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isService"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic isIncoming;



- (BOOL)isIncomingValue {
	NSNumber *result = [self isIncoming];
	return [result boolValue];
}

- (void)setIsIncomingValue:(BOOL)value_ {
	[self setIsIncoming:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsIncomingValue {
	NSNumber *result = [self primitiveIsIncoming];
	return [result boolValue];
}

- (void)setPrimitiveIsIncomingValue:(BOOL)value_ {
	[self setPrimitiveIsIncoming:[NSNumber numberWithBool:value_]];
}





@dynamic isService;



- (BOOL)isServiceValue {
	NSNumber *result = [self isService];
	return [result boolValue];
}

- (void)setIsServiceValue:(BOOL)value_ {
	[self setIsService:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsServiceValue {
	NSNumber *result = [self primitiveIsService];
	return [result boolValue];
}

- (void)setPrimitiveIsServiceValue:(BOOL)value_ {
	[self setPrimitiveIsService:[NSNumber numberWithBool:value_]];
}





@dynamic messageText;






@dynamic messageTimestamp;






@dynamic chat;

	






@end
