package cucumber.com.dreamforce.selenium.factory;

import com.thoughtworks.selenium.Selenium;
/**
 * SeleniumBuilder
 * @author Shuji Ui
 * @version Oct 27 2013
 */
public class SeleniumBuilder {
      public static Selenium build(SeleniumFactory sf){
    	  Selenium sele = sf.getSelenium();
    	  return sele;
      }
}
