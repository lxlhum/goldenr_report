package com.forlink.exchange.settlesrv.hstd;

import static com.forlink.exchange.settlesrv.hstd.HstdReportPubTools.creatXMLforClient;

import java.util.Date;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;

import com.forlink.exchange.entity.model.AssociatorInfo;
import com.forlink.exchange.pub.RetDefine;
import com.forlink.exchange.settlesrv.ContractFInfo;

/**
 * Hstd新增结算账单(生成相应的XML文件)
 * @author yangtz
 */
@SuppressWarnings({"unused","unchecked","static-access"})
public class HstdSettleReports extends AbstractHstdSettleReports {
	private Logger logger;
	private String settleDay;// 结算日
	private String nextSettleDay;
	private String statDay;
	private String curMonth;
	private String monthBeginDay;
	private Date curEndTime;// 当前数据统计结束时间
	private Date curBeginTime;// 当前数据统计开始时间
	private String assocDir;// 会员文件主目录
	private String dayDir;// 年月日目录
	private Date month_l;
	private String last_month2;//上月末
	private Date last_month;
	
	// 会员信息Map
	private Map<String, AssociatorInfo> associatorInfoMap = new HashMap<String, AssociatorInfo>();

	public HstdSettleReports(Logger log) throws Exception {
		logger = log;
	}

	public void initReports(String settleDay, String lastSettleDay,
			String nextSettleDay, String curMonth, String monthBeginDay,
			String statMonth, String statDay, Date curBeginTime,
			Date curEndTime, Date monthBeginTime, Date lastBeginTime, int rate,
			double taxRate, String reports, String centerDir, String assocDir,
			String dayDir, Map<String, AssociatorInfo> associatorInfoMap,
			Map<String, String> clientMap,
			Map<String, ContractFInfo> contractInfoMap, String last_month2) {
		this.settleDay = settleDay;
		this.nextSettleDay = nextSettleDay;
		this.statDay = statDay;
		this.curMonth = curMonth;
		this.curBeginTime = curBeginTime;
		this.monthBeginDay = monthBeginDay;
		this.curEndTime = curEndTime;
		this.assocDir = assocDir;
		this.dayDir = dayDir;
		this.associatorInfoMap = associatorInfoMap;
		this.last_month2 = last_month2;
	}

	private static EnumSet<AdapterEnum4Spring> enumSet = EnumSet
			.allOf(AdapterEnum4Spring.class);

	// 生成Hstd结算报表
	public String[] doXmlReports() throws Exception {
		String retStr[];
		for (AdapterEnum4Spring beanid : enumSet) {
			retStr = doReport(beanid.toString());
			if (!retStr[0].equals(RetDefine.pub_success[0])) {
				logger.error(retStr[1]);
				return retStr;
			}
		}
		return RetDefine.pub_success;
	}

	@SuppressWarnings("unchecked")
	private String[] doReport(String tagspring) throws Exception {
		ISemanticProvider4All aProvider = (ISemanticProvider4All) getCtx()
				.getBean(tagspring);
		logger.info("开始生成" + aProvider.getTitle());
		Map<String, Document> aDocMaps = aProvider.getDocMap(getCondMap(),
				logger);
		for (String newId : aDocMaps.keySet()) {
			// 生成XML文件
			creatXMLforClient(newId, aDocMaps.get(newId), aProvider.getTitle(),
					aProvider.getType(), associatorInfoMap, settleDay, statDay,
					assocDir, dayDir);
			// logger.info("用户:" + newId + aProvider.getType() + "_XML生成成功");
		}

		return RetDefine.pub_success;

	}

	@SuppressWarnings("unchecked")
	private Map condMap = new HashMap();

	@SuppressWarnings("unchecked")
	public Map getCondMap() {
		condMap.put("SUM_DAY_C", nextSettleDay);
		condMap.put("SUM_DAY", settleDay);
		condMap.put("beginTime", curBeginTime);
		condMap.put("endTime", curEndTime);
		condMap.put("month_t", curMonth);
		condMap.put("monthBeginDay", monthBeginDay);
		condMap.put("last_month", last_month2);
		return condMap;
	}

	public void setCondMap(Map<String, Date> condMap) {
		this.condMap = condMap;
	}
}