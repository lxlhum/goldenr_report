<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html" indent="no" encoding="GBK"/>
    <xsl:decimal-format name="CNY" decimal-separator="." grouping-separator=","/>
	<xsl:template match="root">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
				<title>
					<xsl:value-of select="file_title"/>
				</title>
			</head>
			<body>
				<table align="center">
					<tr>
						<td>
							<table align="center" width="100%" border="0">
								<tr>
									<td align="center">
										<H3>�����̿����嵥�ձ���</H3>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<table border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
								<tr>
									<td height="20" colspan="15" valign="middle" bgcolor="#FFFFFF">
										<table width="100%" height="30" border="0" cellpadding="0" cellspacing="0">
											<tr>
												<xsl:for-each select="top/item">
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
								<!--
								xml.���� = lastFrzRiskFund - frzRiskFund - curManageFee;
								xsl.���� = xml.���� - �Ѹ����� + ���ջ��� - �򷽲��˻���
								-->
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>һ�����վ�̬Ȩ��</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/lbitem/litem/LAST_TOTAL_RIGHT,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/lbitem/litem/LAST_TOTAL_RIGHT = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/lbitem/litem/LAST_TOTAL_RIGHT != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/lbitem/litem/LAST_TOTAL_RIGHT,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<!-- <tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
										<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										���տ����ʽ�
										</p>
									</td>
									<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="body/cbitem/citem/LAST_AVLB_FUND"/>
										</p>
									</td>
								</tr> -->
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
										    <!-- �±ߵĶ��ǿո� ��������ʽ���Ķ��� -->
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(+)�������</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CUR_IN_FUND,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CUR_IN_FUND = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CUR_IN_FUND != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CUR_IN_FUND,'#,##0.00','CNY')"/>
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)���ճ���</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CUR_OUT_FUND,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CUR_OUT_FUND = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CUR_OUT_FUND != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CUR_OUT_FUND,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)���ս���������</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CUR_POUNDAGE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CUR_POUNDAGE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CUR_POUNDAGE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CUR_POUNDAGE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)���ս���������</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CUR_CSG_FEE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CUR_CSG_FEE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CUR_CSG_FEE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CUR_CSG_FEE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)������Ѻ������</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CUR_LOAN_POUNDAGE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CUR_LOAN_POUNDAGE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CUR_LOAN_POUNDAGE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CUR_LOAN_POUNDAGE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)���ղִ���</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CUR_AGENCY_FEE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CUR_AGENCY_FEE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CUR_AGENCY_FEE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CUR_AGENCY_FEE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)������Ϣ</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CUR_LOAN_INTEREST,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CUR_LOAN_INTEREST = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CUR_LOAN_INTEREST != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CUR_LOAN_INTEREST,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)����ΥԼ��</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CUR_DISOBEY_FEE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CUR_DISOBEY_FEE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CUR_DISOBEY_FEE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CUR_DISOBEY_FEE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(+)����Ӷ��</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/RET_POUNDAGE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/RET_POUNDAGE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/RET_POUNDAGE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/RET_POUNDAGE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(+)�����յ�����</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/GOT_PAYMENT,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/GOT_PAYMENT = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/GOT_PAYMENT != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/GOT_PAYMENT,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)���ո�������</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/PAID_PAYMENT,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/PAID_PAYMENT = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/PAID_PAYMENT != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/PAID_PAYMENT,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)�����˽Ჹ�˿�</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CUR_BUYER_DIFF,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CUR_BUYER_DIFF = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CUR_BUYER_DIFF != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CUR_BUYER_DIFF,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(+)����Ԥ�������˲�</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CSG_PAYMENT_DIFF,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CSG_PAYMENT_DIFF = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CSG_PAYMENT_DIFF != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CSG_PAYMENT_DIFF,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(+)����Ԥ�ջ����˲�</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CSG_RECEIVABLE_DIFF,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CSG_RECEIVABLE_DIFF = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CSG_RECEIVABLE_DIFF != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CSG_RECEIVABLE_DIFF,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>����ת��ӯ��</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CNY_BALANCE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CNY_BALANCE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CNY_BALANCE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CNY_BALANCE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>���ս���ӯ��</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CSG_BALANCE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CSG_BALANCE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CSG_BALANCE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CSG_BALANCE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<!-- ȥ�����ս���ӯ����������ӯ���͵���ת��ӯ���ӵ�һ�� <tr> 
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>���ս���ӯ��</p>
									</td>
									<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CSG_INCOME,'#,###0.00','CNY')"/>
										</p>
									</td>
								</tr> -->
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>���մ������</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/lbitem/litem/LAST_LOAN_BALANCE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/lbitem/litem/LAST_LOAN_BALANCE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/lbitem/litem/LAST_LOAN_BALANCE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/lbitem/litem/LAST_LOAN_BALANCE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)���ջ����ܶ�</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CUR_REPAY_SUM,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CUR_REPAY_SUM = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CUR_REPAY_SUM != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CUR_REPAY_SUM,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(+)���մ����ܶ�</p>
									</td>
								    <!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/DK_SUM - body/lbitem/litem/LAST_LOAN_BALANCE + body/cbitem/citem/CUR_REPAY_SUM,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/DK_SUM - body/lbitem/litem/LAST_LOAN_BALANCE + body/cbitem/citem/CUR_REPAY_SUM = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/DK_SUM - body/lbitem/litem/LAST_LOAN_BALANCE + body/cbitem/citem/CUR_REPAY_SUM != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/DK_SUM - body/lbitem/litem/LAST_LOAN_BALANCE + body/cbitem/citem/CUR_REPAY_SUM,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>���մ������</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CUR_LOAN_BALANCE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CUR_LOAN_BALANCE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CUR_LOAN_BALANCE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CUR_LOAN_BALANCE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>����</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/OTHER_FEE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/OTHER_FEE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/OTHER_FEE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/OTHER_FEE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>��.���վ�̬Ȩ��</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/TOTAL_RIGHT,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/TOTAL_RIGHT = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/TOTAL_RIGHT != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/TOTAL_RIGHT,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(+)���ո���ӯ��</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/ACCT_BALANCE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/ACCT_BALANCE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/ACCT_BALANCE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/ACCT_BALANCE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>��. ���ն�̬Ȩ��</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/DYNAMIC_RIGHT,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/DYNAMIC_RIGHT = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/DYNAMIC_RIGHT != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/DYNAMIC_RIGHT,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>�ġ����տ���</p>
									</td>
									<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<!-- <xsl:value-of select="format-number(body/cbitem/citem/RISK_MANAGEMENT,'#,###0.00','CNY')"/> -->
										</p>
									</td>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)��������</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/FRZ_ORD_FUND,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/FRZ_ORD_FUND = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/FRZ_ORD_FUND != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/FRZ_ORD_FUND,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)���ն���ռ��</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/SUBS_DEPOSIT,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/SUBS_DEPOSIT = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/SUBS_DEPOSIT != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/SUBS_DEPOSIT,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)�����������ռ��</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/FRZ_RISK_FUND,'#,###0.00','CNY')"/>--><!-- ��ȷ�� --><!--
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/FRZ_RISK_FUND = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/FRZ_RISK_FUND != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/FRZ_RISK_FUND,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>��ؿ������</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/AVLB_FUND,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/AVLB_FUND = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/AVLB_FUND != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/AVLB_FUND,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>�塢����</p>
									</td>
									<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<!-- <xsl:value-of select="format-number(body/cbitem/citem/CSG,'#,###0.00','CNY')"/> -->
										</p>
									</td>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)���ս��ն���</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CSG_FRZ_QTT,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CSG_FRZ_QTT = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CSG_FRZ_QTT != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CSG_FRZ_QTT,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>���տ������</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CSG_AVLB_BALN,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CSG_AVLB_BALN = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CSG_AVLB_BALN != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CSG_AVLB_BALN,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>������������</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/CASH_AVLB_BALN,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/CASH_AVLB_BALN = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/CASH_AVLB_BALN != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/CASH_AVLB_BALN,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>��.����Ӧ׷���ʽ�����</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/APP_FUND,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/cbitem/citem/APP_FUND = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/cbitem/citem/APP_FUND != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/cbitem/citem/APP_FUND,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
