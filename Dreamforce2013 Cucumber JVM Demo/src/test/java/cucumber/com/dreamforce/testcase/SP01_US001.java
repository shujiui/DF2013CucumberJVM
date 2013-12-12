package cucumber.com.dreamforce.testcase;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.util.Date;

import com.thoughtworks.selenium.Selenium;
import com.thoughtworks.selenium.SeleniumException;

import cucumber.annotation.After;
import cucumber.annotation.Before;
import cucumber.annotation.en.Given;
import cucumber.annotation.en.Then;
import cucumber.annotation.en.When;
import cucumber.com.dreamforce.constant.DFConstants;
import cucumber.com.dreamforce.selenium.factory.SeleniumBuilder;
import cucumber.com.dreamforce.selenium.factory.SeleniumFactory_Impl_Local_Firefox;
import cucumber.com.dreamforce.sflogin.SFLoginBuilder;
import cucumber.com.dreamforce.sflogin.SFLogin_Impl_Demo_User;

/**
 * @author Shuji Ui
 * Sprint 1 User Story 001 feature implementation
 * 
 * Feature: US001 Design and build an application in Salesforce.com org 
 * that logged in user is able to make a different user chatter-follows an contact. 
 * 
 * Hello DF2013!
 */

public class SP01_US001 {
	
	private static Selenium selenium;
	private boolean isFeatureEnd = false;
	private String demoUserContactName = "demo-"+ new Date().getTime();
	
	/**
	 * @author Shuji Ui
	 * 
	 * Create Selenium instance here 
	 */
	
	@Before
	public void initSelenium() throws Exception {
		// Selenium calling test.salesforce.com
		if(selenium ==null){
			selenium = SeleniumBuilder.build(new SeleniumFactory_Impl_Local_Firefox(DFConstants.SF_PROD));
		}
 	}

	/**
	 * @author Shuji Ui
	 * 
	 * Scenario: TC01 By creating Contact Relationship record that associates 
	 * demo user and demo contact record, demo user starts following the demo contact record. 
	 *
	 */

	@Given("^chatter admin user is created in Salesforce.com test org.$")
	public void chatter_admin_user_is_created_in_Salesforce_com_test_org() throws Throwable {
		//Users are created in the demo org
		//We don't need to test this.	
	}

	@Given("^demo user is created in Salesforce.com test org.$")
	public void demo_user_is_created_in_Salesforce_com_test_org() throws Throwable {
		//Users are created in the demo org
		//We don't need to test this.	
	}

	@Given("^chatter admin user is logged in to the org.$")
	public void chatter_admin_user_is_logged_in_to_the_org() throws Throwable {
		//used login builder 
		SFLoginBuilder.build(new SFLogin_Impl_Demo_User(selenium));
	}

	@Given("^demo contact record is created in the org.$")
	public void demo_contact_record_is_created_in_the_org() throws Throwable {
		// create demo Contact here 
		selenium.click("//a[contains(text(),'Contacts')]");
		selenium.waitForPageToLoad("30000");
		selenium.click("//input[@name='new']");
		selenium.waitForPageToLoad("30000");
		selenium.type("//input[@id='name_lastcon2']", "demo");
		selenium.click("//input[@name='save']");
		selenium.waitForPageToLoad("30000");	
	}

	@When("^chatter admin user associates demo user record and demo contact record by creating a Contact Relationship record.$")
	public void chatter_admin_user_associates_demo_user_record_and_demo_contact_record_by_creating_a_Contact_Relationship_record() throws Throwable {
		selenium.click("//a[contains(text(),'Contact Relationships')]");
		selenium.waitForPageToLoad("30000");
		selenium.click("//input[@name='new']");
		selenium.waitForPageToLoad("30000");
		selenium.type("//input[@id='CF00Ni000000AaCR4']", "demo");
		selenium.type("//input[@id='CF00Ni000000AaCR3']", "demo");
		selenium.click("xpath=(//input[@name='save'])[2]");
		selenium.waitForPageToLoad("30000");
	}

	@Then("^demo user starts following demo contact in Chatter.$")
	public void demo_user_starts_following_demo_contact_in_Chatter() throws Throwable {
		
		try{
			selenium.click("//a[contains(text(),'Contacts')]");
			selenium.waitForPageToLoad("30000");
			selenium.click("//a[contains(text(),'demo')]");
			selenium.waitForPageToLoad("30000");
			selenium.click("//span[@id='moreFollowersLink']");
			selenium.waitForPageToLoad("30000");
			// check if text demo is on the moreFollowersLink modal window
			assertTrue( selenium.isTextPresent("demo"));
			selenium.waitForPageToLoad("30000");
			selenium.click("//input[@id='cancel']");
			
		}catch (SeleniumException se){
		   fail(se.getMessage());
           // DFUtil.errorOutput(se.getMessage());
		}
	}

	/**
	 * @author Shuji Ui
	 * 
	 * Scenario: TC02 the chatter admin user deletes the Contact Relationship record that associates the demo user and the demo contact record. 
	 * the demo user stops following the demo contact record.
	 *
	 */
	
	@Given("^the chatter admin user is logged in to the org.$")
	public void the_chatter_admin_user_is_logged_in_to_the_org() throws Throwable {
		// already logged in from previous scenario
	}

	@Given("^the demo user is following the demo contact record by the creation of the Contact Relationship record$")
	public void the_demo_user_is_following_the_demo_contact_record_by_the_creation_of_the_Contact_Relationship_record() throws Throwable {
	    // previous scenario the Contact Relationship record is created
	}

	@When("^chatter admin user deletes the Contact Relationship record$")
	public void chatter_admin_user_deletes_the_Contact_Relationship_record() throws Throwable {
		selenium.click("//a[contains(text(),'Contact Relationships')]");
		selenium.waitForPageToLoad("30000");
		selenium.click("//a[contains(text(),'CR-')]");
		selenium.waitForPageToLoad("30000");
		selenium.click("xpath=(//input[@name='del'])[2]");
		assertTrue(selenium.getConfirmation().matches("^Are you sure[\\s\\S]$"));
	}

	@Then("^the demo user stops following the demo contact record.$")
	public void the_demo_user_stops_following_the_demo_contact_record() throws Throwable {
	    selenium.click("//a[contains(text(),'Contacts')]");
		selenium.waitForPageToLoad("30000");
		selenium.click("//a[contains(text(),'demo')]");
		selenium.waitForPageToLoad("30000");
		//check if text "No followers." on the Contact detail page
		assertTrue( selenium.isTextPresent("No followers."));
		isFeatureEnd = true;
	}

	@After
	public void tearDown() throws Exception {
			
		if(isFeatureEnd){
			try{
				// here deleting the demo contact record and log out
				selenium.click("//input[@name='del']");
				assertTrue(selenium.getConfirmation().matches("^Are you sure[\\s\\S]$"));
				selenium.click("//a[contains(text(),'Setup')]");
				selenium.waitForPageToLoad("30000");
				selenium.click("//div[@id='userNavButton']");
				selenium.click("//a[contains(text(),'Logout')]");
				selenium.waitForPageToLoad("30000");
			
				// close windows
				selenium.close();
				selenium.stop();
			}catch (SeleniumException se){
			}
		}
	}
	
}
