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
						<button id="btnSearch" class="btn btn-primary mt-n1"><i class="fas fa-search"></i> 조회</button>
					</div>
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><i class="fas fa-sync"></i> <b>EP 연동</b></h1>
					</div>
					
					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="empCompanyCd" class="col-form-label col-sm-3 text-sm-end"><b>회사</b></label>
												<div class="col-sm-8">
													<select id="empCompanyCd" class="form-select mb-2" onchange="fnChangeCompany()">
													</select>
												</div>
											</div>
										</div>
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="syncDiv" class="col-form-label col-sm-3 text-sm-end"><b>구분</b></label>
												<div class="col-sm-8">
													<select id="syncDiv" class="form-select mb-2">
														<option selected value="">-선택-</option>
														<option value="TODB">TODB</option>
														<option value="TOSYNC">TOSYNC</option>
													</select>
												</div>
											</div>
										</div>
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="autoDiv" class="col-form-label col-sm-3 text-sm-end"><b>자동/수동</b></label>
												<div class="col-sm-8">
													<select id="autoDiv" class="form-select mb-2">
														<option selected value="">-선택-</option>
														<option value="Y">자동</option>
														<option value="N">수동</option>
													</select>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-header">
									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 데이터 동기화</h5>
								</div>
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-6">
											<form>
												<div class="mb-3 row">
													<label for="btnSyncAll" class="col-form-label col-sm-3 text-sm-end"><b>전체 정보</b></label>
													<div class="col-sm-8">
														<button id="btnSyncAll" class="btn btn-info"><i class="fas fa-fw fa-cog"></i> 가져오기</button>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="btnSyncCode" class="col-form-label col-sm-3 text-sm-end"><b>코드 정보</b></label>
													<div class="col-sm-4">
														<button id="btnSyncCode" class="btn btn-info"><i class="fas fa-fw fa-cog"></i> 가져오기</button>
													</div>
												</div>
											</form>
										</div>
										<div class="col-12 col-xl-6">
											<form>
												<div class="mb-3 row">
													<label for="btnSyncEmp" class="col-form-label col-sm-2 text-sm-end"><b>사용자 정보</b></label>
													<div class="col-sm-8">
														<button id="btnSyncEmp" class="btn btn-info"><i class="fas fa-fw fa-cog"></i> 가져오기</button>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="btnSyncDept" class="col-form-label col-sm-2 text-sm-end"><b>부서 정보</b></label>
													<div class="col-sm-8">
														<button id="btnSyncDept" class="btn btn-info"><i class="fas fa-fw fa-cog"></i> 가져오기</button>
													</div>
												</div>
											</form>
										</div>
									</div>
								</div>
							</div>
						</div>	
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-header">
									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 연동 History</h5>
								</div>
								<div class="card-body">
									<table id="syncTable" class="table table-striped" style="width:100%">
										<thead>
											<tr>
												<th>SEQ</th>
												<th>구분</th>
												<th>자동/수동</th>
												<th>회사</th>
												<th>연동 일자</th>
												<th>사용자 연동 결과</th>
												<th>부서 연동 결과</th>
												<th>코드 연동 결과</th>
											</tr>
										</thead>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</main>

			<%@ include file="/WEB-INF/views/admin/include/footer.jsp"%>
		</div>


<%@ include file="/WEB-INF/views/admin/include/script.jsp" %>

<script>
let dtSyncHisTable;

$(function() {
	fnSetMenuSelection();
	fnSetCompany();
	fnSetEvent();
})

function fnSetMenuSelection() {
	gfnSelectMenu("epsyncform", "", "");
}


function fnSetEvent() {
	$("#btnSearch").off("click").on("click", function (e) {
		e.preventDefault();
		fnReSelSyncLogTable();
	});
	
	$("#btnSyncAll").off("click").on("click", function (e) {
		e.preventDefault();
		fnSyncData("all", "전체 정보");
	});
	
	$("#btnSyncEmp").off("click").on("click", function (e) {
		e.preventDefault();
		fnSyncData("emp", "사용자 정보");
	});
	
	$("#btnSyncDept").off("click").on("click", function (e) {
		e.preventDefault();
		fnSyncData("dept", "부서 정보");
	});
	
	$("#btnSyncCode").off("click").on("click", function (e) {
		e.preventDefault();
		fnSyncData("code", "코드 정보");
	});
	
}

//회사목록 SelectBox 조회
function fnSetCompany() {
	let apiUrl = '/rest/admin/companies';
	$.ajax({
	    url: apiUrl,
	    type: 'get',
	    beforeSend : function(xmlHttpRequest) {
	    	xmlHttpRequest.setRequestHeader("AJAX", "true");
	    }
	}).done(function(data) {
		$.each(data, function(idx, item){
			let option = $("<option value=" + item.companyCd + ">" + item.companyNm + "</option>");
	    	$('#empCompanyCd').append(option);
	    });
	}).always(function(msg) {
		fnSetSyncLogTable();
	});
}

//회사 select box 변경
function fnChangeCompany() {
	$("#syncDiv").val("");
	$("#autoDiv").val("");
	fnReSelSyncLogTable();
}

//EP Sync Data
function fnSyncData(sep, sepmsg) {
	gfnShowLoadingBar();
	let params = new Object();
	params.companyCd = $("#empCompanyCd").val();
	params.syncCode = sep;
	$.ajax({
		type:'post',
		url:'/rest/admin/sync/data',
		data: params,
		beforeSend : function(xmlHttpRequest) {
			xmlHttpRequest.setRequestHeader("AJAX", "true");
		}
	}).done(function(data) {
		gfnSuccessAlert(sepmsg + gCmmnSM_SyncData, 2000);
		fnReSelSyncLogTable();
	}).fail(function(request, status, error) {
		gfnFailAlert(gCmmnUsrAdmNm + gCmmnEM_ServiceError, 5000);
	}).always(function(msg) {
		gfnHideLoadingBar();
	});
}

//Sync Log 조회
function fnSetSyncLogTable() {
	let apiUrl = "/rest/admin/sync/logs";
	
	dtSyncHisTable = $("#syncTable").DataTable({
		ajax: {
			url : apiUrl,
			data : function (d) {
				d.companyCd = $("#empCompanyCd").val();
				d.syncDiv = $("#syncDiv").val();
				d.autoDiv = $("#autoDiv").val();
		  	},
			dataSrc : "data"
		},
		columns: [
           	{data: "seq", width : "100px"},
           	{data: "syncDiv"},
           	{
           		data: "autoDiv",
           		render: function(data) {
   					if(data == "Y") return "자동";
   					else if(data == "N") return "수동";
   					return data;
           		}
           	},
   			{data: "companyNm"},
   			{data: "syncDate", width : "200px"},
   			{data: "empSyncResult", width : "150px", className: 'text-center'},
   			{data: "deptSyncResult", width : "150px", className: 'text-center'},
   			{data: "codeSyncResult", width : "150px", className: 'text-center'}
       	],
       	processing: true,
		serverSide: true,
		ordering : false,
       	destroy: true,
       	responsive: true,
       	info: true,
		searching: false,
		scrollY: 365,
		scrollCollapse : false,
		paging : true,
		select : false,
		lengthChange : true,
		lengthMenu : [10, 50, 100, 500],
		loadBeforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", "true");
		}
 	});
}

//연동 History 재조회
function fnReSelSyncLogTable() {
	dtSyncHisTable.ajax.reload();
}

</script>

</body>

</html>