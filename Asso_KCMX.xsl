<?xml version="1.0" encoding="gb2312"?>
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
                    <H2>交易商库存日报表</H2><!--格式修改-标题太小了-->
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

                <!-- 存货明细 -->
                <xsl:if test="count(body/inventory_item/inventoryitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="19" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">存货明细</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodyhead_inventory_item"/>
                        </tr>
                        <xsl:for-each select="body/inventory_item/inventoryitem" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                        <tr>
                          <xsl:apply-templates select="body/inventory_item/inventoryitemtotal" />
                        </tr>
                      </table>
                    </td>
                  </tr>
                </xsl:if>

                <!-- 入库明细 -->
                <xsl:if test="count(body/warehousein_item/warehouseinitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">入库明细</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodyhead_warehousein_item"/>
                        </tr>
                        <xsl:for-each select="body/warehousein_item/warehouseinitem" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                        <tr>
                          <xsl:apply-templates select="body/warehousein_item/warehouseintotal" />
                        </tr>
                      </table>
                    </td>
                  </tr>
                </xsl:if>

                <!-- 出库明细 -->
                <xsl:if test="count(body/warehouseout_item/warehouseoutitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">出库明细</td>
                        </tr>
                        <tr>
                          <xsl:call-template name="bodyhead_warehouseout_item"/>
                        </tr>
                        <xsl:for-each select="body/warehouseout_item/warehouseoutitem" >
                          <tr>
                            <xsl:apply-templates select="."/>
                          </tr>
                        </xsl:for-each>
                        <tr>
                          <xsl:apply-templates select="body/warehouseout_item/warehouseouttotal" />
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
  <xsl:template name="bodyhead_inventory_item">
    <td bgcolor="#FFFFFF">
      <p align="center">序号</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">商品编号</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">产品类别</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">产品名称</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">计量单位</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">件数</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">总实际数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">总标准数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">在库实际数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">在库标准数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">风控可用数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">交收可用数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">已购待选货数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">已售待交收数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">风控冻结数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">交收冻结数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">可提货数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">已申请未提货数量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">锁定重量</p>
    </td>
  </xsl:template>
  
  <!-- 存货明细 表体行 -->
  <xsl:template match="inventoryitem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="GOODS_ID"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="GOODS_CLASS"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="GOODS_NAME"/>
      </p>
    </td>
    <!-- 计量单位，新增的字段 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="UNIT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="UNIT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="UNIT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="UNIT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 件数 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="COUNT_GOODS"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="COUNT_GOODS = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="COUNT_GOODS != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="COUNT_GOODS"/>
        </td>
      </xsl:when>
    </xsl:choose>
        <!-- 总实际数量(kg) -->
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
        <!-- 总标准数量(kg) -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
     <!-- 在库实际数量(kg) -->
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
     <!-- 在库标准数量(kg) -->
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
        <!-- 风控可用数量(kg) -->
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
        <!-- 交收可用数量(kg) -->
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
     <!-- 已购待选货数量（kg) -->
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
     <!-- 已售待交收数量（kg)  -->
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
    <!-- 风控冻结数量（kg) -->
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
    <!-- 交收冻结数量（kg) -->
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
    <!-- 可提货数量（kg) -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="KTH_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="KTH_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="KTH_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="KTH_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 已申请未提货数量（kg) -->
    <!--<td bgcolor="#FFFFFF">
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
    <!-- 锁定重量(kg) -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="MKD_LOCKED_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="MKD_LOCKED_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="MKD_LOCKED_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="MKD_LOCKED_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!-- 存货明细 合计行 -->
  <xsl:template match="inventoryitemtotal">
    <td colspan="5" bgcolor="#FFFFFF">
      <p align="left">合计：</p>
    </td>
    <!-- 件数 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_COUNT_GOODS"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_COUNT_GOODS = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_COUNT_GOODS != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_COUNT_GOODS"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 总实际数量(kg) 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_TOTAL_ACT_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_TOTAL_ACT_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_TOTAL_ACT_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_TOTAL_ACT_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 总标准数量(kg) 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_TOTAL_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_TOTAL_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_TOTAL_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_TOTAL_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 在库实际数量(kg) 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_MKD_ACT_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_MKD_ACT_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_MKD_ACT_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_MKD_ACT_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 在库标准数量(kg) 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_MKD_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_MKD_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_MKD_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_MKD_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 风控可用数量(kg) 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_AVLB_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_AVLB_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_AVLB_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_AVLB_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 交收可用数量(kg) 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_CSG_AVLB_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_CSG_AVLB_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_CSG_AVLB_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_CSG_AVLB_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 已购待选货数量（kg) 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_BUYED_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_BUYED_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_BUYED_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_BUYED_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 已售待交收数量（kg) 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_SELLED_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_SELLED_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_SELLED_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_SELLED_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 风控冻结数量（kg) 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_FRZ_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_FRZ_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_FRZ_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_FRZ_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 交收冻结数量（kg) 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_CSG_FRZ_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_CSG_FRZ_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_CSG_FRZ_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_CSG_FRZ_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 可提货数量(kg) 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_KTH_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_KTH_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_KTH_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_KTH_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 已申请未提货数量(kg) 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_MKD_FRZ_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_MKD_FRZ_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_MKD_FRZ_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_MKD_FRZ_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 锁定重量(kg) 合计项-->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_MKD_LOCKED_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_MKD_LOCKED_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_MKD_LOCKED_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_MKD_LOCKED_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
   <!-- 入库明细表体头 -->
  <xsl:template name="bodyhead_warehousein_item">
    <td bgcolor="#FFFFFF">
      <p align="center">序号</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">入库编码</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">仓库</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">入库时间</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">产品类别</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">产品名称</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">计量单位</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">件数</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">实际重量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">标准重量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">毛重</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">交易商确认状态</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">备注</p>
    </td>
  </xsl:template>
  
  <!--  表体行 -->
  <xsl:template match="warehouseinitem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="WAREHOUSEIN_NO"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="WAREHOUSE_NAME"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="WAREHOSUEIN_DATE"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="GOODS_CLASS"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="GOODS_NAME"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="UNIT"/>
      </p>
    </td>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="WI_PCS"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="WI_PCS = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="WI_PCS != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="WI_PCS"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="WI_ACT_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="WI_ACT_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="WI_ACT_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="WI_ACT_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="WI_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="WI_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="WI_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="WI_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="WI_GR_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="WI_GR_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="WI_GR_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="WI_GR_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="CONFIRM_STATUS = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center">未确认</p>
        </td>
      </xsl:when>
      <xsl:when test="CONFIRM_STATUS = '1'">
        <td bgcolor="#FFFFFF">
          <p align="center">已确认</p>
        </td>
      </xsl:when>
    </xsl:choose>        
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="REMARK"/>
      </p>
    </td>
  </xsl:template>
  
  <!--  合计行 -->
  <xsl:template match="warehouseintotal">
    <td colspan="7" bgcolor="#FFFFFF">
      <p align="left">合计</p>
    </td>
    <!-- 件数合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_WI_PCS"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_WI_PCS = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_WI_PCS != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_WI_PCS"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 实际重量(kg)合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_WI_ACT_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_WI_ACT_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_WI_ACT_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_WI_ACT_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 标准重量(kg)合计项 -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_WI_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_WI_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_WI_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_WI_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 毛重(kg) -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_WI_GR_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_WI_GR_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_WI_GR_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_WI_GR_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <td bgcolor="#FFFFFF" colspan="3"></td>
  </xsl:template>
  
   <!-- 出库明细表体头 -->
  <xsl:template name="bodyhead_warehouseout_item">
    <td bgcolor="#FFFFFF">
      <p align="center">序号</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">出库单编码</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">仓库</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">出库时间</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">提货申请单编码</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">产品类别</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">产品名称</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">计量单位</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">件数</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">实际重量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">标准重量</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">毛重</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">交易商确认状态</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">备注</p>
    </td>
  </xsl:template>

  <!--  表体行 -->
  <xsl:template match="warehouseoutitem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="WAREHOUSEOUT_NO"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="WAREHOUSE_ID"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="WAREHOUSEOUT_DATE"/>
      </p>
    </td>
    <!-- 提货申请单编码 -->
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="REQ_WAREHOUSEOUT_NO"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="GOODS_CLASS"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="GOODS_NAME"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="UNIT"/>
      </p>
    </td>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="WO_PCS"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="WO_PCS = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="WO_PCS != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="WO_PCS"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="WO_ACT_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="WO_ACT_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="WO_ACT_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="WO_ACT_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="WO_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="WO_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="WO_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="WO_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- 毛重(kg) -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="WO_GR_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="WO_GR_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="WO_GR_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="WO_GR_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
   <xsl:choose>
      <xsl:when test="CONFIRM_STATUS = '0'"><!-- 买卖方向 -->
        <td bgcolor="#FFFFFF">
          <p align="center">未确认</p>
        </td>
      </xsl:when>
      <xsl:when test="CONFIRM_STATUS = '1'">
        <td bgcolor="#FFFFFF">
          <p align="center">已确认</p>
        </td>
      </xsl:when>
    </xsl:choose>        
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="REMARK"/>
      </p>
    </td>
  </xsl:template>
  
  <!--  合计行 -->
  <xsl:template match="warehouseouttotal">
    <td colspan="8" bgcolor="#FFFFFF">
      <p align="left">合计:</p>
    </td>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_WO_PCS"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_WO_PCS = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_WO_PCS != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_WO_PCS"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_WO_ACT_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_WO_ACT_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_WO_ACT_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_WO_ACT_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_WO_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_WO_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_WO_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_WO_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="TOTAL_WO_GR_QTT"/>
      </p>
    </td>-->
    <xsl:choose>
      <xsl:when test="TOTAL_WO_GR_QTT = '0'">
        <td bgcolor="#FFFFFF">
          <p align="center"> </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_WO_GR_QTT != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="TOTAL_WO_GR_QTT"/>
        </td>
      </xsl:when>
    </xsl:choose>
    <td bgcolor="#FFFFFF" colspan="3"></td>
  </xsl:template>
</xsl:stylesheet>
