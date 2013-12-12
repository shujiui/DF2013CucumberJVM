/**
* @author       SonomaPartners
* @date         09/25/13
* @description  Used by Chatter Follow trigger
*				 
*               
-----------------------------------------------------------------------------
*    Developer                    Date                Description
*    -----------------------------------------------------------------------------
*    Shuji Ui                  09/25/2013             insert (follow),delete (unfollow), and update
*    Shuji Ui                  09/26/2013             bulkified
*/

// made with sharing for now
public with sharing class SNM_ChatterFollowTriggerUtil {

/**
   this method does
  
   1. go trough trigger.new : list of SNM_Contact_Follow__c 
      construct map of userId and set of contacts ids
   2. query EntitySubscription records subscriberId in the key set
   3. check duplicates by going through results returned by the query 
      and construct set of dupes ids combination strings 
   4. go through conFollows again and build a list of subscriptions to insert
   5. insert the list
   
   Note:
   - System validation on EntitySubscription. Cannot insert duplicate combination
     of parentId and subscriberId 
*/
public static void followContacts(List<SNM_Contact_Follow__c> conFollows){
                
        //1. go through conFollows
        //   construct map of userId and set of contacts Ids
        Map<Id,Set<Id>> mapUsersContacts = new Map<Id,Set<Id>>();
        for (SNM_Contact_Follow__c cf : conFollows) {
        	// we don't need it but null check here for best practice 
            if(cf.User__c != null && cf.Contact__c != null){
            // construct map
             	if(mapUsersContacts.containsKey(cf.User__c)){
             		mapUsersContacts.get(cf.User__c).add(cf.Contact__c);
             	}else{
             		Set<Id> newConSet = new Set<Id>();
             		newConSet.add(cf.Contact__c);
             		mapUsersContacts.put(cf.User__c, newConSet);
             	}
            }
        }
        
       List<EntitySubscription> subscriptions = new List<EntitySubscription>(); 
        //2. query EntitySubscription records subscriberId in the key set
       if(mapUsersContacts.keySet().size() >0) {
	       subscriptions = [select parentId,
	        					   subscriberId
	        				from   EntitySubscription
	        				where  subscriberId in :mapUsersContacts.keySet()];
	       
       }
       
       Set<String> dupesSet = new Set<String>();
       // 3.  check duplicates and construct set of dupes ids combination strings
       for ( EntitySubscription s  : subscriptions){
       	     // if yes the combination is dupe
       	     if(mapUsersContacts.get(s.subscriberId).contains(s.parentId)){
       	     	dupesSet.add(''+s.subscriberId + s.parentId);
       	     }
       }
       
       // 4. then go through conFollows again and build a list of subscriptions to insert
       List<EntitySubscription> subscriptionsToAdd = new List<EntitySubscription>();
       for (SNM_Contact_Follow__c cf: conFollows){
           if(!dupesSet.contains(''+ cf.User__c + cf.Contact__c)){
           	 subscriptionsToAdd.add(
       	     			new EntitySubscription(
                		parentId = cf.Contact__c,
               		 	subscriberId = cf.User__c
            	));
             // here add the combination to dupesSet to remove dupes in the conFollows
             dupesSet.add(''+cf.User__c + cf.Contact__c);
           }
       }
       // 5. insert the list
       if(subscriptionsToAdd.size() >0){
        	try{
        		insert subscriptionsToAdd;
        	} catch (DMLException de){
        	    // i haven't decide what to do just throw for now. 
        	    throw de;   
        	}  
        }
}

/**
   this method does
   
   1. go trough conFollows constructs set of User Id and set of Contact Id
   2. query parentId and subscriberId from EntitySubscription based on the sets created in 2. 
   3. make the user unflow the contacts
   
*/
public static void unfollowContacts(List<SNM_Contact_Follow__c> conFollows){
        // we can assume UserId and ContactId are alway passed by trigger 
        // System.Debug('conFollows.size='+ conFollows.size() + ' ##############');
        //1. 
        Set<Id> conIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        Map<Id,Set<Id>> mapOfUserIdAndContactIdSet = new Map<Id,Set<Id>>();
        for (SNM_Contact_Follow__c cf : conFollows) {
            if(cf.User__c != null && cf.Contact__c != null){
                conIds.add(cf.Contact__c);
            	if(mapOfUserIdAndContactIdSet.containsKey(cf.User__c)){
             		mapOfUserIdAndContactIdSet.get(cf.User__c).add(cf.Contact__c);
             	}else{
             		Set<Id> newConSet = new Set<Id>();
             		newConSet.add(cf.Contact__c);
             		mapOfUserIdAndContactIdSet.put(cf.User__c, newConSet);
             	}
            }
        }
                
        //2. 
        List<EntitySubscription> subscriptions = [select parentId,
        												 subscriberId
        										  from	 EntitySubscription
        										  where  parentId in :conIds AND
        										  		 subscriberid in :mapOfUserIdAndContactIdSet.keySet()];
        
        List<EntitySubscription> subToBeDeleted = new List<EntitySubscription>();
        
        for(EntitySubscription es: subscriptions){
              Set<Id> conSet = mapOfUserIdAndContactIdSet.get(es.subscriberId);
              if(conSet!=null && conset.contains(es.parentId)){        
              	subToBeDeleted.add(es);
              }
        }
        // System.Debug('subToBeDeleted.size='+ subToBeDeleted.size() + ' ##############');								  		 
        //3.   										
        if(subToBeDeleted.size() >0){
			delete subToBeDeleted;
        } 
}

/**
   this method for update
   this method does
   assumming only one record is passed by the trigger
   1. go through conFollows check for fields updates for User__c and Contact__c
   2. construct new and old list from 1. which actually updated
   3. call unfollowContacts to unfollow old
   4. call followContacts to follow new
   
*/
public static void unfollowAndFollowContacts(List<SNM_Contact_Follow__c> conFollowsNew, List<SNM_Contact_Follow__c> conFollowsOld){
	List<SNM_Contact_Follow__c> followList = new List<SNM_Contact_Follow__c>();
    List<SNM_Contact_Follow__c> unfollowList = new List<SNM_Contact_Follow__c>();
    //1.
    for(Integer i=0 ; i<conFollowsNew.size(); i++){
         if( (conFollowsNew[i].User__c != conFollowsOld[i].User__c) ||
         	 (conFollowsNew[i].Contact__c != conFollowsOld[i].Contact__c)){
         	 unfollowList.add(confollowsOld[i]);	
             followList.add(conFollowsNew[i]);
          }
    }
    if(followList.size() >0){
    		//3.
    		unfollowContacts(unfollowList);	
            //4.
            followContacts(followList); 
    }
}

}