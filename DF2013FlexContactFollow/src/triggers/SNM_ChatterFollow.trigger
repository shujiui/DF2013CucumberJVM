/**
* @author       SonomaPartners
* @date         09/25/13
* @description  Used by Chatter Follow trigger
*				 
*				User field must have validation rule for null check
*               This is not a bulk trigger. Cannot use this for dataload. 
-----------------------------------------------------------------------------
*    Developer                    Date                Description
*    -----------------------------------------------------------------------------
*    Shuji Ui                  09/25/2013             NO Bulk: A user follows a contact
*    Shuji Ui                  09/26/2013             Bulkified this trigger
*/

trigger SNM_ChatterFollow on SNM_Contact_Follow__c (after delete, after insert, after update)  {
     
     if(Trigger.isAfter){
           if(Trigger.isInsert){
 
                SNM_ChatterFollowTriggerUtil.followContacts(Trigger.new);
                
           } else if (Trigger.isUpdate){
            		
           		SNM_ChatterFollowTriggerUtil.unfollowAndFollowContacts(Trigger.new,Trigger.old);
           } 
           else if (Trigger.isDelete){
           
           		SNM_ChatterFollowTriggerUtil.unfollowContacts(Trigger.old);
           
           }
     }      
}