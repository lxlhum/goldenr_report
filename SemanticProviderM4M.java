package com.forlink.exchange.settlesrv.hstd;

import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.BODY;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.FILETITLE;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.REPORTNAME;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.ROOT;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.TOP;

import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.forlink.exchange.pub.tools.PubTools;

/**
 * @see hstd->com.forlink.exchange.settlesrv.hstd.SemanticProviderM4M.java
 * @author Ryan
 * @CreateDate: May 27, 2015 2:50:25 PM
 * @version 1.0
 * @Description
 */
public class SemanticProviderM4M implements ISemanticProvider4All {

	private HSTDCreateElementImpl[] reportElements;
	private String title;
	private String type;
	private Map<String, Document> aDocMap = new HashMap<String, Document>();;
	private Set<String> aClientIDSet = new HashSet<String>();

	@Override
	public Map<String, Document> getDocMap(Map<String, Date> map4SettleDay,
			Logger logger) throws Exception {

		for (HSTDCreateElementImpl temp : reportElements) {
			temp.initAllDatas(map4SettleDay, logger);
			aClientIDSet.addAll(temp.getClientIDs());
			System.out.println(temp.getClientIDs());
		}
		for (String newId : aClientIDSet) {
			Document doc = getReportDocument();
			Element root = doc.getDocumentElement();
			Element body = doc.createElement(BODY.toLowerCase());
			root.appendChild(body);
			
			for (HSTDCreateElementImpl temp : reportElements) {
				temp.initReportElements(doc, logger,newId);
				if (!temp.getReportElements().isEmpty()) {
					Element aitem = (Element) temp.getReportElements().get(
							newId);
					body.appendChild(aitem);
					System.out.println(aitem);
				}
			}
			
			aDocMap.put(newId, doc);
		}
		return aDocMap;
	}

	@Override
	public String getTitle() {
		return title;
	}

	@Override
	public String getType() {
		return type;
	}

	public HSTDCreateElementImpl[] getReportElements() {
		return reportElements;
	}

	public void setReportElements(HSTDCreateElementImpl[] reportElements) {
		this.reportElements = reportElements;
	}

	public void setType(String type) {
		this.type = type;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public static Document getReportDocument() {

		Document doc = PubTools.getDocument();
		Element root = doc.createElement(ROOT.toLowerCase());

		Element file_title = doc.createElement(FILETITLE.toLowerCase());
		root.appendChild(file_title);

		Element report_name = doc.createElement(REPORTNAME.toLowerCase());
		root.appendChild(report_name);

		Element top = doc.createElement(TOP.toLowerCase());
		root.appendChild(top);

		doc.appendChild(root);

		return doc;
	}

}
