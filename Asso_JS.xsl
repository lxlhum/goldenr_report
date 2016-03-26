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
                    <H2>交易商交收日报表</H2>
                    <!--格式修改-标题太小-->
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
                <xsl:if test="count(body/mcbitem/mcitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">交收汇总表</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="mbodyhead"/>
                        </tr>
                        <xsl:for-each select="body/mcbitem/mcitem" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                        <tr>
                          <xsl:apply-templates select="body/mcbitem/total" />
                        </tr>
                      </table>
                    </td>
                  </tr>
                </xsl:if>
                <!-- 交收清单 -->
                <xsl:if test="count(body/jsqdbitem/jsqditem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="18" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">交收清单</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="nbodyhead"/>
                        </tr>
                        <xsl:for-each select="body/jsqdbitem/jsqditem" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                        <tr>
                          <xsl:apply-templates select="body/jsqdbitem/jsqdtotal" />
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

  <!-- 交易商交收汇总 表体头 -->
  <xsl:template name="mbodyhead">
    <tr>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">序号</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">合同编码</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">买卖方向</p>
    </td>
    <td bgcolor="#FFFFFF" colspan="2" >
      <p align="center">选货/交货数量</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">交割货款</p>
    </td>
    <td bgcolor="#FFFFFF" colspan="2" >
      <p align="center">剩余未匹配数量</p>
    </td>
    <td bgcolor="#FFFFFF" colspan="2" >
      <p align="center">剩余未了结数量</p>
    </td>
    </tr>
    <tr>
      <td bgcolor="#FFFFFF" >
        <p align="center">标重</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">实重</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">标重</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">实重</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">标重</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">实重</p>
      </td>
    </tr>
  </xsl:template>

  <!-- 交易商交收汇总 表体行 -->
  <!-- ps：此处item要与xml中对应的item名字一致 -->
  <xsl:template match="mcitem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
        <!-- 序号 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="CONTRACT_ID"/>
        <!-- 合同编码 -->
      </p>
    </td>
    <xsl:choose>
      <xsl:when test="BUYORSELL = '1'">
        <!-- 买卖方向 -->
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
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="PIK_QTT"/>
        --><!--交货/选货标重 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="PIK_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="PIK_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="PIK_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="ACT_PIK_QTT"/>
        --><!-- 交货/选货实重 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="ACT_PIK_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="ACT_PIK_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="ACT_PIK_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(CSG_AMT,'##,##0.00','CNY')"/>
        --><!-- 交割货款 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="CSG_AMT = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="CSG_AMT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(CSG_AMT,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="MAT_QTT"/>
        --><!-- 剩余未匹配标数 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="MAT_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="MAT_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="MAT_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="ACT_MAT_QTT"/>
        --><!-- 剩余未匹配实数 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="ACT_MAT_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="ACT_MAT_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="ACT_MAT_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="FIN_QTT"/>
        --><!-- 剩余未了结标数 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="FIN_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="FIN_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="FIN_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="ACT_FIN_QTT"/>
        --><!-- 剩余未了结实数 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="ACT_FIN_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="ACT_FIN_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="ACT_FIN_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- 交收申报日报表 合计行 -->
  <xsl:template match="total">
    <td colspan="3" bgcolor="#FFFFFF">
      <p align="left">合计:</p>
    </td>
    <!-- 交货选货标数 合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_PIK_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_PIK_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_PIK_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_PIK_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 交货选货实重 合计项 --> 
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_ACT_PIK_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_ACT_PIK_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_ACT_PIK_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_ACT_PIK_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 交割货款 合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(TOTAL_CSG_AMT,'##,##0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_CSG_AMT = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_CSG_AMT != '0.0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(TOTAL_CSG_AMT,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 剩余未匹配标重 合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_MAT_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_MAT_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_MAT_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_MAT_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 剩余未匹配实重 合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_ACT_MAT_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_ACT_MAT_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_ACT_MAT_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_ACT_MAT_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 剩余未了结标重 合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_FIN_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_FIN_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_FIN_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_FIN_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 剩余未了结实重 合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_ACT_FIN_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_ACT_FIN_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_ACT_FIN_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_ACT_FIN_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  
  <!-- 交收清单 表体头 -->
  <xsl:template name="nbodyhead">
    <tr>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">序号</p>
    </td>
     <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">匹配单号</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">合同编码</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">买卖方向</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2" >
      <p align="center">匹配数量</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">实发数量</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">订货均价</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">成交金额</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">交收价</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">升贴水</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">交割货款</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">交收服务费</p>
    </td>
    <td bgcolor="#FFFFFF" colspan="2" >
      <p align="center">发票违约数量</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">违约金额</p>
    </td>
    <td bgcolor="#FFFFFF" colspan="2" >
      <p align="center">了结数量</p>
    </td>
    </tr>
    <tr>
      <td bgcolor="#FFFFFF" >
        <p align="center">标重</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">实重</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">标重</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">实重</p>
      </td>
    </tr>
  </xsl:template>
  
  
   <!-- 交收清单 表体行 -->
  <!-- ps：此处item要与xml中对应的item名字一致 -->
  <xsl:template match="jsqditem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
        <!-- 序号 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="MATCHING_SEQ"/>
        <!-- 匹配单号 -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="CONTRACT_ID"/>
        <!-- 合同编码 -->
      </p>
    </td>
    <xsl:choose>
      <xsl:when test="BUYORSELL = '1'">
        <!-- 买卖方向 -->
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
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="G_CSG_QTT"/>
        --><!--匹配数量 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="G_CSG_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="G_CSG_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="G_CSG_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="G_CSG_QTT"/>
        --><!-- 实发数量 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="G_CSG_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="G_CSG_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="G_CSG_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(AVG_PRICE,'##,##0.00','CNY')"/>
        --><!-- 订货均价 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="AVG_PRICE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="AVG_PRICE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(AVG_PRICE,'#,##0.00','CNY')"/>
          <!-- 订货均价 -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(CSG_FUND_AMT,'##,##0.00','CNY')"/>
        --><!-- 成交金额 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="CSG_FUND_AMT = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="CSG_FUND_AMT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(CSG_FUND_AMT,'#,##0.00','CNY')"/>
          <!-- 成交金额 -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(CSG_PRICE,'##,##0.00','CNY')"/>
        --><!-- 交收价 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="CSG_PRICE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="CSG_PRICE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(CSG_PRICE,'#,##0.00','CNY')"/>
          <!-- 交收价 -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(AGIO_FEE,'##,##0.00','CNY')"/>
        --><!-- 升贴水 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="AGIO_FEE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="AGIO_FEE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(AGIO_FEE,'#,##0.00','CNY')"/>
          <!-- 升贴水 -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(FUND_AMT,'##,##0.00','CNY')"/>
        --><!-- 交割货款 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="FUND_AMT = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="FUND_AMT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(FUND_AMT,'#,##0.00','CNY')"/>
          <!-- 交割货款 -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(SRV_FUND,'##,##0.00','CNY')"/>
        --><!-- 手续费 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="SRV_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="SRV_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(SRV_FUND,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="BREACH_QTT"/>
        --><!-- 发票预期违约标重 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="BREACH_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="BREACH_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="BREACH_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="ACT_BREACHIN_QTT"/>
        --><!-- 发票预期违约实重 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="ACT_BREACHIN_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="ACT_BREACHIN_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="ACT_BREACHIN_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(BREACHIN_AMT,'##,##0.00','CNY')"/>
        --><!-- 违约金额 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="BREACHIN_AMT = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="BREACHIN_AMT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(BREACHIN_AMT,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="MATCHING_QTT"/>
        --><!-- 了结数量标重 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="MATCHING_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="MATCHING_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="MATCHING_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="ACT_QTT"/>
        --><!-- 了结数量实重 --><!--
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="ACT_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="ACT_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="ACT_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- 交收清单 合计行 -->
  <xsl:template match="jsqdtotal">
    <td colspan="4" bgcolor="#FFFFFF">
      <p align="left">合计:</p>
    </td>
    <!-- 匹配数量 合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_CSG_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_CSG_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_CSG_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_CSG_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 实发数量 合计项 --> 
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_G_CSG_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_G_CSG_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_G_CSG_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_G_CSG_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 调整格式 合计项 --> 
    <td bgcolor="#FFFFFF">
      <p align="right">
        -
      </p>
    </td>
    <!-- 成交金额 合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(TOTAL_CSG_FUND_AMT,'##,##0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_CSG_FUND_AMT = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_CSG_FUND_AMT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(TOTAL_CSG_FUND_AMT,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 调整格式 合计项 --> 
    <td bgcolor="#FFFFFF">
      <p align="right">
        -
      </p>
    </td>
    <!-- 升贴水 合计项 --> 
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(TOTAL_AGIO_FEE,'##,##0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_AGIO_FEE = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_AGIO_FEE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(TOTAL_AGIO_FEE,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 交割货款 合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(TOTAL_FUND_AMT,'##,##0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_FUND_AMT = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_FUND_AMT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(TOTAL_FUND_AMT,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 交收服务费 合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(TOTAL_SRV_FUND,'##,##0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_SRV_FUND = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_SRV_FUND != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(TOTAL_SRV_FUND,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 发票违约数量标重 合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_BREACH_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_BREACH_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_BREACH_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_BREACH_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 发票违约数量实重 合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_ACT_BREACHIN_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_ACT_BREACHIN_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_ACT_BREACHIN_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_ACT_BREACHIN_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 违约金额 合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(TOTAL_BREACHIN_AMT,'##,##0.00','CNY')"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_BREACHIN_AMT = '0'">

        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_BREACHIN_AMT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(TOTAL_BREACHIN_AMT,'#,##0.00','CNY')"/>
          <!-- XXXXXX -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 了结标重 合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_MATCHING_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_MATCHING_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_MATCHING_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_MATCHING_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 剩余未了结实重 合计项 -->
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
  </xsl:template>
</xsl:stylesheet>
