package com.forlink.exchange.settlesrv.hstd;

import static com.forlink.exchange.settlesrv.hstd.HstdReportPubTools.getAllClientID;
import static com.forlink.exchange.settlesrv.hstd.HstdReportPubTools.insertBodyItem;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.forlink.exchange.pub.db.DBUtil;
import com.forlink.exchange.pub.tools.ResultMap;


/**
 * @see hstd->com.forlink.exchange.settlesrv.hstd.SemanticProviderOne4All.java
 * @author Ryan
 * @CreateDate: May 20, 2015 2:04:50 PM
 * @version 1.0
 * @Description
 */
public class SemanticProviderOne4All implements ISemanticProvider4All {

	private String sqlmapstr;
	private String title;
	private String type;
	private String[] bodyitem;
	private Map<String, Document> aDocMaps = new HashMap<String, Document>();
	private Map<String, Integer> clientMap = new HashMap<String, Integer>();

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Document> getDocMap(Map<String, Date> conMap4SettleDay,Logger logger)
			throws Exception {
		List<ResultMap> item_lists = getSqlResult(conMap4SettleDay);
		if (item_lists != null) {
			getAllClientID(clientMap, item_lists);
			for (String newId : clientMap.keySet()) {

				Document doc = HstdReportPubTools
						.getReportDocument(getBodyitem());
				Element root = doc.getDocumentElement();
				Element listing_body = (Element) root.getElementsByTagName(
						getBodyitem()[0].toLowerCase()).item(0);
				Element spread_body = (Element) root.getElementsByTagName(
						getBodyitem()[1].toLowerCase()).item(0);
				Element spreadlisting_body = (Element) root
						.getElementsByTagName(getBodyitem()[2].toLowerCase())
						.item(0);
				Element csgdelaying_body = (Element) root.getElementsByTagName(
						getBodyitem()[3].toLowerCase()).item(0);

				Map<Object, Double> listingTotal = new HashMap<Object, Double>();
				Map<Object, Double> spreadTotal = new HashMap<Object, Double>();
				Map<Object, Double> spreadlistingTotal = new HashMap<Object, Double>();
				Map<Object, Double> csgdelayingTotal = new HashMap<Object, Double>();
				creatBodyItemForAll(logger,"client_id", "item", newId, item_lists,
						listingTotal, spreadTotal, spreadlistingTotal,
						csgdelayingTotal, listing_body, spread_body,
						spreadlisting_body, csgdelaying_body);

				if (listingTotal.size() > 0) {
					// 1.连续/挂牌/协议成交明细 记录合计项
					insertTotal(listing_body, listingTotal, "total");
				}

				if (spreadTotal.size() > 0) {
					// 2.隔日组合成交明细 记录合计项
					insertTotal(spread_body, spreadTotal, "total");
				}

				if (spreadlistingTotal.size() > 0) {
					// 3.定制组合成交明细 记录合计项
					insertTotal(spreadlisting_body, spreadlistingTotal, "total");
				}

				if (csgdelayingTotal.size() > 0) {
					// 4.已付款合同选货展期交易明细 记录合计项
					insertTotal(csgdelaying_body, csgdelayingTotal, "total");
				}

				aDocMaps.put(newId, doc);
			}

		}

		return aDocMaps;
	}

	private void insertTotal(Element body,
			Map<Object, Double> mapTotal, String totalString) {
		Document doc = body.getOwnerDocument();
		Element total = doc.createElement(totalString);
		body.appendChild(total);
		for (Object totalTag : mapTotal.keySet()) {
			Element elName = doc.createElement("TOTAL_"
					+ totalTag.toString().toUpperCase());
			elName.setTextContent(String.valueOf(mapTotal.get(totalTag)));
			total.appendChild(elName);
		}
	}

	private void creatBodyItemForAll(Logger logger,String lowerCase, String itemstring,
			String newId, List<ResultMap> lists,
			Map<Object, Double> listingTotal, Map<Object, Double> spreadTotal,
			Map<Object, Double> spreadlistingTotal,
			Map<Object, Double> csgdelayingTotal, Element... item) {

		String source_flag = "";
		int listingseq = 0;
		int spreadseq = 0;
		int spreadlistingseq = 0;
		int csgdelayingseq = 0;

		for (ResultMap rtMap : lists) {
			String clientId = rtMap.getString(lowerCase);
			source_flag = rtMap.getString("source_flag", "");
			if (!"".equals(clientId) && newId.equals(clientId)) {
				if (source_flag.startsWith("0") || "1".equals(source_flag)) {// 连续/挂牌/协议成交
					insertBodyItem(item[0], rtMap, ++listingseq, listingTotal,
							itemstring, logger);
				} else if ("2".equals(source_flag) || "3".equals(source_flag)) { // 隔日组合成交
					insertBodyItem(item[1], rtMap, ++spreadseq, spreadTotal,
							itemstring, logger);
				} else if ("4".equals(source_flag)) { // 定制组合成交
					insertBodyItem(item[2], rtMap, ++spreadlistingseq,
							spreadlistingTotal, itemstring, logger);
				} else if ("5".equals(source_flag)) { // 已付款合同选货展期交易明细
					insertBodyItem(item[3], rtMap, ++csgdelayingseq,
							csgdelayingTotal, itemstring, logger);
				}
			}
		}
	}

	@SuppressWarnings("unchecked")
	private List<ResultMap> getSqlResult(Map<String, Date> conMap4SettleDay)
			throws Exception {
		return DBUtil.getSqlMap()
				.queryForList(getSqlmapstr(), conMap4SettleDay);
	}

	public String getSqlmapstr() {
		return sqlmapstr;
	}

	public void setSqlmapstr(String sqlmapstr) {
		this.sqlmapstr = sqlmapstr;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String[] getBodyitem() {
		return bodyitem;
	}

	public void setBodyitem(String[] bodyitem) {
		this.bodyitem = bodyitem;
	}

}
