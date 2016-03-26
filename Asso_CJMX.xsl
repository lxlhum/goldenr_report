<?xml version="1.0" encoding="gb2312"?>
<!-- ���ܣ��ɽ���ϸ������չʾ ���ε���2015/09/14�� -->
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
                    <H2>�����̳ɽ��ձ��嵥</H2>
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

                <!-- ����/����/Э��ɽ���ϸ -->
                <xsl:if test="count(body/listing_deal/item) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">����/����/Э��ɽ���ϸ</td>
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

                <!-- ������ϳɽ���ϸ -->
                <xsl:if test="count(body/spread_deal/item) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">������ϳɽ���ϸ</td>
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

                <!-- ������ϳɽ���ϸ -->
                <xsl:if test="count(body/spreadlisting_deal/item) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">������ϳɽ���ϸ</td>
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

                <!-- �Ѹ����ͬѡ��չ�ڽ�����ϸ -->
                <xsl:if test="count(body/csgdelaying_deal/item) &gt; 0">
                  <tr>
                    <td>
                      <table width="100%" border="0" cellpadding="0" cellspacing="1">
                        <tr>
                          <td colspan="17" align="center" valign="middle" bgcolor="#FFFFFF"  style="font-weight:bold;">�Ѹ����ͬѡ��չ�ڽ�����ϸ</td>
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

  <!-- ����ͷ -->
  <xsl:template name="bodyhead">
    <td bgcolor="#FFFFFF">
      <p align="center">���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��ͬ����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��Ʒ����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">��������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ɽ�����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ɽ��۸�</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ɽ�����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ʽ𵣳ɽ���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">���ﵣ���ɽ���</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ɽ����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">������</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ʽ�ռ��</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">����ռ��</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">ת��ӯ��</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ɽ���Դ</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ɽ�����</p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">�ɽ�ʱ��</p>
    </td>
  </xsl:template>

  <!--  ������ -->
  <xsl:template match="item">
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="SEQ"/><!-- ��� -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="CONTRACT_ID"/><!-- ��ͬ���� -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="GOODS_NAME"/><!-- ��Ʒ���� -->
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
    <xsl:choose>
      <xsl:when test="DEAL_TYPE = '1'"><!-- �ɽ����� -->
        <td bgcolor="#FFFFFF">
          <p align="center">����</p>
        </td>
      </xsl:when>
      <xsl:when test="DEAL_TYPE = '20'">
        <td bgcolor="#FFFFFF">
          <p align="center">ת��</p>
        </td>
      </xsl:when>
      <xsl:when test="DEAL_TYPE = '21'">
        <td bgcolor="#FFFFFF">
          <p align="center">ƽ��</p>
        </td>
      </xsl:when>
      <xsl:when test="DEAL_TYPE = '22'">
        <td bgcolor="#FFFFFF">
          <p align="center">ƽ��</p>
        </td>
      </xsl:when>
      <xsl:when test="DEAL_TYPE = '3'">
        <td bgcolor="#FFFFFF">
          <p align="center">ǿ��ת��</p>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <td bgcolor="#FFFFFF">
          <p align="center">����</p>
        </td>
      </xsl:otherwise>
    </xsl:choose>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="DEAL_PRICE"/><!-- �ɽ��۸� -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="DEAL_QTT"/><!-- �ɽ����� -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT_FUND"/><!-- �ʽ𵣱������� -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="AVLB_QTT_GOODS"/><!-- ���ﵣ�������� -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="DEAL_AMT"/><!-- �ɽ���� -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="POUNDAGE"/><!-- ������ -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="DEAL_DEPOSIT"/><!-- �ʽ�ռ�� -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="RISK_RCPT"/><!-- ����ռ�� -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="right">
        <xsl:value-of select="CNY_BALANCE"/><!-- ת��ӯ�� -->
      </p>
    </td>
    <xsl:choose>
      <xsl:when test="SOURCE_FLAG = '00'"><!-- �ɽ���Դ -->
        <td bgcolor="#FFFFFF">
          <p align="center">��������</p>
        </td>
      </xsl:when>
      <xsl:when test="SOURCE_FLAG = '01'">
        <td bgcolor="#FFFFFF">
          <p align="center">Э��ת��</p>
        </td>
      </xsl:when>
      <xsl:when test="SOURCE_FLAG = '02'">
        <td bgcolor="#FFFFFF">
          <p align="center">Э�鶩��</p>
        </td>
      </xsl:when>
      <xsl:when test="SOURCE_FLAG = '1'">
        <td bgcolor="#FFFFFF">
          <p align="center">����/ժ��</p>
        </td>
      </xsl:when>
      <xsl:when test="SOURCE_FLAG = '2'">
        <td bgcolor="#FFFFFF">
          <p align="center">������������걨</p>
        </td>
      </xsl:when>
      <xsl:when test="SOURCE_FLAG = '3'">
        <td bgcolor="#FFFFFF">
          <p align="center">�������ϵͳ�걨</p>
        </td>
      </xsl:when>
      <xsl:when test="SOURCE_FLAG = '4'">
        <td bgcolor="#FFFFFF">
          <p align="center">������Ϲ���/ժ��</p>
        </td>
      </xsl:when>
      <xsl:when test="SOURCE_FLAG = '5'">
        <td bgcolor="#FFFFFF">
          <p align="center">ǿ��ת��</p>
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
        <xsl:value-of select="DEAL_NO"/><!-- �ɽ����� -->
      </p>
    </td>
    <td bgcolor="#FFFFFF">
      <p align="center">
        <xsl:value-of select="DEAL_TIME"/><!-- �ɽ�ʱ�� -->
      </p>
    </td>
  </xsl:template>
  
  <!--  �ϼ��� -->
  <xsl:template match="total">
    <td colspan="6" bgcolor="#FFFFFF">
      <p align="left">�ϼ�</p>
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
