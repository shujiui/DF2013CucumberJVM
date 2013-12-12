package cucumber.com.dreamforce.sflogin;
/**
 * SFLogin_Impl_Demo_User
 * 
 * @author Shuji Ui
 * @version Oct 27 2013
 */
import com.thoughtworks.selenium.Selenium;

import cucumber.com.dreamforce.constant.DFConstants;

public class SFLogin_Impl_Demo_User implements SFLogin {
    Selenium selenium;
    private SFLogin_Impl_Demo_User(){
    	//TODO: throw exception
    }
	public SFLogin_Impl_Demo_User(Selenium sele){
    	selenium = sele;
    }
	@Override
	public void loginToSalesforce() {
	     SFLoginUtil.startSelenium(selenium);
	     SFLoginUtil.userLogin(selenium, DFConstants.DEMO_USER_USERNAME,DFConstants.DEMO_USER_PASSWORD);
	}

}
