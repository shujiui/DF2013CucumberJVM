/**
* @author       SonomaPartners
* @date         09/25/13
* @description  Unit Tests for SNM_ChatterFollowTriggerUtil
* 
*               
-----------------------------------------------------------------------------
*    Developer                    Date                Description
*    -----------------------------------------------------------------------------
*    Shuji Ui                  09/26/2013             unit test for followingContact method
*/
@isTest
private class SNM_ChatterFollowTriggerUtilTest {

/**
   unit test for followContacts method
   test steps
   
   1. create 2 users
   2. create 3 contacts
   3. create 10 SNM_Contact_Follow__c records 
     a. include all combination of the users and the contacts
     b. duplicate a. 
   4. check the 2 users are following 3 contacts
   
*/
    static testMethod void followContactsTest() {
    	SNM_ChatterFollowTriggerUtilTest tests = new SNM_ChatterFollowTriggerUtilTest();
    	// 1. and 2.
    	tests.setup();
    	//3.
    	tests.createTestConFollows();
    	
    	List<EntitySubscription> subscriptions = [select parentId,
        												 subscriberId
        										  from	 EntitySubscription
        										  where   subscriberid in :tests.listOfUsers];
        //4. the query should return 6 EntitySubscription records
        System.assert(subscriptions.size()==6);
    }

/**
   unit test for unfollowContacts method
   test steps
   
   1. create 2 users
   2. create 3 contacts
   3. create  SNM_Contact_Follow__c records mapping above
   4. delete 4 pairs   
   5. check the 4 pairs are deleted  
   
*/  
    static testMethod void unfollowContactsTest() {
        SNM_ChatterFollowTriggerUtilTest tests = new SNM_ChatterFollowTriggerUtilTest();
    	// 1. and 2.
    	tests.setup();
    	//3.
    	tests.createTestConFollows();
    	//.4 
    	List<SNM_Contact_Follow__c> listOfConFollowToBeDeleted = new List<SNM_Contact_Follow__c>() ;
    	listOfConFollowToBeDeleted.add(tests.listOfConFollows[0]);
    	listOfConFollowToBeDeleted.add(tests.listOfConFollows[1]);
    	listOfConFollowToBeDeleted.add(tests.listOfConFollows[2]);
    	listOfConFollowToBeDeleted.add(tests.listOfConFollows[3]);
    	delete listOfConFollowToBeDeleted;
    	List<EntitySubscription> subscriptions = [select parentId,
        												 subscriberId
        										  from	 EntitySubscription
        										  where   subscriberid in :tests.listOfUsers];
        //5. the query should return 2 EntitySubscription records
        //System.Debug('size='+ subscriptions.size() + ' unit test ##############');
        System.assert(subscriptions.size()==2);
    	//the user should be listOfUsers[1].Id   	
    	System.assertEquals(subscriptions[0].subscriberId,tests.listOfUsers[1].Id);
    	//the user should be listOfUsers[1].Id
    	System.assertEquals(subscriptions[1].subscriberId, tests.listOfUsers[1].Id);
    }

/**
   unit test for unfollowAndFollowContacts method
   test steps
   
   1. create 2 users
   2. create 3 contacts
   3. create  SNM_Contact_Follow__c records mapping above
   4. update 3 pairs   
   5. check 3 pairs are updated  
   
*/ 
    static testMethod void unfollowAndFollowContacts() {
        SNM_ChatterFollowTriggerUtilTest tests = new SNM_ChatterFollowTriggerUtilTest();
    	// 1. and 2.
    	tests.setup();
    	//3.
    	tests.createTestConFollows();
        //4. 
        tests.listOfConFollows[3].User__c= tests.listOfUsers[0].Id;
        tests.listOfConFollows[4].User__c= tests.listOfUsers[0].Id;
        tests.listOfConFollows[5].User__c= tests.listOfUsers[0].Id;
        
        update tests.listOfConFollows;
        
        //5. this should return only 3 now because updated vaule are dupes  
        List<EntitySubscription> subscriptions = [select parentId,
        												 subscriberId
        										  from	 EntitySubscription
        										  where   subscriberid in :tests.listOfUsers];
        
    	System.assert(subscriptions.size()==3);
    }
    
    
    // create 2 users
    // create 3 contacts
    // create all combination of SMN_Contact_Follow__c records
    List<User>    listOfUsers;
    List<Contact> listOfContacts;
    List<SNM_Contact_Follow__c> listOfConFollows;
    private void setup(){
    	
       //listOfUsers = SmartFactory.createSObjectList('User', false, 2);
       Profile p = [select id from profile where name='Standard User'];
       
       listOfUsers = new List<User>();
       listOfUsers.add( new User(alias = 'standt1', email='standarduser01@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing01', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='standarduser01@baird.com'));
       
       listOfUsers.add( new User(alias = 'standt2', email='standarduser02@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing02', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='standarduser02@baird.com'));
       insert listOfUsers;
       
       Account testAcct = new Account(Name = 'Test Account');
       insert testAcct;
       
       listOfContacts = new List<Contact>();
       listOfContacts.add(new Contact(AccountId=testAcct.Id, LastName = 'test01'));
       listOfContacts.add(new Contact(AccountId=testAcct.Id, LastName = 'test02'));
       listOfContacts.add(new Contact(AccountId=testAcct.Id, LastName = 'test03'));       
       insert listOfContacts;
       
    }
    private void createTestConFollows(){
    	 listOfConFollows = new List<SNM_Contact_Follow__c>();
         listOfConFollows.add(new SNM_Contact_Follow__c(
         												User__c=listOfUsers[0].Id,
         												Contact__c=listOfContacts[0].id)
         												);
         listOfConFollows.add(new SNM_Contact_Follow__c(
         												User__c=listOfUsers[0].Id,
         												Contact__c=listOfContacts[1].id)
         												);
          listOfConFollows.add(new SNM_Contact_Follow__c(
         												User__c=listOfUsers[0].Id,
         												Contact__c=listOfContacts[2].id)
         												);
          listOfConFollows.add(new SNM_Contact_Follow__c(
         												User__c=listOfUsers[1].Id,
         												Contact__c=listOfContacts[0].id)
         												);
         listOfConFollows.add(new SNM_Contact_Follow__c(
         												User__c=listOfUsers[1].Id,
         												Contact__c=listOfContacts[1].id)
         												);
          listOfConFollows.add(new SNM_Contact_Follow__c(
         												User__c=listOfUsers[1].Id,
         												Contact__c=listOfContacts[2].id)
         												);  
         												
         insert listOfConFollows;                                 
    }
}