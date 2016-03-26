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
                    <H2>交易商已付款待选货明细清单</H2><!--格式修改-标题太小-->
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

                <!-- 已付款待选货明细查询 -->
                <xsl:if test="count(body/csg_order_item/item) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">已付款待选货明细查询</td>
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
      <p align="center">合同编码</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">买卖方向</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">可选数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">已选数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">金额</p>
    </td>
  </xsl:template>
  
  <!-- 已付款待选货明细查询 表体行 -->
  <xsl:template match="item"><!-- 此处item要与xml中对应的item名字一致 -->
  <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="CONTRACT_ID"/>
      </p>
    </td>
    <xsl:choose>
      <xsl:when test="BUYORSELL = '1'">
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
        <xsl:value-of select="AVLB_QTT"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="PICKED_QTT"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
       <xsl:value-of select="format-number(AVLB_AMT,'#,###0.00','CNY')"/>
      </p>
    </td>
  </xsl:template>
  
  <!-- 已付款待选货明细查询 合计行 -->
  <xsl:template match="total">
    <td colspan="3" bgcolor="#FFFFFF">
      <p align="left">合计:</p>
    </td>
    <!-- 可选数量 合计项 -->
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_AVLB_QTT"/>
      </p>
    </td>
    <!-- 已选数量 合计项 -->
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_PICKED_QTT"/>
      </p>
    </td>
    <!-- 金额 合计项 -->
    <td bgcolor="#FFFFFF">
      <p align="right">
       <xsl:value-of select="format-number(TOTAL_AVLB_AMT,'#,###0.00','CNY')"/>
      </p>
    </td>
    <!--<td bgcolor="#FFFFFF" colspan="2"></td>--><!--更改表样式，删除一列-->
  </xsl:template>
</xsl:stylesheet>
