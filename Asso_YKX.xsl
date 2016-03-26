<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html" indent="no" encoding="GBK" />
	<xsl:decimal-format name="CNY" decimal-separator="." grouping-separator=","/>
	<xsl:template match="root">
		<html>
			<head>
				<meta http-equiv="Content-Type"
					content="text/html; charset=gb2312" />
				<title>
					<xsl:value-of select="file_title" />
				</title>
			</head>
			<body>
				<table align="center">
					<tr>
						<td>
							<table align="center" width="100%"
								border="0">
								<tr>
									<td align="center">
										<H2>�����̿����嵥�±���</H2>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<table border="0" align="center"
								cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
								<tr>
									<td height="20" colspan="15"
										valign="middle" bgcolor="#FFFFFF">
										<table width="100%" height="30"
											border="0" cellpadding="0" cellspacing="0">
											<tr>
												<xsl:for-each
													select="top/item">
													<xsl:choose>
														<xsl:when
															test="position() = 1">
															<td
																align="right" valign="middle">
																��Ա���룺
															</td>
														</xsl:when>
														<xsl:when
															test="position() = 2">
															<td
																align="right" valign="middle">
																��Ա���ƣ�
															</td>
														</xsl:when>
														<xsl:when
															test="position() = 3">
															<td
																align="right" valign="middle">
																�� �ڣ�
															</td>
														</xsl:when>
													</xsl:choose>
													<td align="left"
														valign="middle">
														<xsl:value-of
															select="content" />
													</td>
												</xsl:for-each>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td align="center" width="349"
										height="20" bgcolor="#FFFFFF">
										<p>��Ŀ</p>
									</td>
									<td width="349" bgcolor="#FFFFFF">
										<p align="right">���</p>
									</td>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<!-- �±ߵĶ��ǿո� ��������ʽ���Ķ��� -->
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											�ڳ���̬Ȩ��
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/lqmbitem/lqmitem/TOTAL_RIGHT,'#,###0.00','CNY')"/>--><!-- ������ --><!--
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/lqmbitem/lqmitem/TOTAL_RIGHT = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/lqmbitem/lqmitem/TOTAL_RIGHT != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/lqmbitem/lqmitem/TOTAL_RIGHT,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											���
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/CUR_IN_FUND,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/CUR_IN_FUND = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/CUR_IN_FUND != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/CUR_IN_FUND,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											����
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/CUR_OUT_FUND,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/CUR_OUT_FUND = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/CUR_OUT_FUND != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/CUR_OUT_FUND,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											����������
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/CUR_POUNDAGE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/CUR_POUNDAGE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/CUR_POUNDAGE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/CUR_POUNDAGE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											����������
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/CUR_CSG_FEE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/CUR_CSG_FEE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/CUR_CSG_FEE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/CUR_CSG_FEE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
                </tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											��Ѻ������
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/CUR_LOAN_POUNDAGE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/CUR_LOAN_POUNDAGE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/CUR_LOAN_POUNDAGE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/CUR_LOAN_POUNDAGE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											�ִ���
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/CUR_AGENCY_FEE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/CUR_AGENCY_FEE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/CUR_AGENCY_FEE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/CUR_AGENCY_FEE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											��Ϣ
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/CUR_LOAN_INTEREST,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/CUR_LOAN_INTEREST = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/CUR_LOAN_INTEREST != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/CUR_LOAN_INTEREST,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											ΥԼ��
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/CUR_DISOBEY_FEE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/CUR_DISOBEY_FEE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/CUR_DISOBEY_FEE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/CUR_DISOBEY_FEE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											����Ӷ��
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/RET_POUNDAGE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/RET_POUNDAGE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/RET_POUNDAGE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/RET_POUNDAGE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											�յ�����
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/GOT_PAYMENT,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/GOT_PAYMENT = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/GOT_PAYMENT != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/GOT_PAYMENT,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											��������
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/PAID_PAYMENT,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/PAID_PAYMENT = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/PAID_PAYMENT != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/PAID_PAYMENT,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											�����˽Ჹ�˿�
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/CUR_BUYER_DIFF,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/CUR_BUYER_DIFF = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/CUR_BUYER_DIFF != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/CUR_BUYER_DIFF,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											Ԥ�������
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/CSG_PAYMENT_DIFF,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                 <xsl:choose>
                  <xsl:when test="body/mcbitem/mcitem/CSG_PAYMENT_DIFF = '0'">

                    <td bgcolor="#FFFFFF">
                      <p align="center">

                      </p>
                    </td>
                  </xsl:when>
                  <xsl:when test="body/mcbitem/mcitem/CSG_PAYMENT_DIFF != '0'">
                    <td bgcolor="#FFFFFF" align ="right">
                      <xsl:value-of select="format-number(body/mcbitem/mcitem/CSG_PAYMENT_DIFF,'#,##0.00','CNY')"/>
                      <!-- XXXXXX -->
                    </td>
                  </xsl:when>
                </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											Ԥ�ջ����
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/CSG_RECEIVABLE_DIFF,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/CSG_RECEIVABLE_DIFF = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/CSG_RECEIVABLE_DIFF != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/CSG_RECEIVABLE_DIFF,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											ת��ӯ��
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/CNY_BALANCE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/CNY_BALANCE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/CNY_BALANCE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/CNY_BALANCE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<!-- ȥ�����ս���ӯ����������ӯ���͵���ת��ӯ���ӵ�һ��  -->
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											����ӯ��
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/JIAOSHOU,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/JIAOSHOU = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/JIAOSHOU != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/JIAOSHOU,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											���´������
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/lmbitem/lmitem/LOAN_BALANCE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/lmbitem/lmitem/LOAN_BALANCE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/lmbitem/lmitem/LOAN_BALANCE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/lmbitem/lmitem/LOAN_BALANCE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											���´������
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/LOAN_BALANCE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/LOAN_BALANCE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/LOAN_BALANCE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/LOAN_BALANCE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											���»����ܶ�
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/lmbitem/lmitem/CUR_REPAY_SUM,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/lmbitem/lmitem/CUR_REPAY_SUM = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/lmbitem/lmitem/CUR_REPAY_SUM != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/lmbitem/lmitem/CUR_REPAY_SUM,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											���»����ܶ�
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/CUR_REPAY_SUM,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/CUR_REPAY_SUM = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/CUR_REPAY_SUM != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/CUR_REPAY_SUM,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											����
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/mcbitem/mcitem/OTHER_FEE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/mcbitem/mcitem/OTHER_FEE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/mcbitem/mcitem/OTHER_FEE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/mcbitem/mcitem/OTHER_FEE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											��ĩ��̬Ȩ��
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/ncbitem/ncitem/TOTAL_RIGHT,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/ncbitem/ncitem/TOTAL_RIGHT = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/ncbitem/ncitem/TOTAL_RIGHT != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/ncbitem/ncitem/TOTAL_RIGHT,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											��ĩ����ӯ��
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/ncbitem/ncitem/ACCT_BALANCE,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/ncbitem/ncitem/ACCT_BALANCE = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/ncbitem/ncitem/ACCT_BALANCE != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/ncbitem/ncitem/ACCT_BALANCE,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											��ĩ��̬Ȩ��
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/ncbitem/ncitem/DYNAMIC_RIGHT,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/ncbitem/ncitem/DYNAMIC_RIGHT = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/ncbitem/ncitem/DYNAMIC_RIGHT != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/ncbitem/ncitem/DYNAMIC_RIGHT,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											��ĩ��������
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/ncbitem/ncitem/FRZ_ORD_FUND,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/ncbitem/ncitem/FRZ_ORD_FUND = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/ncbitem/ncitem/FRZ_ORD_FUND != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/ncbitem/ncitem/FRZ_ORD_FUND,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											��ĩ����ռ��
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/ncbitem/ncitem/SUBS_DEPOSIT,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/ncbitem/ncitem/SUBS_DEPOSIT = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/ncbitem/ncitem/SUBS_DEPOSIT != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/ncbitem/ncitem/SUBS_DEPOSIT,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											��ĩ�������ռ��
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/ncbitem/ncitem/FRZ_RISK_FUND,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/ncbitem/ncitem/FRZ_RISK_FUND = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/ncbitem/ncitem/FRZ_RISK_FUND != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/ncbitem/ncitem/FRZ_RISK_FUND,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											��ĩ��ؿ������
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/ncbitem/ncitem/AVLB_FUND,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/ncbitem/ncitem/AVLB_FUND = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/ncbitem/ncitem/AVLB_FUND != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/ncbitem/ncitem/AVLB_FUND,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											��ĩ���ն���
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/ncbitem/ncitem/CSG_FRZ_QTT,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/ncbitem/ncitem/CSG_FRZ_QTT = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/ncbitem/ncitem/CSG_FRZ_QTT != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/ncbitem/ncitem/CSG_FRZ_QTT,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											��ĩ���տ������
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/ncbitem/ncitem/CSG_AVLB_BALN,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/ncbitem/ncitem/CSG_AVLB_BALN = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/ncbitem/ncitem/CSG_AVLB_BALN != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/ncbitem/ncitem/CSG_AVLB_BALN,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											��������
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/ncbitem/ncitem/CASH_AVLB_BALN,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/ncbitem/ncitem/CASH_AVLB_BALN = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/ncbitem/ncitem/CASH_AVLB_BALN != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/ncbitem/ncitem/CASH_AVLB_BALN,'#,##0.00','CNY')"/>
                        <!-- XXXXXX -->
                      </td>
                    </xsl:when>
                  </xsl:choose>
								</tr>
								<tr>
									<td width="469" height="20"
										bgcolor="#FFFFFF">
										<p>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text
												disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											Ӧ׷���ʽ�����
										</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of
												select="format-number(body/ncbitem/ncitem/APP_FUND,'#,###0.00','CNY')"/>
										</p>
									</td>-->
                  <xsl:choose>
                    <xsl:when test="body/ncbitem/ncitem/APP_FUND = '0'">

                      <td bgcolor="#FFFFFF">
                        <p align="center">

                        </p>
                      </td>
                    </xsl:when>
                    <xsl:when test="body/ncbitem/ncitem/APP_FUND != '0'">
                      <td bgcolor="#FFFFFF" align ="right">
                        <xsl:value-of select="format-number(body/ncbitem/ncitem/APP_FUND,'#,##0.00','CNY')"/>
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
