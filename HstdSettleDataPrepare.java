/**
 * 
 */
package com.forlink.exchange.settlesrv.hstd;

import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;

import com.forlink.exchange.entity.business.ITradeUtil;
import com.forlink.exchange.entity.business.SettleManangeImpl;
import com.forlink.exchange.entity.business.TradeUtilFactory;
import com.forlink.exchange.entity.dao.ClientInfoDAOImpl;
import com.forlink.exchange.entity.dao.ContractFDAOImpl;
import com.forlink.exchange.entity.dao.DealFDAO;
import com.forlink.exchange.entity.dao.DealFDAOImpl;
import com.forlink.exchange.entity.dao.GoodsModelDAO;
import com.forlink.exchange.entity.dao.GoodsModelDAOImpl;
import com.forlink.exchange.entity.dao.TrackDAO;
import com.forlink.exchange.entity.dao.TrackDAOImpl;
import com.forlink.exchange.entity.dao.TrackHistDAO;
import com.forlink.exchange.entity.dao.TrackHistDAOImpl;
import com.forlink.exchange.entity.model.ClientInfo;
import com.forlink.exchange.entity.model.ClientInfoExample;
import com.forlink.exchange.entity.model.ContractF;
import com.forlink.exchange.entity.model.ContractFExample;
import com.forlink.exchange.entity.model.DealF;
import com.forlink.exchange.entity.model.DealFExample;
import com.forlink.exchange.entity.model.GoodsModel;
import com.forlink.exchange.entity.model.GoodsModelExample;
import com.forlink.exchange.entity.model.Track;
import com.forlink.exchange.entity.model.TrackExample;
import com.forlink.exchange.entity.model.TrackHist;
import com.forlink.exchange.entity.model.TrackHistExample;
import com.forlink.exchange.pub.RetDefine;
import com.forlink.exchange.pub.RetObject;
import com.forlink.exchange.pub.convert.Converter;
import com.forlink.exchange.pub.tools.DateUtil;
import com.forlink.exchange.pub.tools.StringUtil;
import com.forlink.exchange.settlesrv.SettleUtil;
import com.hstd.exchange.entity.business.impl.PremiumImpl;
import com.hstd.exchange.entity.business.impl.TradeModeListFactory;
import com.hstd.exchange.entity.business.interfaces.ITradeModeList;
import com.hstd.exchange.entity.business.interfaces.Premium;
import com.hstd.exchange.entity.dao.DailyPremiumDAO;
import com.hstd.exchange.entity.dao.DailyPremiumDAOImpl;
import com.hstd.exchange.entity.dao.PremiumSettingDAOImpl;
import com.hstd.exchange.entity.model.DailyPremium;
import com.hstd.exchange.entity.model.DailyPremiumExample;
import com.hstd.exchange.entity.model.PremiumSetting;
import com.hstd.exchange.entity.model.PremiumSettingExample;
import com.hstd.exchange.pub.forwarding.HstdFundUtil;
import com.hstd.exchange.pub.forwarding.HstdSubsFUtil;
import com.hstd.exchange.pub.forwarding.HstdTradeFactory;
import com.hstd.exchange.pub.forwarding.HstdTradeRetDefine;
import com.hstd.exchange.pub.forwarding.HstdTradeUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * 结算数据准备
 * @author hc
 *
 */
@SuppressWarnings({"unused","unchecked","static-access"})
public class HstdSettleDataPrepare {
	// 数据库连接
	private SqlMapClient sqlMap;
	// 运行日志
	private Logger logger;
	
	private HstdTradeUtil hTradeUtil;
	private HstdSubsFUtil  hSubsF;
	private HstdFundUtil hFund;
	private ITradeModeList iTradeModeList;
	private ITradeUtil iTradeUtil ;
	SettleManangeImpl settleManangeImpl;
	public HstdSettleDataPrepare(SqlMapClient sqlMapClient, Logger log){
		this.sqlMap = sqlMapClient;
		this.logger = log;
		
		this.hTradeUtil = HstdTradeFactory.getTradeUtil(logger);
		this.hSubsF = HstdTradeFactory.getSubsFUtil(logger);
		this.hFund = HstdTradeFactory.getFundUtil(logger);
		this.iTradeModeList = TradeModeListFactory.getInstance(logger);
		this.settleManangeImpl = new SettleManangeImpl(logger);
		this.iTradeUtil = TradeUtilFactory.getInstance(logger);
	}
	
	/**
	 * 结算前数据准备1
	 * @return
	 */
	public String[] execute1() throws Exception
	{
		String[] ret;
		
		//同步保证金
		ret = hTradeUtil.copyDepositToGoodsPro();
		if(!ret[0].equals(RetDefine.pub_success[0]))
		{
			return ret;
		}
		//为了对冲定金重算，将货物担保持仓变换为仓单担保持仓。
		ret = hSubsF.settleChangeRiskSubsToRcpt(SettleUtil.CUR_SETTLE_DAY);
		if(!ret[0].equals(RetDefine.pub_success[0]))
		{
			return ret;
		}
		
		//为了对冲交收申报报单冻结，将定金申报变换为仓单申报
		ret = changeCsgOrderStatus();
		if(!ret[0].equals(RetDefine.pub_success[0]))
		{
			return ret;
		}
		
		// 成功返回
		return RetDefine.pub_success;
	}
	/**
	 * 结算前数据准备2
	 * @return
	 * @throws Exception
	 */
	public String[] execute2() throws Exception
	{
		String[] ret;
		
		//升贴水计算 lxy
		ret = 	calculatPremuim();
		if(!ret[0].equals(RetDefine.pub_success[0]))
		{
			return ret;
		}
		//更新行情 包含计算出的升贴水
		ret = updateFutureTrack();		//updateTrack();
		if(!ret[0].equals(RetDefine.pub_success[0]))
		{
			return ret;
		}
		//更新仓储费
		ret = updateStorageFeeProcess();
		if(!ret[0].equals(RetDefine.pub_success[0]))
		{
			return ret;
		}
		
		// 成功返回
		return RetDefine.pub_success;
	}
//	/**
//	 * 将货物担保的持仓变换为时力的仓单持仓。
//	 * 	在结算后(HstdSettlePostProcess)会将时力的仓单持仓变换为货物担保持仓
//	 * @return
//	 * @throws Exception
//	 */
//	private String[] changeRiskSubsToRcpt() throws Exception
//	{
//		String[] ret;
//		RetObject retObj;
//		
//		//key:clientId##contractId##buyorsell
//		Map<String, ResultMap> rcptMap = new HashMap<String, ResultMap>();
//		
//		//持仓明细
//		HstdSubsFDetailExample exa = new HstdSubsFDetailExample();
//		exa.setRiskRcptQtt(0L);
//		exa.setRiskRcptQtt_Indicator(HstdSubsFDetailExample.EXAMPLE_GREATER_THAN);
//		HstdSubsFDetailDAO dao = new HstdSubsFDetailDAOImpl(this.sqlMap);
//		List list = dao.selectByExample(exa);
//		if(list != null && list.size() > 0){
//			retObj = new RetObject();
//			for(int i=0; i<list.size(); i++){
//				HstdSubsFDetail subsFDetail = (HstdSubsFDetail)list.get(i);
//				
//				long thisPrice = subsFDetail.getDealPrice();
//				long thisQtt = Math.min(subsFDetail.getLeftQttDpst(), subsFDetail.getRiskRcptQtt());
//
//				if(thisQtt != 0L){
//					//按clientId+contractId+buyorsell分组存储
//					String key = subsFDetail.getClientId() + "##" + subsFDetail.getContractId() + "##" + subsFDetail.getBuyorsell();
//					if(!rcptMap.containsKey(key)){
//						ResultMap map = new ResultMap();
//						map.put("clientId", subsFDetail.getClientId());
//						map.put("contractId", subsFDetail.getContractId());
//						map.put("buyorsell", subsFDetail.getBuyorsell());
//						map.put("rcpt", thisQtt);
//					} else {
//						ResultMap map = rcptMap.get(key);
//						map.put("rcpt", map.getLong("rcpt") + thisQtt);
//					}
//
//					//持仓明细变换:货物担保->时力仓单
//					hSubsF.changeDetailBySeq(-thisQtt, thisQtt, 0, 0, 0, 0,0,subsFDetail.getDetailSeq());
//				}
//			}
//		}
//		
//		//修改主表
//		for(ResultMap map : rcptMap.values()){
//			long rcpt = map.getLong("rcpt", 0L);
//			if(rcpt != 0L){
//				HstdSubsF subsF = new HstdSubsF();
//				subsF.setClientId(map.getString("clientId"));
//				subsF.setContractId(map.getString("contractId"));
//				subsF.setBuyorsell(map.getString("buyorsell"));
//				subsF.setSubsRcptQtt(rcpt);
//	
//				hSubsF.changeSubsF(subsF);
//			}
//		}
//		
//		// 成功返回
//		return RetDefine.pub_success;
//	}
	/**
	 * 将待交收的交收申报交收申报的类型由 1 -> 10。
	 * 避免重算交收风控冻结
	 * @return
	 * @throws Exception
	 */
	private String[] changeCsgOrderStatus() throws Exception
	{
//		Map para = new HashMap();
//		para.put("buyorsell", "1");
		int rows = this.sqlMap.update("udp_hstd_settle_csgOrderFPrepare_T_CSG_ORDER_F");
		
		// 成功返回
		return RetDefine.pub_success;
	}
	/**
	 * 更新行情：目前主要更新下一交易日合约的行情。
	 * @return
	 * @throws Exception
	 */
	private String[] updateTrack() throws Exception
	{
		String[] ret;
		RetObject retObj = new RetObject();
		
		
		//当前交易日
		String curSettleDay = SettleUtil.CUR_SETTLE_DAY;
		//下一交易日
		String nextSettleDay = SettleUtil.NEXT_SETTLE_DAY;

		//成交记录DAO
		DealFDAO dealDao = new DealFDAOImpl(sqlMap);
		DealFExample dealExa = new DealFExample();
		//行情DAO
		TrackDAO trackDao = new TrackDAOImpl(sqlMap);
		TrackExample trackExa = new TrackExample();
		TrackHistDAO trackHistDao = new TrackHistDAOImpl(sqlMap);
		TrackHistExample trackHistExa = new TrackHistExample();
		trackHistExa.setTradeDay(DateUtil.parse(curSettleDay, "yyyyMMdd"));
		trackHistExa.setTradeDay_Indicator(TrackHistExample.EXAMPLE_EQUALS);

		//商品查询
		GoodsModelDAO gmDAO = new GoodsModelDAOImpl(sqlMap);
		GoodsModelExample gmExa = new GoodsModelExample();
		List list = gmDAO.selectByExample(gmExa);
		if(list != null && list.size() > 0){
			for(int i=0; i<list.size(); i++){
				GoodsModel gm = (GoodsModel)list.get(i);
				//当日合约
				ContractF curContractF = null;
				retObj.setRetObject(null);
				ret = hTradeUtil.getTheDayContractF(String.valueOf(gm.getGoodsId()), curSettleDay, retObj);
				//如果没有当日合约则跳过处理
				if(ret[0].equals(HstdTradeRetDefine.tradesrv_pub_contractfdayErr[0])){
					continue;
				}
				if(!ret[0].equals(RetDefine.pub_success[0]))
				{
					return ret;
				}
				curContractF = (ContractF)retObj.getRetObject();
				
				//下一日合约
				ContractF nextContractF = null;
				retObj.setRetObject(null);
				ret = hTradeUtil.getTheDayContractF(String.valueOf(gm.getGoodsId()), nextSettleDay, retObj);
				//如果没有次日合约则跳过
				if(ret[0].equals(HstdTradeRetDefine.tradesrv_pub_contractfdayErr[0])){
					continue;
				}
				if(!ret[0].equals(RetDefine.pub_success[0]))
				{
					return ret;
				}
				nextContractF = (ContractF)retObj.getRetObject();

				//更新次日合约的行情价格 -- 收盘价
				dealExa.setContractId(nextContractF.getContractId());
				dealExa.setContractId_Indicator(DealFExample.EXAMPLE_EQUALS);
				List dealList = dealDao.selectByExample(dealExa, "DEAL_NO DESC");
				if(dealList != null && dealList.size() > 0){
					long endPrice = ((DealF)dealList.get(0)).getDealPrice();
					//当日行情
					trackExa.setContractId(nextContractF.getContractId());
					trackExa.setContractId_Indicator(TrackExample.EXAMPLE_EQUALS);
					List trackList = trackDao.selectByExample(trackExa);
					if(trackList != null && trackList.size() > 0){
						Track track = (Track)trackList.get(0);
						track.setEndPrice(endPrice);
						trackDao.updateByPrimaryKey(track);
					}
					//历史行情
					trackHistExa.setContractId(nextContractF.getContractId());
					trackHistExa.setContractId_Indicator(TrackHistExample.EXAMPLE_EQUALS);
					List trackHistList = trackHistDao.selectByExample(trackHistExa);
					if(trackHistList != null && trackHistList.size() > 0){
						TrackHist trackHist = (TrackHist)trackHistList.get(0);
						trackHist.setEndPrice(endPrice);
						trackHistDao.updateByPrimaryKey(trackHist);
					}
				}
			}
		}
		
		// 成功返回
		return RetDefine.pub_success;
	}
	
	/**
	 * 更新远期合约行情的收盘价
	 * 撮合：初始化合约readContractInfo，写入历史行情writeTrackHist
	 * 结算：初始化合约 SettleUtil.intitContractInfoMap
	 * @return
	 * @throws Exception
	 */
	private String[] updateFutureTrack() throws Exception
	{
		String[] ret; 
		RetObject retObj = new RetObject();
//		HstdTradeUtil hTradeUtil = HstdTradeFactory.getTradeUtil(logger);
		
		//当前交易日
		String curSettleDay = SettleUtil.CUR_SETTLE_DAY;
		
		//升贴水记录
//		DailyPremium dailyPremium = new DailyPremium();
		DailyPremiumDAO dailyPremiumDAO = new DailyPremiumDAOImpl(sqlMap);
		DailyPremiumExample dailyPremiumExample = new DailyPremiumExample();
		//成交记录DAO
		DealFDAO dealDao = new DealFDAOImpl(sqlMap);
		DealFExample dealExa = new DealFExample();
		//行情DAO
		TrackDAO trackDao = new TrackDAOImpl(sqlMap);
		TrackExample trackExa = new TrackExample();
		TrackHistDAO trackHistDao = new TrackHistDAOImpl(sqlMap);
		TrackHistExample trackHistExa = new TrackHistExample();
		trackHistExa.setTradeDay(DateUtil.parse(curSettleDay, "yyyyMMdd"));
		trackHistExa.setTradeDay_Indicator(TrackHistExample.EXAMPLE_EQUALS);
//		ITradeUtil iTradeUtil = TradeUtilFactory.getInstance(logger);

		/**商品**/
		GoodsModelExample goodsExa = new GoodsModelExample();
		GoodsModelDAO goodsDao = new GoodsModelDAOImpl(sqlMap);
		List<GoodsModel> goodsModelList = goodsDao.selectByExample(goodsExa);
		
		for(int j=0;j<goodsModelList.size();j++){
			String goodsId = String.valueOf(goodsModelList.get(j).getGoodsId());
//			int days = 0;

			//当日合约
			ContractF curContractF = null;
			retObj.setRetObject(null);
			ret = hTradeUtil.getTheDayContractF(goodsId, curSettleDay, retObj);
			//如果没有当日合约则跳过处理
			if(ret[0].equals(HstdTradeRetDefine.tradesrv_pub_contractfdayErr[0])){
				continue;
			}
			if(!ret[0].equals(RetDefine.pub_success[0]))
			{
				logger.error(ret[1] + ". goodsId=" + goodsId);
				return ret;
			}
			
//			retMsg = iTradeUtil.getTodaySettlePrice(contractF.getContractId(), retObj);
//			if (!RetDefine.pub_success[0].equals(retMsg[0]))
//			{
//				// 得到昨日结算均价
//				retMsg = iTradeUtil.getLastSettlePrice(contractF.getContractId(), retObj);
//				if (!RetDefine.pub_success[0].equals(retMsg[0]))
//				{
//					throw new Exception(retMsg[1]);
//				}
//			}
//			long settlePrice = retObj.getRetLong();
			
			//当前行情结算价
			ret = hTradeUtil.getCurSettlePrice(goodsId, retObj);
			if (!RetDefine.pub_success[0].equals(ret[0]))
			{
				//昨日结算均价
				ret = hTradeUtil.getPreSettlePrice(goodsId, retObj);
				if (!RetDefine.pub_success[0].equals(ret[0]))
				{
					logger.error(ret[1] + ". goodsId=" + goodsId);
					return ret;
				}
			}
			long settlePrice = retObj.getRetLong();
			
			dailyPremiumExample.setGoodsId(Integer.parseInt(goodsId));
			dailyPremiumExample.setGoodsId_Indicator(DailyPremiumExample.EXAMPLE_EQUALS);
			List<DailyPremium> dailyPremiumList=dailyPremiumDAO.selectByExample(dailyPremiumExample,"DAYS ASC");
			for(int i=0;i<dailyPremiumList.size();i++){
				DailyPremium dailyPremium = dailyPremiumList.get(i);
				int days = (int)(dailyPremium.getDays());
//				logger.info("days="+days);
				long daylyPremium= dailyPremium.getPremium();
//				Converter.fen2yuan(fen);
				if(days>0){
					//查询第N天后的合约实体 如果没有合约则跳过
					ret = hTradeUtil.getNDayContractF(goodsId, days, retObj);
					if(!ret[0].equals(RetDefine.pub_success[0]))
					{
						continue;
					}
					ContractF contractF = (ContractF)retObj.getRetObject();
					//合同最小变动价
					long minDiffPrice = contractF.getMinDiffPrice();
					if(minDiffPrice == 0L){
						minDiffPrice = 1L;
					}
					boolean hasDeal = false;
					long endPrice = 0L;
					//查当日合约成交
					logger.debug("更新远期合约行情：contract_id="+contractF.getContractId());
					dealExa.setContractId(contractF.getContractId());
					dealExa.setContractId_Indicator(DealFExample.EXAMPLE_EQUALS);
					List<DealF> dealList = dealDao.selectByExample(dealExa, "DEAL_NO DESC");
					//降序排列，取最后一条成交记录的价格   封装成一个方法
					if(dealList != null && dealList.size() > 0){
						//收盘价
						endPrice = dealList.get(0).getDealPrice();
						//按合约最小变动价位取整
						endPrice = Converter.double2long( (1d* endPrice) / minDiffPrice) * minDiffPrice;
						//有成交
						hasDeal = true;
					}else{
//						用升贴水去计算收盘价 即期合约的结算价+升贴水
//						获取当天指定合同当日结算价
//						public String[] getTodaySettlePrice(String contractId, RetObject ret);
						endPrice = settlePrice+daylyPremium;
						logger.info("无成交记录... 即期合约结算价 settlePrice="+settlePrice+",daylyPremium="+daylyPremium+",收盘价="+endPrice);
						//合同最小变动价
						endPrice = Converter.double2long( (1d* endPrice) / minDiffPrice) * minDiffPrice;
						logger.info("向上取整：endPrice="+endPrice);
					}
					//更新当日行情表
					trackExa.setContractId(contractF.getContractId());
					trackExa.setContractId_Indicator(TrackExample.EXAMPLE_EQUALS);
					List trackList = trackDao.selectByExample(trackExa);
					if(trackList != null && trackList.size() > 0){
						Track track = (Track)trackList.get(0);
						track.setEndPrice(endPrice);
						if(!hasDeal)
						{
							track.setSettlePrice(endPrice);
						}
						trackDao.updateByPrimaryKey(track);
					}
					//更新历史行情表
					trackHistExa.setContractId(contractF.getContractId());
					trackHistExa.setContractId_Indicator(TrackHistExample.EXAMPLE_EQUALS);
					List trackHistList = trackHistDao.selectByExample(trackHistExa);
					if(trackHistList != null && trackHistList.size() > 0){
						TrackHist trackHist = (TrackHist)trackHistList.get(0);
						trackHist.setEndPrice(endPrice);
						if(!hasDeal)
						{
							trackHist.setSettlePrice(endPrice);
						}
						trackHistDao.updateByPrimaryKey(trackHist);
					}
				}
			}
		}

		// 成功返回
		return RetDefine.pub_success;
	}
	
	/**
	 * 仓储费处理
	 * 计算用户的仓储费用，生成凭证
	 * @return
	 * @throws Exception
	 */
	private String[] updateStorageFeeProcess() throws Exception
	{
		//仓储费的计算
		String client_id = "";
		String associatorNo = "";
		
    	logger.info("仓储费计算");
    	logger.info("SettleUtil.CUR_SETTLE_DAY....结算日："+SettleUtil.CUR_SETTLE_DAY);
    	
    	ClientInfoDAOImpl clientInfoDAOImpl = new ClientInfoDAOImpl(sqlMap);
		ClientInfoExample clientInfoExample = new ClientInfoExample();
		ClientInfo clientInfo = new ClientInfo();
		List list = clientInfoDAOImpl.selectByExample(clientInfoExample);
		
    	for(int i=0;i<list.size();i++){
    		clientInfo = (ClientInfo) list.get(i);
    		client_id = clientInfo.getClientId();
    		
    		if(client_id.equals("000000")){//中心账户
    			continue;
    		}
    		//client_id 转换为 associatorNo
    		associatorNo = Converter.gstring(sqlMap.queryForObject("select_IFund_queryAssociatorByClient_T_CLIENT_INFO", client_id));
    		long storageFee = hFund.getAllGoodsStorageFee(client_id);
    		
    		if(storageFee!=0){
    			logger.info("associatorNo："+associatorNo+",storageFee ="+storageFee);
    		}
    		boolean ret = settleManangeImpl.addVoucher(associatorNo, "00001", StringUtil.pad("201", associatorNo, '0', 12), "20405", storageFee,"SYS-DS:CCF", "代收款凭证:仓储费", "root");
    		
			/**插入凭证没成功**/
			if(ret == false)
			{
			return RetDefine.pub_failed;
			}
    	}
		// 成功返回
		return RetDefine.pub_success;
	}
	
	/**
	 * 升贴水计算
	 * 区间升贴水设置,每日升贴水计算
	 * @return
	 * @throws Exception
	 */
	private String[] calculatPremuim() throws Exception
	{
		String goodsId = "";
		/**商品名称**/
		GoodsModelExample goodsExa = new GoodsModelExample();
		GoodsModelDAO goodsDao = new GoodsModelDAOImpl(sqlMap);
		List<GoodsModel> goodsModelList = goodsDao.selectByExample(goodsExa);
		
		for(int i=0;i<goodsModelList.size();i++){
			
			goodsId = String.valueOf(goodsModelList.get(i).getGoodsId());
			logger.info("产品id="+goodsId);
//			if(!(goodsId.equals("1"))){//目前只计算白银产品的升贴水，遇其他产品跳过
//				continue;
//			}
			logger.info("计算区间升贴水开始...");
			Premium premium = new PremiumImpl();
			premium.setSectionPremuim(goodsId);
			logger.info("计算区间升贴水结束...");
			logger.info("计算每日升贴水开始...");
			premium.CalculatDailyPremuim(goodsModelList.get(i).getGoodsId());
			logger.info("计算每日升贴水结束...");
		}
		// 成功返回
		return RetDefine.pub_success;
		
	}

}
