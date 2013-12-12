package cucumber.com.dreamforce.selenium.factory;

import com.thoughtworks.selenium.DefaultSelenium;
import com.thoughtworks.selenium.Selenium;

import cucumber.com.dreamforce.constant.DFConstants;

/**
 * @author Shuji Ui
 * @version Oct 27 2013
 */
public class SeleniumFactory_Impl_Local_Firefox implements SeleniumFactory{
    String url;
    /**
     * @param url
     */
    public SeleniumFactory_Impl_Local_Firefox(String url){
    	this.url = url;
    }
	/**
       @return Selenium
       with local firefox browser
    */
	
	 public Selenium getSelenium(){ 
		Selenium sele = new DefaultSelenium(DFConstants.LOC_SERVER, DFConstants.LOC_SERVER_PORT, 
				DFConstants.FIREFOX,url);
       
		return sele; 
	 }
}
