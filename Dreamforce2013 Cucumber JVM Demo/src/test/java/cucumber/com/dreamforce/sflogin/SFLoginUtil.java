package cucumber.com.dreamforce.sflogin;
 
//Selenium
import com.thoughtworks.selenium.DefaultSelenium;
import com.thoughtworks.selenium.Selenium;

import cucumber.com.dreamforce.constant.DFConstants;
import cucumber.com.dreamforce.selenium.factory.SeleniumBuilder;
import cucumber.com.dreamforce.selenium.factory.SeleniumFactory_Impl_Local_Firefox;

public class SFLoginUtil {
		
	public static void startSelenium(Selenium selenium){

		selenium.start();
	}
	
	public static void userLogin(Selenium selenium, String username, String password){
		selenium.open("/");
		selenium.click("//div[@id='usrn']/div");
		selenium.type("//input[@id='username']", username);
		selenium.click("//input[@id='password']");
		selenium.type("//input[@id='password']", password);
		selenium.click("//button[@id='Login']");
		selenium.waitForPageToLoad("30000");
	}
		
}