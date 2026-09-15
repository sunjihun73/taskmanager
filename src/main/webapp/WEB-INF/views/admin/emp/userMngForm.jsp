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
						<button class="btn btn-primary mt-n1" id="btnSearch"><i class="fas fa-search"></i> 조회</button>
					</div>
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><i class="fas fa-user-cog"></i> <b>사용자 관리</b></h1>
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
												<label for="empEmpNm" class="col-form-label col-sm-3 text-sm-end"><b>성명</b></label>
												<div class="col-sm-8">
													<div class="input-group">
														<input type="text" id="empEmpNm" class="form-control"> 
													</div>
												</div>
											</div>
										</div>
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="empEmail" class="col-form-label col-sm-3 text-sm-end"><b>이메일</b></label>
												<div class="col-sm-8">
													<div class="input-group">
														<input type="text" id="empEmail" class="form-control"> 
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
						<div class="col-12 col-xl-3">
							<div class="card">
								<div class="card-header">
									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 부서 목록</h5>
								</div>
								<div class="card-body">
									<div class="input-group">
										<input type="text" id="empDeptNm" class="form-control" placeholder="부서명">
										<button class="btn btn-secondary" id="btnEmpDeptNmSearch"><i class="fas fa-search"></i></button> 
									</div>
									<div id="treeDeptList" style="height:442px;overflow:auto;"></div>
								</div>
							</div>
						</div>
						<div class="col-12 col-xl-9">
							<div class="card">
								<div class="card-header">
									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 사용자 목록</h5>
								</div>
								<div class="card-body">
									<table id="empMngTable" class="table table-striped" style="width:100%">
										<thead>
											<tr>
												<th>상세</th>
												<th>회사</th>
												<th>성명</th>
												<th>직위</th>
												<th>부서</th>
												<th>이메일</th>
												<th>수동여부</th>
												<th>숨김여부</th>
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

	</div>

<%@ include file="/WEB-INF/views/admin/include/script.jsp" %>

<script>
let dtEmpList;
let gDeptCd = "";

$(function() {
	fnSetMenuSelection();
	fnSetEvent();
	fnSetComponent();
})

function fnSetMenuSelection() {
	gfnSelectMenu("userManage", "userSide", "usermngform");
}

function fnSetComponent() {
	fnSetCompany();
}

function fnSetEvent() {
	$("#empDeptNm").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			let searchString = $("#empDeptNm").val();
			$('#treeDeptList').jstree(true).search(searchString);
		}
	});
	$("#btnEmpDeptNmSearch").off("click").on("click", function (e) {
		e.preventDefault();
		let searchString = $("#empDeptNm").val();
		$('#treeDeptList').jstree(true).search(searchString);
	});
	
	$("#empEmpNm").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnResetDeptSearch();
			fnReselEmpList();
		}
	});
	$("#empEmail").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnResetDeptSearch();
			fnReselEmpList();
		}
	});
	$("#btnSearch").off("click").on("click", function (e) {
		e.preventDefault();
		fnResetDeptSearch();
		fnReselEmpList();
	});

    fnGetSeacrhCondition();
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
		fnLoadEmpList();
		fnInitTree();
	});
}

//사용자목록 조회
function fnLoadEmpList() {
	let apiUrl = '/rest/admin/employees';
	dtEmpList = $("#empMngTable").DataTable({
		ajax: {
			url : apiUrl,
            type : "POST",
			dataSrc : "data",
			data : function (d) {
				d.deptCd = gDeptCd;
				d.empNm = $("#empEmpNm").val();
				d.email = $("#empEmail").val();
				d.companyCd = $("#empCompanyCd").val();
		    },
		    error : function (xhr, error, code) {
		    	gfnFailAlert(gCmmnUsrAdmNm + gCmmnEM_ServiceError, gDelay_Long);
			}		    
		},
		columns: [
			{
   				data: 'email',
   				className: 'text-center',
   				width : "60px",
   				render: function(data) {
   					return '<button class="btn btn-info btn-sm" type="button" onclick="fnGoEmpDetail(' + "'" + data + "'" + ')"><i class="fas fa-search"> 상세</i></button>';
   				}
   			},
			{data: 'companyNm', width : "150px"},
   			{data: 'empNm'},
   			{data: 'posNm'},
   			{data: 'deptNm', width : "150px"},
   			{data: 'email'},
   			{data: 'manualMngYn'},
   			{data: 'hiddenYn'},
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
		loadBeforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", "true");
		},
		initComplete: function () {
			gfnSuccessAlert(gCmmnUserNm + gCmmnSM_List, gDelay_Short);
		}		
 	});
	gDeptCd = '';
}

//사용자목록 재조회
function fnReselEmpList() {
	dtEmpList.ajax.reload(function (json) {
		if (json.resultCode === "SUCCESS") {
			gfnSuccessAlert(gCmmnUserNm + gCmmnSM_List, gDelay_Short);
		}
		else {
			gfnFailAlert(gCmmnUsrAdmNm + gCmmnEM_ServiceError, gDelay_Long);
		}
	});
}

//회사 select box 변경
function fnChangeCompany() {
	fnResetEmpSearch();
	fnReselTree();
	fnReselEmpList();
}

//부서트리 생성
function fnInitTree() {
	let apiUrl = "/rest/admin/depts/all";
	let params = new Object();
	params.companyCd = $("#empCompanyCd").val();
	
	let deptList = new Array();
 	$.ajax({
		type:'get',
		url:apiUrl,
		data: params,
		dataType:'json',
		success: function(data) {
	        $.each(data, function(idx, item){
	        	if(item.parentDeptCd == '0') deptList[idx] = {id:item.deptCd, parent:'#', text:item.deptNm, icon:'/adminkit/common/common/images/company.png'};
	        	else deptList[idx] = {id:item.deptCd, parent:item.parentDeptCd, text:item.deptNm};
	        });
	        $('#treeDeptList').jstree({
	            'core': {
	                'data': deptList
	            },
	            'types': {
	                'default': {
	                	'icon': '/adminkit/common/common/images/dept.png'
	                }
	            },
	            'plugins' : ["search", "types"]
	        })
	        // 노드 선택시 발생하는 이벤트
	        .bind('select_node.jstree', function(event, data){
	        	$("#empEmpNm").val("");
	        	gDeptCd = data.instance.get_node(data.selected).id;
	            fnReselEmpList();
	        })
	        //gfnSuccessAlert(gCmmnDeptNm + gCmmnSM_List, 2000);
		},
		error:function (data) {
			gfnFailAlert(gCmmnUsrAdmNm + gCmmnEM_ServiceError, gDelay_Long);
		}
	});
}

//트리 재조회
function fnReselTree() {
	let apiUrl = "/rest/admin/depts/all";
	let params = new Object();
	params.companyCd = $("#empCompanyCd").val();
	let deptList = new Array();
 	$.ajax({
		type:'get',
		url:apiUrl,
		data: params,
		dataType:'json',
		success: function(data) {
			$.each(data, function(idx, item){
	        	if(item.parentDeptCd == '0') deptList[idx] = {id:item.deptCd, parent:'#', text:item.deptNm, icon:'/adminkit/common/common/images/company.png'};
	        	else deptList[idx] = {id:item.deptCd, parent:item.parentDeptCd, text:item.deptNm};
	        });
	  		$('#treeDeptList').jstree(true).settings.core.data = deptList;
	  		$('#treeDeptList').jstree(true).refresh();
		}
	});
}

//부서트리 검색 초기화
function fnResetDeptSearch() {
	gDeptCd = '';
	$("#empDeptNm").val("");
	$("#treeDeptList").jstree("deselect_all");
	$("#treeDeptList").jstree(true).clear_search()
}

//검색조건 초기화
function fnResetEmpSearch() {
	$("#empEmpNm").val("");
	$("#empEmail").val("");
	fnResetDeptSearch();
	$('#empMngTable').DataTable().rows('.selected').deselect();
}

// 사용자 상세 버튼 클릭시 이동
function fnGoEmpDetail(email) {
    fnSetSessionStorage();
	let apiUrl = '/admin/emps/userdetailform';
	let params = new Object();
	//params.companyCd = $("#empCompanyCd").val();
	params.email = email;
	fnPostMove(apiUrl, params);
}

// 검색조건 유지 (세션스토리지에서 저장했던 검색조건을 가지고옴)
function fnGetSeacrhCondition() {
    $("#empCompanyCd").val(sessionStorage.getItem("USER_MNG_FORM_EMP_COMPANY_CD"));
    $("#empEmpNm").val(sessionStorage.getItem("USER_MNG_FORM_EMP_NM"));
    $("#empEmail").val(sessionStorage.getItem("USER_MNG_FORM_EMP_EMAIL"));

    sessionStorage.clear();
}

//검색조건 세션스토리지에 저장
function fnSetSessionStorage() {
    sessionStorage.setItem("USER_MNG_FORM_EMP_COMPANY_CD",$("#empCompanyCd").val());
    sessionStorage.setItem("USER_MNG_FORM_EMP_NM",$("#empEmpNm").val());
    sessionStorage.setItem("USER_MNG_FORM_EMP_EMAIL",$("#empEmail").val());
}

</script>

</body>

</html>