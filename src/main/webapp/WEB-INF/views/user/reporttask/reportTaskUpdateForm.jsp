<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="en">

<%@ include file="/WEB-INF/views/user/include/meta.jsp"%>
<!--
  HOW TO USE: 
  data-theme: default (default), dark, light, colored
  data-layout: fluid (default), boxed
  data-sidebar-position: left (default), right
  data-sidebar-layout: default (default), compact
-->

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
	<div class="wrapper">
		<%@ include file="/WEB-INF/views/user/include/sidebar.jsp"%>

		<div class="main">
			<%@ include file="/WEB-INF/views/user/include/header.jsp"%>

			<main class="content">
				<div class="container-fluid p-0">

					<div style="float:right;">
						<button class="btn btn-primary mt-n1" id="btnTempSaveReportTask"><i class="fas fa-save"></i> 임시저장</button>
						<button class="btn btn-primary mt-n1" id="btnSendReportTask"><i class="fas fa-fw fa-paper-plane"></i> 보고</button>
						<button class="btn btn-danger mt-n1" id="btnDeleteReportTask"><i class="fas fa-trash"></i> 삭제</button>
						<button class="btn btn-warning mt-n1" id="btnGoList"><i class="fas fa-list"></i> 목록</button>
					</div>
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><i class="align-middle" data-feather="edit"></i> <b>일일업무보고 수정</b></h1>
					</div>

					<div class="row">

						<div class="col-md-12">
							<div class="card">
								<div class="card-header">
									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 일일업무보고 상세</h5>
								</div>
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-6">
											<form id ="frmReportTaskform">
												<div class="mb-3 row">
													<label for="taskTitle" class="col-form-label col-sm-2 text-sm-end"><b>업무명</b></label>
													<div class="col-sm-9">
														<input type="text" id="taskTitle" class="form-control is-valid" autocomplete="off" required>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="taskStateNm" class="col-form-label col-sm-2 text-sm-end"><b>상태</b></label>
													<div class="col-sm-4">
														<input type="text" id="taskStateNm" class="form-control is-valid" required readonly>
														<input type="hidden" id="taskStateCd">
													</div>
												</div>												
												<div class="mb-3 row">
													<label for="taskOwnerMemberNm" class="col-form-label col-sm-2 text-sm-end"><b>작성자</b></label>
													<div class="col-sm-4">
														<input type="text" id="taskOwnerMemberNm" class="form-control is-valid" required readonly>
														<input type="hidden" id="taskOwnerMemberId">
													</div>
												</div>
												<div class="mb-3 row">
													<label for="taskDt" class="col-form-label col-sm-2 text-sm-end"><b>업무일자</b></label>
													<div class="col-sm-4">
														<input id="taskDt" type="text" class="form-control flatpickr-minimum is-valid" placeholder="Select date" required/>
													</div>
												</div>												
												<div class="mb-3 row">
													<label class="col-form-label col-sm-2 text-sm-end"><b>보고대상</b></label>
													
													<div id =taskReceiverMember class="col-sm-9">
														<span id="taskReceiverMemberSpan"></span>
														<button id="btnTaskRcvMemberAdd" type="button" class="btn btn-secondary mb-2" onclick="setTimeout(fnLoadEmpModal, 500)" data-bs-toggle="modal" data-bs-target="#empAddModal"><i class="far fa-fw fa-user"></i> 추가</button>
													</div>
												</div>												
												<div class="mb-3 row">
													<label for="taskDetail" class="col-form-label col-sm-2 text-sm-end"><b>보고내용</b></label>
													<div class="col-sm-9">
														<textarea id="taskDetail" class="form-control" style="min-height: 19rem;" ></textarea>
													</div>
												</div>
											</form>
										</div>
										
										<div class="col-12 col-xl-6">
											<form>
												<div class="mb-3 row">
													<label class="col-form-label col-sm-2 text-sm-end"><b>파일</b></label>
													<div class="col-sm-9">
														<label class="btn btn-secondary" for="input-file"><i class="far fa-fw fa-file"></i> 파일첨부</label>
														<form method="POST" onsubmit="return false;" enctype="multipart/form-data" >
													        <input type="file" id="input-file" onchange="fnUploadFile(this);" multiple hidden/>
													    </form>
													</div>
													
												</div>
												<div class="row" id="fileList">
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

			<%@ include file="/WEB-INF/views/user/include/footer.jsp"%>
		</div>

	</div>

<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-lg" role="document" style=" --bs-modal-width:1100px">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title"><i class="fas fa-angle-double-right"></i> 보고대상자 추가</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body m-3">
				<div class="row">
					<div class="card">
						<div class="card-body">
							<div class="row">
								<div class="col-12 col-xl-4">
									<div class="row">
										<label for="empCompanyCd" class="col-form-label col-sm-3 text-sm-end"><b>회사</b></label>
										<div class="col-sm-8">
											<select id="empCompanyCd" class="form-select mb-2" onchange="fnChangeCompany()">
											</select>
										</div>
									</div>
								</div>
								<div class="col-12 col-xl-4">
									<div class="row">
										<label for="empEmpNm" class="col-form-label col-sm-3 text-sm-end"><b>성명</b></label>
										<div class="col-sm-8">
											<div class="input-group">
												<input type="text" id="empEmpNm" class="form-control">
												<button class="btn btn-secondary" id="btnEmpNmSearch"><i class="fas fa-search"></i></button> 
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-12 col-xl-4">
						<div class="card">
							<div class="card-body">
								<div class="input-group">
									<input type="text" id="empDeptNm" class="form-control" placeholder="부서명">
									<button class="btn btn-secondary" id="btnEmpDeptNmSearch"><i class="fas fa-search"></i></button> 
								</div>
								<div id="treeDeptList" style="height:440px;overflow:auto;"></div>
							</div>
						</div>
					</div>
					<div class="col-12 col-xl-8">
						<div class="card">
							<div class="card-body">
								<table id="empAddTable" class="table table-striped" style="width:100%">
									<thead>
										<tr>
											<th>회사</th>
											<th>회사코드</th>
											<th>성명</th>
											<th>직위</th>
											<th>부서</th>
											<th>이메일</th>
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
				<button type="button" id="btnEmpAssignModal" class="btn btn-primary">선택</button>
			</div>
		</div>
	</div>
</div>

<form id="frmHiddenParam">
  <input type="hidden" id="pTaskId" name="pTaskId" value="<c:out value="${taskId}"/>"/>
  <input type="hidden" id="pDeptCd" name="pDeptCd" value="<c:out value="${deptCd}"/>"/>
</form>

<%@ include file="/WEB-INF/views/user/include/script.jsp" %>

<script>
let fileHeight = 0;
let empHeight = 0;
let selFile;
let empArr = new Array();
let filesArr = new Array();
let fpTaskDt;
let dtEmpList;
let gDeptCd = "";

$(function() {
	fnSetMenuSelection();
	fnSetCompany();
	fnSetComponent();
	fnSetEvent();
	fnSetData();
})

function fnSetMenuSelection() {
	gfnSelectMenu("reportTaskManage", "reportTaskSide", "reportTaskAdd");
}

function fnSetComponent() {
	fpTaskDt = flatpickr("#taskDt", {
		dateFormat: "Y-m-d"
	});

	selFile = document.querySelector("input[type=file]");
}

function fnSetEvent() {
	// 일일업무보고 보고  임시저장
	$("#btnTempSaveReportTask").off("click").on("click", function (e) {
		e.preventDefault();
		if(empArr.length <= 0) {
			gfnFailAlert("보고자는 필수 입력사항 입니다.", 5000);
	    	return false;
		}
		else if (gfnCheckRequired($("#frmReportTaskform"))) {
			fnSaveTempReportTask();
		}
	});

	// 일일업무보고 보고 
	$("#btnSendReportTask").off("click").on("click", function (e) {
		e.preventDefault();
		let msg = "해당 일일업무보고 건을 보고하시겠습니까?";
		let callback = fnSendReportTask;

		if(empArr.length <= 0) {
			gfnFailAlert("보고자는 필수 입력사항 입니다.", 5000);
	    	return false;
		}
		else if (gfnCheckRequired($("#frmReportTaskform"))) {
			gfnInitCfmMdlDialog(msg, callback);
		}
	});	

	// 일일업무보고 보고 삭제
	$("#btnDeleteReportTask").off("click").on("click", function (e) {
		e.preventDefault();
		let msg = "해당 일일업무보고 건을 삭제하시겠습니까?";
		let callback = fnDeleteTempReportTask;
		gfnInitWrnCfmMdlDialog(msg, callback);
	});	
	
	$("#btnGoList").off("click").on("click", function (e) {
		e.preventDefault();
		fnGoList();
	});
	
	$("#btnEmpAssignModal").off("click").on("click", function (e) {
		e.preventDefault();
		fnSetEmpAdd();
	});
	
	$("#taskDetail").off("keydown").on("keydown", function(e) {
		$(this).height(1).height( $(this).prop('scrollHeight')+12 );
	});

	$("#taskDetail").off("keyup").on("keyup", function(e) {
		$(this).height(1).height( $(this).prop('scrollHeight')+12 );
	});
	
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
	$("#btnEmpNmSearch").off("click").on("click", function (e) {
		e.preventDefault();
		fnResetDeptSearch();
		fnReselEmpList();
	});

}

//참여자추가 팝업의 회사목록 조회
function fnSetCompany() {
	let apiUrl = '/rest/user/companies';
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
		fnInitTree();
	});
}

//참여자추가 팝업의 사용자목록 조회
function fnLoadEmpList() {
let apiUrl = '/rest/user/employees/all';
	
	dtEmpList = $("#empAddTable").DataTable({
		ajax: {
			url : apiUrl,
			dataSrc : "data",
			data : function (d) {
				d.deptCd = gDeptCd;
				d.empNm = $("#empEmpNm").val();
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
		lengthChange : true,
		lengthMenu : [10, 50, 100, 500],
		select: {
			style: 'multi'
		},
		loadBeforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", "true");
		},
 	});
	gDeptCd = '';
}

//사용자목록 재조회
function fnReselEmpList() {
	dtEmpList.ajax.reload();
}

//참여자추가 팝업에서 선택한 사용자 화면에 Set
function fnSetEmpAdd() {
	$('#empAddModal').modal('hide');
	
	let buttonStyle = 'primary';
	let len = $('#empAddTable').DataTable().rows('.selected').data().length;

	
	for(let i = 0; i < len; i++) {
		let data = $('#empAddTable').DataTable().rows('.selected').data()[i];
	
		if(empArr.some(v => v.email === data.email)) {
			gfnFailAlert("이미 추가된 참여자가 존재합니다.", 5000);
			continue;
		}
		
		let num = empHeight+i;
		let htmlData = '';
	    htmlData += '<div class="btn-group me-2" id="empAddGroup' + num + '" aria-label="First group" role="group">';
	    htmlData += '<button id="btnEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + ' mb-2">'+ data.empNm + '</button>';
	    htmlData += '<input type="text" id="empAddEmail' + num + '" value="'+ data.email +'" hidden>';
	    htmlData += '<button class="btn btn-'+ buttonStyle + ' mb-2" type="button" onclick="fnDeleteEmpTask(' + num + ')">';
	    htmlData += '<i class="fas fa-times"></i>';
	    htmlData += '</button>';
	    htmlData += '</div>';
	    
	    $('#taskReceiverMemberSpan').append(htmlData);
    	empArr.push({
    		email: data.email,
    		companyCd: data.companyCd
    	});
	}
	
  empHeight += len;
  fnResetEmpAdd();
}

//참여자 추가 팝업의 부서트리 생성
function fnInitTree() {
	let apiUrl = "/rest/user/depts";
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
	        	if(item.parentDeptCd == '0') deptList[idx] = {id:item.deptCd, parent:'#', text:item.deptNm, icon:'common/common/images/company.png'};
	        	else deptList[idx] = {id:item.deptCd, parent:item.parentDeptCd, text:item.deptNm};
	        });
	        $('#treeDeptList').jstree({
	            'core': {
	                'data': deptList
	            },
	            'types': {
	                'default': {
	                	'icon': 'common/common/images/dept.png'
	                }
	            },
	            'plugins' : ["search", "types"]
	        })
	        .bind('load_all.jstree', function(event, data){
	        	$('#treeDeptList').jstree(true).select_node($("#pDeptCd").val());
        	})
	        // 노드 선택시 발생하는 이벤트
	        .bind('select_node.jstree', function(event, data){
	        	$("#empEmpNm").val("");
	        	gDeptCd = data.instance.get_node(data.selected).id;
	            fnReselEmpList();
	        })
		},
		error:function (data) {
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

//회사 select box 변경
function fnChangeCompany() {
	fnResetEmpAdd();
	fnReselTree();
	fnReselEmpList();
}

//트리 재조회
function fnReselTree() {
	let apiUrl = "/rest/user/depts";
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
	        	if(item.parentDeptCd == '0') deptList[idx] = {id:item.deptCd, parent:'#', text:item.deptNm, icon:'common/common/images/company.png'};
	        	else deptList[idx] = {id:item.deptCd, parent:item.parentDeptCd, text:item.deptNm};
	        });
	  		$('#treeDeptList').jstree(true).settings.core.data = deptList;
	  		$('#treeDeptList').jstree(true).refresh();
	  		$('#treeDeptList').bind("refresh.jstree", function(e,d) {
	  			$('#treeDeptList').jstree(true).select_node($("#pDeptCd").val());
	  		}.bind(this));

		}
	});
}

//참여자 추가 modal 클릭
function fnLoadEmpModal() {
	$("#empCompanyCd option:eq(0)").prop("selected", true);
	fnResetEmpAdd();
	fnReselTree();
	fnLoadEmpList();
}

//사용자팝업 초기화
function fnResetEmpAdd() {
	$("#empEmpNm").val("");
	fnResetDeptSearch();
	$('#empAddTable').DataTable().rows('.selected').deselect();
}

//참여자 삭제
function fnDeleteEmpTask(num) {
	for(let i = 0; i < empArr.length; i++) {
		let email = $('#empAddEmail'+num).val();
		if(empArr[i].email == email) {
			empArr.splice(i, 1);
		}
	}
	$("#empAddGroup" + num).remove();
}

// 일일 업무보고 임시저장
function fnSaveTempReportTask() {
	gfnShowLoadingBar();
	let taskId = $("#pTaskId").val();
	let params = new Object();
	params.taskTitle = $("#taskTitle").val();
	params.taskDt = gfnNoFormatDate(fpTaskDt.selectedDates);
	params.taskDetail = $("#taskDetail").val();
	params.taskOwnerMemberId = $("#taskOwnerMemberId").val();
	params.taskReceiverMemberId = empArr[0].email
	
	for(let i = 0; i < empArr.length; i++) {
		params['empList[' + i +'].email'] = empArr[i].email;
		params['empList[' + i +'].companyCd'] = empArr[i].companyCd;
		params['empList[' + i +'].taskEmpCd'] = "CM005CD001";
	}

	for(let i = 0; i < filesArr.length; i++) {
		params['fileList[' + i +'].fileNm'] = filesArr[i].fileNm;
		params['fileList[' + i +'].fileDispNm'] = filesArr[i].fileDispNm; 
	}

	$.ajax({
		type:"PUT",
		url:"/rest/user/reporttasks/temp/" + taskId,
		data: params,
		beforeSend : function(xmlHttpRequest) {
			xmlHttpRequest.setRequestHeader("AJAX", "true");
		}
	}).done(function(result) {
		if (result.resultCode == "SUCCESS") {
			gfnSuccessAlert(gCmmnRptTask + gCmmnSM_TmpUpdate, 2000);
		}
		else {
			gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, 5000);		
		}
	}).fail(function(jqXHR, textStatus) {
		gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, 5000);		
	}).always(function(msg) {
		gfnHideLoadingBar();
	});
}

//일일 업무보고 보고
function fnSendReportTask() {
	gfnShowLoadingBar();
	let taskId = $("#pTaskId").val();
	let params = new Object();
	params.taskTitle = $("#taskTitle").val();
	params.taskDt = gfnNoFormatDate(fpTaskDt.selectedDates);
	params.taskDetail = $("#taskDetail").val();
	params.taskOwnerMemberId = $("#taskOwnerMemberId").val();
	params.taskReceiverMemberId = empArr[0].email;
	params.taskReceiverCompanyCd = empArr[0].companyCd;
	
	for(let i = 0; i < empArr.length; i++) {
		params['empList[' + i +'].email'] = empArr[i].email;
		params['empList[' + i +'].companyCd'] = empArr[i].companyCd;
		params['empList[' + i +'].taskEmpCd'] = "CM005CD002";
	}

	for(let i = 0; i < filesArr.length; i++) {
		params['fileList[' + i +'].fileNm'] = filesArr[i].fileNm;
		params['fileList[' + i +'].fileDispNm'] = filesArr[i].fileDispNm; 
	}

	$.ajax({
		type:"PUT",
		url:"/rest/user/reporttasks/send/" + taskId,
		data: params,
		beforeSend : function(xmlHttpRequest) {
			xmlHttpRequest.setRequestHeader("AJAX", "true");
		}
	}).done(function(result) {
		if (result.resultCode == "SUCCESS") {
			gfnSuccessAlert(gCmmnRptTask + gCmmnSM_Send, 2000);
			setTimeout(fnGoList, 500);
		}
		else {
			gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, 5000);
		}
	}).fail(function(jqXHR, textStatus) {
		gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, 5000);
	}).always(function(msg) {
		gfnHideLoadingBar();
	});
}

//일일 업무보고 삭제
function fnDeleteTempReportTask() {
	gfnShowLoadingBar();
	let taskId = $("#pTaskId").val();

	$.ajax({
		type:"DELETE",
		url:"/rest/user/reporttasks/temp/" + taskId,
		beforeSend : function(xmlHttpRequest) {
			xmlHttpRequest.setRequestHeader("AJAX", "true");
		}
	}).done(function(result) {
		if (result.resultCode == "SUCCESS") {
			gfnSuccessAlert(gCmmnRptTask + gCmmnSM_Delete, 2000);
			setTimeout(fnGoList, 500);
		}
		else {
			gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, 5000);
		}
	}).fail(function(jqXHR, textStatus) {
		gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, 5000);
	}).always(function(msg) {
		gfnHideLoadingBar();
	});
}

//첨부파일 추가
function fnUploadFile(obj){
	let files = obj.files;
	/*
    if(files.length+filesArr.length > 10) {
    	gfnFailAlert("파일은 10개까지만 첨부할 수 있습니다.", 5000);
    	return;
    }
    */
    let formData = new FormData();
    for (var i = 0; i < files.length; i++) {
    	//파일 추가
        const file = files[i];
    	if(validation(file)) {
    		formData.append('file', file);
    	} else {
    		continue;
    	}
    }
    
    if(!formData.get('file')) {
    	return;
    }

    gfnShowLoadingBar();

	$.ajax({
		type:'post',
		url:'/rest/files/azure',
		cache : false,
	    contentType : false,
	    processData : false,
	    data : formData,
	    beforeSend : function(xmlHttpRequest) {
	    	xmlHttpRequest.setRequestHeader("AJAX", "true");
	    }
	}).done(function(data) {
		$.each(data, function(idx, item){
			//filesArr[fileHeight] = item;
			filesArr.push(item);
			fnSetFile(fileHeight, item);
		});
		gfnSuccessAlert(gCmmnSM_FileUp, 2000);
	}).fail(function(request, status, error) {
		gfnFailAlert(error, 5000);
	}).always(function(msg) {
		gfnHideLoadingBar();
	});
}

//화면에 파일 추가
function fnSetFile(height, file) {
    let htmlData = '';
    htmlData += '<label id="fileLabel' + height + '" class="form-label col-sm-2 text-sm-end"></label>';
    htmlData += '<div id="fileDiv' + height + '" class="col-sm-9">'
    htmlData += '<div class="input-group mb-3">';
    htmlData += '<input type="text" class="form-control" id="fileNm' + height + '" value="' + file.fileNm + '" hidden>';
    htmlData += '<input type="text" class="form-control" id="fileDispNm' + height + '" value="' + file.fileDispNm + '" disabled>';
    htmlData += '<button class="btn btn-success" type="button" onclick="fnDownloadFile(' + height + ')">';
    htmlData += '<i class="fas fa-download"></i> ';
    htmlData += '</button>';
    htmlData += '<button class="btn btn-secondary" type="button" onclick="fnDeleteFile(' + height + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
   	htmlData += '</div>';
   	htmlData += '</div>';
   	$('#fileList').append(htmlData);
   	
   	fileHeight += 1;
}

//첨부파일 삭제
function fnDeleteFile(num) {
    var dt = new DataTransfer()
    var { files } = selFile;
    for (var i = 0; i < files.length; i++) {
        var file = files[i];
        if (num !== i) dt.items.add(file);
        selFile.files = dt.files;
    }
    for(let i = 0; i < filesArr.length; i++) {
		let fileNm = $('#fileNm'+num).val();
		if(filesArr[i].fileNm == fileNm) {
			filesArr.splice(i, 1);
		}
	}
    
    $("#fileDiv" + num).remove();
    $("#fileLabel" + num).remove();
}

//첨부파일 검증
function validation(obj){
	const fileTypes =  ['bmp' , 'hwp', 'jpg', 'pdf', 'png', 'xls', 'zip', 'pptx', 'xlsx', 'jpeg', 'doc', 'gif', 'csv', 'tif', 'txt', 'docx'];
	let fileType =  obj.name.split('.').pop().toLowerCase();
	
    let msg = '';
    if (obj.name.length > 100) {
    	msg = "파일명이 100자 이상인 파일은 제외되었습니다.";
        gfnFailAlert(msg, 5000);
        return false;
    } else if (obj.size > (50 * 1024 * 1024)) {
    	msg = "최대 파일 용량인 50MB를 초과한 파일은 제외되었습니다.";
        gfnFailAlert(msg, 5000);
        return false;
    } else if (obj.name.lastIndexOf('.') == -1) {
    	msg = "확장자가 없는 파일은 제외되었습니다.";
        gfnFailAlert(msg, 5000);
        return false;
    } else if (!fileTypes.includes(fileType)) {
    	msg = "첨부가 불가능한 파일은 제외되었습니다.";
        gfnFailAlert(msg, 5000);
        return false;
    } else {
        return true;
    }
}

//파일 다운로드
function fnDownloadFile(num) {
	let fileDispNm = $('#fileDispNm'+num).val();
	let fileNm = $('#fileNm'+num).val();
	if (typeof fileDispNm == "undefiled" || typeof fileNm == "undefined") {
    	let msg = "다운로드 할 수 없는 파일입니다.";
    	gfnFailAlert(msg, 5000);
	}
	else {
		let downUrl = "/rest/files/azure";
		downUrl = downUrl + "?fileDispNm=" + fileDispNm;
		downUrl = downUrl + "&fileNm=" + fileNm;
		
		const encFileName = encodeURI(downUrl);
		window.open(encFileName);
	}
}

function fnSetData() {
	fnSelectReportTask();
}

function fnSelectReportTask() {
	gfnShowLoadingBar();
	let taskId = $("#pTaskId").val();
	let apiUrl = "/rest/user/reporttasks/" + taskId;
	
	$.ajax({
		url : apiUrl,
		method : "GET",
		dataType : 'json',
		beforeSend : function(xmlHttpRequest) {
			xmlHttpRequest.setRequestHeader("AJAX", "true");
		}		
	}).done(function(result) {
		if (result.resultCode == "SUCCESS") {
			$("#taskTitle").val(gfnUnescapeHTML(result.dataOne.taskTitle));
			$("#taskStateNm").val(result.dataOne.taskStateNm);
			$("#taskStateCd").val(result.dataOne.taskStateCd);
			fpTaskDt.setDate(gfnYmdFormat(result.dataOne.taskDt, "-"));
			$("#taskOwnerMemberNm").val(gfnUnescapeHTML(result.dataOne.taskOwnerMemberNm));
			$("#taskOwnerMemberId").val(result.dataOne.taskOwnerMemberId);
			$("#taskDetail").val(gfnUnescapeHTML(result.dataOne.taskDetail));

			//fnSetTaskEmp(result.dataOne.taskReceiverMemberId, result.dataOne.taskReceiverMemberNm, result.dataOne.taskReceiverCompanyCd);
			fnSetTaskEmp(result.dataOne.taskEmpList);
			
			for(let i = 0; i < result.dataOne.fileList.length; i++) {
	  			filesArr.push(result.dataOne.fileList[i]);
	 			fnSetFile(fileHeight, result.dataOne.fileList[i]);
			};
	          
        	gfnSuccessAlert(gCmmnRptTask + gCmmnSM_One, 2000);
		}
		else {
			gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, 5000);
		}			
	}).fail(function(jqXHR, textStatus) {
		gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, 5000);
	}).always(function(msg) {
		gfnHideLoadingBar();
	});	
}

function fnSetTaskEmp(taskEmpList) {
	for(let i = 0; i < taskEmpList.length; i++) {		
		let num = empHeight+i;
		let htmlData = '';
		let buttonStyle = 'primary';

	    htmlData += '<div class="btn-group me-2" id="empAddGroup' + num + '" aria-label="First group" role="group">';
	    htmlData += '<button id="btnEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + ' mb-2">'+ gfnUnescapeHTML(taskEmpList[i].empNm) + '</button>';
	    htmlData += '<input type="text" id="empAddEmail' + num + '" value="'+ taskEmpList[i].email +'" hidden>';
	    htmlData += '<button class="btn btn-'+ buttonStyle + ' mb-2" type="button" onclick="fnDeleteEmpTask(' + num + ')">';
	    htmlData += '<i class="fas fa-times"></i>';
	    htmlData += '</button>';
	    htmlData += '</div>';
	    
	    $('#taskReceiverMemberSpan').append(htmlData);
	    empArr.push({
    		email: taskEmpList[i].email,
    		companyCd: taskEmpList[i].companyCd,
    		empNm: taskEmpList[i].empNm
    	});
	}
}

/*
function fnSetTaskEmp(taskReceiverMemberId, taskReceiverMemberNm, taskReceiverCompanyCd){
	let num = empHeight + 0;
	let htmlData = '';
	let buttonStyle = "primary";
	
    htmlData += '<div class="btn-group me-2" id="empAddGroup' + num + '" aria-label="First group" role="group">';
    htmlData += '<button id="btnEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + ' mb-2">'+ taskReceiverMemberNm + '</button>';
    htmlData += '<input type="text" id="empAddEmail' + num + '" value="'+ taskReceiverMemberId +'" hidden>';
    htmlData += '<button class="btn btn-'+ buttonStyle + ' mb-2" type="button" onclick="fnDeleteEmpTask(' + num + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
    htmlData += '</div>';

    $('#taskReceiverMemberSpan').append(htmlData);
	empArr.push({
		email: taskReceiverMemberId,
		companyCd: taskReceiverCompanyCd
	});
}
*/

function fnGoList() {
	location.href = "/user/reporttasks/tempreporttasksform";
}
</script>

</body>

</html>