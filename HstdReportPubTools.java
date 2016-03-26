package com.forlink.exchange.settlesrv.hstd;

import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.BODY;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.CONTENT;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.FILETITLE;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.INVENTORYITEM;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.INVENTORYITEMTOTAL;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.ISNOTOTAL;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.ISTOTAL;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.ITEM;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.REPORTNAME;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.ROOT;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.SEQ;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.TOP;
import static com.forlink.exchange.settlesrv.hstd.ReportTableNameSet.TOTAL_COUNT_GOODS;

import java.io.File;
import java.text.DecimalFormat;
import java.util.EnumSet;
import java.util.List;
import java.util.Map;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.forlink.exchange.entity.model.AssociatorInfo;
import com.forlink.exchange.pub.convert.Converter;
import com.forlink.exchange.pub.tools.PubTools;
import com.forlink.exchange.pub.tools.ResultMap;
import com.forlink.exchange.pub.tools.StringUtil;

/**
 * @see hstd->com.forlink.exchange.settlesrv.hstd.HstdReportPubTools.java
 * @author Ryan
 * @CreateDate: Apr 7, 2015 2:09:48 PM
 * @version 1.0
 * @Description
 */
public class HstdReportPubTools {

	static DecimalFormat goodsQttFormatter = new DecimalFormat("#0.######");// 货物数量/重量格式化
	private static Transformer trans = null;
	private static StreamResult result = null;
	private static String fileName;
	private static EnumSet<ForMoneyFind> enumSet = EnumSet
			.allOf(ForMoneyFind.class);

	// 2.数量处理方法：elAsseembleForNum
	public static void countGoods(Document item_doc, Element myElement,
			ResultMap rtMap, String elementassemble, long onlyForTotal) {
		Element elName = item_doc.createElement(elementassemble);
		elName.setTextContent(String.valueOf(onlyForTotal));
		myElement.appendChild(elName);
	}

	// 3.金额处理方法：elAsseembleForMoney
	public static void elAsseembleForMoney(Document item_doc,
			Element myElement, ResultMap rtMap, String elementassemble,
			char switchCheckOnly, long onlyForTotal) {
		Element elName = item_doc.createElement(elementassemble);
		// 金额处理方法 要使用Converter.formatFen2yuan(rtMap.getLong(***,0))
		switch (switchCheckOnly) {
		case ISNOTOTAL:
			elName.setTextContent(Converter.formatFen2yuan(rtMap.getLong(
					elementassemble.toLowerCase(), 0)));
			break;
		case ISTOTAL:
			elName.setTextContent(Converter.formatFen2yuan(onlyForTotal));
		}
		myElement.appendChild(elName);
	}

	// 4.货物重量格式化处理方法：elAsseembleForGoods
	public static void elAsseembleForGoods(Document item_doc,
			Element myElement, ResultMap rtMap, String elementassemble,
			long onlyForTotal) {
		Element elName = item_doc.createElement(elementassemble);
		// 货物重量格式化使用的特殊的工具goodsQttFormatter=DecimalFormat
		elName.setTextContent(goodsQttFormatter.format(rtMap.getDouble(
				elementassemble.toLowerCase(), 0)));
		myElement.appendChild(elName);
	}

	public static void insertTotal(Element body, long total_count_goods,
			Map<Object, Double> mapTotal) {

		Document doc = body.getOwnerDocument();
		Element total = doc.createElement(INVENTORYITEMTOTAL.toLowerCase());// inventoryitemtotal
		body.appendChild(total);

		Element countGoods = doc.createElement(TOTAL_COUNT_GOODS);
		countGoods.setTextContent(String.valueOf(total_count_goods));
		total.appendChild(countGoods);

		for (Object totalTag : mapTotal.keySet()) {
			Element elName = doc.createElement("TOTAL_"
					+ totalTag.toString().toUpperCase());
			elName.setTextContent(String.valueOf(mapTotal.get(totalTag)));
			total.appendChild(elName);
		}
	}

	public static void insertTotal(Element body, Map<Object, Double> mapTotal,
			String totalString, Logger logger) {
		DecimalFormat decimalFormat = new DecimalFormat("#0.######");// 格式化设置
		Document doc = body.getOwnerDocument();
		Element total = doc.createElement(totalString);
		body.appendChild(total);
		for (Object totalTag : mapTotal.keySet()) {
			Element elName = doc.createElement("TOTAL_"
					+ totalTag.toString().toUpperCase());
			elName.setTextContent(decimalFormat.format(mapTotal.get(totalTag)));
			total.appendChild(elName);
		}
	}

	public static void insertBodyItem(Element bodyTopItem, ResultMap rtMap,
			int seq, Map<Object, Double> mapTotal) {
		Document doc = bodyTopItem.getOwnerDocument();
		Element bodySubItem = doc.createElement(INVENTORYITEM.toLowerCase());
		bodyTopItem.appendChild(bodySubItem);
		elAddSEQ(doc, bodySubItem, rtMap, SEQ, seq);// 序号
		for (Object theField : rtMap.keySet()) {
			elAddField(doc, bodySubItem, rtMap, theField, mapTotal);
		}
	}

	public static void insertBodyItem(Element bodyTopItem, ResultMap rtMap,
			int seq, Map<Object, Double> mapTotal, String item, Logger logger) {
		Document doc = bodyTopItem.getOwnerDocument();
		Element bodySubItem = doc.createElement(item);
		bodyTopItem.appendChild(bodySubItem);
		elAddSEQ(doc, bodySubItem, rtMap, SEQ, seq);// 序号
		for (Object theField : rtMap.keySet()) {
			if (theField.equals("remark")) {
				continue;
			}
			elAddField(doc, bodySubItem, rtMap, theField, mapTotal, logger);
		}
	}

	public static void elAddField(Document doc, Element bodySubItem,
			ResultMap rtMap, Object theField, Map<Object, Double> mapTotal,
			Logger logger) {
		DecimalFormat decimalFormat = new DecimalFormat("#0.######");// 格式化设置
		Element elName = doc.createElement(theField.toString().toUpperCase());
		// 此处是由于没有想好如何进行XSL的可视化操作，进行的一个折中的处理办法
		
		//System.out.println("theField="+theField);
		//System.out.println("rtMap.get(theField)="+rtMap.get(theField));
		//System.out.println("rtMap.get(theField).getClass()="+rtMap.get(theField).getClass());
		//System.out.println("rtMap.get(theField).getClass().getName()="+rtMap.get(theField).getClass().getName());
		if (rtMap.get(theField).getClass().getName().equals("java.lang.String")) {
			elName.setTextContent(rtMap.getString(theField, ""));
		} else if (rtMap.get(theField).getClass().getName().equals(
				"java.math.BigDecimal")) {
			if (enumSet.toString().contains(theField.toString())) {
				elName.setTextContent(Converter.formatFen2yuan(rtMap.getLong(
						theField, 0)));
				if (mapTotal.containsKey(theField)) {
					mapTotal.put(theField, new Double(Converter
							.formatFen2yuan(rtMap.getLong(theField, 0)))
							+ mapTotal.get(theField));
				} else {
					mapTotal.put(theField, new Double(Converter
							.formatFen2yuan(rtMap.getLong(theField, 0))));
				}
			} else {
				elName.setTextContent(decimalFormat.format(rtMap.getDouble(
						theField, 0)));
				if (mapTotal.containsKey(theField)) {
					mapTotal.put(theField, new Double(decimalFormat
							.format(rtMap.getDouble(theField, 0)))
							+ mapTotal.get(theField));
				} else {
					mapTotal.put(theField, rtMap.getDouble(theField, 0));
				}
			}
		}
		bodySubItem.appendChild(elName);
	}

	public static void elAddField(Document doc, Element bodySubItem,
			ResultMap rtMap, Object theField, Map<Object, Double> mapTotal) {
		Element elName = doc.createElement(theField.toString().toUpperCase());
		elName.setTextContent(rtMap.getString(theField, ""));
		if (rtMap.get(theField).getClass().getName().equals(
				"java.math.BigDecimal")) {
			if (enumSet.contains(theField)) {
				if (mapTotal.containsKey(theField)) {
					mapTotal.put(theField, new Double(Converter
							.formatFen2yuan(rtMap.getLong(theField, 0)))
							+ new Double(mapTotal.get(theField)));
				} else {
					mapTotal.put(theField, new Double(Converter
							.formatFen2yuan(rtMap.getLong(theField, 0))));
				}
			} else {
				if (mapTotal.containsKey(theField)) {
					mapTotal.put(theField, new Double(rtMap
							.getLong(theField, 0))
							+ new Double(mapTotal.get(theField)));
				} else {
					mapTotal.put(theField, new Double(rtMap
							.getLong(theField, 0)));
				}
			}
		}
		bodySubItem.appendChild(elName);
	}

	public static void elAddSEQ(Document doc, Element bodySubItem,
			ResultMap rtMap, String seqString, int seq) {
		Element elSeq = doc.createElement(seqString);
		elSeq.setTextContent(String.valueOf(seq));
		bodySubItem.appendChild(elSeq);
	}

	public static void getAllClientID(List<ResultMap> itemLists,
			Map<String, Integer> clientMap) {
		int count = 0;
		for (ResultMap rtMap : itemLists) {
			String clientId = rtMap.getString("client_id");
			// 将用户查询出来，通过map去重
			if (!"".equals(clientId))
				clientMap.put(clientId, ++count);
		}
	}

	public static void getAllClientID(Map<String, Integer> clientMap,
			List<ResultMap>... allitemLists) {
		int count = 0;
		for (List<ResultMap> itemLists : allitemLists) {
			for (ResultMap rtMap : itemLists) {
				String clientId = rtMap.getString("client_id");
				// 将用户查询出来，通过map去重
				if (!"".equals(clientId))
					clientMap.put(clientId, ++count);
			}
		}
	}

	public static Document getReportDocument(String[] items) {

		Document doc = PubTools.getDocument();
		Element root = doc.createElement(ROOT.toLowerCase());

		Element file_title = doc.createElement(FILETITLE.toLowerCase());
		root.appendChild(file_title);

		Element report_name = doc.createElement(REPORTNAME.toLowerCase());
		root.appendChild(report_name);

		Element top = doc.createElement(TOP.toLowerCase());
		root.appendChild(top);

		Element body = doc.createElement(BODY.toLowerCase());
		root.appendChild(body);

		// 此处可以写一个循环，放自己的item
		for (String itemString : items) {
			Element your_item = doc.createElement(itemString.toLowerCase());
			body.appendChild(your_item);
		}

		doc.appendChild(root);

		return doc;
	}

	public static void creatXMLforClient(String newID, Document doc,
			String fileTitle, String fileFlag,
			Map<String, AssociatorInfo> associatorInfoMap, String settleDay,
			String statDay, String assocDir, String dayDir) {
		Element root = doc.getDocumentElement();
		// 客户对应的会员信息
		String associatorNo = StringUtil.subStrToStart(newID, 6);
		String assoRemark = associatorInfoMap.get(associatorNo).getRemarak();
		String associatorName = associatorInfoMap.get(associatorNo)
				.getFullName();
		// 补充报表信息
		Element file_title = (Element) root.getElementsByTagName(
				FILETITLE.toLowerCase()).item(0);
		file_title.setTextContent(assoRemark + "_" + settleDay + fileFlag);
		root.appendChild(file_title);
		Element report_name = (Element) root.getElementsByTagName(
				REPORTNAME.toLowerCase()).item(0);
		report_name.setTextContent(fileTitle);
		root.appendChild(report_name);

		Element top = (Element) root.getElementsByTagName(TOP.toLowerCase())
				.item(0);

		Element top_item1 = doc.createElement(ITEM.toLowerCase());
		top.appendChild(top_item1);
		Element top_item1_content = doc.createElement(CONTENT.toLowerCase());
		top_item1_content.setTextContent(assoRemark);
		top_item1.appendChild(top_item1_content);

		Element top_item2 = doc.createElement(ITEM.toLowerCase());
		top.appendChild(top_item2);
		Element top_item2_content = doc.createElement(CONTENT.toLowerCase());
		top_item2.appendChild(top_item2_content);
		top_item2_content.setTextContent(associatorName);

		Element item3 = doc.createElement(ITEM.toLowerCase());
		top.appendChild(item3);
		Element content = doc.createElement(CONTENT.toLowerCase());
		content.setTextContent(statDay);
		item3.appendChild(content);
		// 保存并生成XML文档
		fileName = assocDir + assoRemark + dayDir + assoRemark + "_"
				+ settleDay + fileFlag + ".xml";
		DOMSource dom = new DOMSource(doc);
		result = new StreamResult(new File(fileName));
		try {
			trans = TransformerFactory.newInstance().newTransformer();
		} catch (TransformerConfigurationException e) {
			e.printStackTrace();
		} catch (TransformerFactoryConfigurationError e) {
			e.printStackTrace();
		}
		try {
			trans.transform(dom, result);
		} catch (TransformerException e) {
			e.printStackTrace();
		}
	}

	public static void getAllClientID(Map<String, Integer> clientMap,
			Map<String, List<ResultMap>> item_lists) {
		int count = 0;
		for (String keyStr : item_lists.keySet()) {
			for (ResultMap rtMap : item_lists.get(keyStr)) {
				String clientId = rtMap.getString("client_id");
				// 将用户查询出来，通过map去重
				if (!"".equals(clientId))
					clientMap.put(clientId, ++count);
			}
		}
	}
}
