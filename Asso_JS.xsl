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
                    <H2>�����̽����ձ���</H2>
                    <!--��ʽ�޸�-����̫С-->
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
                              <td align="right" valign="middle">��Ա����:</td>
                            </xsl:when>
                            <xsl:when test="position() = 2">
                              <td align="right" valign="middle">��Ա����:</td>
                            </xsl:when>
                            <xsl:when test="position() = 3">
                              <td align="right" valign="middle">����:</td>
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

                <!-- �����걨�ձ��� -->
                <xsl:if test="count(body/mcbitem/mcitem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">���ջ��ܱ�</td>
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
                <!-- �����嵥 -->
                <xsl:if test="count(body/jsqdbitem/jsqditem) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="18" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">�����嵥</td>
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

  <!-- �����̽��ջ��� ����ͷ -->
  <xsl:template name="mbodyhead">
    <tr>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">���</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">��ͬ����</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">��������</p>
    </td>
    <td bgcolor="#FFFFFF" colspan="2" >
      <p align="center">ѡ��/��������</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">�������</p>
    </td>
    <td bgcolor="#FFFFFF" colspan="2" >
      <p align="center">ʣ��δƥ������</p>
    </td>
    <td bgcolor="#FFFFFF" colspan="2" >
      <p align="center">ʣ��δ�˽�����</p>
    </td>
    </tr>
    <tr>
      <td bgcolor="#FFFFFF" >
        <p align="center">����</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">ʵ��</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">����</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">ʵ��</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">����</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">ʵ��</p>
      </td>
    </tr>
  </xsl:template>

  <!-- �����̽��ջ��� ������ -->
  <!-- ps���˴�itemҪ��xml�ж�Ӧ��item����һ�� -->
  <xsl:template match="mcitem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
        <!-- ��� -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="CONTRACT_ID"/>
        <!-- ��ͬ���� -->
      </p>
    </td>
    <xsl:choose>
      <xsl:when test="BUYORSELL = '1'">
        <!-- �������� -->
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
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="PIK_QTT"/>
        --><!--����/ѡ������ --><!--
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
        --><!-- ����/ѡ��ʵ�� --><!--
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
        --><!-- ������� --><!--
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
        --><!-- ʣ��δƥ����� --><!--
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
        --><!-- ʣ��δƥ��ʵ�� --><!--
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
        --><!-- ʣ��δ�˽���� --><!--
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
        --><!-- ʣ��δ�˽�ʵ�� --><!--
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

  <!-- �����걨�ձ��� �ϼ��� -->
  <xsl:template match="total">
    <td colspan="3" bgcolor="#FFFFFF">
      <p align="left">�ϼ�:</p>
    </td>
    <!-- ����ѡ������ �ϼ��� -->
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
    <!-- ����ѡ��ʵ�� �ϼ��� --> 
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
    <!-- ������� �ϼ��� -->
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
    <!-- ʣ��δƥ����� �ϼ��� -->
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
    <!-- ʣ��δƥ��ʵ�� �ϼ��� -->
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
    <!-- ʣ��δ�˽���� �ϼ��� -->
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
    <!-- ʣ��δ�˽�ʵ�� �ϼ��� -->
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
  
  
  <!-- �����嵥 ����ͷ -->
  <xsl:template name="nbodyhead">
    <tr>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">���</p>
    </td>
     <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">ƥ�䵥��</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">��ͬ����</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">��������</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2" >
      <p align="center">ƥ������</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">ʵ������</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">��������</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">�ɽ����</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">���ռ�</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">����ˮ</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">�������</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">���շ����</p>
    </td>
    <td bgcolor="#FFFFFF" colspan="2" >
      <p align="center">��ƱΥԼ����</p>
    </td>
    <td bgcolor="#FFFFFF" rowspan ="2">
      <p align="center">ΥԼ���</p>
    </td>
    <td bgcolor="#FFFFFF" colspan="2" >
      <p align="center">�˽�����</p>
    </td>
    </tr>
    <tr>
      <td bgcolor="#FFFFFF" >
        <p align="center">����</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">ʵ��</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">����</p>
      </td>
      <td bgcolor="#FFFFFF" >
        <p align="center">ʵ��</p>
      </td>
    </tr>
  </xsl:template>
  
  
   <!-- �����嵥 ������ -->
  <!-- ps���˴�itemҪ��xml�ж�Ӧ��item����һ�� -->
  <xsl:template match="jsqditem">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/>
        <!-- ��� -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="MATCHING_SEQ"/>
        <!-- ƥ�䵥�� -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="CONTRACT_ID"/>
        <!-- ��ͬ���� -->
      </p>
    </td>
    <xsl:choose>
      <xsl:when test="BUYORSELL = '1'">
        <!-- �������� -->
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
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="G_CSG_QTT"/>
        --><!--ƥ������ --><!--
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
        --><!-- ʵ������ --><!--
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
        --><!-- �������� --><!--
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
          <!-- �������� -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(CSG_FUND_AMT,'##,##0.00','CNY')"/>
        --><!-- �ɽ���� --><!--
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
          <!-- �ɽ���� -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(CSG_PRICE,'##,##0.00','CNY')"/>
        --><!-- ���ռ� --><!--
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
          <!-- ���ռ� -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(AGIO_FEE,'##,##0.00','CNY')"/>
        --><!-- ����ˮ --><!--
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
          <!-- ����ˮ -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(FUND_AMT,'##,##0.00','CNY')"/>
        --><!-- ������� --><!--
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
          <!-- ������� -->
        </td>
      </xsl:when>
    </xsl:choose>
    <!--<td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="format-number(SRV_FUND,'##,##0.00','CNY')"/>
        --><!-- ������ --><!--
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
        --><!-- ��ƱԤ��ΥԼ���� --><!--
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
        --><!-- ��ƱԤ��ΥԼʵ�� --><!--
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
        --><!-- ΥԼ��� --><!--
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
        --><!-- �˽��������� --><!--
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
        --><!-- �˽�����ʵ�� --><!--
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

  <!-- �����嵥 �ϼ��� -->
  <xsl:template match="jsqdtotal">
    <td colspan="4" bgcolor="#FFFFFF">
      <p align="left">�ϼ�:</p>
    </td>
    <!-- ƥ������ �ϼ��� -->
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
    <!-- ʵ������ �ϼ��� --> 
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
    <!-- ������ʽ �ϼ��� --> 
    <td bgcolor="#FFFFFF">
      <p align="right">
        -
      </p>
    </td>
    <!-- �ɽ���� �ϼ��� -->
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
    <!-- ������ʽ �ϼ��� --> 
    <td bgcolor="#FFFFFF">
      <p align="right">
        -
      </p>
    </td>
    <!-- ����ˮ �ϼ��� --> 
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
    <!-- ������� �ϼ��� -->
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
    <!-- ���շ���� �ϼ��� -->
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
    <!-- ��ƱΥԼ�������� �ϼ��� -->
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
    <!-- ��ƱΥԼ����ʵ�� �ϼ��� -->
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
    <!-- ΥԼ��� �ϼ��� -->
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
    <!-- �˽���� �ϼ��� -->
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
    <!-- ʣ��δ�˽�ʵ�� �ϼ��� -->
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
