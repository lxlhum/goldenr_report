package com.forlink.exchange.settlesrv.report;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import oracle.sql.TIMESTAMP;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.forlink.exchange.entity.base.InitData;
import com.forlink.exchange.entity.business.FundFactory;
import com.forlink.exchange.entity.business.IFund;
import com.forlink.exchange.entity.business.IReceipts;
import com.forlink.exchange.entity.business.ITradeUtil;
import com.forlink.exchange.entity.business.ReceiptsFactory;
import com.forlink.exchange.entity.business.SettleSrvImpl;
import com.forlink.exchange.entity.business.TradeUtilFactory;
import com.forlink.exchange.entity.dao.AssociatorInfoDAOImpl;
import com.forlink.exchange.entity.dao.ClientInfoDAOImpl;
import com.forlink.exchange.entity.dao.CsgOrderFDAOImpl;
import com.forlink.exchange.entity.dao.DailyFundSummaryDAOImpl;
import com.forlink.exchange.entity.dao.FundInoutLogDAOImpl;
import com.forlink.exchange.entity.dao.GoodsModelDAOImpl;
import com.forlink.exchange.entity.dao.OrderCHistDAOImpl;
import com.forlink.exchange.entity.dao.OrderFHistDAOImpl;
import com.forlink.exchange.entity.dao.OrderSHistDAOImpl;
import com.forlink.exchange.entity.dao.ReceiptsDAOImpl;
import com.forlink.exchange.entity.dao.SettleTimeDAOImpl;
import com.forlink.exchange.entity.dao.SubsCDetailDAOImpl;
import com.forlink.exchange.entity.dao.SubsSDetailDAOImpl;
import com.forlink.exchange.entity.dao.TradingDaysDAOImpl;
import com.forlink.exchange.entity.dao.WarehouseInfoDAOImpl;
import com.forlink.exchange.entity.model.AssociatorInfo;
import com.forlink.exchange.entity.model.AssociatorInfoExample;
import com.forlink.exchange.entity.model.AssociatorInfoKey;
import com.forlink.exchange.entity.model.ClientInfo;
import com.forlink.exchange.entity.model.ClientInfoExample;
import com.forlink.exchange.entity.model.CsgOrderF;
import com.forlink.exchange.entity.model.CsgOrderFExample;
import com.forlink.exchange.entity.model.DailyFundSummary;
import com.forlink.exchange.entity.model.DailyFundSummaryExample;
import com.forlink.exchange.entity.model.DailyFundSummaryKey;
import com.forlink.exchange.entity.model.DepositStyle;
import com.forlink.exchange.entity.model.FundInoutLog;
import com.forlink.exchange.entity.model.FundInoutLogExample;
import com.forlink.exchange.entity.model.GoodsModel;
import com.forlink.exchange.entity.model.GoodsModelKey;
import com.forlink.exchange.entity.model.OrderCHist;
import com.forlink.exchange.entity.model.OrderCHistKey;
import com.forlink.exchange.entity.model.OrderFHist;
import com.forlink.exchange.entity.model.OrderFHistKey;
import com.forlink.exchange.entity.model.OrderSHist;
import com.forlink.exchange.entity.model.OrderSHistKey;
import com.forlink.exchange.entity.model.Receipts;
import com.forlink.exchange.entity.model.ReceiptsExample;
import com.forlink.exchange.entity.model.RoeInfo;
import com.forlink.exchange.entity.model.SettleTime;
import com.forlink.exchange.entity.model.SettleTimeExample;
import com.forlink.exchange.entity.model.SettleTimeKey;
import com.forlink.exchange.entity.model.SubsCDetailKey;
import com.forlink.exchange.entity.model.SubsSDetailKey;
import com.forlink.exchange.entity.model.TradingDays;
import com.forlink.exchange.entity.model.TradingDaysExample;
import com.forlink.exchange.entity.model.WarehouseInfo;
import com.forlink.exchange.entity.model.WarehouseInfoKey;
import com.forlink.exchange.pub.Global;
import com.forlink.exchange.pub.RetDefine;
import com.forlink.exchange.pub.RetObject;
import com.forlink.exchange.pub.convert.Converter;
import com.forlink.exchange.pub.db.DBUtil;
import com.forlink.exchange.pub.tools.Constants;
import com.forlink.exchange.pub.tools.DateUtil;
import com.forlink.exchange.pub.tools.PubTools;
import com.forlink.exchange.pub.tools.ResultMap;
import com.forlink.exchange.pub.tools.StringUtil;
import com.forlink.exchange.settlesrv.ContractFInfo;
import com.forlink.exchange.settlesrv.SettleUtil;
import com.forlink.exchange.settlesrv.hstd.HstdSettleReports;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.event.RowHandler;

/**
 * 
 * @author zenglj
 * @version 0.1 2007-5-14 上午11:57:37
 */
@SuppressWarnings({"unused","unchecked","static-access"})
public class DoReports {
	// 数据库连接
	static SqlMapClient sqlMapClient;

	// 运行日志
	protected static Logger logger;

	// 获得公共接口类
	private ITradeUtil tradeUtil;

	private IReceipts receipts;

	static SettleSrvImpl settleSrv;
	// 结算日
	static String settleDay;

	// 上一结算日
	static String lastSettleDay;

	// 下一结算日
	static String nextSettleDay;
	static String curMonth;
	// 当月第一天
	static String monthBeginDay;
	static String statMonth;
	static String statDay;
	
	static Date month_l;
	static String last_month2;
	static Date last_month;

	// 当前数据统计结束时间
	static Date curEndTime;

	// 当前数据统计开始时间
	static Date curBeginTime;

	// 上日数据统计结束时间
	static Date lastEndTime;

	// 上日数据统计开始时间
	static Date lastBeginTime;

	// 当月数据统计开始时间
	static Date monthBeginTime;

	// 价格指数转换比例
	static int rate = 0;

	// 市场的税率，默认1.17，学习网为1，部分市场为1.13
	static double taxRate = 0;

	// 报表主目录
	public static String reports;
	// 当日中心文件目录
	static String centerDir;
	// 会员文件主目录
	static String assocDir;
	// 年月日目录
	static String dayDir;

	static String fileName;

	static DOMSource dom = null;
	static StreamResult result = null;
	static Transformer trans = null;
	static Map<String, AssociatorInfo> associatorInfoMap = new HashMap<String, AssociatorInfo>();
	static Map<String, String> clientMap = new HashMap<String, String>();
	static DailyFundSummaryDAOImpl dailyFundSummaryDAOImpl = null;

	static Map<String, DepositStyle> dpstMap = new HashMap<String, DepositStyle>();
	/**
	 * 合同信息列表 合同编码、交易模式、合同税率和结算价等信息
	 */
	static Map<String, ContractFInfo> contractInfoMap = null;

	/**
	 * 通用数据缓存，目前只能使用 商品相关，合同不能使用
	 */
	static InitData initData;

	/**
	 * 构造函数
	 * 
	 * @author zenglj
	 * @version 0.1 2007-5-14 上午11:57:37
	 */
	public DoReports() throws Exception {
		sqlMapClient = DBUtil.getSqlMap();
		logger = Logger.getLogger(Constants.SETTLESRV);
		tradeUtil = TradeUtilFactory.getInstance(logger);
		receipts = ReceiptsFactory.getInstance(logger);
		settleSrv = new SettleSrvImpl(sqlMapClient, logger);
		dailyFundSummaryDAOImpl = new DailyFundSummaryDAOImpl(sqlMapClient);
		new SettleUtil(sqlMapClient, logger);
		contractInfoMap = SettleUtil.getContractInfoMap();
		initData = InitData.getInstance();
	}

	/**
	 * 创建目录
	 * 
	 * @param folderPath
	 *            目录
	 * @return boolean 已经存在或创建成功返回true，否则false
	 * @throws IOException
	 */
	public boolean createFolder(String folderPath) throws IOException {
		File file = new File(folderPath);
		return file.exists() ? true : file.mkdirs();
	}

	/**
	 * 初始化报表系列数据
	 * 
	 * @param args
	 *            命令参数 日期, 格式：yyyyMMdd
	 * @return
	 * @throws Exception
	 */
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
		System.out.println("last_month2"+last_month2);
		
		
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
		reports = home + "/reports";
		// 存储结算日期的文件
		fileName = reports + "/settleday.txt";
//		reports = "D:/reports";
//		// 存储结算日期的文件
//		fileName = reports + "/settleday.txt";
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

	/**
	 * 生成资金不足交易商清单。
	 * 
	 * @return
	 * @throws Exception
	 */
	private String[] doMorbidReport() throws Exception {
		logger.info("生成可用资金不足交易商清单");

		String associatorNo = "";
		long totalRight = 0;
		long fundTotal = 0;
		long avlbFund = 0;
		long creditTotal = 0;
		long safeFund = 0;
		long subsDeposit = 0;
		long frzRiskFund = 0;
		long acctBalance = 0;
		long index = 1;

		ResultMap map = new ResultMap();
		map.put("nextMonth", nextSettleDay.substring(0, 6));
		// 查询病态会员资金信息列表
		DailyFundSummary dailyFundSummary = new DailyFundSummary();
		DailyFundSummaryExample dailyFundSummaryExample = new DailyFundSummaryExample();
		dailyFundSummaryExample.setAssociatorNo("00001");
		dailyFundSummaryExample.setAssociatorNo_Indicator(4);
		dailyFundSummaryExample.setSumDay(nextSettleDay);
		dailyFundSummaryExample.setSumDay_Indicator(3);
		dailyFundSummaryExample.setAvlbFund(0);
		dailyFundSummaryExample.setAvlbFund_Indicator(7);
		List<DailyFundSummary> list = dailyFundSummaryDAOImpl.selectByExample(
				dailyFundSummaryExample, "associator_no");

		AssociatorInfoDAOImpl associatorInfoDAOImpl = new AssociatorInfoDAOImpl(
				sqlMapClient);

		Document morbidDoc = PubTools.getDocument();

		Element root = morbidDoc.createElement("root");

		Element file_title = morbidDoc.createElement("file_title");
		root.appendChild(file_title);
		file_title.setTextContent(settleDay + "_BT");

		Element report_name = morbidDoc.createElement("report_name");
		report_name.setTextContent("交易中心病态会员清单");
		root.appendChild(report_name);

		Element top = morbidDoc.createElement("top");
		root.appendChild(top);

		Element item = morbidDoc.createElement("item");
		top.appendChild(item);

		Element content = morbidDoc.createElement("content");
		content.setTextContent(statDay);
		item.appendChild(content);

		Element body = morbidDoc.createElement("body");
		root.appendChild(body);

		for (int i = 0; i < list.size(); i++) {
			associatorNo = "";
			totalRight = 0;
			fundTotal = 0;
			avlbFund = 0;
			creditTotal = 0;
			safeFund = 0;
			subsDeposit = 0;
			frzRiskFund = 0;
			acctBalance = 0;

			dailyFundSummary = list.get(i);

			// 会员编码
			associatorNo = dailyFundSummary.getAssociatorNo();
			// |总权益|总资金|可用资金|信用总额|保底资金|订货合同占用|风控冻结资金|帐面价差
			totalRight = dailyFundSummary.getTotalRight();
			fundTotal = dailyFundSummary.getFundTotal();
			avlbFund = dailyFundSummary.getAvlbFund();
			creditTotal = dailyFundSummary.getCreditTotal();
			safeFund = dailyFundSummary.getSafeFund();
			subsDeposit = dailyFundSummary.getSubsDeposit();
			frzRiskFund = dailyFundSummary.getFrzRiskFund();
			acctBalance = dailyFundSummary.getAcctBalance();

			// 宁波液体化工新增 2008/04/29
			// 获取会员远月保证金
			// 风险度 ＝（可用资金 ＋ 可负债金额）/（占用保证金 － 可负债金额）×100％
			// 清仓后可用资金余额 ＝ 客户权益 ＋（账面价差 / 1.17），其中：客户权益＝可用＋占用＋冻结＋ABS（－账面价差）
			// 可负债金额 ＝ 远月合同订货占用保证金×50％
			map.put("associatorNo", associatorNo);
			long avlbDebtFund = Converter.glong(sqlMapClient.queryForObject(
					"sel_settlesrvRpt_farDpstAmt_t_subs_f", map));
			// 风险度-宁波液体化工
			String riskRate = "--";
			if (subsDeposit > 0) {
				riskRate = Converter.formatFen2yuan(Converter
						.double2long((avlbFund + avlbDebtFund) * 10000.0
								/ (subsDeposit - avlbDebtFund)))
						+ "%";
			}
			// 平仓后余额＝可用资金＋保证金占用＋报单冻结+风控冻结＋“账面盈亏”/1.17 -
			// (acctBalance<0?acctBalance:0)
			long aftCnyFund = Converter.double2long(avlbFund + subsDeposit
					+ frzRiskFund + acctBalance / taxRate
					- (acctBalance < 0 ? acctBalance : 0));
			// end 宁波液体化工新增

			// 上海大宗新增
			// 1)比例的风控资金=可用+远月保证金/2
			// 2)固定的风控资金=可用+远月保证金-远月合同持仓数量*该品种商品的固定值 (螺纹和线材300，卷板400 X L 300，RB
			// 400 其它合同0)
			long cRiskFundAddons = ((Long) sqlMapClient.queryForObject(
					"sel_stat_assoFund_criskFundAddons", map)).longValue();
			long riskFundP = avlbFund + avlbDebtFund / 2;
			long riskFundF = avlbFund + avlbDebtFund - cRiskFundAddons;
			AssociatorInfoKey associatorInfoKey = new AssociatorInfoKey();
			associatorInfoKey.setAssociatorNo(associatorNo);
			AssociatorInfo associatorInfo = associatorInfoDAOImpl
					.selectByPrimaryKey(associatorInfoKey);

			item = morbidDoc.createElement("item");
			body.appendChild(item);

			Element itemson = morbidDoc.createElement("SEQ");
			itemson.setTextContent(index + "");
			item.appendChild(itemson);

			itemson = morbidDoc.createElement("ASSOCIATOR_NO");
			itemson.setTextContent(associatorInfo.getRemarak());
			item.appendChild(itemson);

			itemson = morbidDoc.createElement("ASSOC_FULL_NAME");
			itemson.setTextContent(associatorInfoMap.get(associatorNo)
					.getFullName());
			item.appendChild(itemson);

			itemson = morbidDoc.createElement("ASSC_TYPE");
			itemson.setTextContent(associatorInfoMap.get(associatorNo)
					.getAsscType());
			item.appendChild(itemson);

			itemson = morbidDoc.createElement("TOTAL_RIGHT");
			itemson.setTextContent(Converter.formatFen2yuan(totalRight));
			item.appendChild(itemson);

			itemson = morbidDoc.createElement("FUND_TOTAL");
			itemson.setTextContent(Converter.formatFen2yuan(fundTotal));
			item.appendChild(itemson);

			itemson = morbidDoc.createElement("AVLB_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(avlbFund));
			item.appendChild(itemson);

			itemson = morbidDoc.createElement("CREDIT_TOTAL");
			itemson.setTextContent(Converter.formatFen2yuan(creditTotal));
			item.appendChild(itemson);

			itemson = morbidDoc.createElement("SAFE_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(safeFund));
			item.appendChild(itemson);

			itemson = morbidDoc.createElement("SUBS_DEPOSIT");
			itemson.setTextContent(Converter.formatFen2yuan(subsDeposit));
			item.appendChild(itemson);

			itemson = morbidDoc.createElement("FRZ_RISK_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(frzRiskFund));
			item.appendChild(itemson);

			itemson = morbidDoc.createElement("ACCT_BALANCE");
			itemson.setTextContent(Converter.formatFen2yuan(acctBalance));
			item.appendChild(itemson);

			itemson = morbidDoc.createElement("AVLB_DEBT_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(avlbDebtFund));
			item.appendChild(itemson);

			itemson = morbidDoc.createElement("RISK_RATE");
			itemson.setTextContent(riskRate);
			item.appendChild(itemson);

			itemson = morbidDoc.createElement("AFT_CNY_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(aftCnyFund));
			item.appendChild(itemson);
			// 上海大宗新增
			itemson = morbidDoc.createElement("RISK_FUND_P");
			itemson.setTextContent(Converter.formatFen2yuan(riskFundP));
			item.appendChild(itemson);
			itemson = morbidDoc.createElement("RISK_FUND_F");
			itemson.setTextContent(Converter.formatFen2yuan(riskFundF));
			item.appendChild(itemson);
			itemson = morbidDoc.createElement("ASSC_TYPE");
			itemson.setTextContent(associatorInfo.getAsscType());
			item.appendChild(itemson);
			itemson = morbidDoc.createElement("CONTACTER");
			itemson.setTextContent(associatorInfo.getContacter());
			item.appendChild(itemson);
			itemson = morbidDoc.createElement("CONTACTER_TEL");
			itemson.setTextContent(associatorInfo.getContacterTel());
			item.appendChild(itemson);
			itemson = morbidDoc.createElement("CONTACTER_MP");
			itemson.setTextContent(associatorInfo.getContacterMp());
			item.appendChild(itemson);
			//
			index++;
		}

		if (index > 1) {
			fileName = centerDir + settleDay + "_BT.xml";
			morbidDoc.appendChild(root);
			dom = new DOMSource(morbidDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);
		}
		return RetDefine.pub_success;
	}

	/**
	 * 按会员生成款项收付清单
	 * 
	 * @log 20080826 by yanjl 新增仓单质押部分
	 * @return
	 * @throws Exception
	 */
	private String[] doAccountList() throws Exception {
		logger.info("会员/中心款项清单");
		String retStr[];
		RetObject retObj = new RetObject();
		String associatorNo = "";
		String fullName = "";
		long lastTotalRight = 0;
		long lastAvlbFund = 0;
		long lastSubsDeposit = 0;
		long lastFrzRiskFund = 0;
		long lastAcctBalance = 0; // 上一日账面价差
		long lastAcctProfitAndLoss = 0; // 上一日账面盈亏=上一日账面价差/税率
		long totalRight = 0;
		long avlbFund = 0;
		long subsDeposit = 0;
		long frzRiskFund = 0;
		long acctBalance = 0; // =账面价差
		long acctProfitAndLoss = 0; // 账面盈亏=账面价差/税率
		long curInFund = 0;
		long curOutFund = 0;
		long curPoundage = 0;
		long curCsgFee = 0;
		long curCnyInCome = 0;
		long curCsgInCome = 0;
		long curAppFund = 0;
		long curGotPayment = 0;
		long curPaidPayment = 0;
		long leftPayment = 0;
		long curBuyerDiff = 0;
		long curManageFee = 0;
		long curAgencyFee = 0;
		long curDisobeyFee = 0;
		long dealQtt = 0;
		long dealAmt = 0;
		long curCnyBalance = 0;
		long other = 0;
		long accrual = 0;
		long debtFund = 0;
		long repayFund = 0;

		long ttotalRight = 0;
		long totalInFund = 0;
		long totalAvlbFund = 0;
		long totalOutFund = 0;
		long totalPoundage = 0;
		long totalCsgFee = 0;
		long totalManageFee = 0;
		long totalDisobeyFee = 0;
		long totalAgencyFee = 0;
		long totalAccrual = 0;
		long totalDebtFund = 0;
		long totalRepayFund = 0;

		long lastCsgDeposit = 0;
		long csgDeposit = 0;

		/** 20091030 by suntao */
		long riskReserveFund = 0;
		long delayFee = 0;
		long extendFee = 0;

		long index = 1;

		ResultMap map = new ResultMap();
		ResultMap retMap = new ResultMap();

		FileWriter centerInOutFile = null;
		BufferedWriter centerInOutBuf = null;
		FileWriter centerIncomeFile = null;
		BufferedWriter centerIncomeBuf = null;

		map.put("settleDay", settleDay);
		map.put("digestNoNotLike", "SYS%");
		map.put("beginTime", curBeginTime);
		map.put("endTime", curEndTime);
		map.put("nextMonth", nextSettleDay.substring(0, 6));
		// 中心清单
		Document centerDoc = PubTools.getDocument();
		Element root = centerDoc.createElement("root");

		Element file_title = centerDoc.createElement("file_title");
		file_title.setTextContent(settleDay + "_ZXKX");
		root.appendChild(file_title);

		Element report_name = centerDoc.createElement("report_name");
		report_name.setTextContent("交易中心会员款项清单");
		root.appendChild(report_name);

		Element top = centerDoc.createElement("top");
		root.appendChild(top);

		Element item = centerDoc.createElement("item");
		top.appendChild(item);

		Element content = centerDoc.createElement("content");
		content.setTextContent(statDay);
		item.appendChild(content);

		Element body = centerDoc.createElement("body");
		root.appendChild(body);

		DailyFundSummary dailyFundSummary = new DailyFundSummary();
		DailyFundSummaryExample dailyFundSummaryExample = new DailyFundSummaryExample();
		dailyFundSummaryExample.setSumDay(nextSettleDay);
		dailyFundSummaryExample
				.setSumDay_Indicator(DailyFundSummaryExample.EXAMPLE_EQUALS);
		dailyFundSummaryExample.setAssociatorNo("00001");
		dailyFundSummaryExample
				.setAssociatorNo_Indicator(DailyFundSummaryExample.EXAMPLE_NOT_EQUALS);
		// long sqlstart = System.currentTimeMillis();
		List list = dailyFundSummaryDAOImpl
				.selectByExample(dailyFundSummaryExample);

		/** 20080826 by yanjl 查询会员的仓单质押还款信息 */
		// 当日还款信息列表
		List<ResultMap> curRepayList = new ArrayList<ResultMap>();
		// 上日还款信息列表
		List<ResultMap> lastRepayList = new ArrayList<ResultMap>();
		if (list != null && list.size() > 0) {
			ResultMap repayMap = new ResultMap();
			repayMap.put("beginTime", curBeginTime);
			repayMap.put("endTime", curEndTime);
			curRepayList = sqlMapClient.queryForList(
					"sel_settlesrv_t_repay_info_groupByAssoNo", repayMap);
			if (lastSettleDay != null) {
				repayMap.put("beginTime", lastBeginTime);
				repayMap.put("endTime", lastEndTime);
				lastRepayList = sqlMapClient.queryForList(
						"sel_settlesrv_t_repay_info_groupByAssoNo", repayMap);
			}
		}
		Iterator<ResultMap> curRepayIterator = curRepayList.iterator();
		Iterator<ResultMap> lastRepayIterator = lastRepayList.iterator();

		IFund fund = FundFactory.getInstance(logger);

		// logger.debug("sql_1耗时=="+(System.currentTimeMillis()-sqlstart)/1000.0+"秒");
		for (int i = 0; i < list.size(); i++) {
			associatorNo = "";
			fullName = "";

			dailyFundSummary = (DailyFundSummary) list.get(i);

			// 会员编码
			associatorNo = dailyFundSummary.getAssociatorNo();
			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();
			fullName = associatorInfoMap.get(associatorNo).getFullName();

			DailyFundSummary lastdailyFundSummary = new DailyFundSummary();
			DailyFundSummaryKey dailyFundSummaryKey = new DailyFundSummaryKey();
			dailyFundSummaryKey.setSumDay(settleDay);
			dailyFundSummaryKey.setAssociatorNo(associatorNo);

			lastTotalRight = 0;
			lastAvlbFund = 0;
			lastSubsDeposit = 0;
			lastFrzRiskFund = 0;
			lastAcctBalance = 0;
			lastAcctProfitAndLoss = 0;
			totalRight = 0;
			avlbFund = 0;
			subsDeposit = 0;
			frzRiskFund = 0;
			acctBalance = 0;
			acctProfitAndLoss = 0;
			curInFund = 0;
			curOutFund = 0;
			curPoundage = 0;
			curCsgFee = 0;
			curCnyInCome = 0;
			curCsgInCome = 0;
			curAppFund = 0;
			curGotPayment = 0;
			curPaidPayment = 0;
			leftPayment = 0;
			curBuyerDiff = 0;
			curManageFee = 0;
			curAgencyFee = 0;
			curDisobeyFee = 0;
			dealQtt = 0;
			dealAmt = 0;
			curCnyBalance = 0;
			other = 0;
			accrual = 0;
			debtFund = 0;
			repayFund = 0;

			lastCsgDeposit = 0;
			csgDeposit = 0;

			/** 20091030 by suntao */
			riskReserveFund = 0;
			delayFee = 0;
			extendFee = 0;

			// sqlstart = System.currentTimeMillis();
			lastdailyFundSummary = dailyFundSummaryDAOImpl
					.selectByPrimaryKey(dailyFundSummaryKey);
			// logger.debug("sql_2耗时=="+(System.currentTimeMillis()-sqlstart)/1000.0+"秒");
			if (lastdailyFundSummary != null) {
				// |总权益|可用资金|订货合同占用|风控冻结资金|帐面价差
				lastTotalRight = lastdailyFundSummary.getTotalRight();
				lastAvlbFund = lastdailyFundSummary.getAvlbFund();
				lastSubsDeposit = lastdailyFundSummary.getSubsDeposit();
				lastFrzRiskFund = lastdailyFundSummary.getFrzRiskFund();
				lastAcctBalance = lastdailyFundSummary.getAcctBalance();
				lastAcctProfitAndLoss = 0; // 目前无法计算 20091125
			}

			totalRight = dailyFundSummary.getTotalRight();
			avlbFund = dailyFundSummary.getAvlbFund();
			subsDeposit = dailyFundSummary.getSubsDeposit();
			frzRiskFund = dailyFundSummary.getFrzRiskFund();
			/* 当日账面价差 */
			acctBalance = dailyFundSummary.getAcctBalance();
			/* 当日合同盈亏 */
			acctProfitAndLoss = fund.getCurBalance(associatorNo, true);
			curInFund = dailyFundSummary.getCurInFund();
			curOutFund = dailyFundSummary.getCurOutFund();
			curPoundage = dailyFundSummary.getCurPoundage();
			curCsgFee = dailyFundSummary.getCurCsgFee();
			curCnyInCome = dailyFundSummary.getCnyBalance();
			curCsgInCome = dailyFundSummary.getCsgBalance();
			curAppFund = dailyFundSummary.getAppDeposit();
			curGotPayment = dailyFundSummary.getGotPayment();
			curPaidPayment = dailyFundSummary.getPaidPayment();
			leftPayment = dailyFundSummary.getLeftPayment();
			curBuyerDiff = dailyFundSummary.getCurBuyerDiff();
			curManageFee = dailyFundSummary.getCurManageFee();
			curAgencyFee = dailyFundSummary.getCurAgencyFee();
			// curDisobeyFee = dailyFundSummary.getInDisobeyFee() -
			// dailyFundSummary.getOutDisobeyFee();
			curDisobeyFee = dailyFundSummary.getOutDisobeyFee()
					- dailyFundSummary.getInDisobeyFee();

			/** 20091030 by suntao */
			delayFee = dailyFundSummary.getDelayFee();
			extendFee = dailyFundSummary.getExtendFee();

			/* 20091218 by xufeng */
			csgDeposit = dailyFundSummary.getCsgDeposit();
			lastCsgDeposit = lastdailyFundSummary.getCsgDeposit();

			// 20091224 by qiuyc
			long reserve = dailyFundSummary.getReserve();

			other = lastFrzRiskFund - frzRiskFund - curManageFee - reserve;

			map.put("associatorNo", associatorNo);

			/** 20091030 by suntao */
			riskReserveFund = Long.parseLong(sqlMapClient.queryForObject(
					"sel_settlesrvRpt_assoreserve_T_DELAY_FEE_LOG", map)
					.toString());

			// sqlstart = System.currentTimeMillis();
			List deallist = sqlMapClient.queryForList(
					"sel_settlesrvRpt_dealInfo_T_DEAL_F", map);
			// logger.debug("sql_3耗时=="+(System.currentTimeMillis()-sqlstart)/1000.0+"秒");
			retMap = (ResultMap) deallist.get(0);
			dealQtt = retMap.getLong("deal_qtt", 0);
			dealAmt = retMap.getLong("deal_amt", 0);
			curCnyBalance = retMap.getLong("cny_balance", 0);
			// 可负债金额 ＝ 远月合同订货占用保证金×50％
			// sqlstart = System.currentTimeMillis();
			long avlbDebtFund = Converter
					.double2long(Converter.glong(sqlMapClient.queryForObject(
							"sel_settlesrvRpt_farDpstAmt_t_subs_f", map)) / 2.0);
			// logger.debug("sql_4耗时=="+(System.currentTimeMillis()-sqlstart)/1000.0+"秒");
			// 负债率 = 风险度-宁波液体化工
			String debtRate = "--";
			if (subsDeposit > 0) {
				debtRate = Converter.formatFen2yuan(Converter
						.double2long((avlbFund + avlbDebtFund) * 10000.0
								/ (subsDeposit - avlbDebtFund)))
						+ "%";
			}

			// 广西食糖新增交易商货款及盈亏-205凭证资金 2008/06/04
			// sqlstart = System.currentTimeMillis();
			long paymentAndBalance = Converter
					.glong(sqlMapClient
							.queryForObject(
									"Sel_settlesrvRpt_paymentAndBalance_t_voucher_detail",
									map));
			// logger.debug("sql_5耗时=="+(System.currentTimeMillis()-sqlstart)/1000.0+"秒");

			// 新增其他费用 2008/03/26
			// sqlstart = System.currentTimeMillis();
			List otherlist = sqlMapClient.queryForList(
					"sel_settlesrv_voucherDetail_T_VOUCHER_DETAIL", map);
			// logger.debug("sql_6耗时=="+(System.currentTimeMillis()-sqlstart)/1000.0+"秒");
			for (int j = 0; j < otherlist.size(); j++) {
				retMap = (ResultMap) otherlist.get(j);
				// 借方金额
				long debitAmt = retMap.getLong("debit_amt", 0);
				// 贷方金额
				long creditAmt = retMap.getLong("credit_amt", 0);
				// 科目类型（1:借， 2:贷）
				int itemType = retMap.getInt("item_type", 1);
				// 科目ID
				String itemId = retMap.getString("item_id", "");

				if (itemId.startsWith("101") || itemId.startsWith("102")) {
					continue;
				}
				// 摘要编码
				String digestNo = retMap.getString("digest_no", "");

				// 借贷方金额差
				long diffAmt = (creditAmt - debitAmt);

				if (diffAmt == 0) {
					continue;
				}
				// 若是科目类型为借，则反之
				if (itemType == 1) {
					diffAmt = -diffAmt;
				}

				// 当日其它费用变更
				other += diffAmt;

				// 利息accrual
				if (itemId.equals("10302")) {
					accrual += diffAmt;
				}

				logger.debug("associatorNo>>" + associatorNo + "\tdigestNo>>"
						+ digestNo + "\titemId>>>" + itemId + "\tdiffAmt>>>"
						+ diffAmt);
			}

			// 可用仓单累计
			// sqlstart = System.currentTimeMillis();
			retObj.setRetObject(null);
			retStr = receipts.getAvailableReceipt(associatorNo, retObj);
			if (!RetDefine.pub_success[0].equals(retStr[0])) {
				logger.error(retStr[1]);
				return retStr;
			}
			// logger.debug("receipts.getAvailableReceipt耗时=="+(System.currentTimeMillis()-sqlstart)/1000.0+"秒");
			// sqlstart = System.currentTimeMillis();

			Document assocDoc = PubTools.getDocument();
			Element aroot = assocDoc.createElement("root");
			//
			aroot.setAttribute("nextSettleDay", nextSettleDay);

			Element afile_title = assocDoc.createElement("file_title");
			afile_title.setTextContent(settleDay + assoRemark + "_HYKX");
			aroot.appendChild(afile_title);

			Element areport_name = assocDoc.createElement("report_name");
			areport_name.setTextContent("款项收付清单");
			aroot.appendChild(areport_name);

			Element atop = assocDoc.createElement("top");
			aroot.appendChild(atop);

			Element aitem = assocDoc.createElement("item");
			atop.appendChild(aitem);

			Element acontent = assocDoc.createElement("content");
			acontent.setTextContent(assoRemark);
			aitem.appendChild(acontent);

			aitem = assocDoc.createElement("item");
			atop.appendChild(aitem);

			acontent = assocDoc.createElement("content");
			acontent.setTextContent(fullName);
			aitem.appendChild(acontent);

			aitem = assocDoc.createElement("item");
			atop.appendChild(aitem);

			acontent = assocDoc.createElement("content");
			acontent.setTextContent(statDay);
			aitem.appendChild(acontent);

			Element abody = assocDoc.createElement("body");
			aroot.appendChild(abody);

			aitem = assocDoc.createElement("item");
			abody.appendChild(aitem);

			// 写数据
			Element aitemson = assocDoc.createElement("LAST_AVLB_FUND");
			aitemson.setTextContent(Converter.formatFen2yuan(lastAvlbFund));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("LAST_TOTAL_RIGHT");
			aitemson.setTextContent(Converter.formatFen2yuan(lastTotalRight));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CUR_IN_FUND");
			aitemson.setTextContent(Converter.formatFen2yuan(curInFund));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CUR_OUT_FUND");
			aitemson.setTextContent(Converter.formatFen2yuan(curOutFund));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CNY_INCOME");
			aitemson.setTextContent(Converter.formatFen2yuan(curCnyInCome));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CUR_POUNDAGE");
			aitemson.setTextContent(Converter.formatFen2yuan(curPoundage));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CUR_CSG_FEE");
			aitemson.setTextContent(Converter.formatFen2yuan(curCsgFee));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("LAST_SUBS_DEPOSIT");
			aitemson.setTextContent(Converter.formatFen2yuan(lastSubsDeposit));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("SUBS_DEPOSIT");
			aitemson.setTextContent(Converter.formatFen2yuan(subsDeposit));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("LAST_ACCT_BALANCE");
			aitemson.setTextContent(Converter.formatFen2yuan(lastAcctBalance));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("LAST_ACCT_PROFIT_AND_LOSS");
			aitemson.setTextContent(Converter
					.formatFen2yuan(lastAcctProfitAndLoss));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("ACCT_BALANCE");
			aitemson.setTextContent(Converter.formatFen2yuan(acctBalance));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("ACCT_PROFIT_AND_LOSS");
			aitemson
					.setTextContent(Converter.formatFen2yuan(acctProfitAndLoss));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CSG_INCOME");
			aitemson.setTextContent(Converter.formatFen2yuan(curCsgInCome));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("OTHER");
			aitemson.setTextContent(Converter.formatFen2yuan(other));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("PAID_PAYMENT");
			aitemson.setTextContent(Converter.formatFen2yuan(curPaidPayment));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("GOT_PAYMENT");
			aitemson.setTextContent(Converter.formatFen2yuan(curGotPayment));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("LEFT_PAYMENT");
			aitemson.setTextContent(Converter.formatFen2yuan(leftPayment));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CUR_BUYER_DIFF");
			aitemson.setTextContent(Converter.formatFen2yuan(curBuyerDiff));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CUR_DISOBEY_FEE");
			aitemson.setTextContent(Converter.formatFen2yuan(curDisobeyFee));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CUR_AGENCY_FEE");
			aitemson.setTextContent(Converter.formatFen2yuan(curAgencyFee));
			aitem.appendChild(aitemson);

			/** 20080928 by yanjl */
			aitemson = assocDoc.createElement("CUR_MANAGE_FEE");
			aitemson.setTextContent(Converter.formatFen2yuan(curManageFee));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("AVLB_FUND");
			aitemson.setTextContent(Converter.formatFen2yuan(avlbFund));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("APP_FUND");
			aitemson.setTextContent(Converter.formatFen2yuan(curAppFund));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("RECEIPT_QTT");
			aitemson.setTextContent(retObj.getRetLong() + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("LAST_FRZ_RISK_FUND");
			aitemson.setTextContent(Converter.formatFen2yuan(lastFrzRiskFund));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("FRZ_RISK_FUND");
			aitemson.setTextContent(Converter.formatFen2yuan(frzRiskFund));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("AVLB_DEBT_FUND");
			aitemson.setTextContent(Converter.formatFen2yuan(avlbDebtFund));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("DEBT_RATE");
			aitemson.setTextContent(debtRate);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("TOTAL_RIGHT");
			aitemson.setTextContent(Converter.formatFen2yuan(totalRight));
			aitem.appendChild(aitemson);

			/** 20080826 by yanjl 新增仓单质押部分 */
			long curRepaySum = 0, lastRepaySum = 0;
			curRepayIterator = curRepayList.iterator();
			while (curRepayIterator.hasNext()) {
				ResultMap element = curRepayIterator.next();
				if (element.getString("associator_no", "").equals(associatorNo)) {
					curRepaySum = element.getLong("repay_sum", 0);
					// curRepayIterator.remove();
					break;
				}

			}
			lastRepayIterator = lastRepayList.iterator();
			while (lastRepayIterator.hasNext()) {
				ResultMap element = lastRepayIterator.next();
				if (element.getString("associator_no", "").equals(associatorNo)) {
					lastRepaySum = element.getLong("repay_sum", 0);
					// lastRepayIterator.remove();
					break;
				}

			}
			aitemson = assocDoc.createElement("LAST_LOAN_BALANCE");
			if (lastdailyFundSummary != null)
				aitemson.setTextContent(Converter
						.formatFen2yuan(lastdailyFundSummary.getLoanBalance()));
			else
				aitemson.setTextContent("0");
			aitem.appendChild(aitemson);
			aitemson = assocDoc.createElement("CUR_LOAN_BALANCE");
			aitemson.setTextContent(Converter.formatFen2yuan(dailyFundSummary
					.getLoanBalance()));
			aitem.appendChild(aitemson);
			aitemson = assocDoc.createElement("CUR_LOAN_POUNDAGE");
			aitemson.setTextContent(Converter.formatFen2yuan(dailyFundSummary
					.getCurLoanPoundage()));
			aitem.appendChild(aitemson);
			aitemson = assocDoc.createElement("CUR_LOAN_INTEREST");
			aitemson.setTextContent(Converter.formatFen2yuan(dailyFundSummary
					.getCurLoanInterest()));
			aitem.appendChild(aitemson);
			aitemson = assocDoc.createElement("LAST_REPAY_SUM");
			aitemson.setTextContent(Converter.formatFen2yuan(lastRepaySum));
			aitem.appendChild(aitemson);
			aitemson = assocDoc.createElement("CUR_REPAY_SUM");
			aitemson.setTextContent(Converter.formatFen2yuan(curRepaySum));
			aitem.appendChild(aitemson);

			// 新增手续费返还
			aitemson = assocDoc.createElement("RET_POUNDAGE");
			aitemson.setTextContent(Converter.formatFen2yuan(dailyFundSummary
					.getRetPoundage()));
			aitem.appendChild(aitemson);

			// logger.debug("构造会员DOMSource耗时=="+(System.currentTimeMillis()-sqlstart)/1000.0+"秒");
			// sqlstart = System.currentTimeMillis();

			/** 20091030 by suntao */
			aitemson = assocDoc.createElement("RISK_RESERVE_FUND");
			aitemson.setTextContent(Converter.formatFen2yuan(riskReserveFund));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("DELAY_FEE");
			aitemson.setTextContent(Converter.formatFen2yuan(delayFee));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("EXTEND_FEE");
			aitemson.setTextContent(Converter.formatFen2yuan(extendFee));
			aitem.appendChild(aitemson);

			/** 20091107 by suntao 动态权益 */
			aitemson = assocDoc.createElement("DYNAMIC_RIGHT");
			aitemson.setTextContent(Converter.formatFen2yuan(totalRight
					+ acctProfitAndLoss));
			aitem.appendChild(aitemson);
			aitemson = assocDoc.createElement("LAST_DYNAMIC_RIGHT");
			aitemson.setTextContent(Converter.formatFen2yuan(lastTotalRight
					+ lastAcctProfitAndLoss));
			aitem.appendChild(aitemson);

			/** 20091125 by suntao 交割保证金 */
			aitemson = assocDoc.createElement("CSG_DEPOSIT");
			aitemson.setTextContent(Converter.formatFen2yuan(csgDeposit));
			aitem.appendChild(aitemson);
			aitemson = assocDoc.createElement("LAST_CSG_DEPOSIT");
			aitemson.setTextContent(Converter.formatFen2yuan(lastCsgDeposit));
			aitem.appendChild(aitemson);

			// 会员资金文件
			fileName = assocDir + assoRemark + dayDir + assoRemark + "_"
					+ settleDay + "_KX.xml";
			assocDoc.appendChild(aroot);

			dom = new DOMSource(assocDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);
			// logger.debug("会员文件转换耗时=="+(System.currentTimeMillis()-sqlstart)/1000.0+"秒");
			// sqlstart = System.currentTimeMillis();
			// 中心文件
			item = centerDoc.createElement("item");
			body.appendChild(item);

			Element itemson = centerDoc.createElement("ASSOCIATOR_NO");
			itemson.setTextContent(assoRemark);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ASSOC_FULL_NAME");
			itemson.setTextContent(fullName);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("LAST_TOTAL_RIGHT");
			itemson.setTextContent(Converter.formatFen2yuan(lastTotalRight));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("LAST_AVLB_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(lastAvlbFund));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("LAST_SUBS_DEPOSIT");
			itemson.setTextContent(Converter.formatFen2yuan(lastSubsDeposit));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("LAST_ACCT_BALANCE");
			itemson.setTextContent(Converter.formatFen2yuan(lastAcctBalance));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("LAST_ACCT_PROFIT_AND_LOSS");
			itemson.setTextContent(Converter
					.formatFen2yuan(lastAcctProfitAndLoss));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("LAST_FRZ_RISK_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(lastFrzRiskFund));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("TOTAL_RIGHT");
			itemson.setTextContent(Converter.formatFen2yuan(totalRight));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("AVLB_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(avlbFund));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("SUBS_DEPOSIT");
			itemson.setTextContent(Converter.formatFen2yuan(subsDeposit));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ACCT_BALANCE");
			itemson.setTextContent(Converter.formatFen2yuan(acctBalance));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ACCT_PROFIT_AND_LOSS");
			itemson.setTextContent(Converter.formatFen2yuan(acctProfitAndLoss));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("FRZ_RISK_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(frzRiskFund));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("DEAL_QTT");
			itemson.setTextContent(dealQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("DEAL_AMT");
			itemson.setTextContent(Converter.formatFen2yuan(dealAmt));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CUR_POUNDAGE");
			itemson.setTextContent(Converter.formatFen2yuan(curPoundage));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CNY_BALANCE");
			itemson.setTextContent(Converter.formatFen2yuan(curCnyBalance));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CNY_INCOME");
			itemson.setTextContent(Converter.formatFen2yuan(curCnyInCome));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CSG_INCOME");
			itemson.setTextContent(Converter.formatFen2yuan(curCsgInCome));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("PAID_PAYMENT");
			itemson.setTextContent(Converter.formatFen2yuan(curPaidPayment));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("GOT_PAYMENT");
			itemson.setTextContent(Converter.formatFen2yuan(curGotPayment));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("LEFT_PAYMENT");
			itemson.setTextContent(Converter.formatFen2yuan(leftPayment));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CUR_BUYER_DIFF");
			itemson.setTextContent(Converter.formatFen2yuan(curBuyerDiff));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CUR_CSG_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(curCsgFee));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CUR_IN_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(curInFund));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CUR_OUT_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(curOutFund));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("DIFF_PRICE");
			itemson.setTextContent(Converter.formatFen2yuan(0));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CUR_DISOBEY_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(curDisobeyFee));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CUR_AGENCY_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(curAgencyFee));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ACCRUAL");
			itemson.setTextContent(Converter.formatFen2yuan(accrual));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("OTHER");
			itemson.setTextContent(Converter.formatFen2yuan(other - accrual));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("PAYMENT_BALANCE");
			itemson.setTextContent(Converter.formatFen2yuan(paymentAndBalance));
			item.appendChild(itemson);
			/** 20080826 by yanjl */
			itemson = centerDoc.createElement("LAST_LOAN_BALANCE");
			if (lastdailyFundSummary != null)
				itemson.setTextContent(Converter
						.formatFen2yuan(lastdailyFundSummary.getLoanBalance()));
			else
				itemson.setTextContent("0");
			item.appendChild(itemson);
			itemson = centerDoc.createElement("CUR_LOAN_BALANCE");
			itemson.setTextContent(Converter.formatFen2yuan(dailyFundSummary
					.getLoanBalance()));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("CUR_LOAN_POUNDAGE");
			itemson.setTextContent(Converter.formatFen2yuan(dailyFundSummary
					.getCurLoanPoundage()));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("CUR_LOAN_INTEREST");
			itemson.setTextContent(Converter.formatFen2yuan(dailyFundSummary
					.getCurLoanInterest()));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("LAST_REPAY_SUM");
			itemson.setTextContent(Converter.formatFen2yuan(lastRepaySum));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("CUR_REPAY_SUM");
			itemson.setTextContent(Converter.formatFen2yuan(curRepaySum));
			item.appendChild(itemson);
			// 新增手续费返还
			itemson = centerDoc.createElement("RET_POUNDAGE");
			itemson.setTextContent(Converter.formatFen2yuan(dailyFundSummary
					.getRetPoundage()));
			item.appendChild(itemson);

			/** 20091030 by suntao */
			itemson = centerDoc.createElement("RISK_RESERVE_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(riskReserveFund));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("DELAY_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(delayFee));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("EXTEND_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(extendFee));
			item.appendChild(itemson);

			/** 20091107 by suntao 动态权益 */
			itemson = centerDoc.createElement("DYNAMIC_RIGHT");
			itemson.setTextContent(Converter.formatFen2yuan(totalRight
					+ acctProfitAndLoss));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("LAST_DYNAMIC_RIGHT");
			itemson.setTextContent(Converter.formatFen2yuan(lastTotalRight
					+ lastAcctProfitAndLoss));
			item.appendChild(itemson);

			/** 20091125 by suntao 交割保证金 */
			itemson = centerDoc.createElement("CSG_DEPOSIT");
			itemson.setTextContent(Converter.formatFen2yuan(csgDeposit));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("LAST_CSG_DEPOSIT");
			itemson.setTextContent(Converter.formatFen2yuan(lastCsgDeposit));
			item.appendChild(itemson);

			// logger.debug("构造中心DOMSource耗时=="+(System.currentTimeMillis()-sqlstart)/1000.0+"秒");
			// sqlstart = System.currentTimeMillis();

			// 应宁波液化需求追加生成:出入金明细表,收入及代付表
			if (centerInOutFile == null && (curInFund != 0 || curOutFund != 0)) {
				fileName = centerDir + settleDay + "_CRJ.xml";
				centerInOutFile = new FileWriter(fileName);
				centerInOutBuf = new BufferedWriter(centerInOutFile);

				centerInOutBuf
						.write("<?xml version=\"1.0\" encoding=\"GBK\"?>\n");
				centerInOutBuf.write("<root>\n");
				centerInOutBuf.write("	 <file_title>交易中心出入金明细表:" + settleDay
						+ "_CRJ</file_title>\n");
				centerInOutBuf
						.write("	 <report_name>交易中心出入金明细表</report_name>\n");
				centerInOutBuf.write("	 <top>\n");
				centerInOutBuf.write("		<item>\n");

				centerInOutBuf.write("			<content>" + statDay + "</content>\n");
				centerInOutBuf.write("		</item>\n");
				centerInOutBuf.write("	 </top>\n");
				centerInOutBuf.write("	 <body>\n");

			}
			if (centerIncomeFile == null
					&& (curPoundage != 0 || curCsgFee != 0 || curManageFee != 0
							|| curDisobeyFee != 0 || curAgencyFee != 0 || accrual != 0)) {
				fileName = centerDir + settleDay + "_SRDF.xml";
				centerIncomeFile = new FileWriter(fileName);
				centerIncomeBuf = new BufferedWriter(centerIncomeFile);

				centerIncomeBuf
						.write("<?xml version=\"1.0\" encoding=\"GBK\"?>\n");
				centerIncomeBuf.write("<root>\n");
				centerIncomeBuf.write("	 <file_title>交易中心收入及代付表:" + settleDay
						+ "_SRDF</file_title>\n");
				centerIncomeBuf
						.write("	 <report_name>交易中心收入及代付表</report_name>\n");
				centerIncomeBuf.write("	 <top>\n");
				centerIncomeBuf.write("		<item>\n");

				centerIncomeBuf
						.write("			<content>" + statDay + "</content>\n");
				centerIncomeBuf.write("		</item>\n");
				centerIncomeBuf.write("	 </top>\n");
				centerIncomeBuf.write("	 <body>\n");
			}

			if (curInFund != 0 || curOutFund != 0) {
				// 数据输入
				centerInOutBuf.write("	  <item>\n");
				centerInOutBuf.write("		<SEQ>" + index + "</SEQ>\n");
				centerInOutBuf.write("		<ASSOCIATOR_NO>" + assoRemark
						+ "</ASSOCIATOR_NO>\n");
				centerInOutBuf.write("		<TOTAL_RIGHT>"
						+ Converter.formatFen2yuan(totalRight)
						+ "</TOTAL_RIGHT>\n");
				centerInOutBuf.write("		<IN_FUND>"
						+ Converter.formatFen2yuan(curInFund) + "</IN_FUND>\n");
				centerInOutBuf
						.write("		<AVLB_FUND>"
								+ Converter.formatFen2yuan(avlbFund)
								+ "</AVLB_FUND>\n");
				centerInOutBuf.write("		<OUT_FUND>"
						+ Converter.formatFen2yuan(curOutFund)
						+ "</OUT_FUND>\n");
				centerInOutBuf.write("		<OUT_CHECK>" + "" + "</OUT_CHECK>\n");
				centerInOutBuf
						.write("		<DEBT_FUND>"
								+ Converter.formatFen2yuan(debtFund)
								+ "</DEBT_FUND>\n");
				centerInOutBuf.write("		<REPAY_FUND>"
						+ Converter.formatFen2yuan(repayFund)
						+ "</REPAY_FUND>\n");
				centerInOutBuf.write("	  </item>\n");

				ttotalRight += totalRight;
				totalInFund += curInFund;
				totalAvlbFund += avlbFund;
				totalOutFund += curOutFund;
				totalDebtFund += debtFund;
				totalRepayFund += repayFund;
				index++;
				// logger.debug("写交易中心出入金明细表耗时=="+(System.currentTimeMillis()-sqlstart)/1000.0+"秒");
				// sqlstart = System.currentTimeMillis();
			}
			if (curPoundage != 0 || curCsgFee != 0 || curManageFee != 0
					|| curDisobeyFee != 0 || curAgencyFee != 0 || accrual != 0) {
				centerIncomeBuf.write("	  <item>\n");
				centerIncomeBuf.write("		<ASSOCIATOR_NO>" + assoRemark
						+ "</ASSOCIATOR_NO>\n");
				centerIncomeBuf.write("		<CUR_POUNDAGE>"
						+ Converter.formatFen2yuan(curPoundage)
						+ "</CUR_POUNDAGE>\n");
				centerIncomeBuf.write("		<CUR_CSG_FEE>"
						+ Converter.formatFen2yuan(curCsgFee)
						+ "</CUR_CSG_FEE>\n");
				centerIncomeBuf.write("		<CUR_MANAGE_FEE>"
						+ Converter.formatFen2yuan(curManageFee)
						+ "</CUR_MANAGE_FEE>\n");
				centerIncomeBuf.write("		<CUR_DISOBEY_FEE>"
						+ Converter.formatFen2yuan(curDisobeyFee)
						+ "</CUR_DISOBEY_FEE>\n");
				centerIncomeBuf.write("		<CUR_AGENCY_FEE>"
						+ Converter.formatFen2yuan(curAgencyFee)
						+ "</CUR_AGENCY_FEE>\n");
				centerIncomeBuf.write("		<ACCRUAL>"
						+ Converter.formatFen2yuan(accrual) + "</ACCRUAL>\n");
				centerIncomeBuf.write("	  </item>\n");
				totalPoundage += curPoundage;
				totalCsgFee += curCsgFee;
				totalDisobeyFee += curDisobeyFee;
				totalManageFee += curManageFee;
				totalAgencyFee += curAgencyFee;
				totalAccrual += accrual;
				// logger.debug("写交易中心收入及代付表耗时=="+(System.currentTimeMillis()-sqlstart)/1000.0+"秒");
			}

		}
		if (centerInOutFile != null) {
			centerInOutBuf.write("    <total>\n");
			centerInOutBuf.write("		<TOTAL_TOTAL_RIGHT>"
					+ Converter.formatFen2yuan(ttotalRight)
					+ "</TOTAL_TOTAL_RIGHT>\n");
			centerInOutBuf.write("		<TOTAL_IN_FUND>"
					+ Converter.formatFen2yuan(totalInFund)
					+ "</TOTAL_IN_FUND>\n");
			centerInOutBuf.write("		<TOTAL_AVLB_FUND>"
					+ Converter.formatFen2yuan(totalAvlbFund)
					+ "</TOTAL_AVLB_FUND>\n");
			centerInOutBuf.write("		<TOTAL_OUT_FUND>"
					+ Converter.formatFen2yuan(totalOutFund)
					+ "</TOTAL_OUT_FUND>\n");
			centerInOutBuf.write("		<TOTAL_DEBT_FUND>"
					+ Converter.formatFen2yuan(totalDebtFund)
					+ "</TOTAL_DEBT_FUND>\n");
			centerInOutBuf.write("		<TOTAL_REPAY_FUND>"
					+ Converter.formatFen2yuan(totalRepayFund)
					+ "</TOTAL_REPAY_FUND>\n");
			centerInOutBuf.write("    </total>\n");
			centerInOutBuf.write("	 </body>\n");
			centerInOutBuf.write("</root>\n");
			centerInOutBuf.flush();
			centerInOutFile.flush();
			centerInOutBuf.close();
			centerInOutFile.close();
		}
		if (centerIncomeFile != null) {
			centerIncomeBuf.write("	   <total>\n");
			centerIncomeBuf.write("		<TOTAL_POUNDAGE>"
					+ Converter.formatFen2yuan(totalPoundage)
					+ "</TOTAL_POUNDAGE>\n");
			centerIncomeBuf.write("		<TOTAL_CSG_FEE>"
					+ Converter.formatFen2yuan(totalCsgFee)
					+ "</TOTAL_CSG_FEE>\n");
			centerIncomeBuf.write("		<TOTAL_MANAGE_FEE>"
					+ Converter.formatFen2yuan(totalManageFee)
					+ "</TOTAL_MANAGE_FEE>\n");
			centerIncomeBuf.write("		<TOTAL_DISOBEY_FEE>"
					+ Converter.formatFen2yuan(totalDisobeyFee)
					+ "</TOTAL_DISOBEY_FEE>\n");
			centerIncomeBuf.write("		<TOTAL_AGENCY_FEE>"
					+ Converter.formatFen2yuan(totalAgencyFee)
					+ "</TOTAL_AGENCY_FEE>\n");
			centerIncomeBuf.write("		<TOTAL_ACCRUAL>"
					+ Converter.formatFen2yuan(totalAccrual)
					+ "</TOTAL_ACCRUAL>\n");
			centerIncomeBuf.write("    </total>\n");
			centerIncomeBuf.write("	 </body>\n");
			centerIncomeBuf.write("</root>\n");
			centerIncomeBuf.flush();
			centerIncomeFile.flush();
			centerIncomeBuf.close();
			centerIncomeFile.close();
		}

		// sqlstart = System.currentTimeMillis();

		// 中心文件
		fileName = centerDir + settleDay + "_KX.xml";

		centerDoc.appendChild(root);
		dom = new DOMSource(centerDoc);
		result = new StreamResult(new File(fileName));
		trans = TransformerFactory.newInstance().newTransformer();
		trans.transform(dom, result);
		// logger.debug("中心款项表文件转换耗时=="+(System.currentTimeMillis()-sqlstart)/1000.0+"秒");
		return RetDefine.pub_success;
	}

	/**
	 * 生成款项收付月报。
	 * 
	 * @return
	 * @throws Exception
	 */
	private String[] doMonthKxList() throws Exception {
		logger.info("生成交易中心的月款项收付清单...");
		String associatorNo = "";
		long leftPayment = 0;
		long acctBalance = 0;
		long inFund = 0;
		long outFund = 0;
		long gotPayment = 0;
		long paidPayment = 0;
		long buyerDiff = 0;
		long poundage = 0;
		long csgFee = 0;
		long agencyFee = 0;
		long cnyInCome = 0;
		long csgInCome = 0;
		long totalInfund = 0;
		long totalOutfund = 0;
		long totalGotpayment = 0;
		long totalPaidpayment = 0;
		long totalBuyerdiff = 0;
		long totalPoundage = 0;
		long totalCsgfee = 0;
		long totalAgencyfee = 0;
		long totalCnyincome = 0;
		long totalCsgincome = 0;

		/** 20091030 by suntao */
		long riskReserveFund = 0;
		long delayFee = 0;
		long extendFee = 0;

		Document centerDoc = PubTools.getDocument();

		Element root = centerDoc.createElement("root");

		Element file_title = centerDoc.createElement("file_title");
		root.appendChild(file_title);
		file_title.setTextContent(settleDay + "_YKX");

		Element report_name = centerDoc.createElement("report_name");
		report_name.setTextContent("交易中心月款项收付清单");
		root.appendChild(report_name);

		Element top = centerDoc.createElement("top");
		root.appendChild(top);

		Element item = centerDoc.createElement("item");
		top.appendChild(item);

		Element content = centerDoc.createElement("content");
		content.setTextContent(statDay);
		item.appendChild(content);

		Element body = centerDoc.createElement("body");
		root.appendChild(body);

		DailyFundSummary dailyFundSummary = new DailyFundSummary();
		DailyFundSummaryExample dailyFundSummaryExample = new DailyFundSummaryExample();
		dailyFundSummaryExample.setSumDay(nextSettleDay);
		dailyFundSummaryExample
				.setSumDay_Indicator(DailyFundSummaryExample.EXAMPLE_EQUALS);
		dailyFundSummaryExample.setAssociatorNo("00001");
		dailyFundSummaryExample
				.setAssociatorNo_Indicator(DailyFundSummaryExample.EXAMPLE_NOT_EQUALS);
		List list = dailyFundSummaryDAOImpl.selectByExample(
				dailyFundSummaryExample, "ASSOCIATOR_NO");

		/** 20080827 by yanjl 仓单质押 */
		List<ResultMap> repayList = new ArrayList<ResultMap>();
		if (list != null && list.size() > 0) {
			ResultMap repayMap = new ResultMap();
			repayMap.put("beginTime", monthBeginTime);
			repayMap.put("endTime", curEndTime);
			repayList = sqlMapClient.queryForList(
					"sel_settlesrv_t_repay_info_groupByAssoNo", repayMap);
		}
		Iterator<ResultMap> repayIterator = repayList.iterator();

		ResultMap map = new ResultMap();
		map.put("beginDay", monthBeginDay);
		map.put("settleDay", nextSettleDay);

		for (int i = 0; i < list.size(); i++) {
			associatorNo = "";
			leftPayment = 0;
			acctBalance = 0;
			inFund = 0;
			outFund = 0;
			gotPayment = 0;
			paidPayment = 0;
			buyerDiff = 0;
			poundage = 0;
			csgFee = 0;
			agencyFee = 0;
			cnyInCome = 0;
			csgInCome = 0;
			totalInfund = 0;
			totalOutfund = 0;
			totalGotpayment = 0;
			totalPaidpayment = 0;
			totalBuyerdiff = 0;
			totalPoundage = 0;
			totalCsgfee = 0;
			totalAgencyfee = 0;
			totalCnyincome = 0;
			totalCsgincome = 0;

			/** 20091030 by suntao */
			riskReserveFund = 0;
			delayFee = 0;
			extendFee = 0;

			dailyFundSummary = (DailyFundSummary) list.get(i);
			// 会员编码
			associatorNo = dailyFundSummary.getAssociatorNo();
			leftPayment = dailyFundSummary.getLeftPayment();
			acctBalance = dailyFundSummary.getAcctBalance();
			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();

			/** 20080827 仓单质押 */
			long loanPoundage = 0, loanInterest = 0, repaySum = 0, loanBalance = 0;
			loanBalance = dailyFundSummary.getLoanBalance();
			repayIterator = repayList.iterator();
			while (repayIterator.hasNext()) {
				ResultMap element = repayIterator.next();
				if (element.getString("associator_no", "").equals(associatorNo)) {
					repaySum = element.getLong("repay_sum", 0);
					// repayIterator.remove();
					break;
				}
			}

			// 获得月资金统计数据
			map.put("associatorNo", associatorNo);
			List fundList = sqlMapClient.queryForList(
					"sel_settlesrvRpt_monthDate_T_DAILY_FUND_SUMMARY", map);
			ResultMap restMap = (ResultMap) fundList.get(0);
			inFund = restMap.getLong("in_fund", 0);
			outFund = restMap.getLong("out_fund", 0);
			gotPayment = restMap.getLong("got_payment", 0);
			paidPayment = restMap.getLong("paid_payment", 0);
			buyerDiff = restMap.getLong("buyer_diff", 0);
			poundage = restMap.getLong("poundage", 0);
			csgFee = restMap.getLong("csg_fee", 0);
			agencyFee = restMap.getLong("agency_fee", 0);
			cnyInCome = restMap.getLong("cny_balance", 0);
			csgInCome = restMap.getLong("csg_balance", 0);
			loanPoundage = restMap.getLong("cur_loan_poundage", 0);
			loanInterest = restMap.getLong("cur_loan_interest", 0);
			long otherFee = restMap.getLong("other_fee", 0);
			long curManageFee = restMap.getLong("cur_manage_fee", 0);
			long disobeyFee = restMap.getLong("disobey_fee", 0);
			long retPoundage = restMap.getLong("ret_poundage", 0);

			/** 20091030 by suntao */
			delayFee = restMap.getLong("DELAY_FEE", 0);
			extendFee = restMap.getLong("EXTEND_FEE", 0);

			Map reserveMap = new HashMap();
			reserveMap.put("associatorNo", associatorNo);
			reserveMap.put("beginDay", monthBeginDay);
			reserveMap.put("endDay", nextSettleDay);

			riskReserveFund = Long.parseLong(sqlMapClient.queryForObject(
					"sel_settlesrvRpt_assoreserve_T_DELAY_FEE_LOG", reserveMap)
					.toString());

			List totalfundList = sqlMapClient.queryForList(
					"sel_settlesrvRpt_totalDate_T_DAILY_FUND_SUMMARY", map);
			restMap = (ResultMap) totalfundList.get(0);
			totalInfund = restMap.getLong("in_fund", 0);
			totalOutfund = restMap.getLong("out_fund", 0);
			totalGotpayment = restMap.getLong("got_payment", 0);
			totalPaidpayment = restMap.getLong("paid_payment", 0);
			totalBuyerdiff = restMap.getLong("buyer_diff", 0);
			totalPoundage = restMap.getLong("poundage", 0);
			totalCsgfee = restMap.getLong("csg_fee", 0);
			totalAgencyfee = restMap.getLong("agency_fee", 0);
			totalCnyincome = restMap.getLong("cny_balance", 0);
			totalCsgincome = restMap.getLong("csg_balance", 0);
			long totalOtherFee = restMap.getLong("other_fee", 0);
			long totalCurManageFee = restMap.getLong("cur_manage_fee", 0);
			long totalDisobeyFee = restMap.getLong("disobey_fee", 0);
			long totalRetPoundage = restMap.getLong("ret_poundage", 0);

			item = centerDoc.createElement("item");
			body.appendChild(item);

			Element itemson = centerDoc.createElement("ASSOCIATOR_NO");
			itemson.setTextContent(assoRemark);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ASSOC_FULL_NAME");
			itemson.setTextContent(associatorInfoMap.get(associatorNo)
					.getFullName());
			item.appendChild(itemson);

			itemson = centerDoc.createElement("MONTH_POUNDAGE");
			itemson.setTextContent(Converter.formatFen2yuan(poundage));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("MONTH_CSG_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(csgFee));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("MONTH_PAID_PAYMENT");
			itemson.setTextContent(Converter.formatFen2yuan(paidPayment));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("MONTH_GOT_PAYMENT");
			itemson.setTextContent(Converter.formatFen2yuan(gotPayment));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CUR_LEFT_PAYMENT");
			itemson.setTextContent(Converter.formatFen2yuan(leftPayment));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("MONTH_IN_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(inFund));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("MONTH_OUT_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(outFund));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("MONTH_BUYER_DIFF");
			itemson.setTextContent(Converter.formatFen2yuan(buyerDiff));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("MONTH_AGENCY_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(agencyFee));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("MONTH_CNY_INCOME");
			itemson.setTextContent(Converter.formatFen2yuan(cnyInCome));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("TOTAL_CNY_INCOME");
			itemson.setTextContent(Converter.formatFen2yuan(totalCnyincome));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("MONTH_CSG_INCOME");
			itemson.setTextContent(Converter.formatFen2yuan(csgInCome));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("TOTAL_CSG_INCOME");
			itemson.setTextContent(Converter.formatFen2yuan(totalCsgincome));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CUR_ACCT_BALANCE");
			itemson.setTextContent(Converter.formatFen2yuan(acctBalance));
			item.appendChild(itemson);

			/** 20080903 by yanjl 其他费用 */
			itemson = centerDoc.createElement("MONTH_OTHER_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(otherFee));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("TOTAL_OTHER_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(totalOtherFee));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("MONTH_MANAGE_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(curManageFee));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("TOTAL_MANAGE_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(totalCurManageFee));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("MONTH_DISOBEY_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(disobeyFee));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("TOTAL_DISOBEY_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(totalDisobeyFee));
			item.appendChild(itemson);

			/** 20080826 by yanjl 仓单质押 */
			itemson = centerDoc.createElement("LOAN_POUNDAGE");
			itemson.setTextContent(Converter.formatFen2yuan(loanPoundage));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("LOAN_INTEREST");
			itemson.setTextContent(Converter.formatFen2yuan(loanInterest));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("LOAN_REPAY_SUM");
			itemson.setTextContent(Converter.formatFen2yuan(repaySum));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("CUR_LOAN_BALANCE");
			itemson.setTextContent(Converter.formatFen2yuan(loanBalance));
			item.appendChild(itemson);

			/** 20090727 qiuyc 手续费返还 */
			itemson = centerDoc.createElement("MONTH_RET_POUNDAGE");
			itemson.setTextContent(Converter.formatFen2yuan(retPoundage));
			item.appendChild(itemson);
			itemson = centerDoc.createElement("TOTAL_RET_POUNDAGE");
			itemson.setTextContent(Converter.formatFen2yuan(totalRetPoundage));
			item.appendChild(itemson);

			/** 20091030 by suntao */
			itemson = centerDoc.createElement("RISK_RESERVE_FUND");
			itemson.setTextContent(Converter.formatFen2yuan(riskReserveFund));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("DELAY_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(delayFee));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("EXTEND_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(extendFee));
			item.appendChild(itemson);
		}

		fileName = centerDir + settleDay + "_YKX.xml";

		centerDoc.appendChild(root);
		dom = new DOMSource(centerDoc);
		result = new StreamResult(new File(fileName));
		trans = TransformerFactory.newInstance().newTransformer();
		trans.transform(dom, result);

		return RetDefine.pub_success;
	}

	// private String[] doOrderList() throws Exception
	// {
	// logger.info("生成交易中心/会员的委托清单...");
	// RetObject ret = new RetObject();
	// String retStr[];
	// String lastAssocNo = "";
	// String associatorNo = "";
	// String fullName = "";
	// String clientId = "";
	// long assocSeq = 0;
	// long centerSeq = 1;
	//
	// FileWriter assocFileWriter = new FileWriter("");
	// BufferedWriter assocWrite = new BufferedWriter(assocFileWriter);
	//
	// String fileName = centerDir + settleDay + "_WT.xml";
	//
	// FileWriter fileWriter = new FileWriter(fileName);
	// BufferedWriter centerWrite = new BufferedWriter(fileWriter);
	// centerWrite.write("<?xml version=\"1.0\" encoding=\"GB2312\"?>\n");
	// centerWrite.write("<root>\n");
	// centerWrite.write(" <file_title>" + settleDay +"_WT</file_title>\n");
	// centerWrite.write(" <report_name>交易中心委托清单</report_name>\n");
	// centerWrite.write(" <top>\n");
	// centerWrite.write(" <item>\n");

	// centerWrite.write(" <content>" + settleDay + "</content>\n");
	// centerWrite.write(" </item>\n");
	// centerWrite.write(" </top>\n");
	// centerWrite.write(" <body>\n");
	//
	// ResultMap map = new ResultMap();
	// map.put("settleDay", settleDay);
	// List list =
	// sqlMapClient.queryForList("sel_settlesrvRpt_orderDate_T_ORDER_HIST",
	// map);
	// for (int i = 0; i < list.size(); i++)
	// {
	// ResultMap restMap = (ResultMap)list.get(i);
	//
	// clientId = restMap.getString("client_id");
	// String orderNo = restMap.getString("order_no");
	// String contractId = restMap.getString("contract_id");
	// String buyOrSell = restMap.getString("buyorsell");
	// String orderType = restMap.getString("order_type", "1");
	// long isDeposit = restMap.getLong("is_deposit", 1);
	// long orderPrice = restMap.getLong("order_price", 0);
	// long orderQtt = restMap.getLong("order_qtt", 0);
	// long leftQtt = restMap.getLong("left_qtt", 0);
	// String orderTime =
	// DateUtil.format(((TIMESTAMP)restMap.get("order_time")).dateValue(),"yyyy-MM-dd
	// HH:mm:ss");
	// String operatorNo = restMap.getString("operator_no", "--");
	// String cancelOper = restMap.getString("cancel_oper", "--");
	// String cancelTime = restMap.getString("cancel_time", "--");
	// String tradeMode = restMap.getString("trade_mode");
	// String status = restMap.getString("status", "1");
	// long cancelQtt = 0;
	//
	// if (status.equals("4"))
	// {
	// cancelQtt = leftQtt;
	// leftQtt = 0;
	// }
	//
	// String clientName = clientMap.get(clientId);
	// associatorNo = clientId.substring(0, 6);
	//
	// if (!(associatorNo.equals(lastAssocNo)))
	// {
	// // 已经生成有会员了
	// if (centerSeq > 1)
	// {
	// // 关闭上一会员的当日委托文件
	// assocWrite.write(" </body>\n");
	// assocWrite.write("</root>\n");
	// assocWrite.close();
	// assocFileWriter.close();
	// }
	// //下一会员
	// String assocFileName = assocDir + associatorNo + dayDir + associatorNo +
	// "_"+ settleDay + "_WT.xml";
	// AssociatorInfoDAOImpl associatorInfoDAOImpl = new
	// AssociatorInfoDAOImpl(sqlMapClient);
	// AssociatorInfoKey associatorInfoKey = new AssociatorInfoKey();
	// associatorInfoKey.setAssociatorNo(associatorNo);
	// fullName =
	// associatorInfoDAOImpl.selectByPrimaryKey(associatorInfoKey).getFullName();
	//
	// assocFileWriter = new FileWriter(assocFileName);
	// assocWrite = new BufferedWriter(assocFileWriter);
	//
	// assocWrite.write("<?xml version=\"1.0\" encoding=\"GB2312\" ?>\n");
	// assocWrite.write("<root>\n");
	// assocWrite.write(" <file_title>" + associatorNo + "_" + settleDay +
	// "_WT</file_title>\n");
	// assocWrite.write(" <report_name>委托清单</report_name>\n");
	// assocWrite.write(" <top>\n");
	// assocWrite.write(" <item>\n");

	// assocWrite.write(" <content>" + associatorNo + "</content>\n");
	// assocWrite.write(" </item>\n");
	// assocWrite.write(" <item>\n");

	// assocWrite.write(" <content>" + fullName + "</content>\n");
	// assocWrite.write(" </item>\n");
	// assocWrite.write(" <item>\n");

	// assocWrite.write(" <content>" + settleDay + "</content>\n");
	// assocWrite.write(" </item>\n");
	// assocWrite.write(" </top>\n");
	// assocWrite.write(" <body>\n");
	//
	// lastAssocNo = associatorNo;
	// assocSeq = 1;
	// }
	// assocWrite.write(" <item>\n");
	// assocWrite.write(" <SEQ>" + assocSeq + "</SEQ>\n");
	// assocWrite.write(" <CLIENT_ID>" + clientId + "</CLIENT_ID>\n");
	// assocWrite.write(" <CLIENT_NAME>" + clientName + "</CLIENT_NAME>\n");
	// assocWrite.write(" <ORDER_NO>" + orderNo + "</ORDER_NO>\n");
	// assocWrite.write(" <CONTRACT_ID>" + contractId + "</CONTRACT_ID>\n");
	// assocWrite.write(" <TRADE_MODE>" + tradeMode + "</TRADE_MODE>\n");
	// assocWrite.write(" <BUYORSELL>" + buyOrSell + "</BUYORSELL>\n");
	// assocWrite.write(" <ORDER_TYPE>" + orderType +"</ORDER_TYPE>\n");
	// assocWrite.write(" <IS_DEPOSIT>" + isDeposit + "</IS_DEPOSIT>\n");
	// assocWrite.write(" <ORDER_PRICE>" +
	// Converter.formatFen2yuan(Converter.reversePriceByRate(orderPrice, rate))
	// +"</ORDER_PRICE>\n");
	// assocWrite.write(" <ORDER_QTT>" + orderQtt +"</ORDER_QTT>\n");
	// assocWrite.write(" <ORDER_TIME>" + orderTime +"</ORDER_TIME>\n");
	// assocWrite.write(" <OPERATOR_NO>" + operatorNo +"</OPERATOR_NO>\n");
	// assocWrite.write(" <LEFT_QTT>" + leftQtt + "</LEFT_QTT>\n");
	// assocWrite.write(" <CANCEL_QTT>" + cancelQtt + "</CANCEL_QTT>\n");
	// assocWrite.write(" <CANCEL_OPER>" + cancelOper + "</CANCEL_OPER>\n");
	// assocWrite.write(" <CANCEL_TIME>" + cancelTime + "</CANCEL_TIME>\n");
	// assocWrite.write(" </item>\n");
	// assocSeq++;
	//
	// // 中心数据
	// centerWrite.write(" <item>\n");
	// centerWrite.write(" <SEQ>" + centerSeq + "</SEQ>\n");
	// centerWrite.write(" <ASSOCIATOR_NO>" + associatorNo +
	// "</ASSOCIATOR_NO>\n");
	// centerWrite.write(" <ASSOC_FULL_NAME>" + fullName +
	// "</ASSOC_FULL_NAME>\n");
	// centerWrite.write(" <ORDER_NO>" + orderNo + "</ORDER_NO>\n");
	// centerWrite.write(" <CLIENT_ID>" + clientId + "</CLIENT_ID>\n");
	// centerWrite.write(" <CLIENT_NAME>" + clientName + "</CLIENT_NAME>\n");
	// centerWrite.write(" <CONTRACT_ID>" + contractId + "</CONTRACT_ID>\n");
	// centerWrite.write(" <TRADE_MODE>" + tradeMode + "</TRADE_MODE>\n");
	// centerWrite.write(" <BUYORSELL>" + buyOrSell + "</BUYORSELL>\n");
	// centerWrite.write(" <ORDER_TYPE>" + orderType +"</ORDER_TYPE>\n");
	// centerWrite.write(" <IS_DEPOSIT>" + isDeposit + "</IS_DEPOSIT>\n");
	// centerWrite.write(" <ORDER_PRICE>" +
	// Converter.formatFen2yuan(Converter.reversePriceByRate(orderPrice, rate))
	// +"</ORDER_PRICE>\n");
	// centerWrite.write(" <ORDER_QTT>" + orderQtt +"</ORDER_QTT>\n");
	// centerWrite.write(" <ORDER_TIME>" + orderTime +"</ORDER_TIME>\n");
	// centerWrite.write(" <OPERATOR_NO>" + operatorNo +"</OPERATOR_NO>\n");
	// centerWrite.write(" <LEFT_QTT>" + leftQtt + "</LEFT_QTT>\n");
	// centerWrite.write(" <CANCEL_QTT>" + cancelQtt + "</CANCEL_QTT>\n");
	// centerWrite.write(" <CANCEL_OPER>" + cancelOper + "</CANCEL_OPER>\n");
	// centerWrite.write(" <CANCEL_TIME>" + cancelTime + "</CANCEL_TIME>\n");
	// centerWrite.write(" </item>\n");
	// centerSeq++;
	// }
	// centerWrite.write(" </body>");
	// centerWrite.write("</root>");
	// centerWrite.close();
	// fileWriter.close();
	//
	// return RetDefine.pub_success;
	// }
	//
	//

	/**
	 * 按交易商生成当日委托表。
	 * 
	 * @return
	 * @throws Exception
	 */
	private String[] doOrderList() throws Exception {
		logger.info("生成交易中心/会员的委托清单...");
		String lastAssocNo = "";
		String associatorNo = "";
		String fullName = "";
		String clientId = "";
		String clientName = "";
		String orderNo = "";
		String contractId = "";
		String buyOrSell = "";
		String orderType = "";
		String orderTime = "";
		String operatorNo = "";
		String cancelOper = "";
		String cancelTime = "";
		String tradeMode = "";
		String status = "";
		long assocSeq = 0;
		long centerSeq = 1;
		long isDeposit = 0;
		long orderPrice = 0;
		long orderQtt = 0;
		long leftQtt = 0;
		long cancelQtt = 0;

		Document assocDoc = PubTools.getDocument();
		Element aroot = assocDoc.createElement("root");
		Element abody = assocDoc.createElement("body");

		Document centerDoc = PubTools.getDocument();
		Element root = centerDoc.createElement("root");

		Element file_title = centerDoc.createElement("file_title");
		root.appendChild(file_title);
		file_title.setTextContent(settleDay + "_WT");

		Element report_name = centerDoc.createElement("report_name");
		report_name.setTextContent("交易中心委托清单");
		root.appendChild(report_name);

		Element top = centerDoc.createElement("top");
		root.appendChild(top);

		Element item = centerDoc.createElement("item");
		top.appendChild(item);

		Element content = centerDoc.createElement("content");
		content.setTextContent(statDay);
		item.appendChild(content);

		Element body = centerDoc.createElement("body");
		root.appendChild(body);

		// 设置查询条件
		ResultMap map = new ResultMap();
		map.put("settleDay", settleDay);
		List list = sqlMapClient.queryForList(
				"sel_settlesrvRpt_orderDate_T_ORDER_HIST", map);
		for (int i = 0; i < list.size(); i++) {
			clientId = "";
			orderNo = "";
			contractId = "";
			clientName = "";
			buyOrSell = "";
			orderType = "";
			isDeposit = 0;
			orderPrice = 0;
			orderQtt = 0;
			leftQtt = 0;
			orderTime = "";
			operatorNo = "";
			cancelOper = "";
			cancelTime = "";
			tradeMode = "";
			status = "";
			cancelQtt = 0;

			ResultMap restMap = (ResultMap) list.get(i);

			clientId = restMap.getString("client_id");
			clientName = clientMap.get(clientId);
			orderNo = restMap.getString("order_no");
			contractId = restMap.getString("contract_id");
			buyOrSell = restMap.getString("buyorsell");
			orderType = restMap.getString("offset_flag", "1");
			isDeposit = restMap.getLong("is_deposit", 1);
			orderPrice = restMap.getLong("order_price", 0);
			orderQtt = restMap.getLong("order_qtt", 0);
			leftQtt = restMap.getLong("left_qtt", 0);
			orderTime = DateUtil.format(((TIMESTAMP) restMap.get("order_time"))
					.dateValue(), "yyyy-MM-dd HH:mm:ss");
			operatorNo = restMap.getString("operator_no", "--");
			cancelOper = restMap.getString("cancel_oper", "--");
			cancelTime = restMap.getString("cancel_time", "--");
			tradeMode = restMap.getString("trade_mode");
			status = restMap.getString("status", "1");
			cancelQtt = 0;

			if (status.equals("4")) {
				cancelQtt = leftQtt;
				leftQtt = 0;
			}
			associatorNo = StringUtil.subStrToStart(clientId, 6);

			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();

			if (!(associatorNo.equals(lastAssocNo))) {
				// 已经生成有会员了
				if (centerSeq > 1) {
					String lastAssoRemark = associatorInfoMap.get(lastAssocNo)
							.getRemarak();
					// 会员仓单文件
					fileName = assocDir + lastAssoRemark + dayDir
							+ lastAssoRemark + "_" + settleDay + "_WT.xml";
					assocDoc.appendChild(aroot);

					dom = new DOMSource(assocDoc);
					result = new StreamResult(new File(fileName));
					trans = TransformerFactory.newInstance().newTransformer();
					trans.transform(dom, result);
				}

				// 下一会员
				fullName = "";
				fullName = associatorInfoMap.get(associatorNo).getFullName();

				assocDoc = PubTools.getDocument();
				aroot = assocDoc.createElement("root");

				Element afile_title = assocDoc.createElement("file_title");

				assoRemark = associatorInfoMap.get(associatorNo).getRemarak();
				afile_title
						.setTextContent(assoRemark + "_" + settleDay + "_WT");
				aroot.appendChild(afile_title);

				Element areport_name = assocDoc.createElement("report_name");
				areport_name.setTextContent("委托清单");
				aroot.appendChild(areport_name);

				Element atop = assocDoc.createElement("top");
				aroot.appendChild(atop);

				Element aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				Element acontent = assocDoc.createElement("content");
				acontent.setTextContent(assoRemark);
				aitem.appendChild(acontent);

				aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				acontent = assocDoc.createElement("content");
				acontent.setTextContent(fullName);
				aitem.appendChild(acontent);

				aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				acontent = assocDoc.createElement("content");
				acontent.setTextContent(statDay);
				aitem.appendChild(acontent);

				abody = assocDoc.createElement("body");
				aroot.appendChild(abody);

				lastAssocNo = associatorNo;
				assocSeq = 1;
			}

			Element aitem = assocDoc.createElement("item");
			abody.appendChild(aitem);

			Element aitemson = assocDoc.createElement("SEQ");
			aitemson.setTextContent(assocSeq + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CLIENT_ID");
			aitemson.setTextContent(assoRemark);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CLIENT_NAME");
			aitemson.setTextContent(clientName);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("ORDER_NO");
			aitemson.setTextContent(orderNo);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CONTRACT_ID");
			aitemson.setTextContent(contractId);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("TRADE_MODE");
			aitemson.setTextContent(tradeMode);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("BUYORSELL");
			aitemson.setTextContent(buyOrSell);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("ORDER_TYPE");
			aitemson.setTextContent(orderType);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("IS_DEPOSIT");
			aitemson.setTextContent(isDeposit + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("ORDER_PRICE");
			aitemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(orderPrice, rate)));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("ORDER_QTT");
			aitemson.setTextContent(orderQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("ORDER_TIME");
			aitemson.setTextContent(orderTime);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("OPERATOR_NO");
			aitemson.setTextContent(operatorNo);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("LEFT_QTT");
			aitemson.setTextContent(leftQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CANCEL_QTT");
			aitemson.setTextContent(cancelQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CANCEL_OPER");
			aitemson.setTextContent(cancelOper);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CANCEL_TIME");
			aitemson.setTextContent(cancelTime);
			aitem.appendChild(aitemson);

			assocSeq++;

			// 中心数据
			item = centerDoc.createElement("item");
			body.appendChild(item);

			Element itemson = centerDoc.createElement("SEQ");
			itemson.setTextContent(centerSeq + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ASSOCIATOR_NO");
			itemson.setTextContent(assoRemark);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ASSOC_FULL_NAME");
			itemson.setTextContent(fullName);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ORDER_NO");
			itemson.setTextContent(orderNo);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CLIENT_ID");
			itemson.setTextContent(assoRemark);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CLIENT_NAME");
			itemson.setTextContent(clientName);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CONTRACT_ID");
			itemson.setTextContent(assoRemark);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("TRADE_MODE");
			itemson.setTextContent(tradeMode);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("BUYORSELL");
			itemson.setTextContent(buyOrSell);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ORDER_TYPE");
			itemson.setTextContent(orderType);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("IS_DEPOSIT");
			itemson.setTextContent(isDeposit + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ORDER_PRICE");
			itemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(orderPrice, rate)));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ORDER_QTT");
			itemson.setTextContent(orderQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ORDER_TIME");
			itemson.setTextContent(orderTime);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("OPERATOR_NO");
			itemson.setTextContent(operatorNo);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("LEFT_QTT");
			itemson.setTextContent(leftQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CANCEL_QTT");
			itemson.setTextContent(cancelQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CANCEL_OPER");
			itemson.setTextContent(cancelOper);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CANCEL_TIME");
			itemson.setTextContent(cancelTime);
			item.appendChild(itemson);

			centerSeq++;
		}

		// 有数据才写文件
		if (centerSeq > 1) {
			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();
			// 会员委托文件
			fileName = assocDir + assoRemark + dayDir + assoRemark + "_"
					+ settleDay + "_WT.xml";
			assocDoc.appendChild(aroot);
			dom = new DOMSource(assocDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);

			// 中心委托文件
			fileName = centerDir + settleDay + "_WT.xml";
			centerDoc.appendChild(root);

			DOMSource dom = new DOMSource(centerDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);
		}
		return RetDefine.pub_success;
	}

	/**
	 * 按交易商生成当日成交表。
	 * 
	 * @return
	 * @throws Exception
	 */

	private String[] doTradeList() throws Exception {
		logger.info("生成交易中心/会员的交易清单...");
		String lastAssocNo = "";
		String associatorNo = "";
		String fullName = "";
		String clientId = "";
		long assocSeq = 1;
		long centerSeq = 1;
		long totalDealQtt = 0;
		long totalRcptQtt = 0;
		long totalCnyInCome = 0;
		long totalPoundage = 0;
		String dealNo = "";
		String contractId = "";
		String buyOrSell = "";
		String dealType = "";
		String conveyType = "";
		String dealTime = "";
		String orderNo = "";
		String tradeMode = "";
		String orderTime = "--";
		String clientName = "--";
		long dealPrice = 0;
		long dealQtt = 0;
		long dealReceipt = 0;
		long poundage = 0;
		long newCost = 0;
		long cnyBalance = 0;
		long newPrice = 0;
		long cnyInCome = 0;
		int istreatycny = 0;

		Document assocDoc = PubTools.getDocument();
		Element aroot = assocDoc.createElement("root");
		Element abody = assocDoc.createElement("body");

		Document centerDoc = PubTools.getDocument();
		Element root = centerDoc.createElement("root");

		Element file_title = centerDoc.createElement("file_title");
		root.appendChild(file_title);
		file_title.setTextContent(settleDay + "_JY");

		Element report_name = centerDoc.createElement("report_name");
		report_name.setTextContent("交易中心交易清单");
		root.appendChild(report_name);

		Element top = centerDoc.createElement("top");
		root.appendChild(top);

		Element item = centerDoc.createElement("item");
		top.appendChild(item);

		Element content = centerDoc.createElement("content");
		content.setTextContent(statDay);
		item.appendChild(content);

		Element body = centerDoc.createElement("body");
		root.appendChild(body);

		// 设置查询条件
		ResultMap map = new ResultMap();
		map.put("beginTime", curBeginTime);
		map.put("endTime", curEndTime);
		List list = sqlMapClient.queryForList(
				"sel_settlesrvRpt_dealDate_T_DEAL_HIST", map);
		Map<String, String> poundaryMap = new HashMap<String, String>();
		/** 20080813 by yanjl 合同汇率 */
		Map<String, Double> roeInfoMap = new HashMap<String, Double>();
		OrderFHistDAOImpl orderFHistDAOImpl = new OrderFHistDAOImpl(
				sqlMapClient);
		OrderSHistDAOImpl orderSHistDAOImpl = new OrderSHistDAOImpl(
				sqlMapClient);
		OrderCHistDAOImpl orderCHistDAOImpl = new OrderCHistDAOImpl(
				sqlMapClient);
		for (int i = 0; i < list.size(); i++) {
			clientId = "";
			dealNo = "";
			contractId = "";
			buyOrSell = "";
			dealType = "";
			conveyType = "";
			dealTime = "";
			orderNo = "";
			tradeMode = "";
			orderTime = "--";
			clientName = "--";
			dealPrice = 0;
			dealQtt = 0;
			dealReceipt = 0;
			poundage = 0;
			newCost = 0;
			cnyBalance = 0;
			newPrice = 0;
			cnyInCome = 0;
			istreatycny = 0;
			ResultMap restMap = (ResultMap) list.get(i);

			clientId = restMap.getString("client_id");
			clientName = clientMap.get(clientId);
			associatorNo = StringUtil.subStrToStart(clientId, 6);

			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();

			dealNo = restMap.getString("deal_no");
			contractId = restMap.getString("contract_id");
			buyOrSell = restMap.getString("buyorsell");
			dealType = restMap.getString("deal_type", "1");
			dealTime = DateUtil.format(((TIMESTAMP) restMap.get("deal_time"))
					.dateValue(), "yyyy-MM-dd HH:mm:ss");
			orderNo = restMap.getString("order_no", "--");
			tradeMode = restMap.getString("trade_mode");

			dealPrice = restMap.getLong("deal_price", 0);
			dealQtt = restMap.getLong("deal_qtt", 0);
			dealReceipt = restMap.getLong("deal_receipt", 0);
			poundage = restMap.getLong("poundage", 0);
			newCost = restMap.getLong("new_cost", 0);
			cnyBalance = restMap.getLong("cny_balance", 0);

			if (roeInfoMap.isEmpty() || roeInfoMap.get(contractId) == null) {
				RoeInfo roeInfo = tradeUtil.getRoeInfo(tradeMode, contractId,
						settleDay);

				roeInfoMap.put(contractId + "@roe", roeInfo == null ? 1.0
						: roeInfo.getRoe() / 10000.0);
			}
			logger.debug("contract " + contractId + "'s roe is "
					+ roeInfoMap.get(contractId + "@roe"));
			newPrice = newCost == 0 ? dealPrice : Converter.double2long(newCost
					/ dealQtt / roeInfoMap.get(contractId + "@roe")); // TODO
																		// MODIFY
																		// 此处newCost为结算币种
																		// 价格是否需要修改???
			istreatycny = restMap.getInt("istreatycny", 0);
			conveyType = restMap.getString("convey_type", "0");
			// 手续费类型，１－平今，０－普通
			int type = conveyType.equals("1") ? 1 : 0;
			if (poundaryMap.get(type + clientId + contractId) == null) {
				ContractFInfo contractInfo = settleSrv.getPoundaryCsgFee(
						tradeMode, clientId, contractId);
				// 判断返回结果
				if (contractInfo == null) {
					return RetDefine.settlesrv_queryObjectIsNull;
				}
				// 普通交易手续费
				// 比例 交易费率支持4位小数
				if ("1".equals(contractInfo.getPoundaryFlag())) {
					poundaryMap.put(0 + clientId + contractId,
							new DecimalFormat("#0.####").format(contractInfo
									.getPoundary() / 100)
									+ "%");
				} else {
					poundaryMap.put(0 + clientId + contractId,
							new DecimalFormat("#0.####").format(contractInfo
									.getPoundary() / 100)
									+ "");
				}

				// 远期合同将平今手续费一起取出来
				if ("F".equals(tradeMode)) {
					if ("1".equals(contractInfo.getTodayPoundaryFlag())) {
						poundaryMap
								.put(
										1 + clientId + contractId,
										new DecimalFormat("#0.####")
												.format(contractInfo
														.getTodayPoundary() / 100)
												+ "%");
					} else {
						poundaryMap
								.put(
										1 + clientId + contractId,
										new DecimalFormat("#0.####")
												.format(contractInfo
														.getTodayPoundary() / 100)
												+ "");
					}
				}
			}

			if (cnyBalance != 0) {
				cnyInCome = Converter.double2long(cnyBalance
						/ contractInfoMap.get(contractId).getTaxRate());
			}

			if (!orderNo.equals("--")) {
				if (tradeMode.equals("F")) {
					OrderFHistKey orderFHistKey = new OrderFHistKey();
					orderFHistKey.setOrderNo(orderNo);
					OrderFHist orderFHist = orderFHistDAOImpl
							.selectByPrimaryKey(orderFHistKey);
					if (orderFHist != null) {
						orderTime = DateUtil.format(orderFHist.getOrderTime());
					} else {
						logger.warn("没有找到对应的委托时间");
					}
				}
				if (tradeMode.equals("S")) {
					OrderSHistKey orderSHistKey = new OrderSHistKey();
					orderSHistKey.setOrderNo(orderNo);
					OrderSHist orderSHist = orderSHistDAOImpl
							.selectByPrimaryKey(orderSHistKey);
					if (orderSHist != null) {
						orderTime = DateUtil.format(orderSHist.getOrderTime());
					} else {
						logger.warn("没有找到对应的委托时间");
					}
				}
				if (tradeMode.equals("C")) {
					OrderCHistKey orderCHistKey = new OrderCHistKey();
					orderCHistKey.setOrderNo(orderNo);
					OrderCHist orderCHist = orderCHistDAOImpl
							.selectByPrimaryKey(orderCHistKey);
					if (orderCHist != null) {
						orderTime = DateUtil.format(orderCHist.getOrderTime());
					} else {
						logger.warn("没有找到对应的委托时间");
					}
				}
			}

			if (!(associatorNo.equals(lastAssocNo))) {
				// 已经生成有会员了
				if (centerSeq > 1) {
					Element atotal = assocDoc.createElement("total");
					abody.appendChild(atotal);

					Element atotalson = assocDoc
							.createElement("TOTAL_DEAL_QTT");
					atotalson.setTextContent(totalDealQtt + "");
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_DEAL_RECEIPT");
					atotalson.setTextContent(totalRcptQtt + "");
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_CNY_INCOME");
					atotalson.setTextContent(Converter
							.formatFen2yuan(totalCnyInCome));
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_POUNDAGE");
					atotalson.setTextContent(Converter
							.formatFen2yuan(totalPoundage));
					atotal.appendChild(atotalson);
					String lastAssoRemark = associatorInfoMap.get(lastAssocNo)
							.getRemarak();
					// 会员交易文件
					fileName = assocDir + lastAssoRemark + dayDir
							+ lastAssoRemark + "_" + settleDay + "_JY.xml";
					assocDoc.appendChild(aroot);

					DOMSource dom = new DOMSource(assocDoc);
					result = new StreamResult(new File(fileName));
					trans = TransformerFactory.newInstance().newTransformer();
					trans.transform(dom, result);
				}

				// 下一会员
				fullName = associatorInfoMap.get(associatorNo).getFullName();

				assocDoc = PubTools.getDocument();
				aroot = assocDoc.createElement("root");

				Element afile_title = assocDoc.createElement("file_title");
				afile_title
						.setTextContent(assoRemark + "_" + settleDay + "_JY");
				aroot.appendChild(afile_title);

				Element areport_name = assocDoc.createElement("report_name");
				areport_name.setTextContent("交易清单");
				aroot.appendChild(areport_name);

				Element atop = assocDoc.createElement("top");
				aroot.appendChild(atop);

				Element aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				Element acontent = assocDoc.createElement("content");
				acontent.setTextContent(assoRemark);
				aitem.appendChild(acontent);

				aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				acontent = assocDoc.createElement("content");
				acontent.setTextContent(fullName);
				aitem.appendChild(acontent);

				aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				acontent = assocDoc.createElement("content");
				acontent.setTextContent(statDay);
				aitem.appendChild(acontent);

				abody = assocDoc.createElement("body");
				aroot.appendChild(abody);

				lastAssocNo = associatorNo;
				assocSeq = 1;
				totalDealQtt = 0;
				totalRcptQtt = 0;
				totalPoundage = 0;
				totalCnyInCome = 0;

			}

			Element aitem = assocDoc.createElement("item");
			abody.appendChild(aitem);

			Element aitemson = assocDoc.createElement("SEQ");
			aitemson.setTextContent(assocSeq + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CLIENT_ID");
			aitemson.setTextContent(assoRemark);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CLIENT_NAME");
			aitemson.setTextContent(clientName);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("DEAL_NO");
			aitemson.setTextContent(dealNo);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CONTRACT_ID");
			aitemson.setTextContent(contractId);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("TRADE_MODE");
			aitemson.setTextContent(tradeMode);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("BUYORSELL");
			aitemson.setTextContent(buyOrSell);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("DEAL_TYPE");
			aitemson.setTextContent(dealType);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("ISTREATYCNY");
			aitemson.setTextContent(istreatycny + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("SUBS_PRICE");
			aitemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(newPrice, rate)));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("DEAL_PRICE");
			aitemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(dealPrice, rate)));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("DEAL_QTT");
			aitemson.setTextContent(dealQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("DEAL_RECEIPT");
			aitemson.setTextContent(dealReceipt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CNY_INCOME");
			aitemson.setTextContent(Converter.formatFen2yuan(cnyInCome));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("POUNDAGE");
			aitemson.setTextContent(Converter.formatFen2yuan(poundage));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("POUNDARY");
			aitemson.setTextContent(poundaryMap.get(type + clientId
					+ contractId));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("DEAL_TIME");
			aitemson.setTextContent(dealTime);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("ORDER_TIME");
			aitemson.setTextContent(orderTime);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("ORDER_NO");
			aitemson.setTextContent(orderNo);
			aitem.appendChild(aitemson);

			assocSeq++;
			totalDealQtt += dealQtt;
			totalRcptQtt += dealReceipt;
			totalPoundage += poundage;
			totalCnyInCome += cnyInCome;

			// 中心数据
			item = centerDoc.createElement("item");
			body.appendChild(item);

			Element itemson = centerDoc.createElement("SEQ");
			itemson.setTextContent(centerSeq + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CLIENT_ID");
			itemson.setTextContent(assoRemark);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CLIENT_NAME");
			itemson.setTextContent(clientName);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("DEAL_NO");
			itemson.setTextContent(dealNo);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CONTRACT_ID");
			itemson.setTextContent(contractId);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("TRADE_MODE");
			itemson.setTextContent(tradeMode);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("BUYORSELL");
			itemson.setTextContent(buyOrSell);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("DEAL_TYPE");
			itemson.setTextContent(dealType);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ISTREATYCNY");
			itemson.setTextContent(istreatycny + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("SUBS_PRICE");
			itemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(newPrice, rate)));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("DEAL_PRICE");
			itemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(dealPrice, rate)));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("DEAL_QTT");
			itemson.setTextContent(dealQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("DEAL_RECEIPT");
			itemson.setTextContent(dealReceipt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CNY_INCOME");
			itemson.setTextContent(Converter.formatFen2yuan(cnyInCome));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("POUNDAGE");
			itemson.setTextContent(Converter.formatFen2yuan(poundage));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("POUNDARY");
			itemson.setTextContent(poundaryMap
					.get(type + clientId + contractId));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("DEAL_TIME");
			itemson.setTextContent(dealTime);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ORDER_TIME");
			itemson.setTextContent(orderTime);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ORDER_NO");
			itemson.setTextContent(orderNo);
			item.appendChild(itemson);

			centerSeq++;
		}

		// 有数据才写文件
		if (centerSeq > 1) {
			// 会员委托文件
			// 数据汇总
			Element atotal = assocDoc.createElement("total");
			abody.appendChild(atotal);

			Element atotalson = assocDoc.createElement("TOTAL_DEAL_QTT");
			atotalson.setTextContent(totalDealQtt + "");
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_DEAL_RECEIPT");
			atotalson.setTextContent(totalRcptQtt + "");
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_CNY_INCOME");
			atotalson.setTextContent(Converter.formatFen2yuan(totalCnyInCome));
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_POUNDAGE");
			atotalson.setTextContent(Converter.formatFen2yuan(totalPoundage));
			atotal.appendChild(atotalson);
			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();

			fileName = (assocDir + assoRemark + dayDir + assoRemark + "_"
					+ settleDay + "_JY.xml");
			assocDoc.appendChild(aroot);

			dom = new DOMSource(assocDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);

			// 中心交易文件
			fileName = (centerDir + settleDay + "_JY.xml");
			centerDoc.appendChild(root);

			dom = new DOMSource(centerDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);
		}

		return RetDefine.pub_success;
	}

	/**
	 * 按交易商生成订货表。
	 * 
	 * @return
	 * @throws Exception
	 */
	private String[] doSubsList() throws Exception {
		logger.info("生成交易中心/会员的定货清单及中心合同汇总清单...");
		String lastAssocNo = "";
		String associatorNo = "";
		String fullName = "";
		String clientId = "";
		long assocSeq = 1;
		long centerSeq = 1;
		long totalSubsQtt = 0;
		long totalRcptQtt = 0;
		long totalSubsBalance = 0;
		long totalDpstAmt = 0;
		long centerSubsQtt = 0;
		long centerRcptQtt = 0;
		long centerSubsBalance = 0;
		long centerDpstAmt = 0;
		String clientName = "";
		String contractId = "";
		String buyOrSell = "";
		String tradeMode = "";
		long subsQtt = 0;
		long rcptQtt = 0;
		long dpstAmt = 0;
		long subsBalance = 0;
		long totalCost = 0;
		long centerCost = 0;
		long originRcptCost = 0;
		long originDpstCost = 0;
		long dealPrice = 0;
		long rcptCost = 0;
		long rcptPrice = 0;
		long dpstPrice = 0;
		long settlePrice = -1;

		Document assocDoc = PubTools.getDocument();
		Element aroot = assocDoc.createElement("root");
		Element abody = assocDoc.createElement("body");

		Document centerDoc = PubTools.getDocument();
		Element root = centerDoc.createElement("root");

		Element file_title = centerDoc.createElement("file_title");
		root.appendChild(file_title);
		file_title.setTextContent(settleDay + "_DH");

		Element report_name = centerDoc.createElement("report_name");
		report_name.setTextContent("交易中心定货清单");
		root.appendChild(report_name);

		Element top = centerDoc.createElement("top");
		root.appendChild(top);

		Element item = centerDoc.createElement("item");
		top.appendChild(item);

		Element content = centerDoc.createElement("content");
		content.setTextContent(statDay);
		item.appendChild(content);

		Element body = centerDoc.createElement("body");
		root.appendChild(body);

		// 中心合同汇总文件
		Document contractDoc = PubTools.getDocument();
		Element croot = contractDoc.createElement("root");

		Element cfile_title = contractDoc.createElement("file_title");
		cfile_title.setTextContent(settleDay + "_HT");
		croot.appendChild(cfile_title);

		Element creport_name = contractDoc.createElement("report_name");
		creport_name.setTextContent("交易中心合同汇总清单");
		croot.appendChild(creport_name);

		Element ctop = contractDoc.createElement("top");
		croot.appendChild(ctop);

		Element citem = contractDoc.createElement("item");
		ctop.appendChild(citem);

		Element ccontent = contractDoc.createElement("content");
		ccontent.setTextContent(statDay);
		citem.appendChild(ccontent);

		Element cbody = contractDoc.createElement("body");
		croot.appendChild(cbody);

		List list = sqlMapClient
				.queryForList("sel_settlesrvRpt_subsDate_T_SUBS_DETAIL");

		for (int i = 0; i < list.size(); i++) {
			clientId = "";
			clientName = "";
			associatorNo = "";
			contractId = "";
			buyOrSell = "";
			tradeMode = "";
			subsQtt = 0;
			rcptQtt = 0;
			dpstAmt = 0;
			subsBalance = 0;
			totalCost = 0;
			dealPrice = 0;
			rcptCost = 0;
			rcptPrice = 0;
			dpstPrice = 0;
			settlePrice = -1;
			originDpstCost = 0;
			originRcptCost = 0;

			ResultMap restMap = (ResultMap) list.get(i);

			clientId = restMap.getString("client_id");
			clientName = clientMap.get(clientId);
			associatorNo = StringUtil.subStrToStart(clientId, 6);
			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();
			System.out.println("报表会员ID：：：：" + associatorNo);
			System.out.println("报表会员号：：：：" + assoRemark);

			contractId = restMap.getString("contract_id");
			buyOrSell = restMap.getString("buyorsell");
			tradeMode = restMap.getString("trade_mode");
			subsQtt = restMap.getLong("total_qtt", 0);
			// 仓单数量(吨)
			rcptQtt = restMap.getLong("subs_rcpt_qtt", 0);
			// 合同占用
			dpstAmt = restMap.getLong("frz_dpst_amt", 0);
			subsBalance = restMap.getLong("subs_balance", 0);
			totalCost = restMap.getLong("total_cost", 0);
			rcptCost = restMap.getLong("rcpt_cost", 0);
			originRcptCost = restMap.getLong("origin_rcpt_cost", 0);
			originDpstCost = restMap.getLong("origin_dpst_cost", 0);
			// 开仓价
			if ("F".equals(tradeMode)) // TODO MODIFY F 计算出的是交易币种价格;否则为结算币种价格
										// (totalCost为结算成本)???
			{
				dealPrice = Converter.double2long(1.0
						* (originDpstCost + originRcptCost) / subsQtt);
			} else {
				dealPrice = Converter.double2long(1.0 * totalCost / subsQtt);
			}

			if (rcptQtt > 0) {
				rcptPrice = Converter.double2long(1.0 * originRcptCost
						/ rcptQtt);// TODO MODIFY 交易币种
			}
			if (subsQtt - rcptQtt > 0) {
				dpstPrice = Converter.double2long(1.0 * originDpstCost
						/ (subsQtt - rcptQtt)); // TODO MODIFY 交易币种
			}
			if (tradeMode.equals("F")) {
				settlePrice = contractInfoMap.get(contractId).getSettlePrice();
			}

			if (!(associatorNo.equals(lastAssocNo))) {
				// 已经生成有会员了
				if (centerSeq > 1) {
					// 数据汇总
					Element atotal = assocDoc.createElement("total");
					abody.appendChild(atotal);

					Element atotalson = assocDoc
							.createElement("TOTAL_SUBS_QTT");
					atotalson.setTextContent(totalSubsQtt + "");
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_RCPT_QTT");
					atotalson.setTextContent(totalRcptQtt + "");
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_DPST_AMT");
					atotalson.setTextContent(Converter
							.formatFen2yuan(totalDpstAmt));
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_SUBS_BALANCE");
					atotalson.setTextContent(Converter
							.formatFen2yuan(totalSubsBalance));
					atotal.appendChild(atotalson);

					String lastAssoRemark = associatorInfoMap.get(lastAssocNo)
							.getRemarak();
					// 会员定货文件
					assocDoc.appendChild(aroot);
					fileName = assocDir + lastAssoRemark + dayDir
							+ lastAssoRemark + "_" + settleDay + "_DH.xml";

					dom = new DOMSource(assocDoc);
					result = new StreamResult(new File(fileName));
					trans = TransformerFactory.newInstance().newTransformer();
					trans.transform(dom, result);

					// 合同文件小计
					Element ctotal = contractDoc.createElement("total");
					cbody.appendChild(ctotal);

					Element ctotalson = contractDoc
							.createElement("ASSOCIATOR_NO");
					ctotalson.setTextContent(lastAssoRemark);
					ctotal.appendChild(ctotalson);

					ctotalson = contractDoc.createElement("ASSOCIATOR_NAME");
					ctotalson.setTextContent(fullName);
					ctotal.appendChild(ctotalson);

					ctotalson = contractDoc.createElement("TOTAL_SUBS_QTT");
					ctotalson.setTextContent(totalSubsQtt + "");
					ctotal.appendChild(ctotalson);

					ctotalson = contractDoc.createElement("TOTAL_RCPT_QTT");
					ctotalson.setTextContent(totalRcptQtt + "");
					ctotal.appendChild(ctotalson);

					ctotalson = contractDoc.createElement("TOTAL_DPST_AMT");
					ctotalson.setTextContent(Converter
							.formatFen2yuan(totalDpstAmt));
					ctotal.appendChild(ctotalson);

					ctotalson = contractDoc.createElement("TOTAL_SUBS_BALANCE");
					ctotalson.setTextContent(Converter
							.formatFen2yuan(totalSubsBalance));
					ctotal.appendChild(ctotalson);

					cbody = contractDoc.createElement("body");
					croot.appendChild(cbody);
				}

				// 下一会员
				fullName = associatorInfoMap.get(associatorNo).getFullName();

				assocDoc = PubTools.getDocument();
				aroot = assocDoc.createElement("root");

				Element afile_title = assocDoc.createElement("file_title");
				afile_title
						.setTextContent(assoRemark + "_" + settleDay + "_DH");
				aroot.appendChild(afile_title);

				Element areport_name = assocDoc.createElement("report_name");
				areport_name.setTextContent("定货清单");
				aroot.appendChild(areport_name);

				Element atop = assocDoc.createElement("top");
				aroot.appendChild(atop);

				Element aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				Element acontent = assocDoc.createElement("content");
				acontent.setTextContent(assoRemark);
				aitem.appendChild(acontent);

				aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				acontent = assocDoc.createElement("content");
				acontent.setTextContent(fullName);
				aitem.appendChild(acontent);

				aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				acontent = assocDoc.createElement("content");
				acontent.setTextContent(statDay);
				aitem.appendChild(acontent);

				abody = assocDoc.createElement("body");
				aroot.appendChild(abody);

				lastAssocNo = associatorNo;
				assocSeq = 1;
				totalSubsQtt = 0;
				totalRcptQtt = 0;
				totalSubsBalance = 0;
				totalDpstAmt = 0;
			}

			Element aitem = assocDoc.createElement("item");
			abody.appendChild(aitem);

			Element aitemson = assocDoc.createElement("SEQ");
			aitemson.setTextContent(assocSeq + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CLIENT_ID");
			aitemson.setTextContent(assoRemark);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CLIENT_NAME");
			aitemson.setTextContent(clientName);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CONTRACT_ID");
			aitemson.setTextContent(contractId);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("TRADE_MODE");
			aitemson.setTextContent(tradeMode);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("BUYORSELL");
			aitemson.setTextContent(buyOrSell);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("SUBS_PRICE");
			aitemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(dealPrice, rate)));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("DPST_PRICE");
			aitemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(dpstPrice, rate)));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("RCPT_PRICE");
			aitemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(rcptPrice, rate)));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("SETTLE_PRICE");
			aitemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(settlePrice, rate)));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("SUBS_QTT");
			aitemson.setTextContent(subsQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("RCPT_QTT");
			aitemson.setTextContent(rcptQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("DPST_AMT");
			aitemson.setTextContent(Converter.formatFen2yuan(dpstAmt));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("SUBS_BALANCE");
			aitemson.setTextContent(Converter.formatFen2yuan(subsBalance));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("TOTAL_COST");
			aitemson.setTextContent(Converter.formatFen2yuan(totalCost));
			aitem.appendChild(aitemson);

			assocSeq++;
			totalSubsQtt += subsQtt;
			totalRcptQtt += rcptQtt;
			totalSubsBalance += subsBalance;
			totalDpstAmt += dpstAmt;

			// 中心数据
			item = centerDoc.createElement("item");
			body.appendChild(item);

			Element itemson = centerDoc.createElement("SEQ");
			itemson.setTextContent(centerSeq + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CLIENT_ID");
			itemson.setTextContent(assoRemark);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CLIENT_NAME");
			itemson.setTextContent(clientName);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CONTRACT_ID");
			itemson.setTextContent(contractId);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("TRADE_MODE");
			itemson.setTextContent(tradeMode);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("BUYORSELL");
			itemson.setTextContent(buyOrSell);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("SUBS_PRICE");
			itemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(dealPrice, rate)));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("SETTLE_PRICE");
			itemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(settlePrice, rate)));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("SUBS_QTT");
			itemson.setTextContent(subsQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("RCPT_QTT");
			itemson.setTextContent(rcptQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("DPST_AMT");
			itemson.setTextContent(Converter.formatFen2yuan(dpstAmt));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("SUBS_BALANCE");
			itemson.setTextContent(Converter.formatFen2yuan(subsBalance));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("TOTAL_COST");
			itemson.setTextContent(Converter.formatFen2yuan(totalCost));
			item.appendChild(itemson);

			// 中心合同
			citem = contractDoc.createElement("item");
			cbody.appendChild(citem);

			Element citemson = contractDoc.createElement("SEQ");
			citemson.setTextContent(centerSeq + "");
			citem.appendChild(citemson);

			citemson = contractDoc.createElement("CLIENT_ID");
			citemson.setTextContent(assoRemark);
			citem.appendChild(citemson);

			citemson = contractDoc.createElement("CLIENT_NAME");
			citemson.setTextContent(clientName);
			citem.appendChild(citemson);

			citemson = contractDoc.createElement("CONTRACT_ID");
			citemson.setTextContent(contractId);
			citem.appendChild(citemson);

			citemson = contractDoc.createElement("TRADE_MODE");
			citemson.setTextContent(tradeMode);
			citem.appendChild(citemson);

			citemson = contractDoc.createElement("BUYORSELL");
			citemson.setTextContent(buyOrSell);
			citem.appendChild(citemson);

			citemson = contractDoc.createElement("SUBS_PRICE");
			citemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(dealPrice, rate)));
			citem.appendChild(citemson);

			citemson = contractDoc.createElement("SETTLE_PRICE");
			citemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(settlePrice, rate)));
			citem.appendChild(citemson);

			citemson = contractDoc.createElement("SUBS_QTT");
			citemson.setTextContent(subsQtt + "");
			citem.appendChild(citemson);

			citemson = contractDoc.createElement("RCPT_QTT");
			citemson.setTextContent(rcptQtt + "");
			citem.appendChild(citemson);

			citemson = contractDoc.createElement("DPST_AMT");
			citemson.setTextContent(Converter.formatFen2yuan(dpstAmt));
			citem.appendChild(citemson);

			citemson = contractDoc.createElement("SUBS_BALANCE");
			citemson.setTextContent(Converter.formatFen2yuan(subsBalance));
			citem.appendChild(citemson);

			centerSeq++;
			centerSubsQtt += subsQtt;
			centerRcptQtt += rcptQtt;
			centerSubsBalance += subsBalance;
			centerDpstAmt += dpstAmt;
			centerCost += totalCost;
		}

		// 有数据才写文件
		if (centerSeq > 1) {
			// 会员定货文件
			// 数据汇总
			Element atotal = assocDoc.createElement("total");
			abody.appendChild(atotal);

			Element atotalson = assocDoc.createElement("TOTAL_SUBS_QTT");
			atotalson.setTextContent(totalSubsQtt + "");
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_RCPT_QTT");
			atotalson.setTextContent(totalRcptQtt + "");
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_DPST_AMT");
			atotalson.setTextContent(Converter.formatFen2yuan(totalDpstAmt));
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_SUBS_BALANCE");
			atotalson
					.setTextContent(Converter.formatFen2yuan(totalSubsBalance));
			atotal.appendChild(atotalson);

			assocDoc.appendChild(aroot);
			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();

			fileName = assocDir + assoRemark + dayDir + assoRemark + "_"
					+ settleDay + "_DH.xml";
			dom = new DOMSource(assocDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);

			// 中心定货文件
			// 数据汇总
			Element total = centerDoc.createElement("total");
			body.appendChild(total);

			Element totalson = centerDoc.createElement("TOTAL_SUBS_QTT");
			totalson.setTextContent(centerSubsQtt + "");
			total.appendChild(totalson);

			totalson = centerDoc.createElement("TOTAL_RCPT_QTT");
			totalson.setTextContent(centerRcptQtt + "");
			total.appendChild(totalson);

			totalson = centerDoc.createElement("TOTAL_DPST_AMT");
			totalson.setTextContent(Converter.formatFen2yuan(centerDpstAmt));
			total.appendChild(totalson);

			totalson = centerDoc.createElement("TOTAL_SUBS_BALANCE");
			totalson
					.setTextContent(Converter.formatFen2yuan(centerSubsBalance));
			total.appendChild(totalson);

			totalson = centerDoc.createElement("TOTAL_TOTAL_COST");
			totalson.setTextContent(Converter.formatFen2yuan(centerCost));
			total.appendChild(totalson);

			centerDoc.appendChild(root);
			fileName = centerDir + settleDay + "_DH.xml";
			dom = new DOMSource(centerDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);

			// 合同汇总文件
			Element ctotal = contractDoc.createElement("total");
			cbody.appendChild(ctotal);

			String lastAssoRemark = associatorInfoMap.get(lastAssocNo)
					.getRemarak();
			Element ctotalson = contractDoc.createElement("ASSOCIATOR_NO");
			ctotalson.setTextContent(lastAssoRemark);
			ctotal.appendChild(ctotalson);

			ctotalson = contractDoc.createElement("ASSOCIATOR_NAME");
			ctotalson.setTextContent(fullName);
			ctotal.appendChild(ctotalson);

			ctotalson = contractDoc.createElement("TOTAL_SUBS_QTT");
			ctotalson.setTextContent(totalSubsQtt + "");
			ctotal.appendChild(ctotalson);

			ctotalson = contractDoc.createElement("TOTAL_RCPT_QTT");
			ctotalson.setTextContent(totalRcptQtt + "");
			ctotal.appendChild(ctotalson);

			ctotalson = contractDoc.createElement("TOTAL_DPST_AMT");
			ctotalson.setTextContent(Converter.formatFen2yuan(totalDpstAmt));
			ctotal.appendChild(ctotalson);

			ctotalson = contractDoc.createElement("TOTAL_SUBS_BALANCE");
			ctotalson
					.setTextContent(Converter.formatFen2yuan(totalSubsBalance));
			ctotal.appendChild(ctotalson);

			contractDoc.appendChild(croot);

			fileName = centerDir + settleDay + "_HT.xml";
			dom = new DOMSource(contractDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);
		}

		return RetDefine.pub_success;
	}

	/**
	 * 按交易商生成交货清单
	 * 
	 * @return
	 * @throws Exception
	 */
	private String[] doConsignList() throws Exception {
		logger.info("生成交收货款了结清单");
		String associatorNo = "";
		String lastAssocNo = "";
		String fullName = "";
		long centerCsgQtt = 0;
		double centerActualQtt = 0;
		long centerDealCost = 0;
		long centerCsgDiff = 0;
		long centerActualAmt = 0;
		long centerCsgFee = 0;
		long centerLeftPayment = 0;
		double totalActualQtt = 0;
		long totalDealCost = 0;
		long totalCsgDiff = 0;
		long totalActualAmt = 0;
		long totalCsgFee = 0;
		long totalCsgQtt = 0;
		long totalLeftPayment = 0;
		String OppnAssocNo = "";
		String oppnFullName = "";

		String contractId = "";
		String buyOrSell = "";
		long csgQtt = 0;
		double actualQtt = 0;
		double gcsgQtt = 0;
		long actualAmt = 0;
		long dealPrice = 0;
		long agioFee = 0;
		long csgPrice = 0;
		long csgFee = 0;
		long csgDiff = 0;
		long dealCost = 0;
		long assocSeq = 0;
		long centerSeq = 1;
		long leftPayment = 0;
		int csgPriceType = 2;
		int status = 0;
		//
		long qualityFee = 0;
		long lateFee = 0;

		Document assocDoc = PubTools.getDocument();
		Element aroot = assocDoc.createElement("root");
		Element abody = assocDoc.createElement("body");

		Document centerDoc = PubTools.getDocument();

		Element root = centerDoc.createElement("root");

		Element file_title = centerDoc.createElement("file_title");
		root.appendChild(file_title);
		file_title.setTextContent(settleDay + "_JS");

		Element report_name = centerDoc.createElement("report_name");
		report_name.setTextContent("交易中心交收清单");
		root.appendChild(report_name);

		Element top = centerDoc.createElement("top");
		root.appendChild(top);

		Element item = centerDoc.createElement("item");
		top.appendChild(item);

		Element content = centerDoc.createElement("content");
		content.setTextContent(statDay);
		item.appendChild(content);

		Element body = centerDoc.createElement("body");
		root.appendChild(body);

		// 获得会员交收货款了结数据
		// 设置查询条件
		ResultMap map = new ResultMap();
		map.put("beginTime", curBeginTime);
		map.put("endTime", curEndTime);
		map.put("same", "1");
		List list = sqlMapClient.queryForList(
				"sel_settlesrvRpt_csgFinishDate_T_PAYMENT_FINISH_LIST", map);

		for (int i = 0; i < list.size(); i++) {
			associatorNo = "";
			OppnAssocNo = "";
			oppnFullName = "";
			contractId = "";
			buyOrSell = "";
			csgQtt = 0;
			gcsgQtt = 0;
			actualQtt = 0;
			actualAmt = 0;
			dealPrice = 0;
			agioFee = 0;
			csgPrice = 0;
			csgFee = 0;
			csgDiff = 0;
			dealCost = 0;
			csgPriceType = 2;
			leftPayment = 0;
			status = 0;

			ResultMap csgMap = (ResultMap) list.get(i);
			associatorNo = csgMap.getString("associator_no");
			OppnAssocNo = csgMap.getString("OppnAssocNo");
			oppnFullName = associatorInfoMap.get(OppnAssocNo).getFullName();
			contractId = csgMap.getString("contract_id");
			buyOrSell = csgMap.getString("buyorsell");
			csgQtt = csgMap.getLong("csg_qtt", 0);
			gcsgQtt = csgMap.getDouble("g_csg_qtt", 0);
			actualQtt = csgMap.getDouble("qtt", 0);
			actualAmt = csgMap.getLong("actualAmt", 0);
			dealPrice = csgMap.getLong("dealPrice", 0);
			agioFee = csgMap.getLong("agio_fee", 0);
			csgPrice = csgMap.getLong("csg_price", 0);
			csgFee = csgMap.getLong("csgFee", 0);
			csgDiff = csgMap.getLong("csgDiff", 0);
			dealCost = csgMap.getLong("deal_cost", 0);
			csgPriceType = csgMap.getInt("csg_price_type", 2);
			// 广西新增 2008/05/06
			status = csgMap.getInt("status");
			leftPayment = csgMap.getLong("left_payment");
			// 无锡新增
			qualityFee = csgMap.getLong("quality_fee", 0);
			lateFee = csgMap.getLong("late_fee", 0);

			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();

			// 未了结的差额还没有计算好呢
			if (12 > csgMap.getInt("status")) {
				csgDiff = csgDiff * csgQtt;
			}
			if (!associatorNo.equals(lastAssocNo)) {
				if (centerSeq > 1) {
					// 会员数据汇总
					Element atotal = assocDoc.createElement("total");
					abody.appendChild(atotal);

					Element atotalson = assocDoc
							.createElement("TOTAL_MATCHING_QTT");
					atotalson.setTextContent(totalCsgQtt + "");
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_ACTUAL_QTT");
					atotalson.setTextContent(new DecimalFormat("#0.###")
							.format(totalActualQtt));
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_CSG_AMT");
					atotalson.setTextContent(Converter
							.formatFen2yuan(totalDealCost));
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_CSG_BALANCE");
					atotalson.setTextContent(Converter
							.formatFen2yuan(totalCsgDiff));
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_PAYMENT");
					atotalson.setTextContent(Converter
							.formatFen2yuan(totalActualAmt));
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_CSG_FEE");
					atotalson.setTextContent(Converter
							.formatFen2yuan(totalCsgFee));
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_LEFT_PAYMENT");
					atotalson.setTextContent(Converter
							.formatFen2yuan(totalLeftPayment));
					atotal.appendChild(atotalson);

					// 增加查询交收对应持仓明细
					Map params = new HashMap();
					params.put("beginTime", curBeginTime);
					params.put("endTime", curEndTime);
					params.put("associator_no", lastAssocNo);
					params.put("settle_day", settleDay);
					List<ResultMap> subfs = sqlMapClient.queryForList(
							"sel_settlesrvRpt_csgFinishDate_T_SUBS_F_LOG",
							params);
					Element subfsE = assocDoc.createElement("SUBFS");
					abody.appendChild(subfsE);
					for (ResultMap subf : subfs) {
						Element subfE = assocDoc.createElement("SUBF");
						subfsE.appendChild(subfE);

						Iterator itr = subf.keySet().iterator();
						while (itr.hasNext()) {
							String key = (String) itr.next();
							String value = Converter.gstring(subf.get(key));
							Element tmp = assocDoc.createElement(key);
							tmp.setTextContent(Converter.gstring(value));
							subfE.appendChild(tmp);
						}
					}
					String lastAssoRemark = associatorInfoMap.get(lastAssocNo)
							.getRemarak();
					// 会员交收文件
					fileName = assocDir + lastAssoRemark + dayDir
							+ lastAssoRemark + "_" + settleDay + "_JS.xml";
					assocDoc.appendChild(aroot);
					dom = new DOMSource(assocDoc);
					result = new StreamResult(new File(fileName));
					trans = TransformerFactory.newInstance().newTransformer();
					trans.transform(dom, result);
				}
				// 下一会员
				fullName = associatorInfoMap.get(associatorNo).getFullName();

				assocDoc = PubTools.getDocument();
				aroot = assocDoc.createElement("root");

				Element afile_title = assocDoc.createElement("file_title");
				afile_title
						.setTextContent(assoRemark + "_" + settleDay + "_JS");
				aroot.appendChild(afile_title);

				Element areport_name = assocDoc.createElement("report_name");
				areport_name.setTextContent("交收清单");
				aroot.appendChild(areport_name);

				Element atop = assocDoc.createElement("top");
				aroot.appendChild(atop);

				Element aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				Element acontent = assocDoc.createElement("content");
				acontent.setTextContent(assoRemark);
				aitem.appendChild(acontent);

				aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				acontent = assocDoc.createElement("content");
				acontent.setTextContent(fullName);
				aitem.appendChild(acontent);

				aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				acontent = assocDoc.createElement("content");
				acontent.setTextContent(statDay);
				aitem.appendChild(acontent);

				abody = assocDoc.createElement("body");
				aroot.appendChild(abody);
				totalActualQtt = 0;
				totalDealCost = 0;
				totalCsgDiff = 0;
				totalActualAmt = 0;
				totalLeftPayment = 0;
				totalCsgFee = 0;
				totalCsgQtt = 0;
				assocSeq = 1;
				lastAssocNo = associatorNo;
			}

			// 会员交收数据
			Element aitem = assocDoc.createElement("item");
			abody.appendChild(aitem);

			Element aitemson = assocDoc.createElement("SEQ");
			aitemson.setTextContent(assocSeq + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("MATCHING_SEQ");
			aitemson.setTextContent(csgMap.getString("matching_seq"));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CONTRACT_ID");
			aitemson.setTextContent(assoRemark);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("BUYORSELL");
			aitemson.setTextContent(buyOrSell);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("MATCHING_QTT");
			aitemson.setTextContent(csgQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("G_CSG_QTT");
			aitemson.setTextContent(gcsgQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("ACTUAL_QTT");
			aitemson.setTextContent(new DecimalFormat("#0.###")
					.format(actualQtt));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("SUBS_PRICE");
			aitemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(dealPrice, rate)));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CSG_AMT");
			aitemson.setTextContent(Converter.formatFen2yuan(dealCost));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("AGIO_FEE");
			aitemson.setTextContent(Converter.formatFen2yuan(agioFee));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CSG_PRICE");
			aitemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(csgPrice, rate)));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CSG_PRICE_TYPE");
			aitemson.setTextContent(csgPriceType + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CSG_BALANCE");
			aitemson.setTextContent(Converter.formatFen2yuan(csgDiff));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("PAYMENT");
			aitemson.setTextContent(Converter.formatFen2yuan(actualAmt));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("OPP_ASSO_NAME");
			aitemson.setTextContent(oppnFullName);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CSG_FEE");
			aitemson.setTextContent(Converter.formatFen2yuan(csgFee));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("STATUS");
			aitemson.setTextContent(status + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("LEFT_PAYMENT");
			aitemson.setTextContent(Converter.formatFen2yuan(leftPayment));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("QUALITY_FEE");
			aitemson.setTextContent(Converter.formatFen2yuan(qualityFee));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("LATE_FEE");
			aitemson.setTextContent(Converter.formatFen2yuan(lateFee));
			aitem.appendChild(aitemson);

			totalActualQtt += actualQtt;
			totalDealCost += dealCost;
			totalCsgDiff += csgDiff;
			totalActualAmt += actualAmt;
			totalCsgFee += csgFee;
			totalCsgQtt += csgQtt;
			totalLeftPayment += leftPayment;
			assocSeq++;

			// 中心交收数据
			item = centerDoc.createElement("item");
			body.appendChild(item);

			Element itemson = centerDoc.createElement("SEQ");
			itemson.setTextContent(centerSeq + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("MATCHING_SEQ");
			itemson.setTextContent(csgMap.getString("matching_seq"));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ASSOCIATOR_NO");
			itemson.setTextContent(assoRemark);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ASSOC_FULL_NAME");
			itemson.setTextContent(fullName);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CONTRACT_ID");
			itemson.setTextContent(contractId);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("BUYORSELL");
			itemson.setTextContent(buyOrSell);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("MATCHING_QTT");
			itemson.setTextContent(csgQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("G_CSG_QTT");
			itemson.setTextContent(gcsgQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ACTUAL_QTT");
			itemson.setTextContent(new DecimalFormat("#0.###")
					.format(actualQtt));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("SUBS_PRICE");
			itemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(dealPrice, rate)));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CSG_AMT");
			itemson.setTextContent(Converter.formatFen2yuan(dealCost));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("AGIO_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(agioFee));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CSG_PRICE");
			itemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(csgPrice, rate)));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CSG_PRICE_TYPE");
			itemson.setTextContent(csgPriceType + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CSG_BALANCE");
			itemson.setTextContent(Converter.formatFen2yuan(csgDiff));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("PAYMENT");
			itemson.setTextContent(Converter.formatFen2yuan(actualAmt));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("OPP_ASSO_NAME");
			itemson.setTextContent(oppnFullName);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CSG_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(csgFee));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("STATUS");
			itemson.setTextContent(status + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("LEFT_PAYMENT");
			itemson.setTextContent(Converter.formatFen2yuan(leftPayment));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("QUALITY_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(qualityFee));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("LATE_FEE");
			itemson.setTextContent(Converter.formatFen2yuan(lateFee));
			item.appendChild(itemson);

			centerActualQtt += actualQtt;
			centerDealCost += dealCost;
			centerCsgDiff += csgDiff;
			centerActualAmt += actualAmt;
			centerCsgFee += csgFee;
			centerLeftPayment += leftPayment;
			centerCsgQtt += csgQtt;
			centerSeq++;

		}
		if (centerSeq > 1) {
			// 会员数据汇总
			Element atotal = assocDoc.createElement("total");
			abody.appendChild(atotal);

			Element atotalson = assocDoc.createElement("TOTAL_MATCHING_QTT");
			atotalson.setTextContent(totalCsgQtt + "");
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_ACTUAL_QTT");
			atotalson.setTextContent(new DecimalFormat("#0.###")
					.format(totalActualQtt));
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_CSG_AMT");
			atotalson.setTextContent(Converter.formatFen2yuan(totalDealCost));
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_CSG_BALANCE");
			atotalson.setTextContent(Converter.formatFen2yuan(totalCsgDiff));
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_PAYMENT");
			atotalson.setTextContent(Converter.formatFen2yuan(totalActualAmt));
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_CSG_FEE");
			atotalson.setTextContent(Converter.formatFen2yuan(totalCsgFee));
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_LEFT_PAYMENT");
			atotalson
					.setTextContent(Converter.formatFen2yuan(totalLeftPayment));
			atotal.appendChild(atotalson);

			// 增加查询交收对应持仓明细
			Map params = new HashMap();
			params.put("beginTime", curBeginTime);
			params.put("endTime", curEndTime);
			params.put("associator_no", lastAssocNo);
			params.put("settle_day", settleDay);
			List<ResultMap> subfs = sqlMapClient.queryForList(
					"sel_settlesrvRpt_csgFinishDate_T_SUBS_F_LOG", params);
			Element subfsE = assocDoc.createElement("SUBFS");
			abody.appendChild(subfsE);
			for (ResultMap subf : subfs) {
				Element subfE = assocDoc.createElement("SUBF");
				subfsE.appendChild(subfE);

				Iterator itr = subf.keySet().iterator();
				while (itr.hasNext()) {
					String key = (String) itr.next();
					String value = Converter.gstring(subf.get(key));
					Element tmp = assocDoc.createElement(key);
					tmp.setTextContent(Converter.gstring(value));
					subfE.appendChild(tmp);
				}
			}
			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();

			// 会员交收文件
			fileName = assocDir + assoRemark + dayDir + assoRemark + "_"
					+ settleDay + "_JS.xml";
			assocDoc.appendChild(aroot);
			dom = new DOMSource(assocDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);

			// 中心数据汇总
			Element total = centerDoc.createElement("total");
			body.appendChild(total);

			Element totalson = centerDoc.createElement("TOTAL_MATCHING_QTT");
			totalson.setTextContent(centerCsgQtt + "");
			total.appendChild(totalson);

			totalson = centerDoc.createElement("TOTAL_ACTUAL_QTT");
			totalson.setTextContent(new DecimalFormat("#0.###")
					.format(centerActualQtt));
			total.appendChild(totalson);

			totalson = centerDoc.createElement("TOTAL_CSG_AMT");
			totalson.setTextContent(Converter.formatFen2yuan(centerDealCost));
			total.appendChild(totalson);

			totalson = centerDoc.createElement("TOTAL_CSG_BALANCE");
			totalson.setTextContent(Converter.formatFen2yuan(centerCsgDiff));
			total.appendChild(totalson);

			totalson = centerDoc.createElement("TOTAL_PAYMENT");
			totalson.setTextContent(Converter.formatFen2yuan(centerActualAmt));
			total.appendChild(totalson);

			totalson = centerDoc.createElement("TOTAL_CSG_FEE");
			totalson.setTextContent(Converter.formatFen2yuan(centerCsgFee));
			total.appendChild(totalson);

			totalson = centerDoc.createElement("TOTAL_LEFT_PAYMENT");
			totalson
					.setTextContent(Converter.formatFen2yuan(centerLeftPayment));
			total.appendChild(totalson);

			// 中心交收文件
			fileName = centerDir + settleDay + "_JS.xml";
			centerDoc.appendChild(root);
			dom = new DOMSource(centerDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);
		}
		return RetDefine.pub_success;
	}

	/**
	 * 按交易商生成交货清单,不包含未了结匹配单
	 * 
	 * @return
	 * @throws Exception
	 */
	private String[] doPaymentFinishList() throws Exception {
		logger.info("生成交收货款了结清单...");

		Document centerDoc = PubTools.getDocument();
		Element root = centerDoc.createElement("root");
		centerDoc.appendChild(root);
		root.setAttribute("file_title", settleDay + "_JSHK");
		root.setAttribute("report_name", "交易中心交收清单");
		root.setAttribute("statDay", statDay);
		Element items = centerDoc.createElement("items");
		root.appendChild(items);

		// 获得会员交收货款了结数据
		// 设置查询条件
		ResultMap map = new ResultMap();
		map.put("beginTime", curBeginTime);
		map.put("endTime", curEndTime);
		map.put("same", "1");
		List list = sqlMapClient.queryForList(
				"sel_settlesrvRpt_csgFinishDate_T_PAYMENT_FINISH_LIST2", map);

		Document assocDoc = PubTools.getDocument();
		Element aroot = assocDoc.createElement("root");
		assocDoc.appendChild(aroot);
		Element aitems = assocDoc.createElement("items");
		aroot.appendChild(aitems);

		boolean start = true;
		boolean end = false;

		for (int i = 0; i < list.size(); i++) {
			ResultMap reusltMap = (ResultMap) list.get(i);
			String associatorNo = reusltMap.getString("associator_no");
			String oppAssociatorNo = reusltMap.getString("oppnassocno");

			if (start) {
				aroot.setAttribute("file_title", settleDay + "_JSHK");
				aroot.setAttribute("report_name", "交收清单");
				aroot.setAttribute("statDay", statDay);
				aroot.setAttribute("associator_name", associatorInfoMap.get(
						associatorNo).getFullName());
				aroot.setAttribute("associator_no", associatorNo);
				start = false;
			}

			Element item = centerDoc.createElement("item");
			items.appendChild(item);
			Element aitem = assocDoc.createElement("item");
			aitems.appendChild(aitem);
			Iterator itr = reusltMap.keySet().iterator();
			while (itr.hasNext()) {
				String key = (String) itr.next();
				String value = Converter.gstring(reusltMap.get(key));
				Element tmp = assocDoc.createElement(key);
				tmp.setTextContent(Converter.gstring(value));
				aitem.appendChild(tmp);

				tmp = centerDoc.createElement(key);
				tmp.setTextContent(Converter.gstring(value));
				item.appendChild(tmp);
			}
			Element tmp = assocDoc.createElement("opp_associator_name");
			tmp.setTextContent(associatorInfoMap.get(oppAssociatorNo)
					.getFullName());
			aitem.appendChild(tmp);

			tmp = centerDoc.createElement("opp_associator_name");
			tmp.setTextContent(associatorInfoMap.get(oppAssociatorNo)
					.getFullName());
			item.appendChild(tmp);

			if ((i + 1) < list.size()) {
				reusltMap = (ResultMap) list.get(i + 1);
				String nextAssoNo = reusltMap.getString("associator_no");
				if (!associatorNo.equals(nextAssoNo)) {
					end = true;
				}
			}
			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();
			if ((i + 1) == list.size() || end) {
				fileName = assocDir + assoRemark + dayDir + assoRemark + "_"
						+ settleDay + "_JSHK.xml";
				dom = new DOMSource(assocDoc);
				result = new StreamResult(new File(fileName));
				trans = TransformerFactory.newInstance().newTransformer();
				trans.transform(dom, result);

				start = true;
				end = false;
				assocDoc = PubTools.getDocument();
				aroot = assocDoc.createElement("root");
				assocDoc.appendChild(aroot);
				aitems = assocDoc.createElement("items");
				aroot.appendChild(aitems);
			}

			if ((i + 1) == list.size()) {
				fileName = centerDir + settleDay + "_JSHK.xml";
				dom = new DOMSource(centerDoc);
				result = new StreamResult(new File(fileName));
				trans = TransformerFactory.newInstance().newTransformer();
				trans.transform(dom, result);
			}
		}
		return RetDefine.pub_success;
	}

	/**
	 * 生成会员仓单清单。
	 * 
	 * @log 20080821 yanjl 新增仓单质押部分 质押金额
	 * @return
	 * @throws Exception
	 */
	private String[] doReceiptList() throws Exception {
		logger.info("生成交易中心/会员的仓单清单...");
		String lastAssocNo = "";
		String associatorNo = "";
		String fullName = "";
		long totalRegQtt = 0;
		long totalAvlbQtt = 0;
		long totalFrzQtt = 0;
		double totalActualQtt = 0;
		double totalCsgQtt = 0;
		double totalFrzCsgQtt = 0;
		long centerRegQtt = 0;
		long centerAvlbQtt = 0;
		long centerFrzQtt = 0;
		double centerActualQtt = 0;
		double centerCsgQtt = 0;
		double centerFrzCsgQtt = 0;
		long assocSeq = 0;
		long centerSeq = 1;
		String clientId = "";
		String warehouseName = "";
		String goodsName = "";
		String receiptNo = "";
		String validDay = "";
		int warehouseId = 0;
		int goodsId = 0;
		long avlbQtt = 0;
		double actualQtt = 0;
		double csgQtt = 0;
		double frzCsgQtt = 0;
		long registerQtt = 0;
		long frzQtt = 0;
		// 质押金额合计
		long totalLoanSum = 0;
		long centerTotalLoanSum = 0;

		Document assocDoc = PubTools.getDocument();
		Element aroot = assocDoc.createElement("root");
		Element abody = assocDoc.createElement("body");

		ReceiptsDAOImpl receiptsDAOImpl = new ReceiptsDAOImpl(sqlMapClient);
		ReceiptsExample receiptsExample = new ReceiptsExample();
		Receipts receipts = new Receipts();
		receiptsExample.setAvlbQtt(0);
		receiptsExample.setAvlbQtt_Indicator(5);
		receiptsExample.setIsCanceled(0);
		receiptsExample.setIsCanceled_Indicator(3);
		receiptsExample.setValidDay(DateUtil.parse(settleDay, "yyyyMMdd"));
		receiptsExample.setValidDay_Indicator(6);

		Document centerDoc = PubTools.getDocument();

		Element root = centerDoc.createElement("root");

		Element file_title = centerDoc.createElement("file_title");
		root.appendChild(file_title);
		file_title.setTextContent(settleDay + "_CD");

		Element report_name = centerDoc.createElement("report_name");
		report_name.setTextContent("交易中心仓单清单");
		root.appendChild(report_name);

		Element top = centerDoc.createElement("top");
		root.appendChild(top);

		Element item = centerDoc.createElement("item");
		top.appendChild(item);

		Element content = centerDoc.createElement("content");
		content.setTextContent(statDay);
		item.appendChild(content);

		Element body = centerDoc.createElement("body");
		root.appendChild(body);

		WarehouseInfoDAOImpl warehouseInfoDAOImpl = new WarehouseInfoDAOImpl(
				sqlMapClient);
		GoodsModelDAOImpl goodsModelDAOImpl = new GoodsModelDAOImpl(
				sqlMapClient);
		// 仓单信息列表
		List list = receiptsDAOImpl.selectByExample(receiptsExample,
				"client_Id");

		/** 仓单质押金额 */
		List<ResultMap> loanList = new ArrayList<ResultMap>();
		if (list != null && list.size() > 0)
			loanList = sqlMapClient
					.queryForList("sel_settlesrvRpt_sumByRcptNo_t_loan_info",
							new ResultMap());
		Iterator<ResultMap> loanIterator = loanList.iterator();

		for (int i = 0; i < list.size(); i++) {
			clientId = "";
			warehouseName = "";
			goodsName = "";
			receiptNo = "";
			validDay = "";
			warehouseId = 0;
			goodsId = 0;
			avlbQtt = 0;
			actualQtt = 0;
			csgQtt = 0;
			frzCsgQtt = 0;
			registerQtt = 0;
			frzQtt = 0;

			receipts = (Receipts) list.get(i);

			warehouseId = receipts.getWarehouseId();
			goodsId = receipts.getGoodsId();
			clientId = receipts.getClientId();
			associatorNo = StringUtil.subStrToStart(clientId, 6);
			receiptNo = receipts.getReceiptNo();
			avlbQtt = receipts.getAvlbQtt();
			actualQtt = receipts.getActualQtt();
			csgQtt = receipts.getCsgQtt();
			frzCsgQtt = receipts.getFrzCsgQtt();
			registerQtt = receipts.getRegisterQtt();
			frzQtt = receipts.getFrzQtt();
			validDay = DateUtil.format(receipts.getValidDay());

			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();

			WarehouseInfoKey warehouseInfoKey = new WarehouseInfoKey();
			warehouseInfoKey.setWarehouseId(warehouseId);
			WarehouseInfo warehouseInfo = warehouseInfoDAOImpl
					.selectByPrimaryKey(warehouseInfoKey);
			if (warehouseInfo != null)
				warehouseName = warehouseInfo.getWarehouseName();

			GoodsModelKey goodsModelKey = new GoodsModelKey();
			goodsModelKey.setGoodsId(goodsId);
			GoodsModel goodsModel = goodsModelDAOImpl
					.selectByPrimaryKey(goodsModelKey);
			if (goodsModel != null)
				goodsName = goodsModel.getGoodsName();

			/** 20080826 */
			long loanSum = 0;// 质押金额
			while (loanIterator.hasNext()) {
				ResultMap element = loanIterator.next();
				if (element.getString("receipt_no", "").equals(receiptNo)) {
					loanSum = element.getLong("loan_balance", 0);
					loanIterator.remove();
					break;
				}
			}

			if (!(associatorNo.equals(lastAssocNo))) {
				// 已经生成有会员了
				if (centerSeq > 1) {
					Element total = assocDoc.createElement("total");
					abody.appendChild(total);

					Element totalson = assocDoc
							.createElement("TOTAL_REGISTER_QTT");
					totalson.setTextContent(totalRegQtt + "");
					total.appendChild(totalson);

					totalson = assocDoc.createElement("TOTAL_AVLB_QTT");
					totalson.setTextContent(totalAvlbQtt + "");
					total.appendChild(totalson);

					totalson = assocDoc.createElement("TOTAL_ACTUAL_QTT");
					totalson.setTextContent(totalActualQtt + "");
					total.appendChild(totalson);

					totalson = assocDoc.createElement("TOTAL_FRZ_QTT");
					totalson.setTextContent(totalFrzQtt + "");
					total.appendChild(totalson);

					totalson = assocDoc.createElement("TOTAL_CSG_QTT");
					totalson.setTextContent(totalCsgQtt + "");
					total.appendChild(totalson);

					totalson = assocDoc.createElement("TOTAL_FRZ_CSG_QTT");
					totalson.setTextContent(totalFrzCsgQtt + "");
					total.appendChild(totalson);

					totalson = assocDoc.createElement("TOTAL_LOAN_SUM");
					totalson.setTextContent(Converter
							.formatFen2yuan(totalLoanSum)
							+ "");
					total.appendChild(totalson);

					String lastAssoRemark = associatorInfoMap.get(lastAssocNo)
							.getRemarak();
					// 会员仓单文件
					fileName = assocDir + lastAssoRemark + dayDir
							+ lastAssoRemark + "_" + settleDay + "_CD.xml";
					assocDoc.appendChild(aroot);

					dom = new DOMSource(assocDoc);
					result = new StreamResult(new File(fileName));
					trans = TransformerFactory.newInstance().newTransformer();
					trans.transform(dom, result);
				}

				// 下一会员
				fullName = associatorInfoMap.get(associatorNo).getFullName();

				assocDoc = PubTools.getDocument();
				aroot = assocDoc.createElement("root");

				Element afile_title = assocDoc.createElement("file_title");
				afile_title
						.setTextContent(assoRemark + "_" + settleDay + "_CD");
				aroot.appendChild(afile_title);

				Element areport_name = assocDoc.createElement("report_name");
				areport_name.setTextContent("仓单清单");
				aroot.appendChild(areport_name);

				Element atop = assocDoc.createElement("top");
				aroot.appendChild(atop);

				Element aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				Element acontent = assocDoc.createElement("content");
				acontent.setTextContent(assoRemark);
				aitem.appendChild(acontent);

				aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				acontent = assocDoc.createElement("content");
				acontent.setTextContent(fullName);
				aitem.appendChild(acontent);

				aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				acontent = assocDoc.createElement("content");
				acontent.setTextContent(statDay);
				aitem.appendChild(acontent);

				abody = assocDoc.createElement("body");
				aroot.appendChild(abody);

				lastAssocNo = associatorNo;
				assocSeq = 1;
				totalRegQtt = 0;
				totalAvlbQtt = 0;
				totalFrzQtt = 0;
				totalCsgQtt = 0;
				totalActualQtt = 0;
				totalFrzCsgQtt = 0;
				totalLoanSum = 0;
			}

			Element aitem = assocDoc.createElement("item");
			abody.appendChild(aitem);

			Element aitemson = assocDoc.createElement("SEQ");
			aitemson.setTextContent(assocSeq + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("RECEIPT_NO");
			aitemson.setTextContent(receiptNo);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("GOODS_NAME");
			aitemson.setTextContent(goodsName);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("VALID_DAY");
			aitemson.setTextContent(validDay);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("WAREHOUSE_NAME");
			aitemson.setTextContent(warehouseName);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("REGISTER_QTT");
			aitemson.setTextContent(registerQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("AVLB_QTT");
			aitemson.setTextContent(avlbQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("FRZ_QTT");
			aitemson.setTextContent(frzQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("ACTUAL_QTT");
			aitemson.setTextContent(actualQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CSG_QTT");
			aitemson.setTextContent(csgQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("FRZ_CSG_QTT");
			aitemson.setTextContent(frzCsgQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("LOAN_SUM");
			aitemson.setTextContent(Converter.formatFen2yuan(loanSum) + "");
			aitem.appendChild(aitemson);

			// 中心数据
			item = centerDoc.createElement("item");
			body.appendChild(item);

			Element itemson = centerDoc.createElement("SEQ");
			itemson.setTextContent(centerSeq + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("RECEIPT_NO");
			itemson.setTextContent(receiptNo);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ASSOCIATOR_NO");
			itemson.setTextContent(assoRemark);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ASSOC_FULL_NAME");
			itemson.setTextContent(fullName);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("VALID_DAY");
			itemson.setTextContent(validDay);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("WAREHOUSE_NAME");
			itemson.setTextContent(warehouseName);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("GOODS_NAME");
			itemson.setTextContent(goodsName);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("REGISTER_QTT");
			itemson.setTextContent(registerQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("AVLB_QTT");
			itemson.setTextContent(avlbQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("FRZ_QTT");
			itemson.setTextContent(frzQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("ACTUAL_QTT");
			itemson.setTextContent(actualQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CSG_QTT");
			itemson.setTextContent(csgQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("FRZ_CSG_QTT");
			itemson.setTextContent(frzCsgQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("LOAN_SUM");
			itemson.setTextContent(Converter.formatFen2yuan(loanSum) + "");
			item.appendChild(itemson);

			// 会员合计数据
			totalRegQtt += registerQtt;
			totalAvlbQtt += avlbQtt;
			totalFrzQtt += frzQtt;
			totalActualQtt += actualQtt;
			totalCsgQtt += csgQtt;
			totalFrzCsgQtt += frzCsgQtt;
			totalLoanSum += loanSum;
			assocSeq++;

			// 中心合计数据
			centerRegQtt += registerQtt;
			centerAvlbQtt += avlbQtt;
			centerFrzQtt += frzQtt;
			centerActualQtt += actualQtt;
			centerCsgQtt += csgQtt;
			centerFrzCsgQtt += frzCsgQtt;
			centerTotalLoanSum += loanSum;
			centerSeq++;

		}

		// 有数据才写文件
		if (centerSeq > 1) {
			Element total = assocDoc.createElement("total");
			abody.appendChild(total);

			Element totalson = assocDoc.createElement("TOTAL_REGISTER_QTT");
			totalson.setTextContent(totalRegQtt + "");
			total.appendChild(totalson);

			totalson = assocDoc.createElement("TOTAL_AVLB_QTT");
			totalson.setTextContent(totalAvlbQtt + "");
			total.appendChild(totalson);

			totalson = assocDoc.createElement("TOTAL_FRZ_QTT");
			totalson.setTextContent(totalFrzQtt + "");
			total.appendChild(totalson);

			totalson = assocDoc.createElement("TOTAL_ACTUAL_QTT");
			totalson.setTextContent(totalActualQtt + "");
			total.appendChild(totalson);

			totalson = assocDoc.createElement("TOTAL_CSG_QTT");
			totalson.setTextContent(totalCsgQtt + "");
			total.appendChild(totalson);

			totalson = assocDoc.createElement("TOTAL_FRZ_CSG_QTT");
			totalson.setTextContent(totalFrzCsgQtt + "");
			total.appendChild(totalson);

			totalson = assocDoc.createElement("TOTAL_LOAN_SUM");
			totalson
					.setTextContent(Converter.formatFen2yuan(totalLoanSum) + "");
			total.appendChild(totalson);

			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();
			// 会员仓单文件
			fileName = assocDir + assoRemark + dayDir + assoRemark + "_"
					+ settleDay + "_CD.xml";
			assocDoc.appendChild(aroot);
			dom = new DOMSource(assocDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);
			// 中心文件
			Element ctotal = centerDoc.createElement("total");
			body.appendChild(ctotal);

			Element ctotalson = centerDoc.createElement("TOTAL_REGISTER_QTT");
			ctotalson.setTextContent(centerRegQtt + "");
			ctotal.appendChild(ctotalson);

			ctotalson = centerDoc.createElement("TOTAL_AVLB_QTT");
			ctotalson.setTextContent(centerAvlbQtt + "");
			ctotal.appendChild(ctotalson);

			ctotalson = centerDoc.createElement("TOTAL_FRZ_QTT");
			ctotalson.setTextContent(centerFrzQtt + "");
			ctotal.appendChild(ctotalson);

			ctotalson = centerDoc.createElement("TOTAL_ACTUAL_QTT");
			ctotalson.setTextContent(centerActualQtt + "");
			ctotal.appendChild(ctotalson);

			ctotalson = centerDoc.createElement("TOTAL_CSG_QTT");
			ctotalson.setTextContent(centerCsgQtt + "");
			ctotal.appendChild(ctotalson);

			ctotalson = centerDoc.createElement("TOTAL_FRZ_CSG_QTT");
			ctotalson.setTextContent(centerFrzCsgQtt + "");
			ctotal.appendChild(ctotalson);

			ctotalson = centerDoc.createElement("TOTAL_LOAN_SUM");
			ctotalson.setTextContent(Converter
					.formatFen2yuan(centerTotalLoanSum)
					+ "");
			ctotal.appendChild(ctotalson);

			// 中心仓单文件
			fileName = centerDir + settleDay + "_CD.xml";
			centerDoc.appendChild(root);
			dom = new DOMSource(centerDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);
		}
		return RetDefine.pub_success;
	}

	/**
	 * 生成中心/会员订货明细清单。
	 * 
	 * @return
	 * @throws Exception
	 */
	private String[] doSubsDetailList() throws Exception {
		logger.info("生成交易中心/会员的定货明细清单...");
		RetObject ret = new RetObject();
		ResultMap map = new ResultMap();
		DepositStyle depositStyle = new DepositStyle();
		String retStr[];
		String lastAssocNo = "";
		String associatorNo = "";
		String fullName = "";
		String clientId = "";
		long assocSeq = 1;
		long centerSeq = 1;
		long totalDpstQtt = 0;
		long totalRcptQtt = 0;
		long totalSubsBalance = 0;
		long totalDpstAmt = 0;
		long centerDpstQtt = 0;
		long centerRcptQtt = 0;
		long centerSubsBalance = 0;
		long centerDpstAmt = 0;
		String clientName = "";
		String contractId = "";
		String buyOrSell = "";
		String tradeMode = "";
		long dealPrice = 0;
		long dpstQtt = 0;
		long rcptQtt = 0;
		long dpstAmt = 0;
		long subsBalance = 0;
		long settlePrice = -1;

		Document assocDoc = PubTools.getDocument();
		Element aroot = assocDoc.createElement("root");
		Element abody = assocDoc.createElement("body");

		Document centerDoc = PubTools.getDocument();
		Element root = centerDoc.createElement("root");

		Element file_title = centerDoc.createElement("file_title");
		root.appendChild(file_title);
		file_title.setTextContent(settleDay + "_DHMX");

		Element report_name = centerDoc.createElement("report_name");
		report_name.setTextContent("交易中心定货明细清单");
		root.appendChild(report_name);

		Element top = centerDoc.createElement("top");
		root.appendChild(top);

		Element item = centerDoc.createElement("item");
		top.appendChild(item);

		Element content = centerDoc.createElement("content");
		content.setTextContent(statDay);
		item.appendChild(content);

		Element body = centerDoc.createElement("body");
		root.appendChild(body);

		List list = sqlMapClient
				.queryForList("sel_settlesrvRpt_subsDetailDate_T_SUBS_DETAIL");

		for (int i = 0; i < list.size(); i++) {
			clientId = "";
			clientName = "";
			associatorNo = "";
			contractId = "";
			buyOrSell = "";
			tradeMode = "";
			dealPrice = 0;
			dpstQtt = 0;
			rcptQtt = 0;
			dpstAmt = 0;
			subsBalance = 0;
			settlePrice = -1;

			ResultMap restMap = (ResultMap) list.get(i);

			clientId = restMap.getString("client_id");
			clientName = clientMap.get(clientId);
			associatorNo = StringUtil.subStrToStart(clientId, 6);
			contractId = restMap.getString("contract_id");
			buyOrSell = restMap.getString("buyorsell");
			tradeMode = restMap.getString("trade_mode");
			dealPrice = restMap.getLong("deal_price", 0);
			dpstQtt = restMap.getLong("deal_qtt", 0);
			rcptQtt = restMap.getLong("left_qtt_rcpt", 0);
			dpstAmt = restMap.getLong("frz_dpst_amt", 0);
			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();

			if (tradeMode.equals("F")) {
				// 结算价
				settlePrice = contractInfoMap.get(contractId).getSettlePrice();
				// 计算定金
				String csgEndDay = contractInfoMap.get(contractId)
						.getCsgEndDay();
				// 汇率
				double rateOfExchange = contractInfoMap.get(contractId)
						.getRateOfExchange();
				if (dpstQtt > 0) {
					// 将＂定金ID＠交收日＂作为关键字存储定金对象，避免重复取
					long depositId = contractInfoMap.get(contractId)
							.getDepositId();
					if (dpstMap.get(depositId + "@" + csgEndDay) == null) {
						ret.setRetObject(null);
						retStr = tradeUtil.getDepositStyleByDepositId("F",
								depositId, nextSettleDay, csgEndDay, ret);
						if (!RetDefine.pub_success[0].equals(retStr[0])) {
							return retStr;
						}
						depositStyle = (DepositStyle) ret.getRetObject();
						if (depositStyle == null) {
							logger.debug("合同--" + contractId
									+ "没有找到定金率，按100%计算");
							depositStyle = new DepositStyle();
							depositStyle.setUsedFlag("1");
							depositStyle.setBuyerDeposit(10000);
							depositStyle.setSellerDeposit(10000);
						}
						dpstMap.put(depositId + "@" + csgEndDay, depositStyle);
					}
					ret.setRetObject(null);
					/** 20080715 by yanjl 修改获取定金额 */
					retStr = settleSrv.getDepositAmt(buyOrSell, Converter
							.double2long(dpstQtt * dealPrice * rateOfExchange),
							dpstQtt, dpstMap.get(depositId + "@" + csgEndDay),
							rateOfExchange, ret);
					if (!RetDefine.pub_success[0].equals(retStr[0])) {
						return retStr;
					}
					dpstAmt = ret.getRetLong();
				}
				// 计算账面价差
				if (csgEndDay.compareTo(settleDay) > 0) {
					long balancePrice = 0;
					long balanceQtt = 0;
					// 财经学习网始终用结算价计算价差 2008/01/25
					if (SettleUtil.IS_XXW || SettleUtil.balancePriceFlag == 1) {
						balancePrice = settlePrice;
					} else {
						if (contractInfoMap.get(contractId).getLastEndPrice() == -1) {
							map.put("contractId", contractId);
							map.put("settleDay", settleDay);
							contractInfoMap
									.get(contractId)
									.setLastEndPrice(
											Converter
													.glong(sqlMapClient
															.queryForObject(
																	"sel_settlesrv_lastEndPrice_T_TRACK_HIST",
																	map)));
						}
						balancePrice = contractInfoMap.get(contractId)
								.getLastEndPrice();
					}
					if (SettleUtil.balanceRcptFlag == 1) {
						balanceQtt = (dpstQtt + rcptQtt);
					} else {
						balanceQtt = dpstQtt;
					}
					// 账面价差计算 买方账面价差＝结算价*持仓数量 – 订货价格*持仓数量；卖方反之
					if (balanceQtt > 0) {
						// logger.debug("balanceQtt==" + balanceQtt + "&&
						// balancePrice===" + balancePrice);
						long depositId = contractInfoMap.get(contractId)
								.getDepositId();
						depositStyle = dpstMap.get(depositId + "@" + csgEndDay);
						if (depositStyle == null) {
							ret.setRetObject(null);
							retStr = tradeUtil.getDepositStyleByDepositId("F",
									depositId, nextSettleDay, csgEndDay, ret);
							if (!RetDefine.pub_success[0].equals(retStr[0])) {
								return retStr;
							}
							depositStyle = (DepositStyle) ret.getRetObject();
							if (depositStyle == null) {
								logger.debug("合同--" + contractId
										+ "没有找到定金率，按100%计算");
								depositStyle = new DepositStyle();
								depositStyle.setUsedFlag("1");
								depositStyle.setBuyerDeposit(10000);
								depositStyle.setSellerDeposit(10000);
							}
						}
						subsBalance = Converter
								.double2long((balancePrice - dealPrice)
										* balanceQtt * rateOfExchange); // TODO
																		// MODIFY
																		// 已修改
						if (SettleUtil.IS_BUY_NOT_BALANCE == 1
								&& buyOrSell.equals("1")
								&& depositStyle.getUsedFlag().equals("1")
								&& depositStyle.getBuyerDeposit() >= 10000) {
							subsBalance = 0;
						}
						// 卖方反之
						subsBalance = buyOrSell.equals("2") ? -subsBalance
								: subsBalance;
					}
				}

				// 恢复初始开仓价
				dealPrice = restMap.getLong("origin_deal_price", 0);
			}
			// 现货,竟价交易仓单交易
			else if (rcptQtt > 0) {
				dpstQtt = 0;
			}

			if (!(associatorNo.equals(lastAssocNo))) {
				// 已经生成有会员了
				if (centerSeq > 1) {
					// 数据汇总
					Element atotal = assocDoc.createElement("total");
					abody.appendChild(atotal);

					Element atotalson = assocDoc
							.createElement("TOTAL_DPST_QTT");
					atotalson.setTextContent(totalDpstQtt + "");
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_RCPT_QTT");
					atotalson.setTextContent(totalRcptQtt + "");
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_DPST_AMT");
					atotalson.setTextContent(Converter
							.formatFen2yuan(totalDpstAmt));
					atotal.appendChild(atotalson);

					atotalson = assocDoc.createElement("TOTAL_SUBS_BALANCE");
					atotalson.setTextContent(Converter
							.formatFen2yuan(totalSubsBalance));
					atotal.appendChild(atotalson);

					// 会员定货明细文件
					assocDoc.appendChild(aroot);
					String lastAssoRemark = associatorInfoMap.get(lastAssocNo)
							.getRemarak();
					fileName = assocDir + lastAssoRemark + dayDir
							+ lastAssoRemark + "_" + settleDay + "_DHMX.xml";

					dom = new DOMSource(assocDoc);
					result = new StreamResult(new File(fileName));
					trans = TransformerFactory.newInstance().newTransformer();
					trans.transform(dom, result);
				}

				// 下一会员
				fullName = associatorInfoMap.get(associatorNo).getFullName();

				assocDoc = PubTools.getDocument();
				aroot = assocDoc.createElement("root");

				Element afile_title = assocDoc.createElement("file_title");
				afile_title.setTextContent(assoRemark + "_" + settleDay
						+ "_DHMX");
				aroot.appendChild(afile_title);

				Element areport_name = assocDoc.createElement("report_name");
				areport_name.setTextContent("定货明细清单");
				aroot.appendChild(areport_name);

				Element atop = assocDoc.createElement("top");
				aroot.appendChild(atop);

				Element aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				Element acontent = assocDoc.createElement("content");
				acontent.setTextContent(assoRemark);
				aitem.appendChild(acontent);

				aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				acontent = assocDoc.createElement("content");
				acontent.setTextContent(fullName);
				aitem.appendChild(acontent);

				aitem = assocDoc.createElement("item");
				atop.appendChild(aitem);

				acontent = assocDoc.createElement("content");
				acontent.setTextContent(statDay);
				aitem.appendChild(acontent);

				abody = assocDoc.createElement("body");
				aroot.appendChild(abody);

				lastAssocNo = associatorNo;
				assocSeq = 1;
				totalDpstQtt = 0;
				totalRcptQtt = 0;
				totalSubsBalance = 0;
				totalDpstAmt = 0;
			}

			Element aitem = assocDoc.createElement("item");
			abody.appendChild(aitem);

			Element aitemson = assocDoc.createElement("SEQ");
			aitemson.setTextContent(assocSeq + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CLIENT_ID");
			aitemson.setTextContent(assoRemark);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CLIENT_NAME");
			aitemson.setTextContent(clientName);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("CONTRACT_ID");
			aitemson.setTextContent(contractId);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("TRADE_MODE");
			aitemson.setTextContent(tradeMode);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("BUYORSELL");
			aitemson.setTextContent(buyOrSell);
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("SUBS_PRICE");
			aitemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(dealPrice, rate)));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("SETTLE_PRICE");
			aitemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(settlePrice, rate)));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("DPST_QTT");
			aitemson.setTextContent(dpstQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("RCPT_QTT");
			aitemson.setTextContent(rcptQtt + "");
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("DPST_AMT");
			aitemson.setTextContent(Converter.formatFen2yuan(dpstAmt));
			aitem.appendChild(aitemson);

			aitemson = assocDoc.createElement("SUBS_BALANCE");
			aitemson.setTextContent(Converter.formatFen2yuan(subsBalance));
			aitem.appendChild(aitemson);
			/** 20080926 by yanjl 新增DEAL_TIME */
			aitemson = assocDoc.createElement("DEAL_TIME");
			aitemson.setTextContent(restMap.getString("DEAL_TIME"));
			aitem.appendChild(aitemson);

			assocSeq++;
			totalDpstQtt += dpstQtt;
			totalRcptQtt += rcptQtt;
			totalSubsBalance += subsBalance;
			totalDpstAmt += dpstAmt;

			// 中心数据
			item = centerDoc.createElement("item");
			body.appendChild(item);

			Element itemson = centerDoc.createElement("SEQ");
			itemson.setTextContent(centerSeq + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CLIENT_ID");
			itemson.setTextContent(assoRemark);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CLIENT_NAME");
			itemson.setTextContent(clientName);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("CONTRACT_ID");
			itemson.setTextContent(contractId);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("TRADE_MODE");
			itemson.setTextContent(tradeMode);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("BUYORSELL");
			itemson.setTextContent(buyOrSell);
			item.appendChild(itemson);

			itemson = centerDoc.createElement("SUBS_PRICE");
			itemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(dealPrice, rate)));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("SETTLE_PRICE");
			itemson.setTextContent(Converter.formatFen2yuan(Converter
					.reversePriceByRate(settlePrice, rate)));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("DPST_QTT");
			itemson.setTextContent(dpstQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("RCPT_QTT");
			itemson.setTextContent(rcptQtt + "");
			item.appendChild(itemson);

			itemson = centerDoc.createElement("DPST_AMT");
			itemson.setTextContent(Converter.formatFen2yuan(dpstAmt));
			item.appendChild(itemson);

			itemson = centerDoc.createElement("SUBS_BALANCE");
			itemson.setTextContent(Converter.formatFen2yuan(subsBalance));
			item.appendChild(itemson);
			/** 20080926 by yanjl 新增DEAL_TIME */
			itemson = centerDoc.createElement("DEAL_TIME");
			itemson.setTextContent(restMap.getString("DEAL_TIME"));
			item.appendChild(itemson);

			centerSeq++;
			centerDpstQtt += dpstQtt;
			centerRcptQtt += rcptQtt;
			centerSubsBalance += subsBalance;
			centerDpstAmt += dpstAmt;
		}

		// 有数据才写文件
		if (centerSeq > 1) {
			// 会员定货明细文件
			// 数据汇总
			Element atotal = assocDoc.createElement("total");
			abody.appendChild(atotal);

			Element atotalson = assocDoc.createElement("TOTAL_DPST_QTT");
			atotalson.setTextContent(totalDpstQtt + "");
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_RCPT_QTT");
			atotalson.setTextContent(totalRcptQtt + "");
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_DPST_AMT");
			atotalson.setTextContent(Converter.formatFen2yuan(totalDpstAmt));
			atotal.appendChild(atotalson);

			atotalson = assocDoc.createElement("TOTAL_SUBS_BALANCE");
			atotalson
					.setTextContent(Converter.formatFen2yuan(totalSubsBalance));
			atotal.appendChild(atotalson);

			assocDoc.appendChild(aroot);
			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();
			fileName = assocDir + assoRemark + dayDir + assoRemark + "_"
					+ settleDay + "_DHMX.xml";
			dom = new DOMSource(assocDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);

			// 中心定货明细文件
			// 数据汇总
			Element total = centerDoc.createElement("total");
			body.appendChild(total);

			Element totalson = centerDoc.createElement("TOTAL_DPST_QTT");
			totalson.setTextContent(centerDpstQtt + "");
			total.appendChild(totalson);

			totalson = centerDoc.createElement("TOTAL_RCPT_QTT");
			totalson.setTextContent(centerRcptQtt + "");
			total.appendChild(totalson);

			totalson = centerDoc.createElement("TOTAL_DPST_AMT");
			totalson.setTextContent(Converter.formatFen2yuan(centerDpstAmt));
			total.appendChild(totalson);

			totalson = centerDoc.createElement("TOTAL_SUBS_BALANCE");
			totalson
					.setTextContent(Converter.formatFen2yuan(centerSubsBalance));
			total.appendChild(totalson);

			centerDoc.appendChild(root);
			fileName = centerDir + settleDay + "_DHMX.xml";
			dom = new DOMSource(centerDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);
		}
		return RetDefine.pub_success;
	}

	/**
	 * 会员月结算报表
	 * 
	 * @log 20080820 by yanjl 为液化修改 新增违约金和会员费等项
	 * @return
	 * @throws Exception
	 */
	private String[] doMonthSettleList() throws Exception {
		String associatorNo = "";
		long avlbFund = 0;
		long subsDeposit = 0;
		long frzRiskFund = 0;
		long acctBalance = 0;
		long curAvlbFund = 0;
		long curSubsDeposit = 0;
		long curFrzRiskFund = 0;
		long curAcctBalance = 0;
		long buyerDiff = 0;
		long csgFee = 0;
		long surrogateFee = 0;
		long poundage = 0;
		long retPoundage = 0;
		long outFund = 0;
		long inFund = 0;
		long paidPayment = 0;
		long gotPayment = 0;
		long cnyIncome = 0;
		long csgIncome = 0;
		long otherFee = 0;
		long curRight = 0;
		long beginRight = 0;
		long disobeyFee = 0;
		long manageFee = 0;

		ResultMap map = new ResultMap();
		map.put("settleDay", nextSettleDay);
		map.put("beginDay", monthBeginDay);
		List list = sqlMapClient.queryForList(
				"sel_settlesrvRpt_monthBegEndFund_T_DAILY_FUND_SUMMARY", map);

		/** 20080826 by yanjl 仓单质押 */

		List<ResultMap> repayList = new ArrayList<ResultMap>();
		if (list != null && list.size() > 0) {
			ResultMap repayMap = new ResultMap();
			repayMap.put("beginTime", monthBeginTime);
			repayMap.put("endTime", curEndTime);
			repayList = sqlMapClient.queryForList(
					"sel_settlesrv_t_repay_info_groupByAssoNo", repayMap);
		}
		Iterator<ResultMap> repayIterator = repayList.iterator();

		for (int i = 0; i < list.size(); i++) {
			avlbFund = 0;
			subsDeposit = 0;
			frzRiskFund = 0;
			acctBalance = 0;
			curAvlbFund = 0;
			curSubsDeposit = 0;
			curFrzRiskFund = 0;
			curAcctBalance = 0;
			buyerDiff = 0;
			csgFee = 0;
			surrogateFee = 0;
			poundage = 0;
			retPoundage = 0;
			outFund = 0;
			inFund = 0;
			paidPayment = 0;
			gotPayment = 0;
			cnyIncome = 0;
			csgIncome = 0;
			otherFee = 0;
			curRight = 0;
			beginRight = 0;

			ResultMap retMap = (ResultMap) list.get(i);
			associatorNo = retMap.getString("associator_no", "");
			avlbFund = retMap.getLong("avlb_fund", 0);
			subsDeposit = retMap.getLong("subs_deposit", 0);
			frzRiskFund = retMap.getLong("frz_risk_fund", 0);
			acctBalance = retMap.getLong("acct_balance", 0);
			curAvlbFund = retMap.getLong("cur_avlb_fund", 0);
			curSubsDeposit = retMap.getLong("cur_subs_deposit", 0);
			curFrzRiskFund = retMap.getLong("cur_frz_risk_fund", 0);
			curAcctBalance = retMap.getLong("cur_acct_balance", 0);
			// 入金
			inFund += retMap.getLong("cur_in_fund_sum", 0)
					- retMap.getLong("in_fund_sum", 0);
			// 出金
			outFund += retMap.getLong("cur_out_fund_sum", 0)
					- retMap.getLong("out_fund_sum", 0);
			// 期初权益
			beginRight = retMap.getLong("total_right", 0);
			// 期末权益
			curRight = retMap.getLong("cur_total_right", 0);

			/** 20080826 by yanjl */
			long loanPoundage = 0, loanInterest = 0, repaySum = 0, loanBalance = 0;
			loanBalance = retMap.getLong("cur_loan_balance", 0);
			repayIterator = repayList.iterator();
			while (repayIterator.hasNext()) {
				ResultMap element = repayIterator.next();
				if (element.getString("associator_no", "").equals(associatorNo)) {
					repaySum = element.getLong("repay_sum", 0);
					// repayIterator.remove();
					break;
				}
			}

			map.put("associatorNo", associatorNo);
			List fundList = sqlMapClient.queryForList(
					"sel_settlesrvRpt_monthFund_T_DAILY_FUND_SUMMARY", map);
			if (fundList.size() > 0) {
				retMap = (ResultMap) fundList.get(0);
				// 交收盈亏
				csgIncome = retMap.getLong("csg_balance", 0);
				// 转让收入
				cnyIncome += retMap.getLong("cny_balance", 0);
				// 收到货款
				gotPayment += retMap.getLong("got_payment", 0);
				// 付出货款
				paidPayment += retMap.getLong("paid_payment", 0);
				// 买方退补货款
				buyerDiff += retMap.getLong("cur_buyer_diff", 0);
				// 交易手续费
				poundage += retMap.getLong("cur_poundage", 0);
				// 返回手续费
				retPoundage += retMap.getLong("ret_poundage", 0);
				// 代收费
				surrogateFee += retMap.getLong("cur_agency_fee", 0);
				// 交收手续费
				csgFee += retMap.getLong("cur_csg_fee", 0);
				// 违约金
				disobeyFee = retMap.getLong("disobey_fee", 0);
				// 会员费
				manageFee = retMap.getLong("cur_manage_fee", 0);

				loanPoundage = retMap.getLong("cur_loan_poundage", 0);
				loanInterest = retMap.getLong("cur_loan_interest", 0);
			}

			// 获得转让价差月度累计
			long cnyBalance = Converter.glong(sqlMapClient.queryForObject(
					"sel_settlesrvRpt_monthCnyBalance_T_DEAL_F_HIST", map));
			System.out.println("--月报会员编码：" + associatorNo);
			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();
			String fileName = assocDir + assoRemark + dayDir + assoRemark + "_"
					+ curMonth + "_MS.xml";
			FileWriter fileWriter = new FileWriter(fileName);
			BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);

			bufferedWriter.write("<?xml version=\"1.0\" encoding=\"GBK\"?>\n");
			bufferedWriter.write("<root>\n");
			bufferedWriter.write("	 <file_title>会员月结算报表:" + curMonth
					+ assoRemark + "_MS</file_title>\n");
			bufferedWriter.write("	 <report_name>会员月结算报表</report_name>\n");
			bufferedWriter.write("	 <top>\n");
			bufferedWriter.write("		<item>\n");

			bufferedWriter.write("			<content>" + assoRemark + "</content>\n");
			bufferedWriter.write("		</item>\n");
			bufferedWriter.write("		<item>\n");

			bufferedWriter.write("			<content>"
					+ associatorInfoMap.get(associatorNo).getFullName()
					+ "</content>\n");
			bufferedWriter.write("		</item>\n");
			bufferedWriter.write("		<item>\n");

			bufferedWriter.write("			<content>" + statMonth + "</content>\n");
			bufferedWriter.write("		</item>\n");
			bufferedWriter.write("	 </top>\n");
			bufferedWriter.write("	 <body>\n");
			// 数据输入
			bufferedWriter.write("	  <item>\n");
			bufferedWriter.write("		<VALUE>金额</VALUE>\n");
			bufferedWriter
					.write("		<BEGIN_RIGHT>"
							+ Converter.formatFen2yuan(beginRight)
							+ "</BEGIN_RIGHT>\n");
			bufferedWriter.write("		<IN_FUND>"
					+ Converter.formatFen2yuan(inFund) + "</IN_FUND>\n");
			bufferedWriter.write("		<OUT_FUND>"
					+ Converter.formatFen2yuan(outFund) + " </OUT_FUND>\n");
			bufferedWriter.write("		<POUNDAGE>"
					+ Converter.formatFen2yuan(poundage) + "</POUNDAGE>\n");
			bufferedWriter.write("		<RET_POUNDAGE>"
					+ Converter.formatFen2yuan(retPoundage)
					+ "</RET_POUNDAGE>\n");
			bufferedWriter.write("		<CSG_FEE>"
					+ Converter.formatFen2yuan(csgFee) + "</CSG_FEE>\n");
			bufferedWriter
					.write("		<GOT_PAYMENT>"
							+ Converter.formatFen2yuan(gotPayment)
							+ "</GOT_PAYMENT>\n");
			bufferedWriter.write("		<PAID_PAYMENT>"
					+ Converter.formatFen2yuan(paidPayment)
					+ "</PAID_PAYMENT>\n");
			bufferedWriter.write("		<BUYER_DIFF>"
					+ Converter.formatFen2yuan(buyerDiff) + "</BUYER_DIFF>\n");
			bufferedWriter
					.write("		<CNY_BALANCE>"
							+ Converter.formatFen2yuan(cnyBalance)
							+ "</CNY_BALANCE>\n");
			bufferedWriter.write("		<CNY_INOME>"
					+ Converter.formatFen2yuan(cnyIncome) + "</CNY_INOME>\n");
			bufferedWriter.write("		<CSG_INOME>"
					+ Converter.formatFen2yuan(csgIncome) + "</CSG_INOME>\n");
			bufferedWriter.write("		<SURROGATE_FEE>"
					+ Converter.formatFen2yuan(surrogateFee)
					+ "</SURROGATE_FEE>\n");
			bufferedWriter.write("		<OTHER_FEE>"
					+ Converter.formatFen2yuan(otherFee) + "</OTHER_FEE>\n");
			bufferedWriter.write("		<CUR_RIGHT>"
					+ Converter.formatFen2yuan(curRight) + "</CUR_RIGHT>\n");
			bufferedWriter.write("		<CUR_SUBS_DEPOSIT>"
					+ Converter.formatFen2yuan(curSubsDeposit)
					+ "</CUR_SUBS_DEPOSIT>\n");
			bufferedWriter.write("		<CUR_ACCT_BALANCE>"
					+ Converter.formatFen2yuan(curAcctBalance)
					+ "</CUR_ACCT_BALANCE>\n");
			bufferedWriter.write("		<CUR_AVLB_FUND>"
					+ Converter.formatFen2yuan(curAvlbFund)
					+ "</CUR_AVLB_FUND>\n");
			bufferedWriter.write("		<AVLB_FUND>"
					+ Converter.formatFen2yuan(avlbFund) + "</AVLB_FUND>\n");
			bufferedWriter.write("		<SUBS_DEPOSIT>"
					+ Converter.formatFen2yuan(subsDeposit)
					+ "</SUBS_DEPOSIT>\n");
			bufferedWriter.write("		<ACCT_BALANCE>"
					+ Converter.formatFen2yuan(acctBalance)
					+ "</ACCT_BALANCE>\n");
			bufferedWriter.write("		<FRZ_RISK_FUND>"
					+ Converter.formatFen2yuan(frzRiskFund)
					+ "</FRZ_RISK_FUND>\n");
			bufferedWriter.write("		<CUR_FRZ_RISK_FUND>"
					+ Converter.formatFen2yuan(curFrzRiskFund)
					+ "</CUR_FRZ_RISK_FUND>\n");
			bufferedWriter
					.write("		<DISOBEY_FEE>"
							+ Converter.formatFen2yuan(disobeyFee)
							+ "</DISOBEY_FEE>\n");
			bufferedWriter.write("		<MANAGE_FEE>"
					+ Converter.formatFen2yuan(manageFee) + "</MANAGE_FEE>\n");
			bufferedWriter.write("		<LOAN_POUNDAGE>"
					+ Converter.formatFen2yuan(loanPoundage)
					+ "</LOAN_POUNDAGE>\n");
			bufferedWriter.write("		<LOAN_INTEREST>"
					+ Converter.formatFen2yuan(loanInterest)
					+ "</LOAN_INTEREST>\n");
			bufferedWriter.write("		<LOAN_REPAY_SUM>"
					+ Converter.formatFen2yuan(repaySum)
					+ "</LOAN_REPAY_SUM>\n");
			bufferedWriter.write("		<CUR_LOAN_BALANCE>"
					+ Converter.formatFen2yuan(loanBalance)
					+ "</CUR_LOAN_BALANCE>\n");
			bufferedWriter.write("	  </item>\n");
			bufferedWriter.write("	 </body>\n");
			bufferedWriter.write("</root>\n");
			bufferedWriter.flush();
			fileWriter.flush();
			bufferedWriter.close();
			fileWriter.close();
		}

		return RetDefine.pub_success;
	}

	/**
	 * 会员入出金月报表
	 * 
	 * @return
	 * @throws Exception
	 */
	private String[] doMonthInOutList() throws Exception {
		String associatorNo = "";
		String lastAssociatorNo = "";
		String style = "";
		String inOrOut = "";
		String checkTime = "";
		String inoroutType = "";
		long amount = 0;
		long totalInFund = 0;
		long totalOutFund = 0;
		FileWriter fileWriter = null;
		BufferedWriter bufferedWriter = null;

		FundInoutLogDAOImpl fundInoutLogDAOImpl = new FundInoutLogDAOImpl(
				sqlMapClient);
		FundInoutLogExample fundInoutLogExample = new FundInoutLogExample();
		FundInoutLog fundInoutLog = new FundInoutLog();
		fundInoutLogExample.setAssociatorNo("00001");
		fundInoutLogExample
				.setAssociatorNo_Indicator(FundInoutLogExample.EXAMPLE_NOT_EQUALS);
		fundInoutLogExample.setCheckTime(monthBeginTime);
		fundInoutLogExample
				.setCheckTime_Indicator(FundInoutLogExample.EXAMPLE_GREATER_THAN_OR_EQUAL);
		/** 20081030 by yanjl */
		fundInoutLogExample.setHasChecked(1);
		fundInoutLogExample
				.setHasChecked_Indicator(FundInoutLogExample.EXAMPLE_EQUALS);
		List list = fundInoutLogDAOImpl.selectByExample(fundInoutLogExample,
				"associator_no");
		for (int i = 0; i < list.size(); i++) {
			inOrOut = "";
			checkTime = "";
			amount = 0;

			fundInoutLog = (FundInoutLog) list.get(i);
			if (fundInoutLog == null) {
			}
			associatorNo = fundInoutLog.getAssociatorNo();
			amount = fundInoutLog.getAmount();
			style = fundInoutLog.getStyle();
			inoroutType = fundInoutLog.getInoroutType();
			inOrOut = fundInoutLog.getInorout();
			checkTime = DateUtil.format(fundInoutLog.getCheckTime(),
					"yyyy-MM-dd");
			System.out.println("++月报会员编码：" + associatorNo);
			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();

			if (!associatorNo.equals(lastAssociatorNo)) {
				if (i > 0) {
					bufferedWriter.write("	   <total>\n");
					bufferedWriter.write("		<TOTAL_IN_FUND>"
							+ Converter.formatFen2yuan(totalInFund)
							+ "</TOTAL_IN_FUND>\n");
					bufferedWriter.write("		<TOTAL_OUT_FUND>"
							+ Converter.formatFen2yuan(totalOutFund)
							+ "</TOTAL_OUT_FUND>\n");
					bufferedWriter.write("		<ADD_FUND>"
							+ Converter.formatFen2yuan(totalInFund
									- totalOutFund) + "</ADD_FUND>\n");
					bufferedWriter.write("    </total>\n");
					bufferedWriter.write("	 </body>\n");
					bufferedWriter.write("</root>\n");
					bufferedWriter.flush();
					fileWriter.flush();
					bufferedWriter.close();
					fileWriter.close();
				}
				fileName = assocDir + assoRemark + dayDir + assoRemark + "_"
						+ curMonth + "_MIO.xml";
				fileWriter = new FileWriter(fileName);
				bufferedWriter = new BufferedWriter(fileWriter);

				bufferedWriter
						.write("<?xml version=\"1.0\" encoding=\"GBK\"?>\n");
				bufferedWriter.write("<root>\n");
				bufferedWriter.write("	 <file_title>会员入出金月报表:" + curMonth
						+ assoRemark + "_MIO</file_title>\n");
				bufferedWriter.write("	 <report_name>会员入出金月报表</report_name>\n");
				bufferedWriter.write("	 <top>\n");
				bufferedWriter.write("		<item>\n");

				bufferedWriter.write("			<content>" + assoRemark
						+ "</content>\n");
				bufferedWriter.write("		</item>\n");
				bufferedWriter.write("		<item>\n");

				bufferedWriter.write("			<content>"
						+ associatorInfoMap.get(associatorNo).getFullName()
						+ "</content>\n");
				bufferedWriter.write("		</item>\n");
				bufferedWriter.write("		<item>\n");

				bufferedWriter.write("			<content>" + statMonth
						+ "</content>\n");
				bufferedWriter.write("		</item>\n");
				bufferedWriter.write("	 </top>\n");
				bufferedWriter.write("	 <body>\n");
				totalInFund = 0;
				totalOutFund = 0;
				lastAssociatorNo = associatorNo;
			}

			// 数据输入
			bufferedWriter.write("	  <item>\n");
			bufferedWriter.write("		<CHECK_TIME>" + checkTime
					+ "</CHECK_TIME>\n");
			bufferedWriter.write("		<AMT>" + Converter.formatFen2yuan(amount)
					+ "</AMT>\n");
			bufferedWriter.write("		<INOROUT>" + inOrOut + "</INOROUT>\n");
			bufferedWriter.write("		<STYLE>"
					+ (inoroutType.equals("8") ? "M" : "C") + "</STYLE>\n");
			bufferedWriter.write("	  </item>\n");

			if ("I".equals(inOrOut)) {
				totalInFund += amount;
			} else {
				totalOutFund += amount;
			}
		}
		if (!associatorNo.equals("")) {
			bufferedWriter.write("	   <total>\n");
			bufferedWriter.write("		<TOTAL_IN_FUND>"
					+ Converter.formatFen2yuan(totalInFund)
					+ "</TOTAL_IN_FUND>\n");
			bufferedWriter.write("		<TOTAL_OUT_FUND>"
					+ Converter.formatFen2yuan(totalOutFund)
					+ "</TOTAL_OUT_FUND>\n");
			bufferedWriter.write("		<ADD_FUND>"
					+ Converter.formatFen2yuan(totalInFund - totalOutFund)
					+ "</ADD_FUND>\n");
			bufferedWriter.write("    </total>\n");
			bufferedWriter.write("	 </body>\n");
			bufferedWriter.write("</root>\n");
			bufferedWriter.flush();
			fileWriter.flush();
			bufferedWriter.close();
			fileWriter.close();
		}

		return RetDefine.pub_success;
	}

	private String[] doMonthConsignList() throws Exception {
		FileWriter fileWriter = null;
		BufferedWriter bufferedWriter = null;
		logger.info("生成交收货款了结月报");
		String associatorNo = "";
		String lastAssocNo = "";
		double totalActualQtt = 0;
		long totalDealCost = 0;
		long totalActualAmt = 0;
		long totalCsgFee = 0;
		long totalCsgQtt = 0;
		long totalLeftPaymen = 0;

		String contractId = "";
		String buyorsell = "";
		String contractType = "";
		long csgQtt = 0;
		double actualQtt = 0;
		long actualAmt = 0;
		long dealPrice = 0;
		long agioFee = 0;
		long csgPrice = 0;
		long csgFee = 0;
		long detailSeq = 0;
		int csgPriceType = 2;
		long dealCost = 0;
		long leftPayment = 0;
		int status = 0;

		// 获得会员交收货款了结数据
		// 设置查询条件
		ResultMap map = new ResultMap();
		SubsCDetailDAOImpl subsCDetailDAOImpl = new SubsCDetailDAOImpl(
				sqlMapClient);
		SubsSDetailDAOImpl subsSDetailDAOImpl = new SubsSDetailDAOImpl(
				sqlMapClient);
		map.put("beginTime", monthBeginTime);
		map.put("endTime", curEndTime);
		map.put("same", "1");
		List list = sqlMapClient.queryForList(
				"sel_settlesrvRpt_csgFinishDate_T_PAYMENT_FINISH_LIST", map);

		for (int i = 0; i < list.size(); i++) {
			associatorNo = "";
			contractId = "";
			buyorsell = "";
			contractType = "";
			csgQtt = 0;
			actualQtt = 0;
			actualAmt = 0;
			dealPrice = 0;
			agioFee = 0;
			csgPrice = 0;
			csgFee = 0;
			detailSeq = 0;
			csgPriceType = 2;
			dealCost = 0;
			status = 0;
			leftPayment = 0;

			ResultMap csgMap = (ResultMap) list.get(i);
			associatorNo = csgMap.getString("associator_no");
			contractId = csgMap.getString("contract_id");
			buyorsell = csgMap.getString("buyorsell");
			csgQtt = csgMap.getLong("csg_qtt", 0);
			actualQtt = csgMap.getDouble("qtt", 0);
			actualAmt = csgMap.getLong("actualAmt", 0);
			dealPrice = csgMap.getLong("dealPrice", 0);
			agioFee = csgMap.getLong("agio_fee", 0);
			csgPrice = csgMap.getLong("csg_price", 0);
			csgFee = csgMap.getLong("csgFee", 0);
			csgPriceType = csgMap.getInt("csg_price_type", 2);
			dealCost = csgMap.getLong("deal_cost", 0);
			status = csgMap.getInt("status");
			leftPayment = csgMap.getLong("left_payment");

			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();

			if (!associatorNo.equals(lastAssocNo)) {
				if (i > 0) {
					// 会员数据汇总
					bufferedWriter.write("	   <total>\n");
					bufferedWriter.write("		<TOTAL_MATCHING_QTT>" + totalCsgQtt
							+ "</TOTAL_MATCHING_QTT>\n");
					bufferedWriter.write("		<TOTAL_ACTUAL_QTT>"
							+ new DecimalFormat("#0.###")
									.format(totalActualQtt)
							+ "</TOTAL_ACTUAL_QTT>\n");
					bufferedWriter.write("		<TOTAL_DEAL_AMT>"
							+ Converter.formatFen2yuan(totalDealCost)
							+ "</TOTAL_DEAL_AMT>\n");
					bufferedWriter.write("		<TOTAL_PAYMENT>"
							+ Converter.formatFen2yuan(totalActualAmt)
							+ "</TOTAL_PAYMENT>\n");
					bufferedWriter.write("		<TOTAL_CSG_FEE>"
							+ Converter.formatFen2yuan(totalCsgFee)
							+ "</TOTAL_CSG_FEE>\n");
					bufferedWriter.write("		<TOTAL_LEFT_PAYMENT>"
							+ Converter.formatFen2yuan(totalLeftPaymen)
							+ "</TOTAL_LEFT_PAYMENT>\n");
					bufferedWriter.write("    </total>\n");
					bufferedWriter.write("	 </body>\n");
					bufferedWriter.write("</root>\n");
					bufferedWriter.flush();
					fileWriter.flush();
					bufferedWriter.close();
					fileWriter.close();
				}
				fileName = assocDir + assoRemark + dayDir + assoRemark + "_"
						+ curMonth + "_MCSG.xml";
				fileWriter = new FileWriter(fileName);
				bufferedWriter = new BufferedWriter(fileWriter); // 下一会员

				bufferedWriter
						.write("<?xml version=\"1.0\" encoding=\"GBK\"?>\n");
				bufferedWriter.write("<root>\n");
				bufferedWriter.write("	 <file_title>会员交收月报表:" + curMonth + "_"
						+ assoRemark + "_MCSG</file_title>\n");
				bufferedWriter.write("	 <report_name>会员交收月报表</report_name>\n");
				bufferedWriter.write("	<top>\n");
				bufferedWriter.write("	 <item>\n");

				bufferedWriter.write("    <content>" + assoRemark
						+ "</content>\n");
				bufferedWriter.write("	 </item>\n");
				bufferedWriter.write("	 <item>\n");

				bufferedWriter.write("    <content>"
						+ associatorInfoMap.get(associatorNo).getFullName()
						+ "</content>\n");
				bufferedWriter.write("  </item>\n");
				bufferedWriter.write("  <item>\n");

				bufferedWriter.write("    <content>" + statMonth
						+ "</content>\n");
				bufferedWriter.write("    </item>\n");
				bufferedWriter.write("	 </top>\n");
				bufferedWriter.write("	 <body>\n");

				totalActualQtt = 0;
				totalDealCost = 0;
				totalActualAmt = 0;
				totalCsgFee = 0;
				totalCsgQtt = 0;
				totalLeftPaymen = 0;
				lastAssocNo = associatorNo;
			}
			// 查询现货订货价
			if ("S".equals(contractType)) {
				SubsSDetailKey subsSDetailKey = new SubsSDetailKey();
				subsSDetailKey.setBuyorsell(buyorsell);
				subsSDetailKey.setDetailSeq(detailSeq);
				dealPrice = subsSDetailDAOImpl.selectByPrimaryKey(
						subsSDetailKey).getDealPrice();
			}
			// 竞价订货价
			else if ("C".equals(contractType)) {
				SubsCDetailKey subsCDetailKey = new SubsCDetailKey();
				subsCDetailKey.setBuyorsell(buyorsell);
				subsCDetailKey.setDetailSeq(detailSeq);
				dealPrice = subsCDetailDAOImpl.selectByPrimaryKey(
						subsCDetailKey).getDealPrice();
			}

			bufferedWriter.write("	 <item>\n");
			bufferedWriter.write("	   <CONTRACT_ID>" + contractId
					+ "</CONTRACT_ID>\n");
			bufferedWriter.write("	   <BUYORSELL>" + buyorsell
					+ "</BUYORSELL>\n");
			bufferedWriter.write("	   <MATCHING_QTT>" + csgQtt
					+ "</MATCHING_QTT>\n");
			bufferedWriter.write("	   <ACTUAL_QTT>"
					+ new DecimalFormat("#0.###").format(actualQtt)
					+ "</ACTUAL_QTT>\n");
			bufferedWriter.write("	   <SUBS_PRICE>"
					+ Converter.formatFen2yuan(Converter.reversePriceByRate(
							dealPrice, rate)) + "</SUBS_PRICE>\n");
			bufferedWriter.write("	   <DEAL_AMT>"
					+ Converter.formatFen2yuan(dealCost) + "</DEAL_AMT>\n");
			bufferedWriter.write("	   <AGIO_FEE>"
					+ Converter.formatFen2yuan(agioFee) + "</AGIO_FEE>\n");
			bufferedWriter.write("	   <CSG_PRICE>"
					+ Converter.formatFen2yuan(Converter.reversePriceByRate(
							csgPrice, rate)) + "</CSG_PRICE>\n");
			bufferedWriter.write("	   <CSG_PRICE_TYPE>" + csgPriceType
					+ "</CSG_PRICE_TYPE>\n");
			bufferedWriter.write("	   <PAYMENT>"
					+ Converter.formatFen2yuan(actualAmt) + "</PAYMENT>\n");
			bufferedWriter.write("	   <CSG_FEE>"
					+ Converter.formatFen2yuan(csgFee) + "</CSG_FEE>\n");
			bufferedWriter.write("	   <STATUS>" + status + "</STATUS>\n");
			bufferedWriter.write("	   <LEFT_PAYMENT>"
					+ Converter.formatFen2yuan(leftPayment)
					+ "</LEFT_PAYMENT>\n");
			bufferedWriter.write("	 </item>\n");

			totalCsgQtt += csgQtt;
			totalActualQtt += actualQtt;
			totalCsgFee += csgFee;
			totalDealCost += dealCost;
			totalActualAmt += actualAmt;
			totalLeftPaymen += leftPayment;
		}
		if (!associatorNo.equals("")) {
			// 会员数据汇总
			bufferedWriter.write("	   <total>\n");
			bufferedWriter.write("		<TOTAL_MATCHING_QTT>" + totalCsgQtt
					+ "</TOTAL_MATCHING_QTT>\n");
			bufferedWriter.write("		<TOTAL_ACTUAL_QTT>"
					+ new DecimalFormat("#0.###").format(totalActualQtt)
					+ "</TOTAL_ACTUAL_QTT>\n");
			bufferedWriter.write("		<TOTAL_DEAL_AMT>"
					+ Converter.formatFen2yuan(totalDealCost)
					+ "</TOTAL_DEAL_AMT>\n");
			bufferedWriter.write("		<TOTAL_PAYMENT>"
					+ Converter.formatFen2yuan(totalActualAmt)
					+ "</TOTAL_PAYMENT>\n");
			bufferedWriter.write("		<TOTAL_CSG_FEE>"
					+ Converter.formatFen2yuan(totalCsgFee)
					+ "</TOTAL_CSG_FEE>\n");
			bufferedWriter.write("		<TOTAL_LEFT_PAYMENT>"
					+ Converter.formatFen2yuan(totalLeftPaymen)
					+ "</TOTAL_LEFT_PAYMENT>\n");
			bufferedWriter.write("    </total>\n");
			bufferedWriter.write("	 </body>\n");
			bufferedWriter.write("</root>\n");
			bufferedWriter.flush();
			fileWriter.flush();
			bufferedWriter.close();
			fileWriter.close();
		}
		return RetDefine.pub_success;
	}

	private String[] doMonthDealList() throws Exception {
		logger.info("生成会员的月交易清单...");

		// 设置查询条件
		ResultMap map = new ResultMap();
		map.put("beginTime", monthBeginTime);
		map.put("endTime", curEndTime);
		// List list =
		// sqlMapClient.queryForList("sel_settlesrvRpt_dealDate_T_DEAL_HIST",
		// map);

		RowHandler handler = new RowHandler() {
			FileWriter fileWriter = null;
			BufferedWriter bufferedWriter = null;
			String lastAssocNo = "";
			String associatorNo = "";
			String clientId = "";
			long assocSeq = 1;
			long totalDealQtt = 0;
			long totalRcptQtt = 0;
			long totalCnyInCome = 0;
			long totalPoundage = 0;
			String dealNo = "";
			String contractId = "";
			String buyOrSell = "";
			String dealType = "";
			String dealTime = "";
			String orderNo = "";
			String tradeMode = "";
			String orderTime = "--";
			long dealPrice = 0;
			long dealQtt = 0;
			long dealReceipt = 0;
			long poundage = 0;
			long newCost = 0;
			long cnyBalance = 0;
			long newPrice = 0;
			long cnyInCome = 0;

			OrderFHistDAOImpl orderFHistDAOImpl = new OrderFHistDAOImpl(
					sqlMapClient);
			OrderSHistDAOImpl orderSHistDAOImpl = new OrderSHistDAOImpl(
					sqlMapClient);
			OrderCHistDAOImpl orderCHistDAOImpl = new OrderCHistDAOImpl(
					sqlMapClient);
			Map<String, Double> roeInfoMap = new HashMap<String, Double>();

			int i = 0;

			@Override
			public void handleRow(Object obj) {
				try {
					if (obj == null) {
						if (assocSeq > 1) {
							// 会员数据汇总
							bufferedWriter.write("	   <total>\n");
							bufferedWriter.write("		<TOTAL_DEAL_QTT>"
									+ totalDealQtt + "</TOTAL_DEAL_QTT>\n");
							bufferedWriter.write("		<TOTAL_CNY_INCOME>"
									+ Converter.formatFen2yuan(totalCnyInCome)
									+ "</TOTAL_CNY_INCOME>\n");
							bufferedWriter.write("		<TOTAL_POUNDAGE>"
									+ Converter.formatFen2yuan(totalPoundage)
									+ "</TOTAL_POUNDAGE>\n");
							bufferedWriter.write("		<TOTAL_DEAL_RECEIPT>"
									+ totalRcptQtt + "</TOTAL_DEAL_RECEIPT>\n");
							bufferedWriter.write("    </total>\n");
							bufferedWriter.write("	 </body>\n");
							bufferedWriter.write("</root>\n");

							bufferedWriter.flush();
							fileWriter.flush();
							bufferedWriter.close();
							fileWriter.close();
						}
						return;
					}
					i++;
					clientId = "";
					dealNo = "";
					contractId = "";
					buyOrSell = "";
					dealType = "";
					dealTime = "";
					orderNo = "";
					tradeMode = "";
					orderTime = "--";
					dealPrice = 0;
					dealQtt = 0;
					dealReceipt = 0;
					poundage = 0;
					newCost = 0;
					cnyBalance = 0;
					newPrice = 0;
					cnyInCome = 0;
					ResultMap restMap = (ResultMap) obj;

					clientId = restMap.getString("client_id");
					associatorNo = StringUtil.subStrToStart(clientId, 6);
					dealNo = restMap.getString("deal_no");
					contractId = restMap.getString("contract_id");
					buyOrSell = restMap.getString("buyorsell");
					dealType = restMap.getString("deal_type", "1");
					dealTime = DateUtil.format(((TIMESTAMP) restMap
							.get("deal_time")).dateValue(),
							"yyyy-MM-dd HH:mm:ss");
					orderNo = restMap.getString("order_no", "--");
					tradeMode = restMap.getString("trade_mode");
					dealPrice = restMap.getLong("deal_price", 0);
					dealQtt = restMap.getLong("deal_qtt", 0);
					dealReceipt = restMap.getLong("deal_receipt", 0);
					poundage = restMap.getLong("poundage", 0);
					newCost = restMap.getLong("new_cost", 0);
					cnyBalance = restMap.getLong("cny_balance", 0);

					String assoRemark = associatorInfoMap.get(associatorNo)
							.getRemarak();

					if (roeInfoMap.isEmpty()
							|| roeInfoMap.get(contractId) == null) {
						RoeInfo roeInfo = tradeUtil.getRoeInfo(tradeMode,
								contractId, DateUtil.format(
										((TIMESTAMP) restMap.get("deal_time"))
												.dateValue(), "yyyyMMdd"));

						roeInfoMap.put(contractId + "@roe",
								roeInfo == null ? 1.0
										: roeInfo.getRoe() / 10000.0);
					}
					// newPrice = newCost == 0 ? dealPrice : newCost/dealQtt;
					newPrice = newCost == 0 ? dealPrice : Converter
							.double2long(newCost / dealQtt
									/ roeInfoMap.get(contractId + "@roe"));

					if (cnyBalance != 0) {
						cnyInCome = Converter.double2long(cnyBalance
								/ contractInfoMap.get(contractId).getTaxRate());
					}

					if (!orderNo.equals("--")) {
						if (tradeMode.equals("F")) {
							OrderFHistKey orderFHistKey = new OrderFHistKey();
							orderFHistKey.setOrderNo(orderNo);
							OrderFHist orderFHist = orderFHistDAOImpl
									.selectByPrimaryKey(orderFHistKey);
							if (orderFHist != null) {
								orderTime = DateUtil.format(orderFHist
										.getOrderTime());
							} else {
								logger.warn("没有找到对应的委托时间");
							}
						} else if (tradeMode.equals("S")) {
							OrderSHistKey orderSHistKey = new OrderSHistKey();
							orderSHistKey.setOrderNo(orderNo);
							OrderSHist orderSHist = orderSHistDAOImpl
									.selectByPrimaryKey(orderSHistKey);
							if (orderSHist != null) {
								orderTime = DateUtil.format(orderSHist
										.getOrderTime());
							} else {
								logger.warn("没有找到对应的委托时间");
							}
						} else // (tradeMode.equals("C"))
						{
							OrderCHistKey orderCHistKey = new OrderCHistKey();
							orderCHistKey.setOrderNo(orderNo);
							OrderCHist orderCHist = orderCHistDAOImpl
									.selectByPrimaryKey(orderCHistKey);
							if (orderCHist != null) {
								orderTime = DateUtil.format(orderCHist
										.getOrderTime());
							} else {
								logger.warn("没有找到对应的委托时间");
							}
						}
					}

					if (!(associatorNo.equals(lastAssocNo))) {
						logger.debug("★〓〓〓§I〓〓〓★〓〓〓§" + i);

						// 已经生成有会员了
						if (assocSeq > 1) {
							// 会员数据汇总
							bufferedWriter.write("	   <total>\n");
							bufferedWriter.write("		<TOTAL_DEAL_QTT>"
									+ totalDealQtt + "</TOTAL_DEAL_QTT>\n");
							bufferedWriter.write("		<TOTAL_CNY_INCOME>"
									+ Converter.formatFen2yuan(totalCnyInCome)
									+ "</TOTAL_CNY_INCOME>\n");
							bufferedWriter.write("		<TOTAL_POUNDAGE>"
									+ Converter.formatFen2yuan(totalPoundage)
									+ "</TOTAL_POUNDAGE>\n");
							bufferedWriter.write("		<TOTAL_DEAL_RECEIPT>"
									+ totalRcptQtt + "</TOTAL_DEAL_RECEIPT>\n");
							bufferedWriter.write("    </total>\n");
							bufferedWriter.write("	 </body>\n");
							bufferedWriter.write("</root>\n");

							bufferedWriter.flush();
							fileWriter.flush();
							bufferedWriter.close();
							fileWriter.close();
						}

						fileName = assocDir + assoRemark + dayDir + assoRemark
								+ "_" + curMonth + "_MDD.xml";
						fileWriter = new FileWriter(fileName);
						bufferedWriter = new BufferedWriter(fileWriter); // 下一会员

						bufferedWriter
								.write("<?xml version=\"1.0\" encoding=\"GBK\"?>\n");
						bufferedWriter.write("<root>\n");
						bufferedWriter.write("	 <file_title>会员交易明细月报表:"
								+ curMonth + "_" + assoRemark
								+ "_MDD</file_title>\n");
						bufferedWriter
								.write("	 <report_name>会员交易明细月报表</report_name>\n");
						bufferedWriter.write("	 <top>\n");
						bufferedWriter.write("		<item>\n");

						bufferedWriter.write("			<content>" + assoRemark
								+ "</content>\n");
						bufferedWriter.write("		</item>\n");
						bufferedWriter.write("		<item>\n");

						bufferedWriter.write("			<content>"
								+ associatorInfoMap.get(associatorNo)
										.getFullName() + "</content>\n");
						bufferedWriter.write("		</item>\n");
						bufferedWriter.write("		<item>\n");

						bufferedWriter.write("			<content>" + statMonth
								+ "</content>\n");
						bufferedWriter.write("		</item>\n");
						bufferedWriter.write("	 </top>\n");

						bufferedWriter.write("	 <body>\n");

						lastAssocNo = associatorNo;
						assocSeq = 1;
						totalDealQtt = 0;
						totalRcptQtt = 0;
						totalPoundage = 0;
						totalCnyInCome = 0;

					}

					// 序号, 客户编码, 客户名称, 合同编码, 买/卖, 类型, 订货价格, 成交价格, 成交数量(吨),
					// 转让收入, 交易手续费, 成交仓单量(吨), 成交时间, 委托时间, 成交单号, 委托单号
					bufferedWriter.write("	  <item>\n");
					bufferedWriter.write("		<SEQ>" + assocSeq + "</SEQ>\n");
					bufferedWriter.write("		<CLIENT_ID>" + assoRemark
							+ "</CLIENT_ID>\n");
					bufferedWriter.write("		<CLIENT_NAME>"
							+ clientMap.get(clientId) + "</CLIENT_NAME>\n");
					bufferedWriter.write("		<CONTRACT_ID>" + contractId
							+ "</CONTRACT_ID>\n");
					bufferedWriter.write("		<BUYORSELL>" + buyOrSell
							+ "</BUYORSELL>\n");
					bufferedWriter.write("		<DEAL_TYPE>" + dealType
							+ "</DEAL_TYPE>\n");
					bufferedWriter.write("		<SUBS_PRICE>"
							+ Converter.formatFen2yuan(Converter
									.reversePriceByRate(newPrice, rate))
							+ "</SUBS_PRICE>\n");
					bufferedWriter.write("		<DEAL_PRICE>"
							+ Converter.formatFen2yuan(Converter
									.reversePriceByRate(dealPrice, rate))
							+ "</DEAL_PRICE>\n");
					bufferedWriter.write("		<DEAL_QTT>" + dealQtt
							+ "</DEAL_QTT>\n");
					bufferedWriter.write("		<CNY_INCOME>"
							+ Converter.formatFen2yuan(cnyInCome)
							+ "</CNY_INCOME>\n");
					bufferedWriter.write("		<POUNDAGE>"
							+ Converter.formatFen2yuan(poundage)
							+ "</POUNDAGE>\n");
					bufferedWriter.write("		<DEAL_RECEIPT>" + dealReceipt
							+ "</DEAL_RECEIPT>\n");
					bufferedWriter.write("		<DEAL_TIME>" + dealTime
							+ "</DEAL_TIME>\n");
					bufferedWriter.write("		<ORDER_TIME>" + orderTime
							+ "</ORDER_TIME>\n");
					bufferedWriter.write("		<DEAL_NO>" + dealNo
							+ "</DEAL_NO>\n");
					bufferedWriter.write("		<ORDER_NO>" + orderNo
							+ "</ORDER_NO>\n");
					bufferedWriter.write("	  </item>\n");

					assocSeq++;
					totalDealQtt += dealQtt;
					totalRcptQtt += dealReceipt;
					totalPoundage += poundage;
					totalCnyInCome += cnyInCome;

					if (i % 500 == 0) {
						fileWriter.flush();
						bufferedWriter.flush();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		};
		sqlMapClient.queryWithRowHandler(
				"sel_settlesrvRpt_dealDate_T_DEAL_HIST", map, handler);
		handler.handleRow(null);

		return RetDefine.pub_success;
	}

	private String[] doContractList() throws Exception {
		logger.info("生成交易中心合同清单...");
		FileWriter fileWriter = null;
		BufferedWriter bufferedWriter = null;
		long totalSubsQtt = 0;
		long totalRcptQtt = 0;
		long totalDealQtt = 0;
		long totalCnyQtt = 0;
		long totalSubsBalance = 0;
		long totalDpstBalance = 0;
		long totalHistCnyBalance = 0;
		long totalBalance = 0;
		long totalCnyBalance = 0;
		long totalCsgIncome = 0;
		long totalDealAmt = 0;
		long totalPoundage = 0;
		long totalDpstAmt = 0;
		long totalMonthQtt = 0;
		long totalMonthAmt = 0;
		long totalMonthPoundage = 0;

		ResultMap map = new ResultMap();
		ResultMap retMap = new ResultMap();
		map.put("settleDay", settleDay);
		List<ResultMap> infoList = new ArrayList<ResultMap>();
		List<ResultMap> list = sqlMapClient.queryForList(
				"sel_settlesrv_ContractInfo_T_Contract_F_S_C", map);
		for (int i = 0; i < list.size(); i++) {
			long subsQtt = 0;
			long frzDpstAmt = 0;
			long subsRcptQtt = 0;
			long dpstBalance = 0;
			long subsBalance = 0;
			long dealAmt = 0;
			long dealQtt = 0;
			long poundage = 0;
			long cnyBalance = 0;
			long balance = 0;
			long cnyQtt = 0;
			long monthDealAmt = 0;
			long monthDealQtt = 0;
			long monthPoundage = 0;
			long histCnyBalance = 0;
			long csgIncome = 0;
			map = list.get(i);
			String contractId = map.getString("CONTRACT_id", "");
			String tradeModeId = map.getString("TRADE_MODE_ID", "");
			map.put("settleDay", settleDay);

			if (fileWriter == null) {
				fileName = centerDir + settleDay + "_ZXHT.xml";
				fileWriter = new FileWriter(fileName);
				bufferedWriter = new BufferedWriter(fileWriter);
				bufferedWriter
						.write("<?xml version=\"1.0\" encoding=\"GBK\"?>\n");
				bufferedWriter.write("<root>\n");
				bufferedWriter.write("	 <file_title>交易中心合同清单:" + settleDay
						+ "_ZXHT</file_title>\n");
				bufferedWriter.write("	 <report_name>交易中心合同清单</report_name>\n");
				bufferedWriter.write("	 <top>\n");
				bufferedWriter.write("		<item>\n");

				bufferedWriter.write("			<content>" + statDay + "</content>\n");
				bufferedWriter.write("		</item>\n");
				bufferedWriter.write("	 </top>\n");
				bufferedWriter.write("	 <body>\n");
			}

			if ("F".equals(tradeModeId)) {
				map.put("settle_Price", contractInfoMap.get(contractId)
						.getSettlePrice());
				// 根据订货记录获得: 总订货量,仓单卖出量,帐面价差,实际帐面价差,保证金金额
				infoList.clear();
				infoList = sqlMapClient.queryForList(
						"sel_settlesrvRpt_contSubs_t_subs_f", map);
				if (infoList == null || infoList.isEmpty()) {
					return RetDefine.settlesrv_queryObjectIsNull;
				}
				retMap.clear();
				retMap = infoList.get(0);
				subsQtt = retMap.getLong("total_qtt", 0) / 2;
				frzDpstAmt = retMap.getLong("frz_dpst_amt", 0);
				subsRcptQtt = retMap.getLong("subs_rcpt_qtt", 0);
				dpstBalance = retMap.getLong("dpst_balance", 0);
				subsBalance = retMap.getLong("subs_balance", 0);
				// 根据凭证表获得交收盈亏
				csgIncome = Converter.glong(sqlMapClient.queryForObject(
						"Sel_settlesrvRpt_csgIncome_t_voucher_detail", map));
				// 价差＝当日转让价差＋历史转让价差＋交收价差
				balance = Converter.glong(sqlMapClient.queryForObject(
						"Sel_settlesrvRpt_balance_t_voucher_detail", map));

				// 根据成交表获得历史转让价差
				infoList.clear();
				map.put("flag", "hist");
				infoList = sqlMapClient.queryForList(
						"sel_settlesrvRpt_dealinfo_t_deal_f_hist", map);
				if (infoList == null || infoList.isEmpty()) {
					return RetDefine.settlesrv_queryObjectIsNull;
				}
				histCnyBalance = infoList.get(0).getLong("cny_balance");

				// 根据成交表获得:当日成交金额, 当日成交量, 当日手续费, 转让价差, 转让数量
				infoList.clear();
				map.put("flag", "today");
				infoList = sqlMapClient.queryForList(
						"sel_settlesrvRpt_dealinfo_t_deal_f_hist", map);
				if (infoList == null || infoList.isEmpty()) {
					return RetDefine.settlesrv_queryObjectIsNull;
				}
				retMap.clear();
				retMap = infoList.get(0);
				dealAmt = retMap.getLong("deal_amt", 0);
				dealQtt = retMap.getLong("deal_qtt", 0);
				poundage = retMap.getLong("poundage", 0);
				cnyBalance = retMap.getLong("cny_balance", 0);
				cnyQtt = retMap.getLong("cny_qtt", 0);

				// 根据成交表获得: 月累计成交金额, 月累计成交量, 月累计手续费
				infoList.clear();
				map.put("flag", "month");
				map.put("monthBeginDay", monthBeginDay);
				infoList = sqlMapClient.queryForList(
						"sel_settlesrvRpt_dealinfo_t_deal_f_hist", map);
				if (infoList == null || infoList.isEmpty()) {
					return RetDefine.settlesrv_queryObjectIsNull;
				}
				retMap.clear();
				retMap = infoList.get(0);
				monthDealAmt = retMap.getLong("deal_amt", 0);
				monthDealQtt = retMap.getLong("deal_qtt", 0);
				monthPoundage = retMap.getLong("poundage", 0);
				bufferedWriter.write("	 <item>\n");
				bufferedWriter.write("		<SETTLE_PRICE>"
						+ Converter.formatFen2yuan(Converter
								.convertPriceByRate(contractInfoMap.get(
										contractId).getSettlePrice(), rate))
						+ "</SETTLE_PRICE>\n");
				bufferedWriter.write("		<SUBS_BALANCE>"
						+ Converter.formatFen2yuan(subsBalance)
						+ "</SUBS_BALANCE>\n");
				bufferedWriter.write("		<DPST_BALANCE>"
						+ Converter.formatFen2yuan(dpstBalance)
						+ "</DPST_BALANCE>\n");
				bufferedWriter.write("		<CNY_QTT>" + cnyQtt + "</CNY_QTT>\n");
				bufferedWriter.write("		<CNY_BALANCE>"
						+ Converter.formatFen2yuan(cnyBalance)
						+ "</CNY_BALANCE>\n");
				bufferedWriter.write("		<HIST_CNY_BALANCE>"
						+ Converter.formatFen2yuan(histCnyBalance)
						+ "</HIST_CNY_BALANCE>\n");
				bufferedWriter.write("		<CSG_INCOME>"
						+ Converter.formatFen2yuan(csgIncome)
						+ "</CSG_INCOME>\n");
				bufferedWriter.write("		<BALANCE>"
						+ Converter.formatFen2yuan(balance) + "</BALANCE>\n");
			} else {
				// 根据订货记录获得: 总订货量,仓单卖出量,帐面价差,实际帐面价差,保证金金额
				infoList.clear();
				infoList = sqlMapClient.queryForList(
						"sel_settlesrvRpt_contSubs_t_subs_s_c_detail", map);
				if (infoList == null || infoList.isEmpty()) {
					return RetDefine.settlesrv_queryObjectIsNull;
				}
				retMap.clear();
				retMap = infoList.get(0);
				subsQtt = retMap.getLong("total_qtt", 0) / 2;
				frzDpstAmt = retMap.getLong("frz_dpst_amt", 0);
				subsRcptQtt = retMap.getLong("subs_rcpt_qtt", 0);

				// 根据成交表获得:当日成交金额, 当日成交量, 当日手续费
				infoList.clear();
				map.put("flag", "today");
				infoList = sqlMapClient.queryForList(
						"sel_settlesrvRpt_dealinfo_t_deal_s_c_hist", map);
				if (infoList == null || infoList.isEmpty()) {
					return RetDefine.settlesrv_queryObjectIsNull;
				}
				retMap.clear();
				retMap = infoList.get(0);
				dealAmt = retMap.getLong("deal_amt", 0);
				dealQtt = retMap.getLong("deal_qtt", 0);
				poundage = retMap.getLong("poundage", 0);

				// 根据成交表获得: 月累计成交金额, 月累计成交量, 月累计手续费
				infoList.clear();
				map.put("flag", "month");
				map.put("monthBeginDay", monthBeginDay);
				infoList = sqlMapClient.queryForList(
						"sel_settlesrvRpt_dealinfo_t_deal_s_c_hist", map);
				if (infoList == null || infoList.isEmpty()) {
					return RetDefine.settlesrv_queryObjectIsNull;
				}
				retMap.clear();
				retMap = infoList.get(0);
				monthDealAmt = retMap.getLong("deal_amt", 0);
				monthDealQtt = retMap.getLong("deal_qtt", 0);
				monthPoundage = retMap.getLong("poundage", 0);

				bufferedWriter.write("	 <item>\n");
				bufferedWriter.write("		<SETTLE_PRICE>--</SETTLE_PRICE>\n");
				bufferedWriter.write("		<SUBS_BALANCE>--</SUBS_BALANCE>\n");
				bufferedWriter.write("		<DPST_BALANCE>--</DPST_BALANCE>\n");
				bufferedWriter.write("		<CNY_QTT>--</CNY_QTT>\n");
				bufferedWriter.write("		<CNY_BALANCE>--</CNY_BALANCE>\n");
				bufferedWriter
						.write("		<HIST_CNY_BALANCE>--</HIST_CNY_BALANCE>\n");
				bufferedWriter.write("		<CSG_INCOME>--</CSG_INCOME>\n");
				bufferedWriter.write("		<BALANCE>--</BALANCE>\n");
			}
			bufferedWriter.write("		<TRADE_MODE_ID>" + tradeModeId
					+ "</TRADE_MODE_ID>\n");
			bufferedWriter.write("		<CONTRACT_ID>" + contractId
					+ "</CONTRACT_ID>\n");
			bufferedWriter
					.write("		<CONTRACT_NAME>"
							+ map.getString("CONTRACT_NAME", "")
							+ "</CONTRACT_NAME>\n");
			bufferedWriter.write("		<SUBS_QTT>" + subsQtt + "</SUBS_QTT>\n");
			bufferedWriter.write("		<SUBS_RCPT_QTT>" + subsRcptQtt
					+ "</SUBS_RCPT_QTT>\n");
			bufferedWriter.write("		<DEAL_QTT>" + dealQtt + "</DEAL_QTT>\n");
			bufferedWriter.write("		<DEAL_AMT>"
					+ Converter.formatFen2yuan(dealAmt) + "</DEAL_AMT>\n");
			bufferedWriter.write("		<POUNDAGE>"
					+ Converter.formatFen2yuan(poundage) + "</POUNDAGE>\n");
			bufferedWriter.write("		<MONTH_DEAL_QTT>" + monthDealQtt
					+ "</MONTH_DEAL_QTT>\n");
			bufferedWriter.write("		<MONTH_DEAL_AMT>"
					+ Converter.formatFen2yuan(monthDealAmt)
					+ "</MONTH_DEAL_AMT>\n");
			bufferedWriter.write("		<MONTH_POUNDAGE>"
					+ Converter.formatFen2yuan(monthPoundage)
					+ "</MONTH_POUNDAGE>\n");
			bufferedWriter.write("		<DPST_AMT>"
					+ Converter.formatFen2yuan(frzDpstAmt) + "</DPST_AMT>\n");
			bufferedWriter.write("	 </item>\n");

			totalHistCnyBalance += histCnyBalance;
			totalSubsQtt += subsQtt;
			totalRcptQtt += subsRcptQtt;
			totalDpstAmt += frzDpstAmt;
			totalDpstBalance += dpstBalance;
			totalSubsBalance += subsBalance;
			totalCsgIncome += csgIncome;
			totalBalance += balance;
			totalCnyQtt += cnyQtt;
			totalDealAmt += dealAmt;
			totalDealQtt += dealQtt;
			totalPoundage += poundage;
			totalMonthAmt += monthDealAmt;
			totalMonthPoundage += monthPoundage;
			totalMonthQtt += monthDealQtt;
			totalCnyBalance += cnyBalance;
		}
		if (fileWriter != null) {
			bufferedWriter.write("	 <total>\n");
			bufferedWriter.write("		<TOTAL_SUBS_BALANCE>"
					+ Converter.formatFen2yuan(totalSubsBalance)
					+ "</TOTAL_SUBS_BALANCE>\n");
			bufferedWriter.write("		<TOTAL_DPST_BALANCE>"
					+ Converter.formatFen2yuan(totalDpstBalance)
					+ "</TOTAL_DPST_BALANCE>\n");
			bufferedWriter.write("		<TOTAL_CNY_QTT>" + totalCnyQtt
					+ "</TOTAL_CNY_QTT>\n");
			bufferedWriter.write("		<TOTAL_CNY_BALANCE>"
					+ Converter.formatFen2yuan(totalCnyBalance)
					+ "</TOTAL_CNY_BALANCE>\n");
			bufferedWriter.write("		<TOTAL_HIST_CNY_BALANCE>"
					+ Converter.formatFen2yuan(totalHistCnyBalance)
					+ "</TOTAL_HIST_CNY_BALANCE>\n");
			bufferedWriter.write("		<TOTAL_CSG_INCOME>"
					+ Converter.formatFen2yuan(totalCsgIncome)
					+ "</TOTAL_CSG_INCOME>\n");
			bufferedWriter.write("		<TOTAL_BALANCE>"
					+ Converter.formatFen2yuan(totalBalance)
					+ "</TOTAL_BALANCE>\n");

			bufferedWriter.write("		<TOTAL_SUBS_QTT>" + totalSubsQtt
					+ "</TOTAL_SUBS_QTT>\n");
			bufferedWriter.write("		<TOTAL_SUBS_RCPT_QTT>" + totalRcptQtt
					+ "</TOTAL_SUBS_RCPT_QTT>\n");
			bufferedWriter.write("		<TOTAL_DEAL_QTT>" + totalDealQtt
					+ "</TOTAL_DEAL_QTT>\n");
			bufferedWriter.write("		<TOTAL_DEAL_AMT>"
					+ Converter.formatFen2yuan(totalDealAmt)
					+ "</TOTAL_DEAL_AMT>\n");
			bufferedWriter.write("		<TOTAL_POUNDAGE>"
					+ Converter.formatFen2yuan(totalPoundage)
					+ "</TOTAL_POUNDAGE>\n");
			bufferedWriter.write("		<TOTAL_MONTH_DEAL_QTT>" + totalMonthQtt
					+ "</TOTAL_MONTH_DEAL_QTT>\n");
			bufferedWriter.write("		<TOTAL_MONTH_DEAL_AMT>"
					+ Converter.formatFen2yuan(totalMonthAmt)
					+ "</TOTAL_MONTH_DEAL_AMT>\n");
			bufferedWriter.write("		<TOTAL_MONTH_POUNDAGE>"
					+ Converter.formatFen2yuan(totalMonthPoundage)
					+ "</TOTAL_MONTH_POUNDAGE>\n");
			bufferedWriter.write("		<TOTAL_DPST_AMT>"
					+ Converter.formatFen2yuan(totalDpstAmt)
					+ "</TOTAL_DPST_AMT>\n");
			bufferedWriter.write("	 </total>\n");
			bufferedWriter.write("	 </body>\n");
			bufferedWriter.write("</root>\n");
			bufferedWriter.flush();
			fileWriter.flush();
			bufferedWriter.close();
			fileWriter.close();
		}

		return RetDefine.pub_success;
	}

	private String[] doMonthPoundage() throws Exception {
		logger.info("生成交易中心月手续费清单...");

		Document centerDoc = PubTools.getDocument();
		Element root = centerDoc.createElement("root");
		centerDoc.appendChild(root);
		root.setAttribute("file_title", settleDay + "_JSHK");
		root.setAttribute("report_name", "交易中心月手续费清单");
		root.setAttribute("statDay", statDay);
		root.setAttribute("settle_day", settleDay);
		Element items = centerDoc.createElement("items");
		root.appendChild(items);

		String date = getFirstTradeDayOfMonth(monthBeginDay);
		RetObject retObj = new RetObject();
		String[] ret = tradeUtil.getNTradeDay(date, 1, retObj);
		if (!ret[0].equals(RetDefine.pub_success[0])) {
			logger.error("没有找到当前交易日");
			throw new Exception(RetDefine.pub_getNextTradingDayFailed[1]);
		}
		String beginDay = retObj.getRetString();

		ResultMap map = new ResultMap();
		map.put("beginDay", beginDay);
		map.put("endDay", nextSettleDay);
		List list = sqlMapClient.queryForList(
				"sel_settlesrvRpt_month_poundage", map);
		for (int i = 0; i < list.size(); i++) {
			ResultMap resultMap = (ResultMap) list.get(i);
			long poundage = resultMap.getLong("poundage", 0);
			while (poundage > 99999999) {
				long amt = 80000000;
				poundage -= amt;
				String amt2 = StringUtil.convertChinese(Math.abs(amt / 100));
				Element item = centerDoc.createElement("item");
				items.appendChild(item);

				Iterator itr = resultMap.keySet().iterator();
				while (itr.hasNext()) {
					String key = (String) itr.next();
					String value = Converter.gstring(resultMap.get(key));
					Element tmp = centerDoc.createElement(key);
					tmp.setTextContent(Converter.gstring(value));
					item.appendChild(tmp);
				}
				Element tmp = centerDoc.createElement("amt");
				tmp.setTextContent(amt + "");
				item.appendChild(tmp);

				tmp = centerDoc.createElement("amt2");
				tmp.setTextContent(amt2);
				item.appendChild(tmp);
			}
			String amt2 = StringUtil.convertChinese(Math
					.abs(poundage * 1.0d / 100));
			amt2 = amt2.replaceAll("角$", "角整");
			if (poundage < 0)
				amt2 = "负" + amt2;
			Element item = centerDoc.createElement("item");
			items.appendChild(item);
			Iterator itr = resultMap.keySet().iterator();
			while (itr.hasNext()) {
				String key = (String) itr.next();
				String value = Converter.gstring(resultMap.get(key));
				Element tmp = centerDoc.createElement(key);
				tmp.setTextContent(Converter.gstring(value));
				item.appendChild(tmp);
			}
			Element tmp = centerDoc.createElement("amt");
			tmp.setTextContent(poundage + "");
			item.appendChild(tmp);

			tmp = centerDoc.createElement("amt2");
			tmp.setTextContent(amt2);
			item.appendChild(tmp);
		}
		fileName = centerDir + settleDay + "_YSXF.xml";
		dom = new DOMSource(centerDoc);
		result = new StreamResult(new File(fileName));
		trans = TransformerFactory.newInstance().newTransformer();
		trans.transform(dom, result);

		return RetDefine.pub_success;
	}

	/**
	 * 生成交收申报报单
	 * 
	 * @return
	 * @throws Exception
	 * 
	 * suntao 20091030
	 */
	private String[] doCsgOrderList() throws Exception {
		logger.info("生成交收申报报单...");

		Document centerDoc = PubTools.getDocument();
		Element root = centerDoc.createElement("root");
		centerDoc.appendChild(root);
		root.setAttribute("file_title", settleDay + "_JSSB");
		root.setAttribute("report_name", "交易中心交收申报报单（含代替交收申报单）");
		root.setAttribute("statDay", statDay);
		root.setAttribute("settle_day", settleDay);
		Element el = centerDoc.createElement("settle_day");
		el.setTextContent(statDay);
		root.appendChild(el);
		Element items = centerDoc.createElement("items");
		root.appendChild(items);

		CsgOrderFDAOImpl csgOrderFDAOImpl = new CsgOrderFDAOImpl(sqlMapClient);
		CsgOrderFExample csgOrderFExample = new CsgOrderFExample();
		csgOrderFExample.setSettleDay(settleDay);
		csgOrderFExample
				.setSettleDay_Indicator(CsgOrderFExample.EXAMPLE_EQUALS);
		List list = csgOrderFDAOImpl.selectByExample(csgOrderFExample,
				" CLIENT_ID,ORDER_NO ");
		int listCount = list.size();

		String associatorNo = null;
		Document assoDoc = null;
		Element assoItems = null;
		Element assoItem = null;

		for (int i = 0; i < listCount; i++) {
			CsgOrderF csgOrderF = (CsgOrderF) list.get(i);

			/* 中心报表 */
			Element item = centerDoc.createElement("item");
			items.appendChild(item);

			Element tmp = centerDoc.createElement("ORDER_NO");
			tmp.setTextContent(csgOrderF.getOrderNo());
			item.appendChild(tmp);
			tmp = centerDoc.createElement("CONTRACT_ID");
			tmp.setTextContent(csgOrderF.getContractId());
			item.appendChild(tmp);
			tmp = centerDoc.createElement("CLIENT_ID");
			String assoRemark = associatorInfoMap.get(csgOrderF.getClientId())
					.getRemarak();
			tmp.setTextContent(assoRemark);
			item.appendChild(tmp);
			tmp = centerDoc.createElement("CLIENT_NAME");
			tmp.setTextContent(clientMap.get(csgOrderF.getClientId()));
			item.appendChild(tmp);
			tmp = centerDoc.createElement("BUYORSELL");
			tmp.setTextContent(csgOrderF.getBuyorsell());
			item.appendChild(tmp);
			tmp = centerDoc.createElement("ORDER_TYPE");
			tmp.setTextContent(csgOrderF.getOrderType());
			item.appendChild(tmp);
			tmp = centerDoc.createElement("IS_DEPOSIT");
			tmp.setTextContent(csgOrderF.getIsDeposit() + "");
			item.appendChild(tmp);
			tmp = centerDoc.createElement("ORDER_PRICE");
			tmp.setTextContent(Converter.formatFen2yuan(csgOrderF
					.getOrderPrice()));
			item.appendChild(tmp);
			tmp = centerDoc.createElement("ORDER_QTT");
			tmp.setTextContent(csgOrderF.getOrderQtt() + "");
			item.appendChild(tmp);
			tmp = centerDoc.createElement("LEFT_QTT_DPST");
			tmp.setTextContent(csgOrderF.getLeftQttDpst() + "");
			item.appendChild(tmp);
			tmp = centerDoc.createElement("LEFT_QTT_RCPT");
			tmp.setTextContent(csgOrderF.getLeftQttRcpt() + "");
			item.appendChild(tmp);
			tmp = centerDoc.createElement("OPERATOR_NO");
			tmp.setTextContent(csgOrderF.getOperatorNo());
			item.appendChild(tmp);
			tmp = centerDoc.createElement("ORDER_TIME");
			tmp.setTextContent(DateUtil.format(csgOrderF.getOrderTime(),
					"yyyy-MM-dd HH:mm:ss"));
			item.appendChild(tmp);
			tmp = centerDoc.createElement("ORDER_IP");
			tmp.setTextContent(csgOrderF.getOrderIp());
			item.appendChild(tmp);
			tmp = centerDoc.createElement("STATUS");
			tmp.setTextContent(csgOrderF.getStatus());
			item.appendChild(tmp);
			tmp = centerDoc.createElement("CANCEL_OPER");
			tmp.setTextContent(csgOrderF.getCancelOper());
			item.appendChild(tmp);
			tmp = centerDoc.createElement("CANCEL_TIME");
			if (csgOrderF.getCancelTime() != null)
				tmp.setTextContent(DateUtil.format(csgOrderF.getCancelTime(),
						"yyyy-MM-dd HH:mm:ss"));
			else
				tmp.setTextContent("");
			item.appendChild(tmp);
			tmp = centerDoc.createElement("CANCEL_IP");
			tmp.setTextContent(csgOrderF.getCancelIp());
			item.appendChild(tmp);
			tmp = centerDoc.createElement("U_ID");
			tmp.setTextContent(csgOrderF.getUId());
			item.appendChild(tmp);
			tmp = centerDoc.createElement("SETTLE_DAY");
			tmp.setTextContent(csgOrderF.getSettleDay());
			item.appendChild(tmp);
			tmp = centerDoc.createElement("BENEFIT_QTT");
			tmp.setTextContent(csgOrderF.getBenefitQtt() + "");
			item.appendChild(tmp);
			tmp = centerDoc.createElement("MATCHING_QTT");
			tmp.setTextContent(csgOrderF.getMatchingQtt() + "");
			item.appendChild(tmp);
			tmp = centerDoc.createElement("DISOBEY_QTT");
			tmp.setTextContent(csgOrderF.getDisobeyQtt() + "");
			item.appendChild(tmp);

			/* 会员报表 */
			String associatorCurrRecord = StringUtil.subStrToStart(csgOrderF
					.getClientId(), 6);
			if (!associatorCurrRecord.equals(associatorNo)) {
				if (assoDoc != null) {
					logger.info("生成交收申报报单...2");
					fileName = assocDir + assoRemark + dayDir + assoRemark
							+ "_" + settleDay + "_JSSB.xml";
					dom = new DOMSource(assoDoc);
					result = new StreamResult(new File(fileName));
					trans = TransformerFactory.newInstance().newTransformer();
					trans.transform(dom, result);
				}
				assoDoc = PubTools.getDocument();
				Element assoRoot = assoDoc.createElement("root");
				assoDoc.appendChild(assoRoot);
				assoRoot.setAttribute("file_title", settleDay
						+ associatorCurrRecord + "_JSSB");
				assoRoot.setAttribute("report_name", "交收申报报单（含代替交收申报单）");
				assoRoot.setAttribute("statDay", statDay);
				assoRoot.setAttribute("settle_day", settleDay);
				Element assoEl = assoDoc.createElement("settle_day");
				assoEl.setTextContent(statDay);
				assoRoot.appendChild(assoEl);

				assoItems = assoDoc.createElement("items");
				assoRoot.appendChild(assoItems);

				associatorNo = associatorCurrRecord;
			}

			assoItem = assoDoc.createElement("item");
			assoItems.appendChild(assoItem);

			Element assoTmp = assoDoc.createElement("ORDER_NO");
			assoTmp.setTextContent(csgOrderF.getOrderNo());
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("CONTRACT_ID");
			assoTmp.setTextContent(csgOrderF.getContractId());
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("CLIENT_ID");
			assoTmp.setTextContent(assoRemark);
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("CLIENT_NAME");
			assoTmp.setTextContent(clientMap.get(csgOrderF.getClientId()));
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("BUYORSELL");
			assoTmp.setTextContent(csgOrderF.getBuyorsell());
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("ORDER_TYPE");
			assoTmp.setTextContent(csgOrderF.getOrderType());
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("IS_DEPOSIT");
			assoTmp.setTextContent(csgOrderF.getIsDeposit() + "");
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("ORDER_PRICE");
			assoTmp.setTextContent(Converter.formatFen2yuan(csgOrderF
					.getOrderPrice()));
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("ORDER_QTT");
			assoTmp.setTextContent(csgOrderF.getOrderQtt() + "");
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("LEFT_QTT_DPST");
			assoTmp.setTextContent(csgOrderF.getLeftQttDpst() + "");
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("LEFT_QTT_RCPT");
			assoTmp.setTextContent(csgOrderF.getLeftQttRcpt() + "");
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("OPERATOR_NO");
			assoTmp.setTextContent(csgOrderF.getOperatorNo());
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("ORDER_TIME");
			assoTmp.setTextContent(DateUtil.format(csgOrderF.getOrderTime(),
					"yyyy-MM-dd HH:mm:ss"));
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("ORDER_IP");
			assoTmp.setTextContent(csgOrderF.getOrderIp());
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("STATUS");
			assoTmp.setTextContent(csgOrderF.getStatus());
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("CANCEL_OPER");
			assoTmp.setTextContent(csgOrderF.getCancelOper());
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("CANCEL_TIME");
			if (csgOrderF.getCancelTime() != null)
				assoTmp.setTextContent(DateUtil.format(csgOrderF
						.getCancelTime(), "yyyy-MM-dd HH:mm:ss"));
			else
				assoTmp.setTextContent("");
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("CANCEL_IP");
			assoTmp.setTextContent(csgOrderF.getCancelIp());
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("U_ID");
			assoTmp.setTextContent(csgOrderF.getUId());
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("SETTLE_DAY");
			assoTmp.setTextContent(csgOrderF.getSettleDay());
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("BENEFIT_QTT");
			assoTmp.setTextContent(csgOrderF.getBenefitQtt() + "");
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("MATCHING_QTT");
			assoTmp.setTextContent(csgOrderF.getMatchingQtt() + "");
			assoItem.appendChild(assoTmp);
			assoTmp = assoDoc.createElement("DISOBEY_QTT");
			assoTmp.setTextContent(csgOrderF.getDisobeyQtt() + "");
			assoItem.appendChild(assoTmp);
		}

		if (assoDoc != null) {
			String assoRemark = associatorInfoMap.get(associatorNo)
					.getRemarak();
			fileName = assocDir + assoRemark + dayDir + assoRemark + "_"
					+ settleDay + "_JSSB.xml";
			dom = new DOMSource(assoDoc);
			result = new StreamResult(new File(fileName));
			trans = TransformerFactory.newInstance().newTransformer();
			trans.transform(dom, result);
		}

		fileName = centerDir + settleDay + "_JSSB.xml";
		dom = new DOMSource(centerDoc);
		result = new StreamResult(new File(fileName));
		trans = TransformerFactory.newInstance().newTransformer();
		trans.transform(dom, result);

		return RetDefine.pub_success;
	}

	private String getFirstTradeDayOfMonth(String monthBeginDay)
			throws Exception {
		TradingDaysExample tradingDaysExample = new TradingDaysExample();
		tradingDaysExample.setTradingDay(monthBeginDay);
		tradingDaysExample
				.setTradingDay_Indicator(TradingDaysExample.EXAMPLE_GREATER_THAN_OR_EQUAL);
		TradingDaysDAOImpl tradingDaysDAOImpl = new TradingDaysDAOImpl(
				sqlMapClient);
		// 查询出来的时间按升序排列
		List list = tradingDaysDAOImpl.selectByExample(tradingDaysExample,
				" trading_day asc");
		if (list.size() > 0) {
			TradingDays tradingDays = (TradingDays) list.get(0);
			return tradingDays.getTradingDay();
		} else {
			throw new Exception(RetDefine.pub_getNextTradingDayFailed[1]);
		}
	}

	/**
	 * 执行生成所有XML报表
	 * 
	 * @return
	 * @throws Exception
	 */
	private String[] doXmlReports() throws Exception {
		String retStr[];
		retStr = doMorbidReport();
		if (!retStr[0].equals(RetDefine.pub_success[0])) {
			logger.error(retStr[1]);
			return retStr;
		}
		logger.info("病态会员清单生成了...");

		retStr = doContractList();
		if (!retStr[0].equals(RetDefine.pub_success[0])) {
			logger.error(retStr[1]);
			return retStr;
		}
		logger.info("交易中心合同清单生成了...");
//      时力原有报表  款项收付清单  wangl屏蔽 2015/08/28
//		retStr = doAccountList();
//		if (!retStr[0].equals(RetDefine.pub_success[0])) {
//			logger.error(retStr[1]);
//			return retStr;
//		}
//		logger.info("会员／中心款项清单生成了...");

		// JIRA - HTS-276 - 这张账单要取消，使用库存日报代替。
		// 2015-5-28-by-yangtz
		// retStr = doReceiptList();
		// if (!retStr[0].equals(RetDefine.pub_success[0]))
		// {
		// logger.error(retStr[1]);
		// return retStr;
		// }
		// logger.info("会员／中心仓单清单生成了...");

		retStr = doOrderList();
		if (!retStr[0].equals(RetDefine.pub_success[0])) {
			logger.error(retStr[1]);
			return retStr;
		}
		logger.info("会员／中心委托单生成了...");
//   交易商合同清单 徐屏蔽 成交报表代替  wangl  2015/08/27
//		retStr = doTradeList();
//		if (!retStr[0].equals(RetDefine.pub_success[0])) {
//			logger.error(retStr[1]);
//			return retStr;
//		}
//		logger.info("会员／中心交易清单生成了...");

//		retStr = doSubsDetailList();
//		if (!retStr[0].equals(RetDefine.pub_success[0])) {
//			logger.error(retStr[1]);
//			return retStr;
//		}
//		logger.info("会员／中心定货明细清单生成了...");

//		retStr = doSubsList();
//		if (!retStr[0].equals(RetDefine.pub_success[0])) {
//			logger.error(retStr[1]);
//			return retStr;
//		}
//		logger.info("交易中心/会员的定货清单及中心合同汇总清单生成了...");

//		retStr = doConsignList();
//		if (!retStr[0].equals(RetDefine.pub_success[0])) {
//			logger.error(retStr[1]);
//			return retStr;
//		}
//		logger.info("交易中心/会员的交收清单生成了...");

		retStr = doPaymentFinishList();
		if (!retStr[0].equals(RetDefine.pub_success[0])) {
			logger.error(retStr[1]);
			return retStr;
		}
		logger.info("交易中心/会员的货款了结清单生成了...");

		retStr = doMonthKxList();
		if (!retStr[0].equals(RetDefine.pub_success[0])) {
			logger.error(retStr[1]);
			return retStr;
		}
		logger.info("中心月款项清单生成了...");

		retStr = doMonthPoundage();
		if (!retStr[0].equals(RetDefine.pub_success[0])) {
			logger.error(retStr[1]);
			return retStr;
		}
		logger.info("交易中心月手续费清单生成了......");

		// 月末生成月款项清单
		if (!curMonth.equals(nextSettleDay.substring(0, 6))) {
//          交收申报月报表屏蔽  by wangl    重新做
//			retStr = doMonthConsignList();
//			if (!retStr[0].equals(RetDefine.pub_success[0])) {
//				logger.error(retStr[1]);
//				return retStr;
//			}
//			logger.info("会员月交收清单生成了...");

			// 学习网数据大，不做月交易数据
			if (!SettleUtil.IS_XXW) {
				/*
				 * retStr = doMonthDealList(); if
				 * (!retStr[0].equals(RetDefine.pub_success[0])) {
				 * logger.error(retStr[1]); return retStr; }
				 * logger.info("会员月交易清单生成了......");
				 */
			}

			retStr = doMonthInOutList();
			if (!retStr[0].equals(RetDefine.pub_success[0])) {
				logger.error(retStr[1]);
				return retStr;
			}
			logger.info("会员月出入金清单生成了......");

			//会员款项月报表  wangl屏蔽 
//			retStr = doMonthSettleList();
//			if (!retStr[0].equals(RetDefine.pub_success[0])) {
//				logger.error(retStr[1]);
//				return retStr;
//			}
//			logger.info("会员月结算清单生成了......");

		}

		/** 20091030 by suntao */
		retStr = doCsgOrderList();
		if (!retStr[0].equals(RetDefine.pub_success[0])) {
			logger.error(retStr[1]);
			return retStr;
		}
		logger.info("交收申报报单生成了......");

		// 20091210 徐峰新添加
		ReportDataBuilder[] builders = new ReportDataBuilder[] {
				new BigSubsRisk(), new MonthDeal() };

		for (ReportDataBuilder builder : builders) {
			builder.build();
		}

		if (SettleUtil.REPORT_IS_ZHJS) {
			new CollectiveSettlement().build();
		}

		// HSTD xml报表生成处理
		{
			logger.info("HSTD 报表生成处理开始.");

			HstdSettleReports hReports = new HstdSettleReports(logger);
			hReports.initReports(settleDay, lastSettleDay, nextSettleDay,
					curMonth, monthBeginDay, statMonth, statDay, curBeginTime,
					curEndTime, monthBeginTime, lastBeginTime, rate, taxRate,
					reports, centerDir, assocDir, dayDir, associatorInfoMap,
					clientMap, contractInfoMap,last_month2);

			retStr = hReports.doXmlReports();
			if (!retStr[0].equals(RetDefine.pub_success[0])) {
				logger.error(retStr[1]);
				return retStr;
			}

			logger.info("HSTD 报表生成处理结束.");
		}

		return RetDefine.pub_success;
	}

	/**
	 * @param args
	 *            命令参数: 日期, 格式：yyyyMMdd
	 */
	public static void main(String args[]) {
		String retStr[];
		try {
			DoReports doReports = new DoReports();
			Global.commonLog = logger;

			logger.info("生成报表数据初始化...");
			String date = "";
			if (args != null && args.length != 0 && args[0].length() == 8) {
				date = args[0];
			}

			retStr = doReports.initReports(date);
			if (!retStr[0].equals(RetDefine.pub_success[0])) {
				logger.error("生成报表失败: " + retStr[1]);
				System.exit(-1);
			}

			// 设置合同信息列表
			retStr = SettleUtil.intitContractInfoMap(settleDay);
			// 判断返回结果是否成功
			if (!retStr[0].equals(RetDefine.pub_success[0])) {
				logger.error("生成报表失败: " + retStr[1]);
				System.exit(-1);
			}

			logger.info("开始生成报表，请等待...");
			retStr = doReports.doXmlReports();
			// retStr=doReports.doSubsList();
			// retStr=doReports.doMonthDealList();
			// retStr=doReports.doMonthSettleList();
			// retStr=doReports.doConsignList();
			// retStr=doReports.doMorbidReport();
			// retStr=doReports.doPaymentFinishList();
			// retStr=doReports.doReceiptList();
			// retStr=doReports.doMonthPoundage();
			if (!retStr[0].equals(RetDefine.pub_success[0])) {
				logger.error("生成报表失败: " + retStr[1]);
				System.exit(-1);
			}
			// return;
			// retStr = doReports.doMonthInOutList();
			// if (!retStr[0].equals(RetDefine.pub_success[0]))
			// {
			// logger.error(retStr[1]);
			// System.exit(-1);
			// }
			// logger.info("会员／中心款项清单生成了...");

		} catch (Exception ex) {
			//ex.printStackTrace();
			logger.error("生成报表失败: " + ex.getMessage(), ex);
			System.exit(-1);

		}
		logger.info("XML报表全部生成了, 下面接着生成HTML的报表，请稍等......");

		// 生成HTML报表
		ParseReportFile reportTest = new ParseReportFile();
		long start = System.currentTimeMillis();
		int count = 1;
		try {
			String language[] = { "chinese" };
			if (!"0".equals(SettleUtil.REPORTS_LANGUAGE)) {
				language = SettleUtil.REPORTS_LANGUAGE.split("@");
			} else {
				logger.warn("没有找到报表语言配置，将以默认的中文输出");
			}

			count = language.length;
			logger.debug("有" + count + "种语言的HTML报表要生成");

			reportTest.tempXmlPath = reports + "/xml";
			for (int i = 0; i < count; i++) {
				logger.debug("语种:" + language[i]);
				reportTest.tempXslPath = reports + "/template/" + language[i];
				reportTest.tempHtmlPath = reports + "/html/" + language[i];
				// 输出 html 文件
				reportTest.findFile(reportTest.tempXmlPath);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			logger.error("生成报表失败: " + ex.getMessage());
			System.exit(-1);
		}
		logger.info("生成HTML报表耗时:" + (System.currentTimeMillis() - start)
				/ 1000.0D + "秒");
		System.exit(0);
	}
}
