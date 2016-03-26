/**
 * HstdSettleEndProcess.java
 */
package com.forlink.exchange.settlesrv.hstd;

import java.util.List;

import org.apache.log4j.Logger;

import com.forlink.exchange.entity.dao.GoodsModelDAO;
import com.forlink.exchange.entity.dao.GoodsModelDAOImpl;
import com.forlink.exchange.entity.model.GoodsModel;
import com.forlink.exchange.entity.model.GoodsModelExample;
import com.forlink.exchange.pub.RetDefine;
import com.hstd.exchange.entity.business.impl.SpreadListingImpl;
import com.hstd.exchange.entity.business.impl.SpreadOrderDealImpl;
import com.hstd.exchange.entity.business.impl.SpreadOrderImpl;
import com.hstd.exchange.entity.business.impl.SpreadOrderTrackImpl;
import com.hstd.exchange.entity.business.impl.SpreadTradeMgrImpl;
import com.hstd.exchange.entity.business.interfaces.ISpreadListing;
import com.hstd.exchange.entity.business.interfaces.ISpreadOrder;
import com.hstd.exchange.entity.business.interfaces.ISpreadOrderDeal;
import com.hstd.exchange.entity.business.interfaces.ISpreadOrderTrack;
import com.hstd.exchange.entity.business.interfaces.ISpreadTradeMgr;
import com.hstd.exchange.pub.forwarding.HstdCsgDomain;
import com.hstd.exchange.pub.forwarding.HstdFundUtil;
import com.hstd.exchange.pub.forwarding.HstdTradeFactory;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * 结算确认后处理
 * @author hc
 *
 */
@SuppressWarnings({"unused","unchecked","static-access"})
public class HstdSettleEndProcess {
	// 数据库连接
	private SqlMapClient sqlMap;
	// 运行日志
	private Logger logger;
	
	public HstdSettleEndProcess(SqlMapClient sqlMapClient, Logger log){
		this.sqlMap = sqlMapClient;
		this.logger = log;
	}
	
	/**
	 * 结算确认后处理
	 * @return
	 */
	public String[] execute() throws Exception
	{
		String[] ret;
		
		//处理远期合约的交收申报
		ret = processCsgOrderFrz();
		if (!RetDefine.pub_success[0].equals(ret[0])) {
			return ret;
		}
		
		//处理组合申报中次日交收申报
		ret = processNextSpreadOrder();
		if (!RetDefine.pub_success[0].equals(ret[0])) {
			return ret;
		}
		
		//处理历史记录
		ret = moveToHist();
		if (!RetDefine.pub_success[0].equals(ret[0])) {
			return ret;
		}
		
		// 成功返回
		return RetDefine.pub_success;
	}
	
	//隔日组合申报处理：对隔日合约进行交收申报处理。
	//运行至此处时，已是第二交易日
	private String[] processNextSpreadOrder()
	{
		try{
			ISpreadTradeMgr spreadMgr = new SpreadTradeMgrImpl(logger);
			GoodsModelDAO gmDAO = new GoodsModelDAOImpl(sqlMap);
			GoodsModelExample gmExa = new GoodsModelExample();
			List list = gmDAO.selectByExample(gmExa);
			if(list != null && list.size() > 0){
				for(int i=0; i<list.size(); i++){
					GoodsModel gm = (GoodsModel)list.get(i);
					spreadMgr.processNextSpreadOrder(String.valueOf(gm.getGoodsId()));
				}
			}
		}catch(Exception ex){
			logger.error("隔日组合次日交收申报出错.",ex);
			return new String[]{"-999","隔日组合次日交收申报出错."};
		}
		// 成功返回
		return RetDefine.pub_success;
	}
	
	//历史记录处理
	private String[] moveToHist()
	{
		String[] ret;
		try{
			//隔日组合申报
			ISpreadOrder orderImpl = new SpreadOrderImpl(logger);
			orderImpl.moveToHist();
			//隔日组合申报记录
			ISpreadOrderTrack track = new SpreadOrderTrackImpl(logger);
			track.moveToHist();
			//隔日组合成交记录
			ISpreadOrderDeal deal = new SpreadOrderDealImpl(logger);
			deal.moveToHist();
			//隔日组合行情记录
			deal.moveDailySpreadOrderTrackToHist();
			//定制组合挂牌、摘牌和成交历史
			ISpreadListing spreadListing = new SpreadListingImpl(logger);
			spreadListing.moveToHist();
			//发票风控冻结记录
			HstdFundUtil hFund = HstdTradeFactory.getFundUtil(logger);
			ret = hFund.moveToInvoiceRiskFundHist();
			if (!RetDefine.pub_success[0].equals(ret[0])) {
				return ret;
			}
		}catch(Exception ex){
			logger.error("处理历史记录出错.",ex);
			return new String[]{"-999","处理HSTD历史记录出错."};
		}
		// 成功返回
		return RetDefine.pub_success;
	}
	
	//处理远期合约的交收申报的冻结
	private String[] processCsgOrderFrz()
	{
		try
		{
			HstdCsgDomain hCsg = new HstdCsgDomain(logger);
			return hCsg.resetFrzCsgOrder();
		}catch(Exception ex){
			logger.error("处理远期合约交收申报出错.",ex);
			return new String[]{"-999","处理远期合约交收申报出错."};
		}
	}
}
