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
                    <H2>订货查询（新）</H2><!--格式修改-标题太小-->
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

                <!-- 订货查询 dh  -->
                <xsl:if test="count(body/dhbodyitem/dhitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">订货查询</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodydh_check"/>
                        </tr>
                        <xsl:for-each select="body/dhbodyitem/dhitem" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                      </table>
                    </td>
                  </tr>
                </xsl:if>

                <!-- 订货查询明细 dhmx -->
                <xsl:if test="count(body/dhmxbodyitem/dhmxitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">订货查询明细</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodydhmx_check"/>
                        </tr>
                        <xsl:for-each select="body/dhmxbodyitem/dhmxitem" >
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

  <!-- 订货查询 表体头 -->
  <xsl:template name="bodydh_check">
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
      <p align="center">订货均价</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">结算价格</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">最新价</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">订货总量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">资金担保订货量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">货物担保订货量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">资金占用</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">货物占用</p>
    </td>   
    <td bgcolor="#FFFFFF">
      <p align="center">浮动盈亏</p>
    </td>
    
  </xsl:template>
  
  <!-- 订货查询 表体行 -->
  <xsl:template match="dhitem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
      </p>
    </td>
    <!-- 合同编码 -->
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="CONTRACT_ID"/>
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
    <!-- 订货均价 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(AVG_ORIGIN_PRICE,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="AVG_ORIGIN_PRICE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="AVG_ORIGIN_PRICE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(AVG_ORIGIN_PRICE,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--结算价格-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
       <xsl:value-of select="format-number(SETTLE_PRICE,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="SETTLE_PRICE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="SETTLE_PRICE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(SETTLE_PRICE,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 最新价  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
       <xsl:value-of select="format-number(END_PRICE,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="END_PRICE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="END_PRICE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(END_PRICE,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--订货总量 -->
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
    <!--资金担保订货量 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT_FUND"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="AVLB_QTT_FUND = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="AVLB_QTT_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="AVLB_QTT_FUND"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 货物担保订货量 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT_GOODS"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="AVLB_QTT_GOODS = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="AVLB_QTT_GOODS != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="AVLB_QTT_GOODS"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--合同占用  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
       <xsl:value-of select="format-number(DEPOSIT_FUND,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="DEPOSIT_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="DEPOSIT_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(DEPOSIT_FUND,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 货物占用  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="DEPOSIT_GOODS"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="DEPOSIT_GOODS = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="DEPOSIT_GOODS != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="DEPOSIT_GOODS"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 浮动盈亏  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
       <xsl:value-of select="format-number(FLOATING_BANLANCE,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="FLOATING_BANLANCE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="FLOATING_BANLANCE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(FLOATING_BANLANCE,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
   
   <!-- 订货明细 表体头 -->
  <xsl:template name="bodydhmx_check">
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
      <p align="center">订货价格</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">结算价格</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">最新价</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">订货总量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">资金担保订货量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">货物担保订货量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">资金占用</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">货物占用</p>
   </td>
    <td bgcolor="#FFFFFF">
      <p align="center">浮动盈亏</p>
    </td>
  </xsl:template>
  
  <!--  订货明细 表体行 -->
  <xsl:template match="dhmxitem">
  	<!-- 序号  -->
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
      </p>
    </td>
    <!-- 合同编码  -->
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="CONTRACT_ID"/>
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
    <!-- 订货价格  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
       <xsl:value-of select="format-number(DEAL_PRICE,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="DEAL_PRICE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="DEAL_PRICE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(DEAL_PRICE,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 结算价格  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(SETTLE_PRICE,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="SETTLE_PRICE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="SETTLE_PRICE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(SETTLE_PRICE,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 最新价 -->
    <!--<td bgcolor="#FFFFFF">
    	<p align="right">
    		<xsl:value-of select="format-number(END_PRICE,'#,###0.00','CNY')"/>
    	</p>
    </td>-->
    <xsl:choose>
      <xsl:when test="END_PRICE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="END_PRICE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(END_PRICE,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 订货总量  -->
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
    <!-- 资金担保订货量  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT_FUND"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="AVLB_QTT_FUND = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="AVLB_QTT_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="AVLB_QTT_FUND"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 货物担保订货量  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT_GOODS"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="AVLB_QTT_GOODS = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="AVLB_QTT_GOODS != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="AVLB_QTT_GOODS"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 合同占用  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(DEPOSIT_FUND,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="DEPOSIT_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="DEPOSIT_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(DEPOSIT_FUND,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 货物占用  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="DEPOSIT_GOODS"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="DEPOSIT_GOODS = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="DEPOSIT_GOODS != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="DEPOSIT_GOODS"/>
        </td>
      </xsl:when>
    </xsl:choose>
   
    <!--浮动盈亏  -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(FLOATING_BANLANCE,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="FLOATING_BANLANCE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="FLOATING_BANLANCE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(FLOATING_BANLANCE,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
  </xsl:template> 
</xsl:stylesheet>
