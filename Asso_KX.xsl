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
										<H3>交易商款项清单日报表</H3>
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
								<!--
								xml.其他 = lastFrzRiskFund - frzRiskFund - curManageFee;
								xsl.其他 = xml.其他 - 已付货款 + 已收货款 - 买方补退货款
								-->
								<tr>
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>一、上日静态权益</p>
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
										上日可用资金
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
										    <!-- 下边的都是空格 来构建格式化的段落 -->
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(+)当日入金</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)当日出金</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)当日交易手续费</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)当日交收手续费</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)当日质押手续费</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)当日仓储费</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)当日利息</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)当日违约金</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(+)返还佣金</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(+)当日收到货款</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)当日付出货款</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)货款了结补退款</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(+)当日预付货款退补</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(+)当日预收货款退补</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>当日转让盈亏</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>当日交收盈亏</p>
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
								<!-- 去掉当日交收盈亏，将交收盈亏和当日转让盈亏加到一起 <tr> 
									<td width="469" height="20" bgcolor="#FFFFFF">
										<p>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>当日交收盈亏</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>上日贷款余额</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)当日还款总额</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(+)当日贷款总额</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>当日贷款余额</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>其他</p>
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
										<p>二.当日静态权益</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(+)当日浮动盈亏</p>
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
										<p>三. 当日动态权益</p>
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
										<p>四、风险控制</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)报单冻结</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)当日定金占用</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)当日其它风控占用</p>
									</td>
									<!--<td width="229" bgcolor="#FFFFFF">
										<p align="right">
											<xsl:value-of select="format-number(body/cbitem/citem/FRZ_RISK_FUND,'#,###0.00','CNY')"/>--><!-- 待确定 --><!--
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>风控可用余额</p>
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
										<p>五、交收</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(-)当日交收冻结</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>交收可用余额</p>
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
										<p>六、可提款余额</p>
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
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>七.当日应追交资金数额</p>
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
