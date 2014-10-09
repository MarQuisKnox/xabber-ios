// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XBXMPPCoreDataAccount.m instead.

#import "_XBXMPPCoreDataAccount.h"

const struct XBXMPPCoreDataAccountAttributes XBXMPPCoreDataAccountAttributes = {
	.accountID = @"accountID",
	.autoLogin = @"autoLogin",
	.host = @"host",
	.port = @"port",
	.status = @"status",
};

const struct XBXMPPCoreDataAccountRelationships XBXMPPCoreDataAccountRelationships = {
	.chats = @"chats",
};

const struct XBXMPPCoreDataAccountFetchedProperties XBXMPPCoreDataAccountFetchedProperties = {
};

@implementation XBXMPPCoreDataAccountID
@end

@implementation _XBXMPPCoreDataAccount

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XBXMPPCoreDataAccount" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XBXMPPCoreDataAccount";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XBXMPPCoreDataAccount" inManagedObjectContext:moc_];
}

- (XBXMPPCoreDataAccountID*)objectID {
	return (XBXMPPCoreDataAccountID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"autoLoginValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"autoLogin"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"portValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"port"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic accountID;






@dynamic autoLogin;



- (BOOL)autoLoginValue {
	NSNumber *result = [self autoLogin];
	return [result boolValue];
}

- (void)setAutoLoginValue:(BOOL)value_ {
	[self setAutoLogin:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveAutoLoginValue {
	NSNumber *result = [self primitiveAutoLogin];
	return [result boolValue];
}

- (void)setPrimitiveAutoLoginValue:(BOOL)value_ {
	[self setPrimitiveAutoLogin:[NSNumber numberWithBool:value_]];
}





@dynamic host;






@dynamic port;



- (int32_t)portValue {
	NSNumber *result = [self port];
	return [result intValue];
}

- (void)setPortValue:(int32_t)value_ {
	[self setPort:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePortValue {
	NSNumber *result = [self primitivePort];
	return [result intValue];
}

- (void)setPrimitivePortValue:(int32_t)value_ {
	[self setPrimitivePort:[NSNumber numberWithInt:value_]];
}





@dynamic status;



- (int16_t)statusValue {
	NSNumber *result = [self status];
	return [result shortValue];
}

- (void)setStatusValue:(int16_t)value_ {
	[self setStatus:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveStatusValue {
	NSNumber *result = [self primitiveStatus];
	return [result shortValue];
}

- (void)setPrimitiveStatusValue:(int16_t)value_ {
	[self setPrimitiveStatus:[NSNumber numberWithShort:value_]];
}





@dynamic chats;

	
- (NSMutableSet*)chatsSet {
	[self willAccessValueForKey:@"chats"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"chats"];
  
	[self didAccessValueForKey:@"chats"];
	return result;
}
	






+ (NSArray*)fetchXBAutoLoginAccounts:(NSManagedObjectContext*)moc_ {
	NSError *error = nil;
	NSArray *result = [self fetchXBAutoLoginAccounts:moc_ error:&error];
	if (error) {
#ifdef NSAppKitVersionNumber10_0
		[NSApp presentError:error];
#else
		NSLog(@"error: %@", error);
#endif
	}
	return result;
}
+ (NSArray*)fetchXBAutoLoginAccounts:(NSManagedObjectContext*)moc_ error:(NSError**)error_ {
	NSParameterAssert(moc_);
	NSError *error = nil;

	NSManagedObjectModel *model = [[moc_ persistentStoreCoordinator] managedObjectModel];
	
	NSDictionary *substitutionVariables = [NSDictionary dictionary];
	
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"XBAutoLoginAccounts"
													 substitutionVariables:substitutionVariables];
	NSAssert(fetchRequest, @"Can't find fetch request named \"XBAutoLoginAccounts\".");

	NSArray *result = [moc_ executeFetchRequest:fetchRequest error:&error];
	if (error_) *error_ = error;
	return result;
}



@end
