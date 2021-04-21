package icu.junyao.crm.utils;

/**
 * @author wu
 */
public class ServiceFactory {
	
	public static Object getService(Object service){
		
		return new TransactionInvocationHandler(service).getProxy();
		
	}
	
}
