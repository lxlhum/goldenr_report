package com.forlink.exchange.settlesrv.hstd;

import static com.forlink.exchange.settlesrv.hstd.HstdReportPubTools.insertBodyItem;
import static com.forlink.exchange.settlesrv.hstd.HstdReportPubTools.insertTotal;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.forlink.exchange.pub.db.DBUtil;
import com.forlink.exchange.pub.tools.ResultMap;

/**
 * @see hstd->com.forlink.exchange.settlesrv.hstd.HSTDCreateElementImpl.java
 * @author Ryan
 * @CreateDate: May 27, 2015 5:09:59 PM
 * @version 1.0
 * @Description
 */
@SuppressWarnings({"unused","unchecked","static-access"})
public class HSTDCreateElementImpl implements IHSTDCreateElement {
	private Set<String> clientIDs = new HashSet<String>();
	private Map<String, Element> reportElements = new HashMap<String, Element>();
	private String sqlMapStr;
	private String bodyitem;
	private String item;
	private String total;
	private List<ResultMap> lists;

	public void initAllDatas(Map conMap, Logger logger)
			throws Exception {
		List<ResultMap> lists = getSqlMapResult(conMap);
		setLists(lists);
		setClientIDs(lists, logger);
	}

	@SuppressWarnings("unchecked")
	public List<ResultMap> getSqlMapResult(Map conMap) throws Exception {
		return DBUtil.getSqlMap().queryForList(getSqlMapStr(), conMap);
	}

	public String getSqlMapStr() {
		return sqlMapStr;
	}

	public void setSqlMapStr(String sqlMapStr) {
		this.sqlMapStr = sqlMapStr;
	}

	public String getBodyitem() {
		return bodyitem;
	}

	public void setBodyitem(String bodyitem) {
		this.bodyitem = bodyitem;
	}

	public String getItem() {
		return item;
	}

	public void setItem(String item) {
		this.item = item;
	}

	public String getTotal() {
		return total;
	}

	public void setTotal(String total) {
		this.total = total;
	}

	// 提供某个SQL查询出的全部人员名单的Set
	public void setClientIDs(List<ResultMap> lists, Logger logger) {
		Set<String> clientIDs = new HashSet<String>();
		for (ResultMap rtMap : lists) {
			String clientId = rtMap.getString("client_id");
			if (!"".equals(clientId))
				clientIDs.add(clientId);
		}
		this.clientIDs = clientIDs;
	}

	@Override
	public Set<String> getClientIDs() {
		return clientIDs;
	}

	private void creatBodyItemForAll(String lowerCase, String itemstring,
			String newId, List<ResultMap> lists, Element item,
			Map<Object, Double> mapTotal, Logger logger) {
		int seq = 0;
		for (ResultMap rtMap : lists) {
			String clientId = rtMap.getString(lowerCase);
			if (!"".equals(clientId) && newId.equals(clientId)) {
				insertBodyItem(item, rtMap, ++seq, mapTotal, itemstring, logger);
			}
		}
	}

	public void initReportElements(Document doc, Logger logger,String newId) {

		Element el = doc.createElement(getBodyitem());
		Map<String, Element> reportElements = new HashMap<String, Element>();
			Map<Object, Double> mapTotal = new HashMap<Object, Double>();
			creatBodyItemForAll("client_id", getItem(), newId, getLists(), el,
					mapTotal, logger);
			if (mapTotal.size() > 0) {
				insertTotal(el, mapTotal, getTotal(), logger);
			}
			reportElements.put(newId, el);
		this.reportElements = reportElements;

	}

	@Override
	public Map<String, Element> getReportElements() {
		return reportElements;
	}

	public List<ResultMap> getLists() {
		return lists;
	}

	public void setLists(List<ResultMap> lists) {
		this.lists = lists;
	}

}
