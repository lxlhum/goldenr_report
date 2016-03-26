<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="html" indent="no" encoding="GBK"/>
  <xsl:decimal-format name="CNY" decimal-separator="." grouping-separator=","/>
  <!-- <xsl:include href="../include.xsl"/> -->
  <xsl:template match="root">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
        <title>
          <xsl:value-of select="file_title"/>
        </title>
      </head>

      <body>
        <table align="center">
          <tr>
            <td>
              <table align="center" width="100%" border="0" >
                <!-- <xsl:call-template name="head"/> -->
                <tr>
                  <td align="center">
                    <H2>交易商风控日报表</H2><!--格式修改-标题太小-->
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td>
              <table border="0" align="center" cellpadding="0" width="1200px" cellspacing="1" bgcolor="cccccc">
                <tr>
                  <td height="20" valign="middle" bgcolor="#FFFFFF">
                    <table width="100%" height="30" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <xsl:for-each select="top/item" >
                          <xsl:choose>
                            <xsl:when test="position() = 1">
                              <td align="right" valign="middle">会员编码：</td>
                            </xsl:when>
                            <xsl:when test="position() = 2">
                              <td align="right" valign="middle">会员名称：</td>
                            </xsl:when>
                            <xsl:when test="position() = 3">
                              <td align="right" valign="middle">日期：</td>
                            </xsl:when>
                          </xsl:choose>
                          <td align="left" valign="middle">
                            <xsl:value-of select="content"/>
                          </td>
                        </xsl:for-each>
                      </tr>
                    </table>
                  </td>
                </tr>

                <!-- 资金查询 -->
                <xsl:if test="count(body/account_info_check/info_checkitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">资金查询</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodyhead_info_check"/>
                        </tr>
                        <xsl:for-each select="body/account_info_check/info_checkitem" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </td>
                  </tr>
                </xsl:if>

                <!-- 货物查询 -->
                <xsl:if test="count(body/inventory_goods_check/goods_checkitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">货物查询</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodyhead_goods_check"/>
                        </tr>
                        <xsl:for-each select="body/inventory_goods_check/goods_checkitem" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </td>
                  </tr>
                </xsl:if>

                <!-- 担保交易订货查询 -->
                <xsl:if test="count(body/subs_deal_check/deal_checkitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">担保交易订货查询</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodyhead_deal_check"/>
                        </tr>
                        <xsl:for-each select="body/subs_deal_check/deal_checkitem" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </td>
                  </tr>
                </xsl:if>
                
                <!-- 风险度查询 -->
                <xsl:if test="count(body/goods_risk_check/risk_checkitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">风险度查询</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodyhead_risk_check"/>
                        </tr>
                        <xsl:for-each select="body/goods_risk_check/risk_checkitem" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </td>
                  </tr>
                </xsl:if>
              </table>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>

  <!-- 资金查询 表体头 -->
  <xsl:template name="bodyhead_info_check">
    <td bgcolor="#FFFFFF">
      <p align="center">序号</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">资金余额</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">风控可用额</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">交收可用额</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">当日入金</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">当日出金</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">当日费用</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">当日转让盈亏</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">合同担保占用</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">报单冻结</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">其它风控冻结</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">浮动盈亏</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">交收冻结</p>
    </td>
  </xsl:template>
  
  <!-- 资金查询 表体行 -->
  <xsl:template match="info_checkitem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
      </p>
    </td>
    <!-- 资金余额 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(BALANCE_FUND,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="BALANCE_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="BALANCE_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(BALANCE_FUND,'#,##0.00','CNY')"/>
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!--风控可用额 数字 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(AVLB_RISK_FUND,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="AVLB_RISK_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="AVLB_RISK_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(AVLB_RISK_FUND,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>

    <!--交收可用额  avlb表示可用-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(AVLB_CSG_FUND,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="AVLB_CSG_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="AVLB_CSG_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(AVLB_CSG_FUND,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--当日入金  金额格式化两位-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(CUR_IN_FUND,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="CUR_IN_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="CUR_IN_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(CUR_IN_FUND,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--当日出金 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(CUR_OUT_FUND,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="CUR_OUT_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="CUR_OUT_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(CUR_OUT_FUND,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--当日费用 【 需要通过代码调用】 此处不在SQL中进行查询-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
       <xsl:value-of select="format-number(CUR_POUNDAGE,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="CUR_POUNDAGE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="CUR_POUNDAGE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(CUR_POUNDAGE,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 当日转让盈亏  【 需要通过代码调用】 此处不在SQL中进行查询 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
       <xsl:value-of select="format-number(CNY_BALANCE,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="CNY_BALANCE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="CNY_BALANCE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(CNY_BALANCE,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--合同担保占用  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(SUBS_DEPOSIT,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="SUBS_DEPOSIT = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="SUBS_DEPOSIT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(SUBS_DEPOSIT,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--报单冻结  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
       <xsl:value-of select="format-number(FRZ_ORD_FUND,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="FRZ_ORD_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="FRZ_ORD_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(FRZ_ORD_FUND,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--其它风控冻结  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(FRZ_RISK_FUND,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="FRZ_RISK_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="FRZ_RISK_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(FRZ_RISK_FUND,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--浮动盈亏 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(ACCT_BALANCE,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="ACCT_BALANCE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="ACCT_BALANCE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(ACCT_BALANCE,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--交收冻结  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(FRZ_CSG_FUND,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="FRZ_CSG_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="FRZ_CSG_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(FRZ_CSG_FUND,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
   <!-- 货物查询 表体头 -->
  <xsl:template name="bodyhead_goods_check">
    <td bgcolor="#FFFFFF">
      <p align="center">序号</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">商品名称</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">商品总数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">风控可用量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">交收可用量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">在库库存标数</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">在库库存实数</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">在库件数</p>
    </td>
     <td bgcolor="#FFFFFF">
      <p align="center">已申请未提货数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">已购待选货数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">已售待交货数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">风控冻结数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">交收冻结数量</p>
    </td>
  </xsl:template>
  
  <!--  货物查询 表体行 -->
  <xsl:template match="goods_checkitem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="GOODS_NAME"/>
      </p>
    </td>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_ACT_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_ACT_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_ACT_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_ACT_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="AVLB_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="AVLB_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="AVLB_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="CSG_AVLB_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="CSG_AVLB_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="CSG_AVLB_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="CSG_AVLB_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="MKD_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="MKD_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="MKD_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="MKD_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="MKD_ACT_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="MKD_ACT_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="MKD_ACT_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="MKD_ACT_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="PCS"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="PCS = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="PCS != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="PCS"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor='#FFFFFF'>
    	<p align="right">
    		<xsl:value-of select="MKD_FRZ_QTT"/>
    	</p>
    </td>-->
    <xsl:choose>
      <xsl:when test="MKD_FRZ_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="MKD_FRZ_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="MKD_FRZ_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="BUYED_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="BUYED_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="BUYED_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="BUYED_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="SELLED_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="SELLED_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="SELLED_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="SELLED_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="FRZ_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="FRZ_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="FRZ_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="FRZ_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="CSG_FRZ_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="CSG_FRZ_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="CSG_FRZ_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="CSG_FRZ_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
   <!-- 担保交易订货查询 表体头 -->
  <xsl:template name="bodyhead_deal_check">
    <td bgcolor="#FFFFFF">
      <p align="center">序号</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">合同编码</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">买卖方向</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">资金担保订货量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">货物担保订货量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">订货量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">浮动盈亏</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">金额</p>
    </td>
  </xsl:template>

  <!-- 担保交易订货查询 表体行 -->
  <xsl:template match="deal_checkitem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="CONTRACT_ID"/><!-- 合同编码 -->
      </p>
    </td>
    <xsl:choose>
      <xsl:when test="BUYORSELL = '1'"><!-- 买卖方向 -->
        <td bgcolor="#FFFFFF">
          <p align="center">买入</p>
        </td>
      </xsl:when>
      <xsl:when test="BUYORSELL = '2'">
        <td bgcolor="#FFFFFF">
          <p align="center">卖出</p>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT_FUND"/> 资金担保订货量 
      </p>
    </td> -->
    <xsl:choose>
      <xsl:when test="AVLB_QTT_FUND = '0'">
        <td bgcolor="#FFFFFF">
          <p>

          </p>
        </td>
      </xsl:when>
      <xsl:when test="AVLB_QTT_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <p>
            <xsl:value-of select="AVLB_QTT_FUND"/>
            <!-- 资金担保订货量 -->
          </p>
        </td>
      </xsl:when>

    </xsl:choose>
    <!-- <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT_GOODS"/> 货物担保订货量
      </p>
    </td> -->
    
    <xsl:choose>
      <xsl:when test="AVLB_QTT_GOODS = '0'">
        <td bgcolor="#FFFFFF">
          <p>
            
          </p>
        </td>
      </xsl:when>
      <xsl:when test="AVLB_QTT_GOODS != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <p>
            <xsl:value-of select="AVLB_QTT_GOODS"/>
            <!-- 货物担保订货量 -->
          </p>
        </td>
      </xsl:when>
      
    </xsl:choose>
    
    <!-- <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT"/> 担保订货量 
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="AVLB_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p>

          </p>
        </td>
      </xsl:when>
      <xsl:when test="AVLB_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <p>
            <xsl:value-of select="AVLB_QTT"/>
            <!-- 货物担保订货量 -->
          </p>
        </td>
      </xsl:when>

    </xsl:choose>
    <!-- <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(FLOATING_BANLANCE,'#,###0.00','CNY')"/>账面价差 
      </p>
    </td> -->
    <xsl:choose>
      <xsl:when test="FLOATING_BANLANCE = '0'">
        <!-- 账面价差 -->
        <td bgcolor="#FFFFFF">
          <p align="center">
            
          </p>
        </td>
      </xsl:when>
      <xsl:when test="FLOATING_BANLANCE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(FLOATING_BANLANCE,'#,##0.00','CNY')"/>
          <!-- 账面价差 -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(TOTAL_COST,'#,###0.00','CNY')"/> 金额（建仓成本）
      </p>
    </td> -->

    <xsl:choose>
      <xsl:when test="TOTAL_COST = '0'">
        <!-- 金额（建仓成本） -->
        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_COST != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(TOTAL_COST,'#,##0.00','CNY')"/>
          <!-- 金额（建仓成本） -->
        </td>
      </xsl:when>
    </xsl:choose>
    
  </xsl:template>
  
   <!-- 风险度查询 表体头 -->
  <xsl:template name="bodyhead_risk_check">
    <td bgcolor="#FFFFFF">
      <p align="center">序号</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">风险度</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">可用资产总值</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">担保占用资产总值</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">可用担保资金</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">报单冻结</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">定金占用</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">其它风控冻结资金</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">可用担保商品价值</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">担保占用商品价值</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">应追交资金数额</p>
    </td>
  </xsl:template>

  <!-- 风险度查询 表体行 -->
  <xsl:template match="risk_checkitem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/><!-- 序号 -->
      </p>
    </td>
       <xsl:if test="ALLVALUE = 0 and FRZ_RISK_ASSETS !=0">
      		<td bgcolor="#FF3030">
      		<p align="right">
      		<xsl:value-of select="BIG"/>
      		</p>
      		</td>
      	</xsl:if>
      	<xsl:if test="ALLVALUE = 0 and FRZ_RISK_ASSETS = 0">
      		<td bgcolor="#FFFFFF">
      		<p align="right">
      		<xsl:value-of select="SMALLL"/>
      		</p>
      		</td>
      	</xsl:if>
      	<xsl:if test="ALLVALUE > 0 and FRZ_RISK_ASSETS = 0">
      		<td bgcolor="#FFFFFF">
      		<p align="right">
      		<xsl:value-of select="SMALLL"/>
      		</p>
      		</td>
      	</xsl:if>
      	<xsl:if test="ALLVALUE > 0 and FRZ_RISK_ASSETS != 0">
      		<td bgcolor="#FFFFFF">
      	  <p align="right">
             <xsl:value-of select="format-number((FRZ_RISK_ASSETS div ALLVALUE)*100,'##.##%')"/>
          </p>      		
          </td>
      	</xsl:if>	 	
       <!--  <xsl:value-of select="RISK_RATIO"/>风险度 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(AVLB_ASSETS,'#,###0.00','CNY')"/> 可用资产总值 
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="AVLB_ASSETS = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="AVLB_ASSETS != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(AVLB_ASSETS,'#,##0.00','CNY')"/>
          <!-- 可用资产总值 -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!-- <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(FRZ_RISK_ASSETS,'#,###0.00','CNY')"/>担保占用资产总值
      </p>
    </td> -->
    <xsl:choose>
      <xsl:when test="FRZ_RISK_ASSETS = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="FRZ_RISK_ASSETS != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(FRZ_RISK_ASSETS,'#,##0.00','CNY')"/>
          <!-- 担保占用资产总值 -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(AVLB_FUND,'#,###0.00','CNY')"/> 可用担保资金 
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="AVLB_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="AVLB_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(AVLB_FUND,'#,##0.00','CNY')"/>
          <!-- 可用担保资金 -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
       <xsl:value-of select="format-number(FRZ_ORD_FUND,'#,###0.00','CNY')"/> 报单冻结
      </p>
    </td> -->
    <xsl:choose>
      <xsl:when test="FRZ_ORD_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="FRZ_ORD_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(FRZ_ORD_FUND,'#,##0.00','CNY')"/>
          <!-- 报单冻结 -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(OCCP_DEPOSIT,'#,###0.00','CNY')"/> 定金占用 
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="OCCP_DEPOSIT = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="OCCP_DEPOSIT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(OCCP_DEPOSIT,'#,##0.00','CNY')"/>
          <!-- 定金占用 -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(FRZ_RISK_FUND,'#,###0.00','CNY')"/> 其它风控冻结资金
      </p>
    </td> -->
    <xsl:choose>
      <xsl:when test="FRZ_RISK_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="FRZ_RISK_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(FRZ_RISK_FUND,'#,##0.00','CNY')"/>
          <!-- 其它风控冻结资金 -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!-- <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(AVLB_GOODS_VALUE,'#,###0.00','CNY')"/> 可用担保商品价值 
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="AVLB_GOODS_VALUE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="AVLB_GOODS_VALUE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(AVLB_GOODS_VALUE,'#,##0.00','CNY')"/>
          <!-- 可用担保商品价值 -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!-- <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(RISK_GOODS_VALUE,'#,###0.00','CNY')"/> 担保占用商品价值
      </p>
    </td> -->
    <xsl:choose>
      <xsl:when test="RISK_GOODS_VALUE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="RISK_GOODS_VALUE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(RISK_GOODS_VALUE,'#,##0.00','CNY')"/>
          <!-- 担保占用商品价值 -->

        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(ADDITIONAL_FUND,'#,###0.00','CNY')"/>应追交资金数额
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="ADDITIONAL_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="ADDITIONAL_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(ADDITIONAL_FUND,'#,##0.00','CNY')"/>
          <!--应追交资金数额-->

        </td>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
