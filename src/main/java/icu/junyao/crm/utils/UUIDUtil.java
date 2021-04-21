package icu.junyao.crm.utils;

import java.util.UUID;

/**
 * @author wu
 */
public class UUIDUtil {
	
	public static String getUUID(){
		
		return UUID.randomUUID().toString().replaceAll("-","");
		
	}
	
}
