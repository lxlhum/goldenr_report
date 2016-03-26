/**
 * 
 */
package com.forlink.exchange.settlesrv.hstd;

import org.apache.log4j.Logger;

import com.forlink.exchange.entity.dao.VoucherDAOImpl;
import com.forlink.exchange.entity.model.VoucherExample;
import com.forlink.exchange.pub.RetDefine;
import com.forlink.exchange.pub.tools.ResultMap;
import com.forlink.exchange.settlesrv.SettleUtil;
import com.hstd.exchange.entity.dao.DailyInventoryDAO;
import com.hstd.exchange.entity.dao.DailyInventoryDAOImpl;
import com.hstd.exchange.entity.model.DailyInventoryExample;
import com.hstd.exchange.pub.forwarding.HstdSubsFUtil;
import com.hstd.exchange.pub.forwarding.HstdTradeFactory;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * 为重做结算处理
 * @author hc
 *
 */
@SuppressWarnings({"unused","unchecked","static-access"})
public class HstdRepeatSettle {
	// 数据库连接
	private SqlMapClient sqlMap;
	// 运行日志
	private Logger logger;
	
	private HstdSubsFUtil  		hSubsF;
	
	public HstdRepeatSettle(SqlMapClient sqlMapClient, Logger log){
		this.sqlMap = sqlMapClient;
		this.logger = log;
		
		this.hSubsF = HstdTradeFactory.getSubsFUtil(logger);
	}
	
	/**
	 * 执行重新结算处理，恢复之前的数据
	 * @return
	 * @throws Exception
	 */
	public String[] execute() throws Exception
	{
		String[] ret;
		
		//恢复当日持仓明细转换记录
		ret = restoreSubsFDetailSettleLog();
		if(!ret[0].equals(RetDefine.pub_success[0]))
		{
			return ret;
		}
		
		//删除当日客户存货记录
		ret = deleteDailyInventory();
		if(!ret[0].equals(RetDefine.pub_success[0]))
		{
			return ret;
		}
		
//		//删除当日即期合约的强制冻结持仓记录
//		ret = deleteSpotSubsFForceFrzLog();
//		if(!ret[0].equals(RetDefine.pub_success[0]))
//		{
//			return ret;
//		}
		//删除当日仓储费凭证
		ret = deleteDailyVoucher();
		if(!ret[0].equals(RetDefine.pub_success[0]))
		{
			return ret;
		}
		// 成功返回
		return RetDefine.pub_success;
	}
	
	/**
	 * 恢复当日持仓明细转换记录
	 * @return
	 * @throws Exception
	 */
	private String[] restoreSubsFDetailSettleLog() throws Exception
	{
		//恢复货物担保的持仓
		return hSubsF.settleChangeRcptSubsToRisk(SettleUtil.CUR_SETTLE_DAY);
	}
	
	/**
	 * 删除当日客户存货记录
	 * @return
	 * @throws Exception
	 */
	private String[] deleteDailyInventory() throws Exception
	{
		DailyInventoryExample exa = new DailyInventoryExample();
		exa.setSumDay(SettleUtil.NEXT_SETTLE_DAY);
		exa.setSumDay_Indicator(DailyInventoryExample.EXAMPLE_EQUALS);
		DailyInventoryDAO dailyInvDao = new DailyInventoryDAOImpl(sqlMap);
		dailyInvDao.deleteByExample(exa);
		
		// 成功返回
		return RetDefine.pub_success;
	}
	
	/**
	 *删除仓储费凭证  lxy
	 * @return
	 * @throws Exception
	 */
	private String[] deleteDailyVoucher() throws Exception
	{
//		DailyInventoryExample exa = new DailyInventoryExample();
//		exa.setSumDay(SettleUtil.NEXT_SETTLE_DAY);
//		exa.setSumDay_Indicator(DailyInventoryExample.EXAMPLE_EQUALS);
//		DailyInventoryDAO dailyInvDao = new DailyInventoryDAOImpl(sqlMap);
//		dailyInvDao.deleteByExample(exa);
		ResultMap map = new ResultMap();
		// 删除结算系统凭证明细记录
		map.put("settleDay", SettleUtil.CUR_SETTLE_DAY);
		map.put("DigestNo", "SYS-DS:CCF");
		map.put("CheckOper", "root");
		map.put("RecordOper", "root");
		sqlMap.delete("del_hstd_settlesrv_DelData_T_VOUCHER_DETAIL", map);

		// 删除结算系统凭证主表记录
		VoucherDAOImpl voucherDAOImpl = new VoucherDAOImpl(sqlMap);
		VoucherExample voucherExample = new VoucherExample();
		voucherExample.setDigestNo("SYS-DS:CCF");
		voucherExample.setDigestNo_Indicator(3);
		voucherExample.setSettleDay(SettleUtil.CUR_SETTLE_DAY);
		voucherExample.setSettleDay_Indicator(3);
		voucherDAOImpl.deleteByExample(voucherExample);
		
		// 恢复凭证未扎帐标记0
//		map.clear();
//		map.put("settleDay", SettleUtil.CUR_SETTLE_DAY);
//		map.put("hasComputed", "0");
//		sqlMap.update("upd_settlesrv_UpDate_T_VOUCHER", map);
		
		// 成功返回
		return RetDefine.pub_success;
	}
	
//	/**
//	 * 删除当日即期合约的强制冻结持仓记录
//	 * @return
//	 * @throws Exception
//	 */
//	private String[] deleteSpotSubsFForceFrzLog() throws Exception
//	{
//		SpotSubsFForceFrzLogExample exa = new SpotSubsFForceFrzLogExample();
//		exa.setSettleDay(SettleUtil.CUR_SETTLE_DAY);
//		exa.setSettleDay_Indicator(SpotSubsFForceFrzLogExample.EXAMPLE_EQUALS);
//		SpotSubsFForceFrzLogDAO logDao = new SpotSubsFForceFrzLogDAOImpl(sqlMap);
//		logDao.deleteByExample(exa);
//		
//		// 成功返回
//		return RetDefine.pub_success;
//	}
}
