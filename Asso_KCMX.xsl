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
                    <H2>�����̿���ձ���</H2><!--��ʽ�޸�-����̫С��-->
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
                              <td align="right" valign="middle">��Ա���룺</td>
                            </xsl:when>
                            <xsl:when test="position() = 2">
                              <td align="right" valign="middle">��Ա���ƣ�</td>
                            </xsl:when>
                            <xsl:when test="position() = 3">
                              <td align="right" valign="middle">���ڣ�</td>
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

                <!-- �����ϸ -->
                <xsl:if test="count(body/inventory_item/inventoryitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="19" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">�����ϸ</td>
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

                <!-- �����ϸ -->
                <xsl:if test="count(body/warehousein_item/warehouseinitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">�����ϸ</td>
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

                <!-- ������ϸ -->
                <xsl:if test="count(body/warehouseout_item/warehouseoutitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">������ϸ</td>
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

  <!-- �����ϸ����ͷ -->
  <xsl:template name="bodyhead_inventory_item">
    <td bgcolor="#FFFFFF">
      <p align="center">���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��Ʒ���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��Ʒ���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��Ʒ����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">������λ</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��ʵ������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ܱ�׼����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ڿ�ʵ������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ڿ��׼����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��ؿ�������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���տ�������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ѹ���ѡ������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���۴���������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��ض�������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���ն�������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">������δ�������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��������</p>
    </td>
  </xsl:template>
  
  <!-- �����ϸ ������ -->
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
    <!-- ������λ���������ֶ� -->
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
    <!-- ���� -->
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
        <!-- ��ʵ������(kg) -->
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
        <!-- �ܱ�׼����(kg) -->
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
     <!-- �ڿ�ʵ������(kg) -->
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
     <!-- �ڿ��׼����(kg) -->
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
        <!-- ��ؿ�������(kg) -->
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
        <!-- ���տ�������(kg) -->
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
     <!-- �ѹ���ѡ��������kg) -->
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
     <!-- ���۴�����������kg)  -->
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
    <!-- ��ض���������kg) -->
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
    <!-- ���ն���������kg) -->
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
    <!-- �����������kg) -->
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
    <!-- ������δ���������kg) -->
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
    <!-- ��������(kg) -->
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
  
  <!-- �����ϸ �ϼ��� -->
  <xsl:template match="inventoryitemtotal">
    <td colspan="5" bgcolor="#FFFFFF">
      <p align="left">�ϼƣ�</p>
    </td>
    <!-- ���� �ϼ���-->
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
    <!-- ��ʵ������(kg) �ϼ���-->
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
    <!-- �ܱ�׼����(kg) �ϼ���-->
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
    <!-- �ڿ�ʵ������(kg) �ϼ���-->
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
    <!-- �ڿ��׼����(kg) �ϼ���-->
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
    <!-- ��ؿ�������(kg) �ϼ���-->
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
    <!-- ���տ�������(kg) �ϼ���-->
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
    <!-- �ѹ���ѡ��������kg) �ϼ���-->
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
    <!-- ���۴�����������kg) �ϼ���-->
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
    <!-- ��ض���������kg) �ϼ���-->
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
    <!-- ���ն���������kg) �ϼ���-->
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
    <!-- ���������(kg) �ϼ���-->
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
    <!-- ������δ�������(kg) �ϼ���-->
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
    <!-- ��������(kg) �ϼ���-->
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
  
   <!-- �����ϸ����ͷ -->
  <xsl:template name="bodyhead_warehousein_item">
    <td bgcolor="#FFFFFF">
      <p align="center">���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ֿ�</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���ʱ��</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��Ʒ���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��Ʒ����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">������λ</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">ʵ������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��׼����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">ë��</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">������ȷ��״̬</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��ע</p>
    </td>
  </xsl:template>
  
  <!--  ������ -->
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
          <p align="center">δȷ��</p>
        </td>
      </xsl:when>
      <xsl:when test="CONFIRM_STATUS = '1'">
        <td bgcolor="#FFFFFF">
          <p align="center">��ȷ��</p>
        </td>
      </xsl:when>
    </xsl:choose>        
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="REMARK"/>
      </p>
    </td>
  </xsl:template>
  
  <!--  �ϼ��� -->
  <xsl:template match="warehouseintotal">
    <td colspan="7" bgcolor="#FFFFFF">
      <p align="left">�ϼ�</p>
    </td>
    <!-- �����ϼ��� -->
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
    <!-- ʵ������(kg)�ϼ��� -->
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
    <!-- ��׼����(kg)�ϼ��� -->
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
    <!-- ë��(kg) -->
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
  
   <!-- ������ϸ����ͷ -->
  <xsl:template name="bodyhead_warehouseout_item">
    <td bgcolor="#FFFFFF">
      <p align="center">���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���ⵥ����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ֿ�</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">����ʱ��</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">������뵥����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��Ʒ���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��Ʒ����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">������λ</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">ʵ������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��׼����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">ë��</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">������ȷ��״̬</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��ע</p>
    </td>
  </xsl:template>

  <!--  ������ -->
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
    <!-- ������뵥���� -->
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
    <!-- ë��(kg) -->
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
      <xsl:when test="CONFIRM_STATUS = '0'"><!-- �������� -->
        <td bgcolor="#FFFFFF">
          <p align="center">δȷ��</p>
        </td>
      </xsl:when>
      <xsl:when test="CONFIRM_STATUS = '1'">
        <td bgcolor="#FFFFFF">
          <p align="center">��ȷ��</p>
        </td>
      </xsl:when>
    </xsl:choose>        
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="REMARK"/>
      </p>
    </td>
  </xsl:template>
  
  <!--  �ϼ��� -->
  <xsl:template match="warehouseouttotal">
    <td colspan="8" bgcolor="#FFFFFF">
      <p align="left">�ϼ�:</p>
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
