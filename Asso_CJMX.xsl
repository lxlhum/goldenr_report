<?xml version="1.0" encoding="gb2312"?>
<!-- 黄总：成交明细表不予以展示 屏蔽掉（2015/09/14） -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="html" indent="no" encoding="GBK"/>
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
                    <H2>交易商成交日报清单</H2>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td>
              <table border="0" align="center" width="1300px" cellpadding="0" cellspacing="1" bgcolor="cccccc">
                <tr>
                  <td height="20" valign="middle" bgcolor="#FFFFFF">
                    <table width="100%" height="30" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <xsl:for-each select="top/item" >
                          <xsl:choose>
                            <xsl:when test="position() = 1">
                              <td align="right" valign="middle">会员编码:</td>
                            </xsl:when>
                            <xsl:when test="position() = 2">
                              <td align="right" valign="middle">会员名称:</td>
                            </xsl:when>
                            <xsl:when test="position() = 3">
                              <td align="right" valign="middle">日期:</td>
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

                <!-- 连续/挂牌/协议成交明细 -->
                <xsl:if test="count(body/listing_deal/item) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">连续/挂牌/协议成交明细</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodyhead"/>
                        </tr>
                        <xsl:for-each select="body/listing_deal/item" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                        <tr>
                          <xsl:apply-templates select="body/listing_deal/total" />
                        </tr>
                      </table>
                    </td>
                  </tr>
                </xsl:if>

                <!-- 隔日组合成交明细 -->
                <xsl:if test="count(body/spread_deal/item) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">隔日组合成交明细</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodyhead"/>
                        </tr>
                        <xsl:for-each select="body/spread_deal/item" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                        <tr>
                          <xsl:apply-templates select="body/spread_deal/total" />
                        </tr>
                      </table>
                    </td>
                  </tr>
                </xsl:if>

                <!-- 定制组合成交明细 -->
                <xsl:if test="count(body/spreadlisting_deal/item) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">定制组合成交明细</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodyhead"/>
                        </tr>
                        <xsl:for-each select="body/spreadlisting_deal/item" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                        <tr>
                          <xsl:apply-templates select="body/spreadlisting_deal/total" />
                        </tr>
                      </table>
                    </td>
                  </tr>
                </xsl:if>

                <!-- 已付款合同选货展期交易明细 -->
                <xsl:if test="count(body/csgdelaying_deal/item) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">已付款合同选货展期交易明细</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodyhead"/>
                        </tr>
                        <xsl:for-each select="body/csgdelaying_deal/item" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                        <tr>
                          <xsl:apply-templates select="body/csgdelaying_deal/total" />
                        </tr>
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

  <!-- 表体头 -->
  <xsl:template name="bodyhead">
    <td bgcolor="#FFFFFF">
      <p align="center">序号</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">合同编码</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">产品名称</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">买卖方向</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">成交类型</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">成交价格</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">成交数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">资金担成交量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">货物担保成交量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">成交金额</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">手续费</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">资金占用</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">货物占用</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">转让盈亏</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">成交来源</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">成交单号</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">成交时间</p>
    </td>
  </xsl:template>

  <!--  表体行 -->
  <xsl:template match="item">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/><!-- 序号 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="CONTRACT_ID"/><!-- 合同编码 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="GOODS_NAME"/><!-- 产品名称 -->
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
    <xsl:choose>
      <xsl:when test="DEAL_TYPE = '1'"><!-- 成交类型 -->
        <td bgcolor="#FFFFFF">
          <p align="center">订货</p>
        </td>
      </xsl:when>
      <xsl:when test="DEAL_TYPE = '20'">
        <td bgcolor="#FFFFFF">
          <p align="center">转让</p>
        </td>
      </xsl:when>
      <xsl:when test="DEAL_TYPE = '21'">
        <td bgcolor="#FFFFFF">
          <p align="center">平今</p>
        </td>
      </xsl:when>
      <xsl:when test="DEAL_TYPE = '22'">
        <td bgcolor="#FFFFFF">
          <p align="center">平昨</p>
        </td>
      </xsl:when>
      <xsl:when test="DEAL_TYPE = '3'">
        <td bgcolor="#FFFFFF">
          <p align="center">强制转让</p>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <td bgcolor="#FFFFFF">
          <p align="center">其它</p>
        </td>
      </xsl:otherwise>
    </xsl:choose>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="DEAL_PRICE"/><!-- 成交价格 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="DEAL_QTT"/><!-- 成交数量 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT_FUND"/><!-- 资金担保订货量 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT_GOODS"/><!-- 货物担保订货量 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="DEAL_AMT"/><!-- 成交金额 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="POUNDAGE"/><!-- 手续费 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="DEAL_DEPOSIT"/><!-- 资金占用 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="RISK_RCPT"/><!-- 货物占用 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="CNY_BALANCE"/><!-- 转让盈亏 -->
      </p>
    </td>
    <xsl:choose>
      <xsl:when test="SOURCE_FLAG = '00'"><!-- 成交来源 -->
        <td bgcolor="#FFFFFF">
          <p align="center">连续交易</p>
        </td>
      </xsl:when>
      <xsl:when test="SOURCE_FLAG = '01'">
        <td bgcolor="#FFFFFF">
          <p align="center">协议转让</p>
        </td>
      </xsl:when>
      <xsl:when test="SOURCE_FLAG = '02'">
        <td bgcolor="#FFFFFF">
          <p align="center">协议订货</p>
        </td>
      </xsl:when>
      <xsl:when test="SOURCE_FLAG = '1'">
        <td bgcolor="#FFFFFF">
          <p align="center">挂牌/摘牌</p>
        </td>
      </xsl:when>
      <xsl:when test="SOURCE_FLAG = '2'">
        <td bgcolor="#FFFFFF">
          <p align="center">隔日组合主动申报</p>
        </td>
      </xsl:when>
      <xsl:when test="SOURCE_FLAG = '3'">
        <td bgcolor="#FFFFFF">
          <p align="center">隔日组合系统申报</p>
        </td>
      </xsl:when>
      <xsl:when test="SOURCE_FLAG = '4'">
        <td bgcolor="#FFFFFF">
          <p align="center">定制组合挂牌/摘牌</p>
        </td>
      </xsl:when>
      <xsl:when test="SOURCE_FLAG = '5'">
        <td bgcolor="#FFFFFF">
          <p align="center">强制转让</p>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <td bgcolor="#FFFFFF">
          <p align="center"></p>
        </td>
      </xsl:otherwise>
    </xsl:choose>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="DEAL_NO"/><!-- 成交单号 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="DEAL_TIME"/><!-- 成交时间 -->
      </p>
    </td>
  </xsl:template>
  
  <!--  合计行 -->
  <xsl:template match="total">
    <td colspan="6" bgcolor="#FFFFFF">
      <p align="left">合计</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_DEAL_QTT"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_AVLB_QTT_FUND"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_AVLB_QTT_GOODS"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_DEAL_AMT"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_POUNDAGE"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_DEAL_DEPOSIT"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_RISK_RCPT"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_CNY_BALANCE"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF" colspan="3"></td>
  </xsl:template>
</xsl:stylesheet>
