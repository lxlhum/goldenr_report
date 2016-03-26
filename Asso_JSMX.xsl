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
                    <H2>交收申报日报表</H2><!--格式修改-标题太小-->
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td>
              <table border="0" align="center" cellpadding="0" width="700px"  cellspacing="1" bgcolor="cccccc">
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

                <!-- 交收申报日报表 -->
                <xsl:if test="count(body/csg_order_item/item) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">交收申报日报表</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodyhead"/>
                        </tr>
                        <xsl:for-each select="body/csg_order_item/item" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                        <tr>
                          <xsl:apply-templates select="body/csg_order_item/total" />
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

  <!-- 已付款待选货明细查询 表体头 -->
  <xsl:template name="bodyhead">
    <td bgcolor="#FFFFFF">
      <p align="center">序号</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">报单号</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">买卖方向</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">合同编码</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">申报价格</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">申报数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">已交收待选货数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">报单状态</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">结算日</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">交收数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">已选货数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">交收转组合申报数量</p>
    </td>
  </xsl:template>
  
  <!-- 交收申报日报表 表体行 -->
  <xsl:template match="item"><!-- 此处item要与xml中对应的item名字一致 -->
  <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/><!-- 序号 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="ORDER_NO"/><!-- 报单号 -->
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
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="CONTRACT_ID"/><!-- 合同编码 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(ORDER_PRICE,'#,###0.00','CNY')"/><!-- 申报价格 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="ORDER_QTT"/><!-- 申报数量 -->
      </p>
    </td>
        <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="L_R_QTT"/><!-- 已交收待选货数量 -->
      </p>
    </td>
    
    
    <xsl:choose>
      <xsl:when test="STATUS = '1'"><!-- 报单状态 -->
        <td bgcolor="#FFFFFF">
          <p align="center">申报</p>
        </td>
      </xsl:when>
      <xsl:when test="STATUS = '2'">
        <td bgcolor="#FFFFFF">
          <p align="center">待交收</p>
        </td>
      </xsl:when>    
      <xsl:when test="STATUS = '3'">
        <td bgcolor="#FFFFFF">
          <p align="center">已处理</p>
        </td>
      </xsl:when>
      
      <xsl:when test="STATUS = '4'">
        <td bgcolor="#FFFFFF">
          <p align="center">系统撤单</p>
        </td>
      </xsl:when>
      <xsl:when test="STATUS = '5'">
        <td bgcolor="#FFFFFF">
          <p align="center">主动撤单</p>
        </td>
      </xsl:when>
    </xsl:choose>
        <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="SETTLE_DAY"/><!-- 结算日 -->
      </p>
    </td>
        <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="MATCHING_QTT"/><!-- 交收数量 -->
      </p>
    </td>
        <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="PICKED_QTT"/><!-- 已选货数量 -->
      </p>
    </td>
        <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TO_SPREADORDER_QTT"/><!-- 交收转组合申报数量 -->
      </p>
    </td>
  </xsl:template>
  
  <!-- 交收申报日报表 合计行 -->
  <xsl:template match="total">
    <td colspan="5" bgcolor="#FFFFFF">
      <p align="left">合计:</p>
    </td>
    <!-- 申报数量 合计项 -->
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_ORDER_QTT"/>
      </p>
    </td>
    <!-- 已交收待选货数量 合计项 -->
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_L_R_QTT"/>
      </p>
    </td>
    <!-- 格式化 合计项 -->
    <td colspan="2" bgcolor="#FFFFFF">
      <p align="right">
        <!-- <xsl:value-of select="TOTAL_AVLB_AMT"/>  -->
      </p>
    </td>
    <td colspan="5" bgcolor="#FFFFFF">
    </td>
    <!-- 交收术量 合计项 -->
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_MATCHING_QTT"/>
      </p>
    </td>
    <!-- 已选货数量 合计项 -->
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_PICKED_QTT"/>
      </p>
    </td>
    <!-- 交收转组合申报数量 合计项 -->
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_TO_SPREADORDER_QTT"/>
      </p>
    </td>
  </xsl:template>
</xsl:stylesheet>
