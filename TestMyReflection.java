package com.forlink.exchange.settlesrv.hstd;

import static com.forlink.exchange.settlesrv.hstd.HstdReportPubTools.creatXMLforClient;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.transform.Transformer;
import javax.xml.transform.stream.StreamResult;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;

import com.forlink.exchange.entity.base.InitData;
import com.forlink.exchange.entity.business.ITradeUtil;
import com.forlink.exchange.entity.business.SettleSrvImpl;
import com.forlink.exchange.entity.business.TradeUtilFactory;
import com.forlink.exchange.entity.dao.AssociatorInfoDAOImpl;
import com.forlink.exchange.entity.dao.ClientInfoDAOImpl;
import com.forlink.exchange.entity.dao.DailyFundSummaryDAOImpl;
import com.forlink.exchange.entity.dao.SettleTimeDAOImpl;
import com.forlink.exchange.entity.model.AssociatorInfo;
import com.forlink.exchange.entity.model.AssociatorInfoExample;
import com.forlink.exchange.entity.model.ClientInfo;
import com.forlink.exchange.entity.model.ClientInfoExample;
import com.forlink.exchange.entity.model.SettleTime;
import com.forlink.exchange.entity.model.SettleTimeExample;
import com.forlink.exchange.entity.model.SettleTimeKey;
import com.forlink.exchange.pub.Global;
import com.forlink.exchange.pub.RetDefine;
import com.forlink.exchange.pub.RetObject;
import com.forlink.exchange.pub.convert.Converter;
import com.forlink.exchange.pub.db.DBUtil;
import com.forlink.exchange.pub.tools.Constants;
import com.forlink.exchange.pub.tools.DateUtil;
import com.forlink.exchange.settlesrv.ContractFInfo;
import com.forlink.exchange.settlesrv.SettleUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * Hstd新增结算账单(生成相应的XML文件)
 * 
 * @author hc
 * @modify by yangtz
 * 
 */
@SuppressWarnings({"unused","unchecked","static-access"})
public class TestMyReflection extends AbstractHstdSettleReports {
	private SqlMapClient sqlMapClient;
	private Logger logger;

	private ITradeUtil tradeUtil; // 交易常用基础业务类
	private SettleSrvImpl settleSrv;// 结算后台接口实现
	private DailyFundSummaryDAOImpl dailyFundSummaryDAOImpl = null;// 资金的SQLMAPdao实现
	private String settleDay;// 结算日
	private String lastSettleDay;
	private String nextSettleDay;
	private String curMonth;
	private String monthBeginDay;// 当月第一天
	private String statMonth;
	private String statDay;
	private Date curEndTime;// 当前数据统计结束时间
	private Date curBeginTime;// 当前数据统计开始时间
	private Date lastEndTime;// 上日数据统计结束时间
	private Date lastBeginTime;// 上日数据统计开始时间
	private Date monthBeginTime;// 当月数据统计开始时间
	private int rate = 0;// 价格指数转换比例
	private double taxRate = 0;// 市场的税率，默认1.17，学习网为1，部分市场为1.13 // 此时暂时不考虑1.17了
	private String reports;// 报表主目录
	private String centerDir;// 当日中心文件目录
	private String assocDir;// 会员文件主目录
	private String dayDir;// 年月日目录
	private String fileName;
	private Date month_l;
	private String last_month2;
	private Date last_month;
	
	
	
	
	// private DOMSource dom = null;
	private StreamResult result = null;
	private Transformer trans = null;
	// 会员信息Map
	private Map<String, AssociatorInfo> associatorInfoMap = new HashMap<String, AssociatorInfo>();
	// 客户Id，客户名称Map
	private Map<String, String> clientMap = new HashMap<String, String>();
	// 合同信息列表 合同编码、交易模式、合同税率和结算价等信息
	private Map<String, ContractFInfo> contractInfoMap = null;
	DecimalFormat goodsQttFormatter;// 货物数量/重量格式化

	public TestMyReflection(Logger log) throws Exception {
		logger = log;
		sqlMapClient = DBUtil.getSqlMap();
		tradeUtil = TradeUtilFactory.getInstance(logger);
		settleSrv = new SettleSrvImpl(sqlMapClient, logger);
		dailyFundSummaryDAOImpl = new DailyFundSummaryDAOImpl(sqlMapClient);
		contractInfoMap = SettleUtil.getContractInfoMap();
		goodsQttFormatter = new DecimalFormat("#0.######");
	}

	// 创建目录 已经存在或创建成功返回true，否则false ,folderPath=目录
	public boolean createFolder(String folderPath) throws IOException {
		File file = new File(folderPath);
		return file.exists() ? true : file.mkdirs();
	}

	// 初始化报表系列数据 测试时使用此方法初始化
	private String[] initReports(String date) throws Exception {
		// 初始化时间
		RetObject ret = new RetObject();
		String retStr[];
		if (!date.equals("")) {
			try {
				DateUtil.parse(date, "yyyyMMdd");
				
			} catch (Exception ex) {
				logger.error("日期参数非法");
				System.exit(-1);
			}
			settleDay = date;
		} else {
			retStr = tradeUtil.getCurTradeDay(ret);

			// 判断返回结果是否成功
			if (!retStr[0].equals(RetDefine.pub_success[0])) {
				logger.error("没有找到当前交易日");
				return retStr;
			}
			settleDay = ret.getRetString();
		}

		retStr = tradeUtil.getNTradeDay(settleDay, 1, ret);// getNTradeDay(1,
		// ret);
		// 判断返回结果是否成功
		if (!retStr[0].equals(RetDefine.pub_success[0])) {
			logger.error("没有找到下一交易日");
			return retStr;
		}
		nextSettleDay = ret.getRetString();
		curMonth = settleDay.substring(0, 6);
		monthBeginDay = curMonth + "01";
		
		month_l = DateUtil.parse(monthBeginDay, "yyyyMMdd");
		last_month = DateUtil.addDay(month_l,-1);
		last_month2 = DateUtil.format(last_month,"yyyyMMdd");
		
		statMonth = curMonth.substring(0, 4) + "年" + curMonth.substring(4)
				+ "月";
		statDay = statMonth + settleDay.substring(6) + "日";

		SettleTimeDAOImpl settleTimeDAOImpl = new SettleTimeDAOImpl(
				sqlMapClient);
		SettleTimeExample settleTimeExample = new SettleTimeExample();
		SettleTimeKey settleTimeKey = new SettleTimeKey();
		SettleTime settleTime = new SettleTime();
		settleTimeKey.setSettleDay(settleDay);
		settleTime = settleTimeDAOImpl.selectByPrimaryKey(settleTimeKey);
		if (settleTime == null) {
			logger.error("没有找到结算起始时间");
			return RetDefine.settlesrv_queryObjectIsNull;
		}
		curBeginTime = settleTime.getLastEndTime();
		curEndTime = settleTime.getCurBeginTime();

		/** 获取上一结算日的相关信息 20080826 */
		settleTimeExample.setSettleDay(settleDay);
		settleTimeExample
				.setSettleDay_Indicator(SettleTimeExample.EXAMPLE_LESS_THAN);
		List<SettleTime> lastTimeList = settleTimeDAOImpl.selectByExample(
				settleTimeExample, "settle_day desc");
		if (lastTimeList != null && lastTimeList.size() > 0) {
			settleTime = lastTimeList.get(0);
			lastSettleDay = settleTime.getSettleDay();
			lastBeginTime = settleTime.getLastEndTime();
			lastEndTime = settleTime.getCurBeginTime();
		}
		logger.debug("last settle day's info:" + lastSettleDay + ":"
				+ lastBeginTime + ":" + lastEndTime);

		settleTimeExample = new SettleTimeExample();
		settleTimeExample.setSettleDay(monthBeginDay);
		settleTimeExample
				.setSettleDay_Indicator(SettleTimeExample.EXAMPLE_GREATER_THAN_OR_EQUAL);
		List dateList = settleTimeDAOImpl.selectByExample(settleTimeExample,
				"settle_day");
		if (dateList.size() < 1) {
			logger.warn("没有找到当月结算开始时间, 取当月第一秒");
			monthBeginTime = DateUtil.parse(monthBeginDay + " 000001",
					"yyyyMMdd HHmmss");
		} else {
			settleTime = (SettleTime) dateList.get(0);
			monthBeginTime = settleTime.getLastEndTime();
			monthBeginDay = settleTime.getSettleDay();
		}

		// 价格转换比例
		InitData initData = InitData.getInstance();
		rate = Converter.str2int(initData.getUnitDef("T", "000000", "R")
				.getUnitValue(), 1);
		taxRate = Converter.str2double(initData.getUnitDef("T", "000000", "T")
				.getUnitValue(), 1);

		// 当前主目录
		String home = System.getProperty("settle.server.home");
		// home = System.getProperty("user.dir");
		if (home == null) {
			home = "." + File.separator;
		}
		logger.debug(home);
		// 报表目录
//		reports ="D:/reports";
		reports = home + "/reports";
		// 存储结算日期的文件
		fileName = reports + "/settleday.txt";
		FileWriter fileWriter = new FileWriter(fileName);
		BufferedWriter BuffWrite = new BufferedWriter(fileWriter);
		BuffWrite.write(settleDay);
		BuffWrite.close();
		fileWriter.close();

		// 年月日目录
		dayDir = "/" + curMonth + "/" + settleDay.substring(6, 8) + "/";
		// 会员文件主目录
		assocDir = reports + "/xml/assoc/";
		// 当日中心文件目录
		centerDir = reports + "/xml/center" + dayDir;

		if (!createFolder(centerDir)) {
			logger.error("目录:" + centerDir + "创建失败");
			return RetDefine.settlesrv_createFolderPathFailed;
		}

		AssociatorInfoDAOImpl associatorInfoDAOImpl = new AssociatorInfoDAOImpl(
				sqlMapClient);
		AssociatorInfoExample associatorInfoExample = new AssociatorInfoExample();
		AssociatorInfo associatorInfo = new AssociatorInfo();
		associatorInfoExample.setAssociatorNo("00001");
		associatorInfoExample.setAssociatorNo_Indicator(4);
		// 会员信息列表
		List list = associatorInfoDAOImpl
				.selectByExample(associatorInfoExample);
		for (int i = 0; i < list.size(); i++) {
			associatorInfo = (AssociatorInfo) list.get(i);

			// 会员编码
			String associatorNo = associatorInfo.getAssociatorNo();
			String assoRemak = associatorInfo.getRemarak(); // 会员编码
			// 建立所有当日有效会员的目录
			if (!createFolder(assocDir + assoRemak + dayDir)) {
				logger.error("目录:" + assocDir + assoRemak + dayDir + "创建失败");
				return RetDefine.settlesrv_createFolderPathFailed;
			}
			// 会员信息
			associatorInfoMap.put(associatorNo, associatorInfo);
		}
		// 客户信息
		list.clear();
		ClientInfoDAOImpl clientInfoDAOImpl = new ClientInfoDAOImpl(
				sqlMapClient);
		ClientInfoExample clientInfoExample = new ClientInfoExample();
		ClientInfo clientInfo = new ClientInfo();
		list = clientInfoDAOImpl.selectByExample(clientInfoExample);
		for (int i = 0; i < list.size(); i++) {
			clientInfo = (ClientInfo) list.get(i);
			if (clientInfo.getFullName() != null
					&& clientInfo.getFullName().length() > 0) {
				clientMap.put(clientInfo.getClientId(), clientInfo
						.getFullName());
			} else {
				clientMap.put(clientInfo.getClientId(), "--");
			}
		}
		return RetDefine.pub_success;
	}

	// 初始化报表系列数据 从DoReports.java 里调用此方法初始化
	public void initReports(String settleDay, String lastSettleDay,
			String nextSettleDay, String curMonth, String monthBeginDay,
			String statMonth, String statDay, Date curBeginTime,
			Date curEndTime, Date monthBeginTime, Date lastBeginTime, int rate,
			double taxRate, String reports, String centerDir, String assocDir,
			String dayDir, Map<String, AssociatorInfo> associatorInfoMap,
			Map<String, String> clientMap,
			Map<String, ContractFInfo> contractInfoMap,String last_month2) {
		this.settleDay = settleDay;
		this.lastSettleDay = lastSettleDay;
		this.nextSettleDay = nextSettleDay;
		this.curMonth = curMonth;
		this.monthBeginDay = monthBeginDay;
		this.statMonth = statMonth;
		this.statDay = statDay;
		this.curBeginTime = curBeginTime;
		this.curEndTime = curEndTime;
		this.monthBeginTime = monthBeginTime;
		this.lastBeginTime = lastBeginTime;
		this.rate = rate;
		this.taxRate = taxRate;
		this.reports = reports;
		this.centerDir = centerDir;
		this.assocDir = assocDir;
		this.dayDir = dayDir;
		this.associatorInfoMap = associatorInfoMap;
		this.clientMap = clientMap;
		this.contractInfoMap = contractInfoMap;
		this.last_month2 = last_month2;
	}

	private static EnumSet<AdapterEnum4Spring> enumSet = EnumSet
	.allOf(AdapterEnum4Spring.class);
	// 生成Hstd结算报表
	public String[] doXmlReports() throws Exception {
		String retStr[];
		// 碎单合并，也就是相当于成交日报 = CJ
		for (AdapterEnum4Spring beanid : enumSet) {
			retStr = doReport(beanid.toString());
			if (!retStr[0].equals(RetDefine.pub_success[0])) {
				logger.error(retStr[1]);
				return retStr;
			 }
			}
		return RetDefine.pub_success;
	}
	
	private String[] doReport(String tagspring) throws Exception {
		ISemanticProvider4All aProvider = (ISemanticProvider4All) getCtx()
				.getBean(tagspring);
		logger.info("开始生成" + aProvider.getTitle());
		//System.out.println("开始生成" + aProvider.getTitle());
		Map<String, Document> aDocMaps = aProvider.getDocMap(getCondMap(),
				logger);
		for (String newId : aDocMaps.keySet()) {
			// 生成XML文件
			creatXMLforClient(newId, aDocMaps.get(newId), aProvider.getTitle(), aProvider
					.getType(), associatorInfoMap, settleDay, statDay,
					assocDir, dayDir);
			logger.info("用户:" + newId + aProvider.getType() + "_XML生成成功");
		}

		return RetDefine.pub_success;

	}
	
	private Map condMap = new HashMap();
	public Map getCondMap() throws ParseException {
		condMap.put("SUM_DAY_C", nextSettleDay);
		condMap.put("SUM_DAY", settleDay);
		condMap.put("beginTime", curBeginTime);
		condMap.put("endTime", curEndTime);
		condMap.put("month_t", curMonth);
		condMap.put("monthBeginDay", monthBeginDay);
		condMap.put("last_month", last_month2);
		condMap.put("same", "1");
		return condMap;
	}

	public void setCondMap(Map<String, Date> condMap) {
		this.condMap = condMap;
	}

	public static void main(String args[]) {
		Logger logger = Logger.getLogger(Constants.SETTLESRV);
		String retStr[];
		try {
			new SettleUtil(DBUtil.getSqlMap(), logger);
			TestMyReflection hReports = new TestMyReflection(logger);
			Global.commonLog = logger;

			logger.info("生成报表数据初始化...");
			String date = "";
			if (args != null && args.length != 0 && args[0].length() == 8) {
				date = args[0];
			}
			retStr = hReports.initReports(date);
			if (!retStr[0].equals(RetDefine.pub_success[0])) {
				logger.error("生成报表失败: " + retStr[1]);
				System.exit(-1);
			}
			// 设置合同信息列表
			retStr = SettleUtil.intitContractInfoMap(date);
			// 判断返回结果是否成功
			if (!retStr[0].equals(RetDefine.pub_success[0])) {
				logger.error("生成报表失败: " + retStr[1]);
				System.exit(-1);
			}
			logger.info("开始生成报表，请等待...");
			retStr = hReports.doXmlReports();
			if (!retStr[0].equals(RetDefine.pub_success[0])) {
				logger.error("生成报表失败: " + retStr[1]);
				System.exit(-1);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			logger.error("生成报表失败: " + ex.getMessage());
			System.exit(-1);
		}
		logger.info("XML报表全部生成了.");
		System.exit(0);
	}
}
