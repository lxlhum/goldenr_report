package com.forlink.exchange.settlesrv.hstd;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

/**
 * @see hstd->com.forlink.exchange.settlesrv.hstd.AbstractHstdSettleReports.java
 * @author Ryan
 * @CreateDate: May 9, 2015 2:14:27 PM
 * @version 1.0
 * @Description 
 */
public abstract class AbstractHstdSettleReports {
	// 部署使用这个spring地址 /app/hstd/apps/settlesrv/bin
//	ApplicationContext ctx = new FileSystemXmlApplicationContext("D:/semanticprovider-config.xml");
		ApplicationContext ctx = new FileSystemXmlApplicationContext("semanticprovider-config.xml");

	public ApplicationContext getCtx() {
		return ctx;
	}

}

