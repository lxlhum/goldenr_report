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
                    <H2>交易商出入金月报表</H2><!--格式修改-标题太小了-->
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td>
              <table border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="cccccc">
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

                <!-- 入金 -->
                <xsl:if test="count(body/inbitem/initem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="19" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">交易商入金月报表</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodyhead"/>
                        </tr>
                         <xsl:for-each select="body/inbitem/initem" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                        <tr>
                          <xsl:apply-templates select="body/inbitem/total" />
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

  <!-- 存货明细表体头 -->
  <xsl:template name="bodyhead">
    <td bgcolor="#FFFFFF">
      <p align="center">序号</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">操作时间</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">出入金类型</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">金额</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">状态</p>
    </td>
  </xsl:template>
  
  <!-- 入金明细 表体行 -->
  <xsl:template match="initem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="CHECK_TIME"/>
      </p>
    </td>
   <xsl:choose>
      <xsl:when test="INOROUT = 'I'"><!-- 买卖方向 -->
        <td bgcolor="#FFFFFF">
          <p align="center">入金</p>
        </td>
      </xsl:when>
      <xsl:when test="INOROUT = 'O'"><!-- 买卖方向 -->
        <td bgcolor="#FFFFFF">
          <p align="center">出金</p>
        </td>
      </xsl:when>
     </xsl:choose>
      <!--<td bgcolor="#FFFFFF">
        <p align="center">
          <xsl:value-of select="format-number(AMOUNT,'#,###0.00','CNY')"/>
        </p>
      </td>-->
    <xsl:choose>
      <xsl:when test="AMOUNT = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="AMOUNT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(AMOUNT,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="HAS_CHECKED = '1'"><!-- 买卖方向 -->
        <td bgcolor="#FFFFFF">
          <p align="center">已复核</p>
        </td>
      </xsl:when>
     </xsl:choose>
  </xsl:template>  
  
  <!-- 入金 合计行 -->
  <xsl:template match="total">
    <td colspan="3" bgcolor="#FFFFFF">
      <p align="left">合计：</p>
    </td>
    <!-- 金额 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(TOTAL_AMOUNT,'#,###0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_AMOUNT = '0.0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_AMOUNT != '0.0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(TOTAL_AMOUNT,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!-- 格式调整-->
    <td bgcolor="#FFFFFF">
      
    </td>
  </xsl:template>
 </xsl:stylesheet>