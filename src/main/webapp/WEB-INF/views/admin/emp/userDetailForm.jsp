<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="en">

<%@ include file="/WEB-INF/views/admin/include/meta.jsp"%>
<!--
  HOW TO USE: 
  data-theme: default (default), dark, light, colored
  data-layout: fluid (default), boxed
  data-sidebar-position: left (default), right
  data-sidebar-layout: default (default), compact
-->

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
	<div class="wrapper">
		<%@ include file="/WEB-INF/views/admin/include/sidebar.jsp"%>

		<div class="main">
			<%@ include file="/WEB-INF/views/admin/include/header.jsp"%>

			<main class="content">
				<div class="container-fluid p-0">

					<div style="float:right;">
						<button class="btn btn-primary mt-n1" id="btnEmpUpdate"><i class="fas fa-save"></i> 저장</button>
						<button class="btn btn-warning mt-n1" id="btnGoEmpMng"><i class="fas fa-list"></i> 목록</button>
					</div>
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><i class="align-middle" data-feather="edit"></i> <b>사용자 상세</b></h1>
					</div>

					<div class="row">

						<div class="col-md-12">
							<div class="card">
								<div class="card-header">
									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-angle-double-right"></i> 사용자 상세정보 조회</h5>
									<h6 class="card-subtitle text-muted"></h6>
								</div>
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-6">
											<form id ="empform">
												<div class="mb-3 row">
													<label for="companyNm" class="col-form-label col-sm-2 text-sm-end"><b>회사</b></label>
													<div class="col-sm-4">
														<input type="text" id="companyNm" class="form-control is-valid" disabled readonly>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="empNm" class="col-form-label col-sm-2 text-sm-end"><b>이름</b></label>
													<div class="col-sm-4">
														<input type="text" id="empNm" class="form-control is-valid" disabled readonly>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="email" class="col-form-label col-sm-2 text-sm-end"><b>이메일</b></label>
													<div class="col-sm-4">
														<input type="text" id="email" class="form-control" disabled readonly>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="deptNm" class="col-form-label col-sm-2 text-sm-end"><b>부서</b></label>
													<div class="col-sm-4">
														<input type="text" id="deptNm" class="form-control" disabled readonly>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="posNm" class="col-form-label col-sm-2 text-sm-end"><b>직위</b></label>
													<div class="col-sm-4">
														<input type="text" id="posNm" class="form-control" disabled readonly>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="empNo" class="col-form-label col-sm-2 text-sm-end"><b>사번</b></label>
													<div class="col-sm-4">
														<input type="text" id="empNo" class="form-control" disabled readonly>
													</div>
												</div>
											</form>
										</div>
										
										<div class="col-12 col-xl-6">
											<form>
												<div class="mb-3 row">
													<label for="enterDt" class="col-form-label col-sm-2 text-sm-end"><b>입사일</b></label>
													<div class="col-sm-4">
														<input id="enterDt" type="text" class="form-control flatpickr-minimum" disabled readonly placeholder="Select date" autocomplete="off"/>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="quitDt" class="col-form-label col-sm-2 text-sm-end"><b>퇴사일</b></label>
													<div class="col-sm-4">
														<input id="quitDt" type="text" class="form-control flatpickr-minimum" disabled readonly placeholder="Select date" autocomplete="off"/>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="jobTelNo" class="col-form-label col-sm-2 text-sm-end"><b>전화번호</b></label>
													<div class="col-sm-4">
														<input type="text" id="jobTelNo" class="form-control" disabled readonly>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="mobileTelNo" class="col-form-label col-sm-2 text-sm-end"><b>휴대폰번호</b></label>
													<div class="col-sm-4">
														<input type="text" id="mobileTelNo" class="form-control" disabled readonly>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="hiddenYn" class="col-form-label col-sm-2 text-sm-end"><b>숨김여부</b></label>
													<div class="col-sm-4">
														<div class="input-group">
															<select id="hiddenYn" class="form-select">
																<option selected value="">-선택-</option>
																<option value="Y">Yes</option>
																<option value="N">No</option>
															</select>
														</div>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="manualMngYn" class="col-form-label col-sm-2 text-sm-end"><b>수동여부</b></label>
													<div class="col-sm-4">
														<div class="input-group">
															<select id="manualMngYn" class="form-select">
																<option selected value="">-선택-</option>
																<option value="Y">Yes</option>
																<option value="N">No</option>
															</select>
														</div>
													</div>
												</div>
											</form>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</main>
			<%@ include file="/WEB-INF/views/admin/include/footer.jsp"%>
		</div>
	</div>

<form id="frmHiddenParam">
  <input type="hidden" id="pEmail" name="pEmail" value="<c:out value="${email}"/>"/>
  <input type="hidden" id="domainId" name="domainId" value="">
  <input type="hidden" id="companyCd" name="companyCd" value="">
</form>

<%@ include file="/WEB-INF/views/admin/include/script.jsp" %>

<script>
let fpEnterDt;
let fpQuitDt;
let referrer = document.referrer;

$(function() {
	fnSetMenuSelection();
	fnSetEvent();
	fnSetComponent();
	fnSetData();
})

function fnSetMenuSelection() {
	gfnSelectMenu("userManage", "userSide", "usermngform");
}

function fnSetComponent() {
	// Flatpickr
	fpEnterDt = flatpickr("#enterDt", {
		dateFormat: "Y-m-d"
	});
	fpQuitDt = flatpickr("#quitDt", {
		dateFormat: "Y-m-d"
	});
}

function fnSetEvent() {
	$("#btnEmpUpdate").off("click").on("click", function (e) {
		e.preventDefault();
		fnUpdateEmp();
	});
	
	$("#btnGoEmpMng").off("click").on("click", function (e) {
		e.preventDefault();
		location.href = "/admin/emps/usermngform";
	});
}

//사용자상세 데이터 Set
function fnSetData() {
	let email =  $('#pEmail').val();
	let apiUrl = '/rest/admin/employees/' + email;
	
	$.ajax({
        url: apiUrl,
        type: 'get',
        beforeSend : function(xmlHttpRequest) {
        	xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
     }).done(function(data) {
         $('#domainId').val(data.domainId);
         $('#companyCd').val(data.companyCd);
         $('#companyNm').val(gfnUnescapeHTML(data.companyNm));
         $('#empNm').val(gfnUnescapeHTML(data.empNm));
         $('#email').val(data.email);
         $('#deptNm').val(gfnUnescapeHTML(data.deptNm));
         $('#posNm').val(gfnUnescapeHTML(data.posNm));
         $('#empNo').val(data.empNo);
         fpEnterDt.setDate(gfnYmdFormat(data.enterDt, "-"));
         fpQuitDt.setDate(gfnYmdFormat(data.quitDt, "-"));
         $('#jobTelNo').val(data.jobTelNo);
         $('#mobileTelNo').val(data.mobileTelNo);
         $('#hiddenYn').val(data.hiddenYn);
         $('#manualMngYn').val(data.manualMngYn);
	}).fail(function(request, status, error) {
		gfnFailAlert(gCmmnUsrAdmNm + gCmmnEM_ServiceError, 5000);
	});
}

//사용자 상세정보 수정
function fnUpdateEmp() {
	let email =  $('#pEmail').val();
	let apiUrl = '/rest/admin/employees/' + email;
	let params = new Object();
	params.domainId = $("#domainId").val();
	params.companyCd = $("#companyCd").val();
	params.email = email;
	params.hiddenYn = $("#hiddenYn").val();
	params.manualMngYn = $("#manualMngYn").val();

	gfnShowLoadingBar();
	
	$.ajax({
        url: apiUrl,
        type: 'put',
        data: params,
        beforeSend : function(xmlHttpRequest) {
        	xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
	}).done(function(data) {
		gfnSuccessAlert(gCmmnUserNm + gCmmnSM_Update, 2000);
	}).fail(function(request, status, error) {
		gfnFailAlert(gCmmnUsrAdmNm + gCmmnEM_ServiceError, 5000);
	}).always(function(msg) {
		gfnHideLoadingBar();
	});
}

</script>

</body>

</html>