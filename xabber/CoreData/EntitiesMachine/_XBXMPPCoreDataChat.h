// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XBXMPPCoreDataChat.h instead.

#import <CoreData/CoreData.h>


extern const struct XBXMPPCoreDataChatAttributes {
	__unsafe_unretained NSString *negotiatorsName;
} XBXMPPCoreDataChatAttributes;

extern const struct XBXMPPCoreDataChatRelationships {
	__unsafe_unretained NSString *account;
	__unsafe_unretained NSString *messages;
} XBXMPPCoreDataChatRelationships;

extern const struct XBXMPPCoreDataChatFetchedProperties {
} XBXMPPCoreDataChatFetchedProperties;

@class XBXMPPCoreDataAccount;
@class XBXMPPCoreDataChatMessage;



@interface XBXMPPCoreDataChatID : NSManagedObjectID {}
@end

@interface _XBXMPPCoreDataChat : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (XBXMPPCoreDataChatID*)objectID;





@property (nonatomic, strong) NSString* negotiatorsName;



//- (BOOL)validateNegotiatorsName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) XBXMPPCoreDataAccount *account;

//- (BOOL)validateAccount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *messages;

- (NSMutableSet*)messagesSet;





@end

@interface _XBXMPPCoreDataChat (CoreDataGeneratedAccessors)

- (void)addMessages:(NSSet*)value_;
- (void)removeMessages:(NSSet*)value_;
- (void)addMessagesObject:(XBXMPPCoreDataChatMessage*)value_;
- (void)removeMessagesObject:(XBXMPPCoreDataChatMessage*)value_;

@end

@interface _XBXMPPCoreDataChat (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveNegotiatorsName;
- (void)setPrimitiveNegotiatorsName:(NSString*)value;





- (XBXMPPCoreDataAccount*)primitiveAccount;
- (void)setPrimitiveAccount:(XBXMPPCoreDataAccount*)value;



- (NSMutableSet*)primitiveMessages;
- (void)setPrimitiveMessages:(NSMutableSet*)value;


@end
