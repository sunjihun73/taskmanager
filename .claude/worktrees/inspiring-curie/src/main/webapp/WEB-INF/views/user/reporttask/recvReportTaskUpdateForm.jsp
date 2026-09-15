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
						<button class="btn btn-primary mt-n1" id="btnSaveReportTask"><i class="fas fa-save"></i> 저장</button>
						<button class="btn btn-primary mt-n1" id="btnCfmReportTask"><i class="fas fa-fw fa-check"></i> 확인</button>
						<button class="btn btn-warning mt-n1" id="btnGoList"><i class="fas fa-list"></i> 목록</button>
					</div>
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><i class="align-middle" data-feather="edit"></i> <b>일일업무보고 확인</b></h1>
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
														<input id="taskDt" type="text" class="form-control flatpickr-minimum is-valid" placeholder="Select date" readonly required/>
													</div>
												</div>												
												<div class="mb-3 row">
													<label class="col-form-label col-sm-2 text-sm-end"><b>보고대상</b></label>
													
													<div id =taskReceiverMember class="col-sm-9">
														<span id="taskReceiverMemberSpan"></span>
<!-- 														<button id="btnTaskRcvMemberAdd" type="button" class="btn btn-secondary mb-2" data-bs-toggle="modal" data-bs-target="#empAddModal"><i class="far fa-fw fa-user"></i> 추가</button> -->
													</div>
												</div>												
												<div class="mb-3 row">
													<label for="taskDetail" class="col-form-label col-sm-2 text-sm-end"><b>보고내용</b></label>
													<div class="col-sm-9">
														<textarea id="taskDetail" class="form-control" style="min-height: 19rem;" readonly></textarea>
													</div>
												</div>
											</form>
										</div>
										
										<div class="col-12 col-xl-6">
											<form>
												<div class="mb-3 row">
													<label for="taskReviewDt" class="col-form-label col-sm-2 text-sm-end"><b>확인일자</b></label>
													<div class="col-sm-4">
														<input id="taskReviewDt" type="text" class="form-control flatpickr-minimum" />
													</div>
												</div>											
											
												<div class="mb-3 row">
													<label for="taskDetail"
														class="col-form-label col-sm-2 text-sm-end"><b>확인내용</b></label>
													<div class="col-sm-9">
														<textarea id="taskReviewContent" class="form-control" style="min-height: 15rem;"></textarea>
													</div>
												</div>
																							
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

<form id="frmHiddenParam">
  <input type="hidden" id="pTaskId" name="pTaskId" value="<c:out value="${taskId}"/>"/>
  <input type="hidden" id="pEmail" name="pEmail" value="<c:out value="${email}"/>"/>
</form>

<%@ include file="/WEB-INF/views/user/include/script.jsp" %>

<script>
let fileHeight = 0;
let empHeight = 0;
let selFile;
let empArr = new Array();
let filesArr = new Array();
let fpTaskDt;
let fpTaskReviewDt;

$(function() {
	fnSetMenuSelection()
	fnSetComponent();
	fnSetEvent();
	fnSetData();
})

function fnSetMenuSelection() {
	gfnSelectMenu("reportTaskManage", "reportTaskSide", "recvReportTasks");
}

function fnSetComponent() {
	fpTaskDt = flatpickr("#taskDt", {
		dateFormat: "Y-m-d"
	});
	fpTaskReviewDt = flatpickr("#taskReviewDt", {
		dateFormat: "Y-m-d"
	});

	selFile = document.querySelector("input[type=file]");
}

function fnSetEvent() {
	// 일일업무보고 보고  저장
	$("#btnSaveReportTask").off("click").on("click", function (e) {
		e.preventDefault();
		if(empArr.length <= 0) {
			gfnFailAlert("보고자는 필수 입력사항 입니다.", 5000);
	    	return false;
		}
		else if (gfnCheckRequired($("#frmReportTaskform"))) {
			fnSaveReportTask();
		}
	});

	// 일일업무보고 보고 
	$("#btnCfmReportTask").off("click").on("click", function (e) {
		e.preventDefault();
		let msg = "해당 일일업무보고 건을 확인하시겠습니까?";
		let callback = fnCfmReportTask;

		if(empArr.length <= 0) {
			gfnFailAlert("보고자는 필수 입력사항 입니다.", 5000);
	    	return false;
		}
		else if (gfnCheckRequired($("#frmReportTaskform"))) {
			gfnInitCfmMdlDialog(msg, callback);
		}
	});	

	$("#btnGoList").off("click").on("click", function (e) {
		e.preventDefault();
		fnGoList();
	});
	
	$("#taskDetail").off("keydown").on("keydown", function(e) {
		$(this).height(1).height( $(this).prop('scrollHeight')+12 );
	});

	$("#taskDetail").off("keyup").on("keyup", function(e) {
		$(this).height(1).height( $(this).prop('scrollHeight')+12 );
	});

}

// 일일 업무보고 수신건 저장
function fnSaveReportTask() {
	gfnShowLoadingBar();
	let taskId = $("#pTaskId").val();
	let params = new Object();
	params.taskTitle = $("#taskTitle").val();
	params.taskDt = gfnNoFormatDate(fpTaskDt.selectedDates);
	params.taskDetail = $("#taskDetail").val();
	params.taskReviewContent = $("#taskReviewContent").val();
	params.taskOwnerMemberId = $("#taskOwnerMemberId").val();
	params.taskReceiverMemberId = empArr[0].email

	for(let i = 0; i < filesArr.length; i++) {
		params['fileList[' + i +'].fileNm'] = filesArr[i].fileNm;
		params['fileList[' + i +'].fileDispNm'] = filesArr[i].fileDispNm; 
	}

	$.ajax({
		type:"PUT",
		url:"/rest/user/reporttasks/recv/temp/" + taskId,
		data: params,
		beforeSend : function(xmlHttpRequest) {
			xmlHttpRequest.setRequestHeader("AJAX", "true");
		}
	}).done(function(result) {
		if (result.resultCode == "SUCCESS") {
			gfnSuccessAlert(gCmmnRptTaskRcv + gCmmnSM_TmpUpdate, 2000);
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

//일일 업무보고 확인
function fnCfmReportTask() {
	let taskId = $("#pTaskId").val();
	let params = new Object();
	params.taskTitle = $("#taskTitle").val();
	params.taskDt = gfnNoFormatDate(fpTaskDt.selectedDates);
	params.taskDetail = $("#taskDetail").val();
	params.taskReviewContent = $("#taskReviewContent").val();
	params.taskOwnerMemberId = $("#taskOwnerMemberId").val();
	params.taskReceiverMemberId = empArr[0].email;
	let taskReviewDt = $("#taskReviewDt").val();
	if(taskReviewDt != '' && taskReviewDt < $("#taskDt").val()) {
		gfnFailAlert("확인일자는 업무일자보다 이후여야 합니다.", 5000);
		return false;
	}
	params.taskReviewDt = gfnNoFormatDate(taskReviewDt);

	for(let i = 0; i < filesArr.length; i++) {
		params['fileList[' + i +'].fileNm'] = filesArr[i].fileNm;
		params['fileList[' + i +'].fileDispNm'] = filesArr[i].fileDispNm; 
	}

	gfnShowLoadingBar();
	$.ajax({
		type:"PUT",
		url:"/rest/user/reporttasks/recv/confirm/" + taskId,
		data: params,
		beforeSend : function(xmlHttpRequest) {
			xmlHttpRequest.setRequestHeader("AJAX", "true");
		}
	}).done(function(result) {
		if (result.resultCode == "SUCCESS") {
			gfnSuccessAlert(gCmmnRptTaskRcv + gCmmnSM_Confirm, 2000);
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
	const fileTypes =  ['bmp' , 'hwp', 'jpg', 'pdf', 'png', 'xls', 'zip', 'pptx', 'xlsx', 'jpeg', 'doc', 'gif', 'csv', 'tif'];
	let fileType =  obj.name.split('.').pop().toLowerCase();
	
    let msg = '';
    if (obj.name.length > 100) {
    	msg = "파일명이 100자 이상인 파일은 제외되었습니다.";
        gfnFailAlert(msg, 5000);
        return false;
    } else if (obj.size > (100 * 1024 * 1024)) {
    	msg = "최대 파일 용량인 20MB를 초과한 파일은 제외되었습니다.";
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

// 일일 업무보고 수신건 한건 조회 
function fnSelectReportTask() {
	gfnShowLoadingBar();
	let taskId = $("#pTaskId").val();
	let apiUrl = "/rest/user/reporttasks/" + taskId;
	let params = new Object();
	params.email = $("#pEmail").val();
	
	$.ajax({
		url : apiUrl,
		method : "GET",
		data : params,
		dataType : 'json',
		beforeSend : function(xmlHttpRequest) {
			xmlHttpRequest.setRequestHeader("AJAX", "true");
		}		
	}).done(function(result) {
		if (result.resultCode == "SUCCESS") {
			$("#taskTitle").val(gfnUnescapeHTML(result.dataOne.taskTitle));
			$("#taskStateNm").val(result.dataOne.taskEmpNm);
			$("#taskStateCd").val(result.dataOne.taskEmpCd);
			fpTaskDt.setDate(gfnYmdFormat(result.dataOne.taskDt, "-"));
			$("#taskOwnerMemberNm").val(gfnUnescapeHTML(result.dataOne.taskOwnerMemberNm));
			$("#taskOwnerMemberId").val(result.dataOne.taskOwnerMemberId);
			$("#taskDetail").val(gfnUnescapeHTML(result.dataOne.taskDetail));
			$("#taskReviewDt").val(gfnYmdFormat(result.dataOne.taskEmpReviewDt, "-"));
			$("#taskReviewContent").val(gfnUnescapeHTML(result.dataOne.taskReviewContent));

			fnSetTaskEmp(result.dataOne.taskEmpList);
			//fnSetTaskEmp(result.dataOne.taskReceiverMemberId, result.dataOne.taskReceiverMemberNm);
			
			for(let i = 0; i < result.dataOne.fileList.length; i++) {
	  			filesArr.push(result.dataOne.fileList[i]);
	 			fnSetFile(fileHeight, result.dataOne.fileList[i]);
			};

			// taskEmpCd 상태에 따라 버튼 보이기 / 숨기기
			fnSetScreenBtn(result.dataOne.taskEmpCd);
			  
        	gfnSuccessAlert(gCmmnRptTaskRcv + gCmmnSM_One, 2000);
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
	    htmlData += '</div>';
	    
	    $('#taskReceiverMemberSpan').append(htmlData);
	    empArr.push({
    		email: taskEmpList[i].email
    	});
	}
}

function fnSetScreenBtn(taskEmpCd) {
	if (taskEmpCd === "CM005CD003") {
		$("#btnSaveReportTask").hide("fast");
		$("#btnCfmReportTask").hide("fast");
	}
	else {
		$("#btnSaveReportTask").show("fast");
		$("#btnCfmReportTask").show("fast");
	}
}

function fnGoList() {
	location.href = "/user/reporttasks/recvreporttasksform";
}
</script>

</body>

</html>