package com.forlink.exchange.settlesrv.hstd;

import java.util.Date;
import java.util.Map;

import org.w3c.dom.Document;
import org.apache.log4j.Logger;

/**
 * @see hstd->com.forlink.exchange.settlesrv.hstd.ISemanticProvider4All.java
 * @author Ryan
 * @CreateDate: May 20, 2015 1:59:18 PM
 * @version 1.0
 * @Description 
 */
public interface ISemanticProvider4All {
	public String getTitle();
	public String getType();
	public Map<String, Document> getDocMap(Map<String, Date> aMap4SettleDay,Logger logger) throws Exception;
}

