<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="en">

<%@ include file="/WEB-INF/views/admin/include/meta.jsp"%>
<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
	<div class="wrapper">
		<%@ include file="/WEB-INF/views/admin/include/sidebar.jsp"%>

		<div class="main">
			<%@ include file="/WEB-INF/views/admin/include/header.jsp"%>

			<main class="content">
				<div class="container-fluid p-0">

					<div style="float:right;">
						<button class="btn btn-primary mt-n1" id="btnSearch"><i class="fas fa-search"></i> 조회</button>
						<button class="btn btn-warning mt-n1" id="btnMngAdd" onclick="setTimeout(fnLoadUsers, 500)" data-bs-toggle="modal" data-bs-target="#mngAddModal" ><i class="fas fa-add"></i> 할당</button>
						<button class="btn btn-danger mt-n1" id="btnCancle"><i class="fas fa-x"></i> 취소</button>
					</div>
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><i class="fas fa-user-lock"></i> <b>사용자권한 관리</b></h1>
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
												<label for="mngEmpNm" class="col-form-label col-sm-3 text-sm-end"><b>성명</b></label>
												<div class="col-sm-8">
													<div class="input-group">
														<input type="text" id="mngEmpNm" class="form-control"> 
													</div>
												</div>
											</div>
										</div>
										
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="mngEmail" class="col-form-label col-sm-3 text-sm-end"><b>이메일</b></label>
												<div class="col-sm-8">
													<div class="input-group">
														<input type="text" id="mngEmail" class="form-control"> 
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-12 col-xl-12">
							<div class="card">
								<div class="card-header">
									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 관리자 목록</h5>
								</div>
								<div class="card-body">
									<table id="managersTable" class="table table-striped" style="width:100%">
										<thead>
											<tr>
												<th>회사</th>
												<th>회사코드</th>
												<th>성명</th>
												<th>직위</th>
												<th>부서</th>
												<th>이메일</th>
												<th>권한</th>
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
		
		<div class="modal fade" id="mngAddModal" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog modal-lg" role="document" style=" --bs-modal-width:1100px">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title"><i class="fas fa-angle-double-right"></i> 관리자 추가</h4>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body m-3">
						<div class="row">
							<div class="col-md-12">
							<div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-5">
											<div class="row">
												<label for="userEmpNm" class="col-form-label col-sm-3 text-sm-end"><b>성명</b></label>
												<div class="col-sm-8">
													<div class="input-group">
														<input type="text" id="userEmpNm" class="form-control">
														<button class="btn btn-secondary" id="btnEmpNmSearch"><i class="fas fa-search"></i></button> 
													</div>
												</div>
											</div>
										</div>
										<div class="col-12 col-xl-5">
											<div class="row">
												<label for="userEmail" class="col-form-label col-sm-3 text-sm-end"><b>이메일</b></label>
												<div class="col-sm-8">
													<div class="input-group">
														<input type="text" id="userEmail" class="form-control">
														<button class="btn btn-secondary" id="btnEmailSearch"><i class="fas fa-search"></i></button> 
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-12 col-xl-12">
								<div class="card">
									<div class="card-body">
										<table id="userAddTable" class="table table-striped" style="width:100%">
											<thead>
												<tr>
													<th>회사</th>
													<th>회사코드</th>
													<th>성명</th>
													<th>직위</th>
													<th>부서</th>
													<th>이메일</th>
													<th>권한</th>
												</tr>
											</thead>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
						<button type="button" id="btnUserAssignModal" class="btn btn-warning">할당</button>
					</div>
				</div>
			</div>
		</div>
	</div>


<%@ include file="/WEB-INF/views/admin/include/script.jsp" %>

<script>
let dtManagers;
let dtUsers;

$(function() {
	fnSetMenuSelection();
	fnSetEvent();
	fnSetComponent();
})

function fnSetMenuSelection() {
	gfnSelectMenu("userManage", "userSide", "authmngform");
}

function fnSetComponent() {
	fnSetCompany();
}

function fnSetEvent() {
	$("#mngEmpNm").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnReselManagers();
		}
	});
	$("#mngEmail").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnReselManagers();
		}
	});
	$("#btnSearch").off("click").on("click", function (e) {
		e.preventDefault();
		fnReselManagers();
	});
	
	$("#btnCancle").off("click").on("click", function (e) {
		e.preventDefault();
		let len = $('#managersTable').DataTable().rows('.selected').data().length;
		if(len == 0) {
			gfnFailAlert("사용자가 선택되지 않았습니다.", 5000);
			return;
		}
		let msg = "해당 사용자의 관리자 권한을 취소하시겠습니까?";
		let callback = fnDeleteManager;
		gfnInitWrnCfmMdlDialog(msg, callback);
	});
	
	$("#btnUserAssignModal").off("click").on("click", function (e) {
		e.preventDefault();
		fnInsertManager();
	});
	
	$("#userEmpNm").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnReselUsers();
		}
	});
	$("#btnEmpNmSearch").off("click").on("click", function (e) {
		e.preventDefault();
		fnReselUsers();
	});
	$("#userEmail").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnReselUsers();
		}
	});
	$("#btnEmailSearch").off("click").on("click", function (e) {
		e.preventDefault();
		fnReselUsers();
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
		fnLoadManagers();
	});
}

//회사 select box 변경
function fnChangeCompany() {
	fnResetSearch();
	fnReselManagers();
	fnReselUsers();
}

//관리자목록 조회
function fnLoadManagers() {
	let apiUrl = '/rest/admin/managers/all';
	
	dtManagers = $("#managersTable").DataTable({
		ajax: {
			url : apiUrl,
            type : "POST",
			dataSrc : "data",
			data : function (d) {
				d.empNm = $("#mngEmpNm").val();
				d.email = $("#mngEmail").val();
				d.companyCd = $("#empCompanyCd").val();
		    },
		    error : function (xhr, error, code) {
		    	gfnFailAlert(gCmmnUsrAdmNm + gCmmnEM_ServiceError, 5000);
			}			    
		},
		columns: [
           	{data: 'companyNm'},
           	{data: 'companyCd', visible: false},
   			{data: 'empNm'},
   			{data: 'posNm'},
   			{data: 'deptNm'},
   			{data: 'email'},
   			{data: 'authorityName'},
       	],
       	processing: true,
		serverSide: true,
		ordering : false,
       	destroy: true,
       	responsive: true,
       	info: true,
		searching: false,
		scrollY: 360,
		scrollCollapse : false,
		paging : true,
		lengthChange : true,
		lengthMenu : [10, 50, 100, 500],
		select: {
			style: 'multi'
		},
		loadBeforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", "true");
		},
		initComplete: function () {
			gfnSuccessAlert(gCmmnUsrAdmNm + gCmmnSM_List, 2000);
		}			
 	});
}

//관리자목록 재조회
function fnReselManagers() {
	dtManagers.ajax.reload(function (json) {
		if (json.resultCode === "SUCCESS") {
			gfnSuccessAlert(gCmmnUsrAdmNm + gCmmnSM_List, 2000);
		}
		else {
			gfnFailAlert(gCmmnUsrAdmNm + gCmmnEM_ServiceError, 5000);
		}
	});
}

//할당 팝업의 사용자목록 조회
function fnLoadUsers() {
	let apiUrl = '/rest/admin/users';
	
	dtUsers = $("#userAddTable").DataTable({
		ajax: {
			url : apiUrl,
			dataSrc : "data",
			data : function (d) {
				d.empNm = $("#userEmpNm").val();
				d.email = $("#userEmail").val();
				d.companyCd = $("#empCompanyCd").val();
		    }
		},
		columns: [
           	{data: 'companyNm'},
           	{data: 'companyCd', visible: false},
   			{data: 'empNm'},
   			{data: 'posNm'},
   			{data: 'deptNm', width : "150px"},
   			{data: 'email'},
   			{data: 'authorityName'},
       	],
       	processing: true,
		serverSide: true,
		ordering : false,
       	destroy: true,
       	responsive: true,
       	info: true,
		searching: false,
		scrollY: 355,
		scrollCollapse : false,
		paging : true,
		lengthChange : false,
		lengthMenu : [10, 50, 100, 500],
		select: {
			style: 'multi'
		},
		loadBeforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", "true");
		},
 	});
}

//사용자목록 재조회
function fnReselUsers() {
	dtUsers.ajax.reload();
}

//관리자 권한 할당
function fnInsertManager() {
	let apiUrl = '/rest/admin/managers';
	let params = new Object();
	
	let len = $('#userAddTable').DataTable().rows('.selected').data().length;
	if(len == 0) {
		gfnFailAlert("사용자가 선택되지 않았습니다.", 5000);
		return;
	}
	
	params.companyCd = $("#empCompanyCd").val();
	for(let i = 0; i < len; i++) {
		let data = $('#userAddTable').DataTable().rows('.selected').data()[i];
		params['managers[' + i +']'] = data.email;
	}
	
	gfnShowLoadingBar();
	$.ajax({
        url: apiUrl,
        type: 'post',
        data: params,
        beforeSend : function(xmlHttpRequest) {
        	xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
	}).done(function(data) {
		gfnSuccessAlert("해당 사용자의 관리자 권한이 할당되었습니다.", 2000);
		$('#mngAddModal').modal('hide');
		dtManagers.ajax.reload();
	}).fail(function(request, status, error) {
		gfnFailAlert(error, 5000);
	}).always(function(msg) {
		gfnHideLoadingBar();
	});
}

//관리자 권한 취소
function fnDeleteManager() {
	let apiUrl = '/rest/admin/managers';
	let params = new Object();
	params.companyCd = $("#empCompanyCd").val();
	
	let len = $('#managersTable').DataTable().rows('.selected').data().length;
	for(let i = 0; i < len; i++) {
		let data = $('#managersTable').DataTable().rows('.selected').data()[i];
		params['managers[' + i +']'] = data.email;
	}
	
	gfnShowLoadingBar();
	$.ajax({
        url: apiUrl,
        method: 'delete',
        data: params,
        beforeSend : function(xmlHttpRequest) {
        	xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
	}).done(function(data) {
		gfnSuccessAlert("해당 사용자의 관리자 권한이 취소되었습니다.", 2000);
		dtManagers.ajax.reload();
	}).fail(function(request, status, error) {
		gfnFailAlert(error, 5000);
	}).always(function(msg) {
		gfnHideLoadingBar();
	});
}

//검색조건 초기화
function fnResetSearch() {
	$("#mngEmpNm").val("");
	$("#mngEmail").val("");
	$("#userEmpNm").val("");
	$("#userEmail").val("");
	$('#managersTable').DataTable().rows('.selected').deselect();
	$('#userAddTable').DataTable().rows('.selected').deselect();
}
</script>

</body>

</html>