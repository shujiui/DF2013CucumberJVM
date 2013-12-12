Feature: US001 Design and build an application in Salesforce.com org that logged in 
user is able to make a different user chatter-follows an contact.


Scenario: TC01 By creating Contact Relationship record that associates 
demo user and demo contact record, demo user starts following the demo contact record. 

Given chatter admin user is created in Salesforce.com test org. 
And demo user is created in Salesforce.com test org. 
And chatter admin user is logged in to the org.
And demo contact record is created in the org. 

When chatter admin user associates demo user record and demo contact record by creating a Contact Relationship record.
Then demo user starts following demo contact in Chatter. 


Scenario: TC02 the chatter admin user deletes the Contact Relationship record that associates 
the demo user and the demo contact record. 
the demo user stops following the demo contact record.

Given the chatter admin user is logged in to the org.
And the demo user is following the demo contact record by the creation of the Contact Relationship record

When chatter admin user deletes the Contact Relationship record
Then the demo user stops following the demo contact record. 
 