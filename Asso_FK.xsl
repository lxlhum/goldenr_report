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
                    <H2>�����̷���ձ���</H2><!--��ʽ�޸�-����̫С-->
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

                <!-- �ʽ��ѯ -->
                <xsl:if test="count(body/account_info_check/info_checkitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">�ʽ��ѯ</td>
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

                <!-- �����ѯ -->
                <xsl:if test="count(body/inventory_goods_check/goods_checkitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">�����ѯ</td>
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

                <!-- �������׶�����ѯ -->
                <xsl:if test="count(body/subs_deal_check/deal_checkitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">�������׶�����ѯ</td>
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
                
                <!-- ���նȲ�ѯ -->
                <xsl:if test="count(body/goods_risk_check/risk_checkitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">���նȲ�ѯ</td>
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

  <!-- �ʽ��ѯ ����ͷ -->
  <xsl:template name="bodyhead_info_check">
    <td bgcolor="#FFFFFF">
      <p align="center">���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ʽ����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��ؿ��ö�</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���տ��ö�</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���ճ���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���շ���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">����ת��ӯ��</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��ͬ����ռ��</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">������ض���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">����ӯ��</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���ն���</p>
    </td>
  </xsl:template>
  
  <!-- �ʽ��ѯ ������ -->
  <xsl:template match="info_checkitem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
      </p>
    </td>
    <!-- �ʽ���� -->
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
    
    <!--��ؿ��ö� ���� -->
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

    <!--���տ��ö�  avlb��ʾ����-->
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
    <!--�������  ����ʽ����λ-->
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
    <!--���ճ��� -->
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
    <!--���շ��� �� ��Ҫͨ��������á� �˴�����SQL�н��в�ѯ-->
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
    <!-- ����ת��ӯ��  �� ��Ҫͨ��������á� �˴�����SQL�н��в�ѯ -->
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
    <!--��ͬ����ռ��  -->
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
    <!--��������  -->
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
    <!--������ض���  -->
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
    <!--����ӯ�� -->
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
    <!--���ն���  -->
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
  
   <!-- �����ѯ ����ͷ -->
  <xsl:template name="bodyhead_goods_check">
    <td bgcolor="#FFFFFF">
      <p align="center">���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��Ʒ����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��Ʒ������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��ؿ�����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���տ�����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ڿ������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ڿ���ʵ��</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ڿ����</p>
    </td>
     <td bgcolor="#FFFFFF">
      <p align="center">������δ�������</p>
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
  </xsl:template>
  
  <!--  �����ѯ ������ -->
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
  
   <!-- �������׶�����ѯ ����ͷ -->
  <xsl:template name="bodyhead_deal_check">
    <td bgcolor="#FFFFFF">
      <p align="center">���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��ͬ����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ʽ𵣱�������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���ﵣ��������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">����ӯ��</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���</p>
    </td>
  </xsl:template>

  <!-- �������׶�����ѯ ������ -->
  <xsl:template match="deal_checkitem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="CONTRACT_ID"/><!-- ��ͬ���� -->
      </p>
    </td>
    <xsl:choose>
      <xsl:when test="BUYORSELL = '1'"><!-- �������� -->
        <td bgcolor="#FFFFFF">
          <p align="center">����</p>
        </td>
      </xsl:when>
      <xsl:when test="BUYORSELL = '2'">
        <td bgcolor="#FFFFFF">
          <p align="center">����</p>
        </td>
      </xsl:when>
    </xsl:choose>
    <!-- <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT_FUND"/> �ʽ𵣱������� 
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
            <!-- �ʽ𵣱������� -->
          </p>
        </td>
      </xsl:when>

    </xsl:choose>
    <!-- <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT_GOODS"/> ���ﵣ��������
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
            <!-- ���ﵣ�������� -->
          </p>
        </td>
      </xsl:when>
      
    </xsl:choose>
    
    <!-- <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT"/> ���������� 
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
            <!-- ���ﵣ�������� -->
          </p>
        </td>
      </xsl:when>

    </xsl:choose>
    <!-- <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(FLOATING_BANLANCE,'#,###0.00','CNY')"/>����۲� 
      </p>
    </td> -->
    <xsl:choose>
      <xsl:when test="FLOATING_BANLANCE = '0'">
        <!-- ����۲� -->
        <td bgcolor="#FFFFFF">
          <p align="center">
            
          </p>
        </td>
      </xsl:when>
      <xsl:when test="FLOATING_BANLANCE != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(FLOATING_BANLANCE,'#,##0.00','CNY')"/>
          <!-- ����۲� -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(TOTAL_COST,'#,###0.00','CNY')"/> �����ֳɱ���
      </p>
    </td> -->

    <xsl:choose>
      <xsl:when test="TOTAL_COST = '0'">
        <!-- �����ֳɱ��� -->
        <td bgcolor="#FFFFFF">
          <p align="center">

          </p>
        </td>
      </xsl:when>
      <xsl:when test="TOTAL_COST != '0'">
        <td bgcolor="#FFFFFF" align ="right">
          <xsl:value-of select="format-number(TOTAL_COST,'#,##0.00','CNY')"/>
          <!-- �����ֳɱ��� -->
        </td>
      </xsl:when>
    </xsl:choose>
    
  </xsl:template>
  
   <!-- ���նȲ�ѯ ����ͷ -->
  <xsl:template name="bodyhead_risk_check">
    <td bgcolor="#FFFFFF">
      <p align="center">���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���ն�</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�����ʲ���ֵ</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">����ռ���ʲ���ֵ</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���õ����ʽ�</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">����ռ��</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">������ض����ʽ�</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���õ�����Ʒ��ֵ</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">����ռ����Ʒ��ֵ</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">Ӧ׷���ʽ�����</p>
    </td>
  </xsl:template>

  <!-- ���նȲ�ѯ ������ -->
  <xsl:template match="risk_checkitem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/><!-- ��� -->
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
       <!--  <xsl:value-of select="RISK_RATIO"/>���ն� -->
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(AVLB_ASSETS,'#,###0.00','CNY')"/> �����ʲ���ֵ 
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
          <!-- �����ʲ���ֵ -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!-- <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(FRZ_RISK_ASSETS,'#,###0.00','CNY')"/>����ռ���ʲ���ֵ
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
          <!-- ����ռ���ʲ���ֵ -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(AVLB_FUND,'#,###0.00','CNY')"/> ���õ����ʽ� 
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
          <!-- ���õ����ʽ� -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
       <xsl:value-of select="format-number(FRZ_ORD_FUND,'#,###0.00','CNY')"/> ��������
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
          <!-- �������� -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(OCCP_DEPOSIT,'#,###0.00','CNY')"/> ����ռ�� 
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
          <!-- ����ռ�� -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(FRZ_RISK_FUND,'#,###0.00','CNY')"/> ������ض����ʽ�
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
          <!-- ������ض����ʽ� -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!-- <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(AVLB_GOODS_VALUE,'#,###0.00','CNY')"/> ���õ�����Ʒ��ֵ 
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
          <!-- ���õ�����Ʒ��ֵ -->
        </td>
      </xsl:when>
    </xsl:choose>
    
    <!-- <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(RISK_GOODS_VALUE,'#,###0.00','CNY')"/> ����ռ����Ʒ��ֵ
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
          <!-- ����ռ����Ʒ��ֵ -->

        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(ADDITIONAL_FUND,'#,###0.00','CNY')"/>Ӧ׷���ʽ�����
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
          <!--Ӧ׷���ʽ�����-->

        </td>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
