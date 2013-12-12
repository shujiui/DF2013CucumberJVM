package cucumber.com.dreamforce.selenium.factory;
import com.thoughtworks.selenium.Selenium;
/**
 * Selenium Factory Interface
 * @author Shuji Ui
 * @version Oct 27 2013
 *
 */
public interface SeleniumFactory {
	/**
	 * @return Selenium
	 */
    public Selenium getSelenium();
 }
