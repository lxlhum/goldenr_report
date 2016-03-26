package com.forlink.exchange.settlesrv.hstd;

import java.util.Map;
import java.util.Set;

import org.w3c.dom.Element;

/**
 * @see hstd->com.forlink.exchange.settlesrv.hstd.IHSTDCreateElement.java
 * @author Ryan
 * @CreateDate: May 27, 2015 5:02:13 PM
 * @version 1.0
 * @Description
 */
public interface IHSTDCreateElement {

	// 提供某个SQL查询出的报表数据子项的Map
	public Map<String, Element> getReportElements();

	// 提供某个SQL查询出的全部人员名单的Set
	public Set<String> getClientIDs();
}
