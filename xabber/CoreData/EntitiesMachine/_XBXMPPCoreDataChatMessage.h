// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XBXMPPCoreDataChatMessage.h instead.

#import <CoreData/CoreData.h>


extern const struct XBXMPPCoreDataChatMessageAttributes {
	__unsafe_unretained NSString *isIncoming;
	__unsafe_unretained NSString *isService;
	__unsafe_unretained NSString *messageText;
	__unsafe_unretained NSString *messageTimestamp;
} XBXMPPCoreDataChatMessageAttributes;

extern const struct XBXMPPCoreDataChatMessageRelationships {
	__unsafe_unretained NSString *chat;
} XBXMPPCoreDataChatMessageRelationships;

extern const struct XBXMPPCoreDataChatMessageFetchedProperties {
} XBXMPPCoreDataChatMessageFetchedProperties;

@class XBXMPPCoreDataChat;






@interface XBXMPPCoreDataChatMessageID : NSManagedObjectID {}
@end

@interface _XBXMPPCoreDataChatMessage : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (XBXMPPCoreDataChatMessageID*)objectID;





@property (nonatomic, strong) NSNumber* isIncoming;



@property BOOL isIncomingValue;
- (BOOL)isIncomingValue;
- (void)setIsIncomingValue:(BOOL)value_;

//- (BOOL)validateIsIncoming:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isService;



@property BOOL isServiceValue;
- (BOOL)isServiceValue;
- (void)setIsServiceValue:(BOOL)value_;

//- (BOOL)validateIsService:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* messageText;



//- (BOOL)validateMessageText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* messageTimestamp;



//- (BOOL)validateMessageTimestamp:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) XBXMPPCoreDataChat *chat;

//- (BOOL)validateChat:(id*)value_ error:(NSError**)error_;





@end

@interface _XBXMPPCoreDataChatMessage (CoreDataGeneratedAccessors)

@end

@interface _XBXMPPCoreDataChatMessage (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIsIncoming;
- (void)setPrimitiveIsIncoming:(NSNumber*)value;

- (BOOL)primitiveIsIncomingValue;
- (void)setPrimitiveIsIncomingValue:(BOOL)value_;




- (NSNumber*)primitiveIsService;
- (void)setPrimitiveIsService:(NSNumber*)value;

- (BOOL)primitiveIsServiceValue;
- (void)setPrimitiveIsServiceValue:(BOOL)value_;




- (NSString*)primitiveMessageText;
- (void)setPrimitiveMessageText:(NSString*)value;




- (NSDate*)primitiveMessageTimestamp;
- (void)setPrimitiveMessageTimestamp:(NSDate*)value;





- (XBXMPPCoreDataChat*)primitiveChat;
- (void)setPrimitiveChat:(XBXMPPCoreDataChat*)value;


@end
