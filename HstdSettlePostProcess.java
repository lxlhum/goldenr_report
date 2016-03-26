/**
 * 
 */
package com.forlink.exchange.settlesrv.hstd;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.forlink.exchange.pub.RetDefine;
import com.forlink.exchange.pub.RetObject;
import com.forlink.exchange.pub.tools.ResultMap;
import com.forlink.exchange.settlesrv.SettleUtil;
import com.hstd.exchange.entity.business.impl.ListingImpl;
import com.hstd.exchange.entity.business.impl.SpreadListingImpl;
import com.hstd.exchange.entity.business.interfaces.ISpreadListing;
import com.hstd.exchange.entity.business.interfaces.ListingInterface;
import com.hstd.exchange.entity.dao.DailyInventoryDAO;
import com.hstd.exchange.entity.dao.DailyInventoryDAOImpl;
import com.hstd.exchange.entity.dao.HstdDailyFundSummaryDAOImpl;
import com.hstd.exchange.entity.dao.InventoryDAO;
import com.hstd.exchange.entity.dao.InventoryDAOImpl;
import com.hstd.exchange.entity.model.DailyInventory;
import com.hstd.exchange.entity.model.HstdDailyFundSummary;
import com.hstd.exchange.entity.model.HstdDailyFundSummaryExample;
import com.hstd.exchange.entity.model.Inventory;
import com.hstd.exchange.entity.model.InventoryExample;
import com.hstd.exchange.pub.forwarding.HstdCsgDomain;
import com.hstd.exchange.pub.forwarding.HstdReceiptUtil;
import com.hstd.exchange.pub.forwarding.HstdSubsFUtil;
import com.hstd.exchange.pub.forwarding.HstdTradeFactory;
import com.hstd.exchange.pub.forwarding.HstdTradeUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * 结算后处理
 * @author hc
 *
 */
@SuppressWarnings({"unused","unchecked","static-access"})
public class HstdSettlePostProcess {
	// 数据库连接
	private SqlMapClient sqlMap;
	// 运行日志
	private Logger logger;

	private HstdTradeUtil 		hTradeUtil;
	private HstdSubsFUtil  		hSubsF;
	private HstdReceiptUtil 	hReceipts;
	
	
	public HstdSettlePostProcess(SqlMapClient sqlMapClient, Logger log){
		this.sqlMap = sqlMapClient;
		this.logger = log;
		
		this.hTradeUtil = HstdTradeFactory.getTradeUtil(logger);
		this.hSubsF = HstdTradeFactory.getSubsFUtil(logger);
		this.hReceipts = HstdTradeFactory.getReceiptUtil(logger);
	}
	
	/**
	 * 结算后数据处理
	 * @return
	 * @throws Exception
	 */
	public String[] execute() throws Exception
	{
		String[] ret;
		
//		//结算后，重新冻结挂牌单和摘牌单的定金 -- 现在统一放在开市阶段进行重算
//		ret = processListingFrz();
//		if(!ret[0].equals(RetDefine.pub_success[0]))
//		{
//			return ret;
//		}
		
		//恢复货物担保的持仓
		ret = hSubsF.settleChangeRcptSubsToRisk(SettleUtil.CUR_SETTLE_DAY);
		if(!ret[0].equals(RetDefine.pub_success[0]))
		{
			return ret;
		}
		
		//恢复待交收的交收申报的定金申报
		ret = changeCsgOrderStatus();
		if(!ret[0].equals(RetDefine.pub_success[0]))
		{
			return ret;
		}
		
		//计算客户的当日款项
		ret = recalcClientDailyFund();
		if(!ret[0].equals(RetDefine.pub_success[0]))
		{
			return ret;
		}
		
		//计算当日客户存货
		ret = calcClientDailyInventory();
		if(!ret[0].equals(RetDefine.pub_success[0]))
		{
			return ret;
		}
		
		// 成功返回
		return RetDefine.pub_success;
	}
	
	/**
	 * 挂牌、摘牌重新进行定金报单冻结处理
	 * @return
	 * @throws Exception
	 */
	private String[] processListingFrz() throws Exception
	{
		try
		{
			ListingInterface listing = new ListingImpl(logger);
			listing.reFreezeListing();
		}catch(Exception ex){
			logger.error("挂牌单和摘牌单重新报单冻结处理出错.", ex);
			return new String[]{"-999","挂牌单和摘牌单重新报单冻结处理出错."};
		}
		
		try
		{
			ISpreadListing spListing = new SpreadListingImpl(logger);
			spListing.reFreezeListing();
		}catch(Exception ex){
			logger.error("定制价差组合挂牌单和摘牌单重新报单冻结处理出错.", ex);
			return new String[]{"-999","定制价差组合挂牌单和摘牌单重新报单冻结处理出错."};
		}
		
		// 成功返回
		return RetDefine.pub_success;
	}
//	/**
//	 * 将时力的仓单持仓变换为货物担保持仓。
//	 * 	在结算数据准备(HstdSettleDataPrepare)中将货物担保的持仓变换为时力的仓单持仓
//	 * @return
//	 * @throws Exception
//	 */
//	private String[] changeRcptSubsToRisk() throws Exception
//	{
//		String[] ret;
//		RetObject retObj;
//		
//		Map<String, ResultMap> rcptMap = new HashMap<String, ResultMap>();
//		
//		HstdSubsFDetailExample exa = new HstdSubsFDetailExample();
//		exa.setRiskRcptQtt(0L);
//		exa.setRiskRcptQtt_Indicator(HstdSubsFDetailExample.EXAMPLE_GREATER_THAN);
//		exa.setLeftQttRcpt(0L);
//		exa.setLeftQttRcpt_Indicator(HstdSubsFDetailExample.EXAMPLE_GREATER_THAN);
//		HstdSubsFDetailDAO dao = new HstdSubsFDetailDAOImpl(this.sqlMap);
//		List list = dao.selectByExample(exa);
//		if(list != null && list.size() > 0){
//			retObj = new RetObject();
//			for(int i=0; i<list.size(); i++){
//				HstdSubsFDetail subsFDetail = (HstdSubsFDetail)list.get(i);
//				
//				long thisPrice = subsFDetail.getDealPrice();
//				long thisQtt = Math.min(subsFDetail.getLeftQttRcpt(), subsFDetail.getRiskRcptQtt());
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
//					//持仓明细变换
//					hSubsF.changeDetailBySeq(thisQtt, -thisQtt, 0, 0, 0,0,0, subsFDetail.getDetailSeq());
//				}
//			}
//		}
//		
//		//修改主表
//		for(ResultMap map : rcptMap.values()){
//			long rcpt = -1 * map.getLong("rcpt", 0L);
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
	 * 将待交收的交收申报的类型由 10 -> 1。
	 * 避免重算交收风控冻结
	 * @return
	 * @throws Exception
	 */
	private String[] changeCsgOrderStatus() throws Exception
	{
//		Map para = new HashMap();
//		para.put("buyorsell", "1");
		int rows = this.sqlMap.update("udp_hstd_settle_csgOrderFProcess_T_CSG_ORDER_F");
		
		// 成功返回
		return RetDefine.pub_success;
	}
	/**
	 * 计算客户的当日款项
	 *   含交收货款
	 * @return
	 * @throws Exception
	 */
	private String[] recalcClientDailyFund() throws Exception
	{
		String[] ret;
		RetObject retObj = new RetObject();
		// 获得实体
		HstdCsgDomain hCsg = new HstdCsgDomain(logger);
		
		HstdDailyFundSummaryDAOImpl dailyFundSummaryDAOImpl = new HstdDailyFundSummaryDAOImpl(sqlMap);
		HstdDailyFundSummaryExample dailyFundSummaryExample = new HstdDailyFundSummaryExample();
		dailyFundSummaryExample.setSumDay(SettleUtil.NEXT_SETTLE_DAY);
		dailyFundSummaryExample.setSumDay_Indicator(HstdDailyFundSummaryExample.EXAMPLE_EQUALS);
		dailyFundSummaryExample.setAssociatorNo("00001");
		dailyFundSummaryExample.setAssociatorNo_Indicator(HstdDailyFundSummaryExample.EXAMPLE_NOT_EQUALS);
		
		List list = dailyFundSummaryDAOImpl.selectByExample(dailyFundSummaryExample, " associator_no");
		if(list != null && list.size() > 0){
			for(int i=0; i<list.size(); i++){
				HstdDailyFundSummary dailyFundSummary = (HstdDailyFundSummary)list.get(i);
				retObj.setRetObject(null);
				//查询交收货款
				ret = hCsg.queryClientCsgPayment(dailyFundSummary.getAssociatorNo(), SettleUtil.CUR_SETTLE_DAY, retObj);
				if(!ret[0].equals(RetDefine.pub_success[0])){
					logger.error("查询会员交收货款错误.assNo="+dailyFundSummary.getAssociatorNo());
					return ret;
				}
				ResultMap rtMap = (ResultMap)retObj.getRetObject();
				dailyFundSummary.setFrzCsgPayment(dailyFundSummary.getFrzCsgPayment()+rtMap.getLong("payment"));
				dailyFundSummary.setFrzCsgReceivable(dailyFundSummary.getFrzCsgReceivable()+rtMap.getLong("receivable"));
				dailyFundSummary.setCsgPaymentDiff(dailyFundSummary.getCsgPaymentDiff() + rtMap.getLong("paymentback"));
				dailyFundSummary.setCsgReceivableDiff(dailyFundSummary.getCsgReceivableDiff() + rtMap.getLong("receivableback"));
				//update
				dailyFundSummaryDAOImpl.updateByPrimaryKey(dailyFundSummary);
			}
		}
		// 成功返回
		return RetDefine.pub_success;
	}
	/**
	 * 计算当日客户存货
	 * @return
	 * @throws Exception
	 */
	private String[] calcClientDailyInventory() throws Exception
	{
		String prevDay = SettleUtil.PRE_SETTLE_DAY;
		String curDay = SettleUtil.CUR_SETTLE_DAY;
		String nextDay = SettleUtil.NEXT_SETTLE_DAY;
		
		Map para = new HashMap();
		para.put("beginDt", prevDay);
		para.put("endDt", curDay);
		ResultMap map;
		
		//查询所有客户存货
		InventoryExample invExa = new InventoryExample();
		InventoryDAO invDao = new InventoryDAOImpl(sqlMap);
		List<Inventory> invList = invDao.selectByExample(invExa);
		if(invList != null && invList.size() > 0){
			DailyInventoryDAO dailyInvDao = new DailyInventoryDAOImpl(sqlMap);
			for(Inventory inv : invList){
				DailyInventory dailyInv = hReceipts.getOrCreateDailyInventory(nextDay, inv, true);
				//计算当日发生的值
				para.put("inventoryId", inv.getInventoyrId());
				//--当日标记存货转入
				map = (ResultMap)sqlMap.queryForObject("sel_hstd_queryInventoryMkdInTotal", para);
				BigDecimal si_act_qtt = BigDecimal.valueOf(map.getDouble("SI_ACT_QTT", 0));
				BigDecimal si_qtt = BigDecimal.valueOf(map.getDouble("SI_QTT", 0));
				//--当日标记存货转出
				map = (ResultMap)sqlMap.queryForObject("sel_hstd_queryInventoryMkdOutTotal", para);
				BigDecimal so_act_qtt = BigDecimal.valueOf(map.getDouble("SO_ACT_QTT", 0));
				BigDecimal so_qtt = BigDecimal.valueOf(map.getDouble("SO_QTT", 0));
				//--当日未标记存货转入
				map = (ResultMap)sqlMap.queryForObject("sel_hstd_queryInventoryUnMkdInTotal", para);
				BigDecimal umsi_qtt = BigDecimal.valueOf(map.getDouble("UMSI_QTT", 0));
				//--当日未标记存货转出
				map = (ResultMap)sqlMap.queryForObject("sel_hstd_queryInventoryUnMkdOutTotal", para);
				BigDecimal umso_qtt = BigDecimal.valueOf(map.getDouble("UMSO_QTT", 0));
				
				dailyInv.setCurMkdActInQtt(si_act_qtt);
				dailyInv.setCurMkdInQtt(si_qtt);
				dailyInv.setCurMkdActOutQtt(so_act_qtt);
				dailyInv.setCurMkdOutQtt(so_qtt);
				dailyInv.setCurUnmkdInQtt(umsi_qtt);
				dailyInv.setCurUnmkdOutQtt(umso_qtt);
				
				dailyInvDao.updateByPrimaryKey(dailyInv);
			}
		}
		
		// 成功返回
		return RetDefine.pub_success;
	}
}
