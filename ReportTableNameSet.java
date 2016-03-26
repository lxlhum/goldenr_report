package com.forlink.exchange.settlesrv.hstd;

/**
 * @see hstd->com.hstd.exchange.tradesrv.reporttool.ReportTableNameSet.java
 * @author Ryan
 * @CreateDate: Mar 19, 2015 2:46:37 PM
 * @version 1.0
 * @Description 1.ReportTableNameSet.java 为报表提供了语义级的支持、维护服务。
 *              2.每一个报表，目前都建议在此处，将完整的XSL结构字段在此构建。 3.字段格式：【报表字段注释+public static
 *              final String 常量名=值;】 4.重复项，请将相关的意思复制过来，并注释。
 *              5.全部的值都为大写，转换小写请使用【toLowerCase】方式进行。
 */
public class ReportTableNameSet {

	// 报表的公共项
	/* 表示合计项 */public static final char ISTOTAL = 'T';
	/* 表示非合计项 */public static final char ISNOTOTAL = 'N';
	/* item */public static final String ITEM = "ITEM";
	/* total */public static final String TOTAL = "TOTAL";
	/* “” */public static final String NUL = "";
	/* body */public static final String BODY = "BODY";
	/* root */public static final String ROOT = "ROOT";
	/* top */public static final String TOP = "TOP";
	/* file_title */public static final String FILETITLE = "FILE_TITLE";
	/* content */public static final String CONTENT = "CONTENT";
	/* report_name */public static final String REPORTNAME = "REPORT_NAME";
	/* beginTime */public static final String BEGINTIME = "BEGINTIME";
	/* endTime */public static final String ENDTIME = "ENDTIME";
	/* client_id */public static final String CLIENTID = "CLIENT_ID";
	/* associator_no */public static final String ASSOCIATOR_NO = "ASSOCIATOR_NO";
	/* sum_day */public static final String SUM_DAY = "SUM_DAY";

	/* id */public static final String ID = "ID";
	
	/* 0 */public static final int ZERO = 1;
	/* 1 */public static final int ONE = 1;
	/* 2 */public static final int TWE = 2;
	/* 3 */public static final int THREE = 3;
	/* 4 */public static final int FOUR = 4;

	// -------------交易商成交日报----start
	// 命名不好，但是还挺好记的....
	public static final String CJMX = "_CJMX";
	public static final String CJMXFILETITLE = "交易商成交日报";

	public static final String CJMXINFO[] = { "LISTING_DEAL", "SPREAD_DEAL",
			"SPREADLISTING_DEAL", "CSGDELAYING_DEAL" };
	// 1.连续/挂牌/协议成交明细、2.隔日组合成交明细、3.定制组合成交明细、4.已付款合同选货展期交易明细
	// 使用的都是同一套表样，只是值不同
	/** 表体行 */
	/* 1.序号public static final String SEQ="SEQ"; */
	/* 2.合同编码 public static final String CONTRACT_ID = "CONTRACT_ID"; */
	/* 3.产品名称 public static final String GOODS_NAME = "GOODS_NAME"; */
	/* 4.买卖方向 public static final String BUYORSELL = "BUYORSELL"; */
	/* 5.成交类型 */public static final String DEAL_TYPE = "DEAL_TYPE";
	/* 6.成交价格 */public static final String DEAL_PRICE = "DEAL_PRICE";
	/* 7.成交数量 public static final String DEAL_QTT = "DEAL_QTT"; */
	/* 8.仓单数量 */public static final String DEAL_RECEIPT = "DEAL_RECEIPT";
	/* 10.成交金额 */public static final String DEAL_AMT = "DEAL_AMT";
	/* 11.手续费 public static final String POUNDAGE = "POUNDAGE"; */
	/* 12.资金占用 */public static final String DEAL_DEPOSIT = "DEAL_DEPOSIT";
	/* 13.货物占用 */public static final String RISK_RCPT = "RISK_RCPT";
	/* 14.转让盈亏 public static final String CNY_BALANCE = "CNY_BALANCE"; */
	/* 15.成交来源 public static final String DEAL_SOURCE = "DEAL_SOURCE"; */
	/* 16.成交单号 */public static final String DEAL_NO = "DEAL_NO";
	/* 16.成交时间 */public static final String DEAL_TIME = "DEAL_TIME";
	/** 合计行 */
	/* 1.成交数量 合计项 */public static final String TOTAL_DEAL_QTT = "TOTAL_DEAL_QTT";
	/* 2.仓单数量 合计项 */public static final String TOTAL_DEAL_RECEIPT = "TOTAL_DEAL_RECEIPT";
	/* 3.成交金额 合计项 */public static final String TOTAL_DEAL_AMT = "TOTAL_DEAL_AMT";
	/* 4.手续费 合计项 */public static final String TOTAL_POUNDAGE = "TOTAL_POUNDAGE";
	/* 5.资金占用 合计项 */public static final String TOTAL_DEAL_DEPOSIT = "TOTAL_DEAL_DEPOSIT";
	/* 6.货物占用 合计项 */public static final String TOTAL_RISK_RCPT = "TOTAL_RISK_RCPT";
	/* 7.转让盈亏 合计项 */public static final String TOTAL_CNY_BALANCE = "TOTAL_CNY_BALANCE";
	// -------------交易商成交日报----end

	// -------------交易商库存日报表----start
	public static final String KCMX = "_KCMX";
	public static final String KCMXFILETITLE = "交易商库存交易明细";
	/*
	 * inventory_item存货明细public static final String
	 * INVENTORY_ITEM="INVENTORY_ITEM";
	 */
	/*
	 * warehousein_item入库明细public static final String
	 * WAREHOUSEIN_ITEM="WAREHOUSEIN_ITEM";
	 */
	/*
	 * warehouseout_item出库明细public static final String
	 * WAREHOUSEOUT_ITEM="WAREHOUSEOUT_ITEM";
	 */
	public static final String INVENTORYINFO[] = { "INVENTORY_ITEM",
			"WAREHOUSEIN_ITEM", "WAREHOUSEOUT_ITEM" };
	// 表一：存货明细
	/** 表体行 */
	/* INVENTORYITEM，表体标签，需要修改 */public static final String INVENTORYITEM = "INVENTORYITEM";
	/* 1.序号public static final String SEQ="SEQ"; */
	/* 2.商品编号 */public static final String GOODS_ID = "GOODS_ID";
	/* 3.产品类别 */public static final String GOODS_CLASS = "GOODS_CLASS";
	/* 4.产品名称 */public static final String GOODS_NAME = "GOODS_NAME";
	/* 5.计量单位 */public static final String UNIT = "UNIT";
	/* 6.件数 */public static final String COUNT_GOODS = "COUNT_GOODS";
	/* 7.总实际重量 */public static final String TOTAL_ACT_QTT = "TOTAL_ACT_QTT";
	/* 8.总标准重量 */public static final String TOTAL_QTT = "TOTAL_QTT";
	/* 9.风控可用数量public static final String AVLB_QTT="AVLB_QTT"; */
	/* 10.交收可用数量 */public static final String CSG_AVLB_QTT = "CSG_AVLB_QTT";
	/* 11.已购待选货数量 */public static final String BUYED_QTT = "BUYED_QTT";
	/* 12.已售待交收数量 */public static final String SELLED_QTT = "SELLED_QTT";
	/* 13.风控冻结数量 */public static final String FRZ_QTT = "FRZ_QTT";
	/* 14.交收冻结数量 */public static final String CSG_FRZ_QTT = "CSG_FRZ_QTT";
	/* 15.锁定重量 */public static final String MKD_LOCKED_QTT = "MKD_LOCKED_QTT";
	/* 16.需要开票重量 */public static final String INVOICE_QTT = "INVOICE_QTT";
	/** 合计行 */
	/* INVENTORYITEMTOTAL 表体合计标签，需要修改 */public static final String INVENTORYITEMTOTAL = "INVENTORYITEMTOTAL";
	/* 1.件数合计项 */public static final String TOTAL_COUNT_GOODS = "TOTAL_COUNT_GOODS";
	/* 2.总实际重量(kg) 合计项 */public static final String TOTAL_TOTAL_ACT_QTT = "TOTAL_TOTAL_ACT_QTT";
	/* 3.总标准重量(kg) 合计项 */public static final String TOTAL_TOTAL_QTT = "TOTAL_TOTAL_QTT";
	/*
	 * 4.风控可用数量(kg) 合计项public static final String
	 * TOTAL_AVLB_QTT="TOTAL_AVLB_QTT";
	 */
	/* 5.交收可用数量(kg) 合计项 */public static final String TOTAL_CSG_AVLB_QTT = "TOTAL_CSG_AVLB_QTT";
	/* 6.已购待选货数量（kg) 合计项 */public static final String TOTAL_BUYED_QTT = "TOTAL_BUYED_QTT";
	/* 7.已售待交收数量（kg) 合计项 */public static final String TOTAL_SELLED_QTT = "TOTAL_SELLED_QTT";
	/* 8.风控冻结数量（kg) 合计项 */public static final String TOTAL_FRZ_QTT = "TOTAL_FRZ_QTT";
	/* 9.交收冻结数量（kg) 合计项 */public static final String TOTAL_CSG_FRZ_QTT = "TOTAL_CSG_FRZ_QTT";
	/* 10.锁定重量(kg) 合计项 */public static final String TOTAL_MKD_LOCKED_QTT = "TOTAL_MKD_LOCKED_QTT";
	/* 11.需要开票重量(kg) 合计项 */public static final String TOTAL_INVOICE_QTT = "TOTAL_INVOICE_QTT";

	// 表二：入库明细
	/** 表体行 */
	public static final String WAREHOUSEINITEM = "WAREHOUSEINITEM";
	/* 1.序号public static final String SEQ="SEQ"; */
	/* 2.入库编码 */public static final String WAREHOUSEIN_NO = "WAREHOUSEIN_NO";
	/* 3.仓库 */public static final String WAREHOUSE_ID = "WAREHOUSE_ID";
	/* 4.入库时间 */public static final String WAREHOSUEIN_DATE = "WAREHOSUEIN_DATE";
	/* 5.产品类别public static final String GOODS_CLASS="GOODS_CLASS"; */
	/* 6.产品名称public static final String GOODS_NAME="GOODS_NAME"; */
	/* 7.计量单位public static final String UNIT="UNIT"; */
	/* 8.件数 */public static final String WI_PCS = "WI_PCS";
	/* 9.实际重量 */public static final String WI_ACT_QTT = "WI_ACT_QTT";
	/* 10.标准重量 */public static final String WI_QTT = "WI_QTT";
	/* 11.毛重 */public static final String WI_GR_QTT = "WI_GR_QTT";
	/* 12.交易商确认状态 */public static final String CONFIRM_STATUS = "CONFIRM_STATUS";
	/* 13.备注 */public static final String REMARK = "REMARK";
	/** 合计行 */
	public static final String WAREHOUSEINTOTAL = "WAREHOUSEINTOTAL";
	/* 1.件数合计项 */public static final String TOTAL_WI_PCS = "TOTAL_WI_PCS";
	/* 2.实际重量(kg)合计项 */public static final String TOTAL_WI_ACT_QTT = "TOTAL_WI_ACT_QTT";
	/* 3.标准重量(kg)合计项 */public static final String TOTAL_WI_QTT = "TOTAL_WI_QTT";
	/* 4.毛重(kg) 合计项 */public static final String TOTAL_WI_GR_QTT = "TOTAL_WI_GR_QTT";

	// 表三：出库明细
	/** 表体行 */
	public static final String WAREHOUSEOUTITEM = "WAREHOUSEOUTITEM";
	/* 1.序号public static final String SEQ="SEQ"; */
	/* 2.出库单编码 */public static final String WAREHOUSEOUT_NO = "WAREHOUSEOUT_NO";
	/* 3.仓库public static final String WAREHOUSE_ID="WAREHOUSE_ID"; */
	/* 4.出库时间 */public static final String WAREHOUSEOUT_DATE = "WAREHOUSEOUT_DATE";
	/* 5.提货申请单编码 */public static final String REQ_WAREHOUSEOUT_NO = "REQ_WAREHOUSEOUT_NO";
	/* 6.产品类别public static final String GOODS_CLASS="GOODS_CLASS"; */
	/* 7.产品名称public static final String GOODS_NAME="GOODS_NAME"; */
	/* 8.计量单位public static final String UNIT="UNIT"; */
	/* 9.件数 */public static final String WO_PCS = "WO_PCS";
	/* 10.实际重量 */public static final String WO_ACT_QTT = "WO_ACT_QTT";
	/* 11.标准重量 */public static final String WO_QTT = "WO_QTT";
	/* 12.毛重 */public static final String WO_GR_QTT = "WO_GR_QTT";
	/* 13.交易商确认状态public static final String CONFIRM_STATUS="CONFIRM_STATUS"; */
	/* 14.备注public static final String REMARK="REMARK"; */
	/** 合计行 */
	public static final String WAREHOUSEOUTTOTAL = "WAREHOUSEOUTTOTAL";
	/* 1.件数合计项 */public static final String TOTAL_WO_PCS = "TOTAL_WO_PCS";
	/* 2.实际重量(kg)合计项 */public static final String TOTAL_WO_ACT_QTT = "TOTAL_WO_ACT_QTT";
	/* 3.标准重量(kg)合计项 */public static final String TOTAL_WO_QTT = "TOTAL_WO_QTT";
	/* 4.毛重(kg) 合计项 */public static final String TOTAL_WO_GR_QTT = "TOTAL_WO_GR_QTT";

	// -------------交易商库存日报表----end

	// -------------交易商风控日报表----start
	public static final String FK = "_FK";
	public static final String FKFILETITLE = "交易商风控日报表";

	public static final String INFO_CHECKITEM = "INFO_CHECKITEM";
	public static final String GOODS_CHECKITEM = "GOODS_CHECKITEM";
	public static final String DEAL_CHECKITEM = "DEAL_CHECKITEM";
	public static final String RISK_CHECKITEM = "RISK_CHECKITEM";
	/*
	 * account_info_check资金查询public static final String
	 * INVENTORY_ITEM="ACCOUNT_INFO_CHECK";
	 */
	/*
	 * inventory_goods_check货物查询public static final String
	 * WAREHOUSEIN_ITEM="INVENTORY_GOODS_CHECK";
	 */
	/*
	 * subs_deal_check担保交易订货查询public static final String
	 * WAREHOUSEOUT_ITEM="SUBS_DEAL_CHECK";
	 */
	/*
	 * goods_risk_check风险度查询public static final String
	 * WAREHOUSEOUT_ITEM="GOODS_RISK_CHECK";
	 */
	public static final String RISK_CHECK[] = { "ACCOUNT_INFO_CHECK",
			"INVENTORY_GOODS_CHECK", "SUBS_DEAL_CHECK", "GOODS_RISK_CHECK" };
	// 表一：资金查询
	/** 表体行 */
	/* 1.序号public static final String SEQ="SEQ"; */
	/* 2.资金余额 */public static final String BALANCE_FUND = "BALANCE_FUND";
	/* 3.风控可用额 */public static final String AVLB_FUND = "AVLB_FUND";
	/* 4.交收可用额 */public static final String AVLB_CSG_FUND = "AVLB_CSG_FUND";
	/* 5.当日入金 */public static final String IN_AMOUNT = "IN_AMOUNT";
	/* 6.当日出金 */public static final String OUT_AMOUNT = "OUT_AMOUNT";
	/* 7.当日费用 */public static final String POUNDAGE = "POUNDAGE";
	/* 8.当日转让盈亏 */public static final String CNY_BALANCE = "CNY_BALANCE";
	/* 9.合同担保占用 */public static final String OCCP_DEPOSIT = "OCCP_DEPOSIT";
	/* 10.报单冻结 */public static final String FRZ_ORD_FUND = "FRZ_ORD_FUND";
	/* 11.其它风控冻结 */public static final String FRZ_RISK_FUND = "FRZ_RISK_FUND";
	/* 12.浮动盈亏 */public static final String ACCT_BALANCE = "ACCT_BALANCE";
	/* 13.交收冻结 */public static final String FRZ_CSG_FUND = "FRZ_CSG_FUND";

	// 表二：货物查询
	/** 表体行 */
	/* 1.序号public static final String SEQ="SEQ"; */
	/* 2.产品名称 public static final String GOODS_NAME = "GOODS_NAME"; */
	/* 3.产品总数量 public static final String TOTAL_ACT_QTT = "TOTAL_ACT_QTT"; */
	/* 4.风控可用量 public static final String AVLB_QTT = "AVLB_QTT"; */
	/* 5.交收可用量public static final String CSG_AVLB_QTT="CSG_AVLB_QTT"; */
	/* 6.在库库存标数 */public static final String MKD_QTT = "MKD_QTT";
	/* 7.在库库存实数 */public static final String MKD_ACT_QTT = "MKD_ACT_QTT";
	/* 8.在库件数 */public static final String PCS = "PCS";
	/* 9.已购待选货数量 public static final String BUYED_QTT = "BUYED_QTT"; */
	/* 10.已售待交货数量 public static final String SELLED_QTT = "SELLED_QTT"; */
	/* 11.风控冻结数量 public static final String FRZ_QTT = "FRZ_QTT";*/
	/* 12.交收冻结数量 public static final String CSG_FRZ_QTT = "CSG_FRZ_QTT"; */

	// 表三：担保交易订货查询
	/** 表体行 */
	/* 1.序号public static final String SEQ="SEQ"; */
	/* 2.合同编码public static final String CONTRACT_ID = "CONTRACT_ID"; */
	/* 3.买卖方向 */public static final String BUYORSELL = "BUYORSELL";
	/* 4.资金担保订货量 */public static final String LEFT_QTT_FUND = "LEFT_QTT_FUND";
	/* 5.货物担保订货量 */public static final String LEFT_QTT_GOODS = "LEFT_QTT_GOODS";
	/* 6.订货量 */public static final String LEFT_QTT_DPST = "LEFT_QTT_DPST";
	/* 7.账面价差 */public static final String DEAL_SOURCE = "DEAL_SOURCE";
	/* 8.金额 */public static final String SUBS_BALANCE = "SUBS_BALANCE";

	// 表四：风险度查询
	/** 表体行 */
	/* 1.序号public static final String SEQ="SEQ"; */
	/* 2.风险度 */public static final String RISK_RATIO = "RISK_RATIO";
	/* 3.可用资产总值 */public static final String AVLB_ASSETS = "AVLB_ASSETS";
	/* 4.担保占用资产总值 */public static final String FRZ_RISK_ASSETS = "FRZ_RISK_ASSETS";
	/* 5.可用担保资金 public static final String AVLB_FUND = "AVLB_FUND"; */
	/* 6.报单冻结public static final String FRZ_RISK_FUND="FRZ_RISK_FUND"; */
	/* 7.定金占用public static final String OCCP_DEPOSIT="OCCP_DEPOSIT"; */
	/* 8.其它风控冻结资金public static final String FRZ_ORD_FUND="FRZ_ORD_FUND"; */
	/* 9.可用担保商品价值 */public static final String AVLB_GOODS_VALUE = "AVLB_GOODS_VALUE";
	/* 10.担保占用商品价值 */public static final String DEAL_QTT = "DEAL_QTT";
	/* 11.应追交资金数额 */public static final String ADDITIONAL_FUND = "ADDITIONAL_FUND";
	// -------------交易商风控日报表----end
	// -------------交易商已付款待选货明细清单----start
	public static final String DXHMX = "_DXHMX";
	public static final String DXHMXFILETITLE = "交易商已付款待选货明细清单";
	/* csg_order_item */public static final String CSGORDERITEM[] = { "CSG_ORDER_ITEM" };
	// 表一：已付款待选货明细查询
	/** 表体行 */
	/* 1.序号 */public static final String SEQ = "SEQ";
	/* 2.合同编码 */public static final String CONTRACT_ID = "CONTRACT_ID";
	/* 3.买卖方向 public static final String BUYORSELL = "BUYORSELL"; */
	/* 4.可选数量 */public static final String AVLB_QTT = "AVLB_QTT";
	/* 5.已选数量 */public static final String PICKED_QTT = "PICKED_QTT";
	/* 6.金额 */public static final String AVLB_AMT = "AVLB_AMT";
	/** 合计行 */
	/* 1.可选数量合计 */public static final String TOTAL_AVLB_QTT = "TOTAL_AVLB_QTT";
	/* 2.已选数量合计 */public static final String TOTAL_PICKED_QTT = "TOTAL_PICKED_QTT";
	/* 3.金额合计 */public static final String TOTAL_AVLB_AMT = "TOTAL_AVLB_AMT";
	// -------------交易商已付款待选货明细清单----end

	// -------------交易商款项清单日报表----start
	public static final String NKX = "_NKX";
	public static final String NKXFILETITLE = "交易商款项清单日报表";
	public static final String NKXITEM[] = { "ITEM" };
	/* 一、上日静态权益 */public static final String LAST_TOTAL_RIGHT = "LAST_TOTAL_RIGHT";
	/* 上日可用资金 */public static final String LAST_AVLB_FUND = "LAST_AVLB_FUND";
	/* (+)当日入金 */public static final String CUR_IN_FUND = "CUR_IN_FUND";
	/* (-)当日出金 */public static final String CUR_OUT_FUND = "CUR_OUT_FUND";
	/* (-)当日交易手续费 */public static final String CUR_POUNDAGE = "CUR_POUNDAGE";
	/* (-)当日交收手续费 */public static final String CUR_CSG_FEE = "CUR_CSG_FEE";
	/* (-)当日质押手续费 */public static final String CUR_LOAN_POUNDAGE = "CUR_LOAN_POUNDAGE";
	/* (-)当日利息 */public static final String CUR_LOAN_INTEREST = "CUR_LOAN_INTEREST";
	/* (-)当日违约金 */public static final String CUR_DISOBEY_FEE = "CUR_DISOBEY_FEE";
	/* 使用XSL计算的元素 OUT_DISOBEY_FEE违约出金，违约入金 */
	// --------------------------------------------------------------
	public static final String OUT_DISOBEY_FEE = "OUT_DISOBEY_FEE";
	public static final String IN_DISOBEY_FEE = "IN_DISOBEY_FEE";
	// ----------------------------------------------------------------
	/* (+)返还佣金 */public static final String RET_POUNDAGE = "RET_POUNDAGE";
	/* (+)当日收到货款 */public static final String GOT_PAYMENT = "GOT_PAYMENT";
	/* (-)当日付出货款 */public static final String PAID_PAYMENT = "PAID_PAYMENT";
	/* (-)买方退补货款 */public static final String CUR_BUYER_DIFF = "CUR_BUYER_DIFF";
	/* (+)当日转让盈亏 */public static final String CNY_INCOME = "CNY_INCOME";
	/* (+)当日交收盈亏 */public static final String CSG_INCOME = "CSG_INCOME";
	/* 上日还款总额 */public static final String LAST_REPAY_SUM = "LAST_REPAY_SUM";
	/* 当日还款总额 */public static final String CUR_REPAY_SUM = "CUR_REPAY_SUM";
	/* (-)上日贷款余额 */public static final String LAST_LOAN_BALANCE = "LAST_LOAN_BALANCE";
	/* (+)当日贷款余额 */public static final String CUR_LOAN_BALANCE = "CUR_LOAN_BALANCE";
	/* 其他 */public static final String OTHER = "OTHER";
	/* 二.当日静态权益 */public static final String TOTAL_RIGHT = "TOTAL_RIGHT";
	/*
	 * (+)当日账面价差 public static final String ACCT_BALANCE = "ACCT_BALANCE"; =
	 * 浮动盈亏？
	 */
	/* 三. 当日动态权益 */public static final String DYNAMIC_RIGHT = "DYNAMIC_RIGHT";
	/* 四、风险控制 */public static final String RISK_MANAGEMENT = "RISK_MANAGEMENT";
	/* (-)报单冻结 public static final String FRZ_ORD_FUND = "FRZ_ORD_FUND"; */
	/* (-)当日定金占用 */public static final String SUBS_DEPOSIT = "SUBS_DEPOSIT";
	/* (-)当日其它风控占用 public static final String FRZ_RISK_FUND = "FRZ_RISK_FUND"; */
	/* 风控可用余额 */public static final String RISK_AVLB_BALN = "RISK_AVLB_BALN";
	/* 五、交收 */public static final String CSG = "CSG";
	/* (-)当日交收冻结 public static final String CSG_FRZ_QTT = "CSG_FRZ_QTT"; */
	/* 交收可用余额 */public static final String CSG_AVLB_BALN = "CSG_AVLB_BALN";
	/* 六、可提款余额 */public static final String CASH_AVLB_BALN = "CASH_AVLB_BALN";
	/* 七.当日应追交资金数额 */public static final String APP_FUND = "APP_FUND";
	// -------------交易商款项清单日报表----end
}
