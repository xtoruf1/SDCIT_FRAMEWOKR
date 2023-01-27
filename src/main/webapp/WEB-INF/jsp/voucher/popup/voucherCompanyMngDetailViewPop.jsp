<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<form id="voucherCompanyInfoForm" name="voucherCompanyInfoForm" action="" method="post" enctype="multipart/form-data">
	<input type="hidden" name="bankbookFileId" id="bankbookFileId" value="<c:out value='${companyInfo.bankbookFileId}'/>"/>
	<input type="hidden" name="saupjaFileId" id="saupjaFileId" value="<c:out value='${companyInfo.saupjaFileId}'/>"/>
	<input type="hidden" name="etcFileId" id="etcFileId" value="<c:out value='${companyInfo.etcFileId}'/>"/>
<div class="fixed_pop_tit">
	<div class="flex popup_top">
		<div class="ml-auto">
			<button type="button" class="btn_sm btn_secondary" onclick="closeLayerPopup();">닫기</button>
		</div>
	</div>
		<div class="popup_body">
			<c:if test="${not empty companyInfo.returnRsn}">
			<div id="divReturnRsn" class="cont_block">
				<div class="tit_bar">
					<h3 class="tit_block">반려사유</h3>
				</div>

				<table class="formTable">
					<colgroup>
						<col style="width:16%;">
					</colgroup>
					<tr>
						<th>반려사유</th>
						<td >
							<textarea id="returnRsnDp" class="form_textarea" rows="4"  readonly="readonly"><c:out value='${companyInfo.returnRsn}'/></textarea>
						</td>
					</tr>
				</table>
			</div>
			</c:if>

			<div class="cont_block">
				<div class="tit_bar">
					<h3 class="tit_block">바우처 정보</h3>
				</div>

				<table class="formTable">
					<colgroup>
						<col style="width:16%" />
						<col />
						<col style="width:16%" />
						<col style="width:22%" />
					</colgroup>
					<tbody>
						<tr>
							<th rowspan="2" scope="row">사업명</th>
							<td rowspan="2">
								<c:out value='${companyInfo.voucherTitle}'/>
							</td>
							<th scope="row">바우처 사업기간</th>
							<td>
								<c:out value='${companyInfo.voucherStdt}'/> ~ <c:out value='${companyInfo.voucherEddt}'/>
							</td>
						</tr>
						<tr>
							<th scope="row">바우처 신청기간</th>
							<td>
								<c:out value='${companyInfo.receStdt}'/> ~ <c:out value='${companyInfo.receEddt}'/>
							</td>
						</tr>
					</tbody>
				</table>
			</div>


			<div class="cont_block">
				<div class="tit_bar">
					<h3 class="tit_block">업체 기본 정보</h3>
				</div>

				<table class="formTable">
					<colgroup>
						<col style="width:8%" />
						<col style="width:8%" />
						<col />
						<col style="width:12%" />
						<col style="width:17%" />
						<col style="width:8%" />
						<col style="width:8%" />
						<col style="width:22%" />
					</colgroup>
					<tbody>
						<tr>
							<th colspan="2" scope="row">무역업고유번호</th>
							<td>
								<c:out value='${companyInfo.tradeNo}'/>
							</td>
							<th scope="row">법인번호</th>
							<td>
								<c:out value='${companyInfo.corpNo}'/>
							</td>
							<th colspan="2" scope="row">사업자등록번호</th>
							<td>
								<c:out value='${companyInfo.corpRegNo}'/>
							</td>
						</tr>
						<tr>
							<th rowspan="2" scope="row">회사명</th>
							<th scope="row">국문</th>
							<td colspan="3">
								<c:out value='${companyInfo.corpNameKr}'/>
							</td>
							<th rowspan="2" scope="row">대표자</th>
							<th>국문</th>
							<td>
								<c:out value='${companyInfo.repreNameKr}'/>
							</td>
						</tr>
						<tr>
							<th scope="row">영문</th>
							<td colspan="3">
								<c:out value='${companyInfo.corpNameEn}'/>
							</td>
							<th scope="row">영문</th>
							<td>
								<c:out value='${companyInfo.repreNameEn}'/>
							</td>
						</tr>
						<tr>
							<th colspan="2" scope="row">주소</th>
							<td colspan="3">
								<c:out value='${companyInfo.corpZipcode}'/>, <c:out value='${companyInfo.corpAddr1}'/> <c:out value='${companyInfo.corpAddr2}'/>
							</td>
							<th colspan="2" scope="row">회사전화번호</th>
							<td>
								<c:out value='${companyInfo.corpTelno}'/>
							</td>
						</tr>
						<tr>
							<th colspan="2" scope="row">대표 E-Mail</th>
							<td colspan="3">
								<c:out value='${companyInfo.corpEmail}'/>
							</td>
							<th colspan="2" scope="row">휴대전화번호</th>
							<td>
								<c:out value='${companyInfo.corpHpno}'/>
							</td>
						</tr>
						<tr>
							<th rowspan="4" scope="row">담당자</th>
							<th scope="row">성명</th>
							<td>
								<c:out value="${ companyInfo.manName }" />
							</td>
							<th scope="row">부서명</th>
							<td>
								<c:out value="${ companyInfo.manDept }" />
							</td>
							<th colspan="2" scope="row">직위명</th>
							<td>
								<c:out value="${ companyInfo.manPos }" />
							</td>
						</tr>
						<tr>
							<th scope="row">전화번호</th>
							<td>
								<c:out value="${ companyInfo.manTelno1 }" />
								-
								<c:out value="${ companyInfo.manTelno2 }" />
								-
								<c:out value="${ companyInfo.manTelno3 }" />
							</td>

							<th scope="row">휴대폰번호</th>
							<td>
								<c:out value="${ companyInfo.manHpno2 }" />
								-
								<c:out value="${ companyInfo.manHpno2 }" />
								-
								<c:out value="${ companyInfo.manHpno3 }" />
							</td>
							<th colspan="2" scope="row">E-Mail</th>
							<td>
								<c:out value="${ companyInfo.manEmail01 }" />@<c:out value="${ companyInfo.manEmail02 }" />
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="cont_block">
				<div class="tit_bar">
					<h3 class="tit_block">지원금 한도 결정</h3>
				</div>

				<table class="formTable">
					<colgroup>
						<col style="width:16%" />
						<col />
						<col style="width:16%" />
						<col style="width:22%" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">회비 납부 년차</th>
							<td>
								<c:out value="${ companyInfo.duesYear }" /> 년
							</td>
							<th scope="row">기본지원금액</th>
							<td>
								<fmt:formatNumber value="${ companyInfo.baseSuppAmt }" /> 원
							</td>
						</tr>
						<tr>
							<th rowspan="3" scope="row">
								KITA 멤버쉽 <br>카드 발급<br>
								(2016년 이후 발급)
							</th>
							<td>
								<label style="cursor: pointer;"><input type="radio" name="kitaCardCd" value="Y" <c:out value="${ companyInfo.kitaCardCd eq 'Y' ? 'checked' : '' }" />  disabled="disabled" style="margin-right: 5px;"/>발급완료</label>
							</td>
							<th scope="row"></th>
							<td></td>
						</tr>
						<tr>
							<td>
								<label style="cursor: pointer;"><input type="radio" name="kitaCardCd" value="E" <c:out value="${ companyInfo.kitaCardCd eq 'E' ? 'checked' : '' }" />  disabled="disabled" style="margin-right: 5px;"/>발급예정</label>
							</td>
							<th scope="row">추가지원금액</th>
							<td>
								<fmt:formatNumber value="${ companyInfo.addSuppAmt }" /> 원
							</td>
						</tr>
						<tr>
							<td>
								<label style="cursor: pointer;"><input type="radio" name="kitaCardCd" value="N" <c:out value="${ companyInfo.kitaCardCd eq 'N' ? 'checked' : '' }" /> disabled="disabled" style="margin-right: 5px;" />미발급(발급 계획 없음, 추가 예산 없음)</label>
							</td>
							<th scope="row"><strong class="point"><span>총지원한도</span></strong></th>
							<td>
								<fmt:formatNumber value="${ companyInfo.baseSuppAmt + companyInfo.addSuppAmt}" /> 원
							</td>
						</tr>
					</tbody>
				</table>
			</div>



			<div class="cont_block">
				<div class="tit_bar">
					<h3 class="tit_block">정산입금용 계좌정보</h3>
				</div>

				<table class="formTable">
					<colgroup>
						<col style="width:16%" />
						<col />
						<col style="width:12%" />
						<col style="width:12%" />
						<col style="width:12%" />
						<col style="width:16%" />
						<col style="width:22%" />
					</colgroup>
					<tbody>
						<tr>
							<th rowspan="2" scope="row">신청회사<br>법인명의</th>
							<td colspan="6">
								※ 추후 정산금 지급 시 지원금을 입금받을 통장계좌 정보를 기입해 주세요. (<span><strong class="point">저축은행, 단위농협, 새마을금고는 제외</strong></span>)
							</td>
						</tr>
						<tr>
							<th scope="row">은행명</th>
							<td>
								<c:out value="${ companyInfo.bankCd }" />
							</td>
							<th scope="row">예금주</th>
							<td>
								<c:out value="${ companyInfo.accountHolder }" />
							</td>
							<th scope="row">계좌번호</th>
							<td>
								<c:out value="${ companyInfo.accountNum }" />
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="cont_block">
				<div class="tit_bar">
					<h3 class="tit_block">신청내역</h3>
				</div>

				<div style="width: 100%;height: 100%;">
					<div id="companyInfoSheet" class="sheet"></div>
				</div>
			</div>

			<div class="cont_block">
				<div class="tit_bar">
					<h3 class="tit_block">첨부서류</h3>
				</div>

				<table class="formTable">
					<colgroup>
						<col style="width:16%" />
						<col style="width:16%" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th rowspan="2" scope="row">기본서류</th>
							<th scope="row">통장사본</th>
							<td>
								<div id="attachFieldList">
									<c:forEach var="fileVO" items="${bankbookFileList}" varStatus="status">
										<div id="fileList_bankbook_<c:out value="${status.count}" />" class="addedFile">
											<a class="filename" href="javascript:doVoucherFileDown('<c:out value="${fileVO.atchFileId}"/>','<c:out value="${fileVO.fileSn}"/>')">
												<c:out value="${fileVO.orignlFileNm}"/> (<c:out value="${fileVO.fileMg}"/>&nbsp;byte)
											</a>
											<button type="button" onclick="viewer.showFileContents('${serverName}/voucher/voucherFileDownload.do?atchFileId=<c:out value="${fileVO.atchFileId}"/>&fileSn=<c:out value="${fileVO.fileSn}"/>','<c:out value="${fileVO.orignlFileNm}"/>','ttestvvou_${profile}_${fileVO.atchFileId}_${fileVO.fileSn}_${fileVO.fileMg}');" class="file_preview btn_tbl_border">
												<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
											</button>
										</div>
									</c:forEach>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">사업자등록증</th>
							<td>
								<div id="attachFieldList">
									<c:forEach var="fileVO" items="${saupjaFileList}" varStatus="status">
										<div id="fileList_saupja_<c:out value="${status.count}" />" class="addedFile">
											<a class="filename" href="javascript:doVoucherFileDown('<c:out value="${fileVO.atchFileId}"/>','<c:out value="${fileVO.fileSn}"/>')">
												<c:out value="${fileVO.orignlFileNm}"/> (<c:out value="${fileVO.fileMg}"/>&nbsp;byte)
											</a>
											<button type="button" onclick="viewer.showFileContents('${serverName}/voucher/voucherFileDownload.do?atchFileId=<c:out value="${fileVO.atchFileId}"/>&fileSn=<c:out value="${fileVO.fileSn}"/>','<c:out value="${fileVO.orignlFileNm}"/>','ttestvvou_${profile}_${fileVO.atchFileId}_${fileVO.fileSn}_${fileVO.fileMg}');" class="file_preview btn_tbl_border">
												<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
											</button>
										</div>
									</c:forEach>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2" scope="row" style="text-align: center;">추가서류</th>
							<td>
								<div id="attachFieldList">
									<c:forEach var="fileVO" items="${etcFileList}" varStatus="status">
										<div id="fileList_etc_<c:out value="${status.count}" />" class="addedFile">
											<a class="filename" href="javascript:doVoucherFileDown('<c:out value="${fileVO.atchFileId}"/>','<c:out value="${fileVO.fileSn}"/>')">
												<c:out value="${fileVO.orignlFileNm}"/> (<c:out value="${fileVO.fileMg}"/>&nbsp;byte)
											</a>
											<button type="button" onclick="viewer.showFileContents('${serverName}/voucher/voucherFileDownload.do?atchFileId=<c:out value="${fileVO.atchFileId}"/>&fileSn=<c:out value="${fileVO.fileSn}"/>','<c:out value="${fileVO.orignlFileNm}"/>','ttestvvou_${profile}_${fileVO.atchFileId}_${fileVO.fileSn}_${fileVO.fileMg}');" class="file_preview btn_tbl_border">
												<img src="<c:url value="/images/admin/ico_search_gray.png" />" alt="미리보기" /> 미리보기
											</button>
										</div>
									</c:forEach>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="cont_block">
				<div class="tit_bar">
					<h3 class="tit_block">정산이력</h3>
				</div>

				<div style="width: 100%;height: 100%;">
					<div id="companySettListSheet" class="sheet"></div>
				</div>
			</div>
		</div>
	</div>
</form>


<script type="text/javascript">

	$(document).ready(function(){

		getCompanyInfo();						// 신청내역 조회
		setSheetHeader_companySettList();		// 정산이력 목록 헤더
		getCompanySettList();					// 정산이력 목록 조회
	});

	// 레이어 팝업 외 영역 클릭시 레이어 팝업 닫기
	$('.modal').on('click', function(e){
		if (!$(e.target).is($('.modal-content, .modal-content *'))) {
			closeLayerPopup();
		}
	});

	function setSheetHeader_companyInfo(cnt) {	// 회사정보 헤더

		// 조회된 데이터가 없을시 cell Type을 AutoSum  => Int 변경한다
		var cellType = '';

		if(cnt > 0) {
			cellType = 'AutoSum';
		} else {
			cellType = 'Int';
		}

		// 데이터가 없는데도 AutoSum을 사용하면 시트에 나옴

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '상태'			, Type: 'Status'		, SaveName: 'status'			, Hidden: true});
		ibHeader.addHeader({Header: '바우처 시퀀스'		, Type: 'Text'			, SaveName: 'vmstSeq'			, Hidden: true});
		ibHeader.addHeader({Header: '순번'			, Type: 'Text'			, SaveName: 'no'				, Edit: false	, Width: 10		, Align: 'Center'});
		ibHeader.addHeader({Header: '이용희망서비스'		, Type: 'Text'			, SaveName: 'voucherName'		, Edit: false	, Width: 40		, Align: 'Left'});
		ibHeader.addHeader({Header: '신청여부'			, Type: 'CheckBox'		, SaveName: 'useYn'				, Edit: false	, Width: 20		, Align: 'Center'	, TrueValue: "Y"	, FalseValue: "N"	, HeaderCheck: 0});
		ibHeader.addHeader({Header: '지원금'			, Type: cellType		, SaveName: 'reqAmt'			, Edit: false	, Width: 30		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '지급완료'			, Type: cellType		, SaveName: 'payAmt'			, Edit: false	, Width: 30		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '지급대기'			, Type: cellType		, SaveName: 'payReadyAmt'		, Edit: false	, Width: 30		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '승인요청'			, Type: cellType		, SaveName: 'aprvReqAmt'		, Edit: false	, Width: 30		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '잔액'			, Type: cellType		, SaveName: 'balanceAmt'		, Edit: false	, Width: 30		, Align: 'Right'	, Format: 'Integer'});

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#companyInfoSheet')[0];
		if (typeof container !== 'undefined' && typeof companyInfoSheet.Index !== 'undefined') {
			companyInfoSheet.DisposeSheet();
		}
		createIBSheet2(container, 'companyInfoSheet', '100%', '10%');
		ibHeader.initSheet('companyInfoSheet');

		companyInfoSheet.SetEllipsis(1); // 말줄임 표시여부
		companyInfoSheet.SetSelectionMode(4);
	}

	function setSheetHeader_companySettList() {	// 사업 리스트 헤더

		var	ibHeader = new IBHeader();
		ibHeader.addHeader({Header: '정산상태코드'		, Type: 'Text'		, SaveName: 'accStatusCd'		, Hidden: true});
		ibHeader.addHeader({Header: '회차'			, Type: 'Text'		, SaveName: 'vouSettRum'		, Edit: false	, Width: 20		, Align: 'Center'});
		ibHeader.addHeader({Header: '신청서비스'		, Type: 'Text'		, SaveName: 'voucherName'		, Edit: false	, Width: 40		, Align: 'Left'});
		ibHeader.addHeader({Header: '신청금액'			, Type: 'Int'		, SaveName: 'reqAmt'			, Edit: false	, Width: 30		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '확정금액'			, Type: 'Int'		, SaveName: 'fixAmt'			, Edit: false	, Width: 30		, Align: 'Right'	, Format: 'Integer'});
		ibHeader.addHeader({Header: '신청일자'			, Type: 'Text'		, SaveName: 'regDt'				, Edit: false	, Width: 30		, Align: 'Center'})
		ibHeader.addHeader({Header: '승인일자'			, Type: 'Text'		, SaveName: 'confirmDt'			, Edit: false	, Width: 30		, Align: 'Center'})
		ibHeader.addHeader({Header: '지급일자'			, Type: 'Text'		, SaveName: 'payDt'				, Edit: false	, Width: 30		, Align: 'Center'})
		ibHeader.addHeader({Header: '상태'			, Type: 'Text'		, SaveName: 'accStatusCdNm'		, Edit: false	, Width: 30		, Align: 'Center'})

		ibHeader.setConfig({AutoFitColWidth: "search|resize|init|colhidden|rowtransaction|colresize",
            DeferredVScroll: 0,
            colresize: true,
            SelectionRowsMode: 1,
            SearchMode: 4,
            NoFocusMode : 0,
            Alternate : 0,
            Page: 10,
            SizeMode: 1});
		ibHeader.setHeaderMode({Sort: 0, ColResize: true, ColMove: true});

		var container = $('#companySettListSheet')[0];
		if (typeof container !== 'undefined' && typeof companySettListSheet.Index !== 'undefined') {
			companySettListSheet.DisposeSheet();
		}
		createIBSheet2(container, 'companySettListSheet', '100%', '10%');
		ibHeader.initSheet('companySettListSheet');

		companySettListSheet.SetEllipsis(1); // 말줄임 표시여부
		companySettListSheet.SetSelectionMode(4);

	}

	function getCompanyInfo() {	// 사업정보 조회

		var tradeNo = $('#tradeNo').val();
		var vmstSeq = $('#vmstSeq').val();

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherSettServiceList.do"
			, data : {'tradeNo' : tradeNo,
					  'vmstSeq' : vmstSeq}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){

				var resultCnt = data.resultList.length;

				setSheetHeader_companyInfo(resultCnt);			// 회사정보 헤더

				companyInfoSheet.LoadSearchData({data: (data.resultList || []) }, {Sync : true});

				if(data.resultList.length > 0) {
					var rowCnt = companyInfoSheet.RowCount();

					var vCnt = 0;

					var chkRow = companyInfoSheet.FindCheckedRow('useYn', {ReturnArray:1});

					if(chkRow.length > 0) {
						vCnt = chkRow.length;
					}

					var reqAmtSum = companyInfoSheet.GetCellValue(rowCnt+1, 'reqAmt');

					$('#reqAmtSum').val(reqAmtSum);
					companyInfoSheet.SetSumText(2, '합계');
					companyInfoSheet.SetSumText(3, "신청서비스 총 ("+ vCnt +") 건");
				}
			}
		});
	}

	function getCompanySettList() {

		var tradeNo = $('#tradeNo').val();
		var vmstSeq = $('#vmstSeq').val();

		global.ajax({
			type : 'POST'
			, url : "/voucher/selectVoucherSettList.do"
			, data : {'tradeNo' : tradeNo,
					  'vmstSeq' : vmstSeq}
			, dataType : 'json'
			, async : true
			, spinner : true
			, success : function(data){
				companySettListSheet.LoadSearchData({data: (data.resultList || []) }, {Sync : true});
			}
		});
	}

	function doVoucherFileDown(atchFileId, fileSn) {	// 파일 다운로드
		window.open("/voucher/voucherFileDownload.do?atchFileId="+atchFileId+"&fileSn="+fileSn+"");
	}

</script>