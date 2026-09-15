<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

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

<body data-theme="default" data-layout="fluid"
	data-sidebar-position="left" data-sidebar-layout="default">
	<div class="wrapper">
		<%@ include file="/WEB-INF/views/user/include/sidebar.jsp"%>

		<div class="main">
			<%@ include file="/WEB-INF/views/user/include/header.jsp"%>

			<main class="content">
				<div class="container-fluid p-0">

					<div style="float: right;">
						<button class="btn btn-warning mt-n1" id="btnGoList">
							<i class="fas fa-list"></i> 목록
						</button>
					</div>
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle">
							<i class="align-middle" data-feather="edit"></i> <b>일일업무보고 상세</b>
						</h1>
					</div>

					<div class="row">

						<div class="col-md-12">
							<div class="card">
								<div class="card-header">
									<h5 class="card-title" style="font-size: 17px;">
										<i class="fas fa-fw fa-folder"></i> 일일업무보고 상세
									</h5>
								</div>
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-6">
											<form id="frmReportTaskform">
												<div class="mb-3 row">
													<label for="taskTitle"
														class="col-form-label col-sm-2 text-sm-end"><b>업무명</b></label>
													<div class="col-sm-9">
														<input type="text" id="taskTitle"
															class="form-control is-valid" autocomplete="off" required>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="taskStateNm"
														class="col-form-label col-sm-2 text-sm-end"><b>상태</b></label>
													<div class="col-sm-4">
														<input type="text" id="taskStateNm"
															class="form-control is-valid" required readonly>
														<input type="hidden" id="taskStateCd">
													</div>
												</div>
												<div class="mb-3 row">
													<label for="taskOwnerMemberNm"
														class="col-form-label col-sm-2 text-sm-end"><b>작성자</b></label>
													<div class="col-sm-4">
														<input type="text" id="taskOwnerMemberNm"
															class="form-control is-valid" required readonly>
														<input type="hidden" id="taskOwnerMemberId">
													</div>
												</div>
												<div class="mb-3 row">
													<label for="taskDt"	class="col-form-label col-sm-2 text-sm-end"><b>업무일자</b></label>
													<div class="col-sm-4">
														<input id="taskDt" type="text" class="form-control is-valid" required readonly />
													</div>
												</div>
												<div class="mb-3 row">
													<label class="col-form-label col-sm-2 text-sm-end"><b>보고대상</b></label>

													<div id=taskReceiverMember class="col-sm-9">
														<span id="taskReceiverMemberSpan"></span>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="taskDetail"	class="col-form-label col-sm-2 text-sm-end"><b>보고내용</b></label>
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
														<input id="taskReviewDt" type="text" class="form-control" readonly />
													</div>
												</div>
												
												<div class="mb-3 row">
													<label for="taskDetail"
														class="col-form-label col-sm-2 text-sm-end"><b>확인내용</b></label>
													<div class="col-sm-9">
														<textarea id="taskReviewContent" class="form-control" style="min-height: 15rem;" readonly></textarea>
													</div>
												</div>
																							
												<div class="mb-3 row">
													<label class="col-form-label col-sm-2 text-sm-end"><b>파일</b></label>
													<div class="col-sm-9">
														<label class="btn btn-secondary" for="input-file"><i class="far fa-fw fa-file"></i> 파일리스트</label>
													</div>
												</div>
												<div class="row" id="fileList"></div>
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
		<input type="hidden" id="pTaskId" name="pTaskId"
			value="<c:out value="${taskId}"/>" />
	</form>

	<%@ include file="/WEB-INF/views/user/include/script.jsp"%>

	<script>
let fileHeight = 0;
let empHeight = 0;
let selFile;
let empArr = new Array();
let filesArr = new Array();

$(function() {
	fnSetMenuSelection()
	fnSetComponent();
	fnSetEvent();
	fnSetData();
})

function fnSetMenuSelection() {
	gfnSelectMenu("reportTaskManage", "reportTaskSide", "sendReportTasks");
}

function fnSetComponent() {
	selFile = document.querySelector("input[type=file]");
}

function fnSetEvent() {
	$("#btnGoList").off("click").on("click", function (e) {
		e.preventDefault();
		fnGoList();
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
//     htmlData += '<button class="btn btn-secondary" type="button" onclick="fnDeleteFile(' + height + ')">';
//     htmlData += '<i class="fas fa-times"></i>';
//     htmlData += '</button>';
   	htmlData += '</div>';
   	htmlData += '</div>';
   	$('#fileList').append(htmlData);
   	
   	fileHeight += 1;
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
		let downUrl = "/api/task/user/files/azure";
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
			$("#taskDt").val(gfnYmdFormat(result.dataOne.taskDt, "-"));
			$("#taskOwnerMemberNm").val(gfnUnescapeHTML(result.dataOne.taskOwnerMemberNm));
			$("#taskOwnerMemberId").val(result.dataOne.taskOwnerMemberId);
			$("#taskDetail").val(gfnUnescapeHTML(result.dataOne.taskDetail));
			$("#taskReviewDt").val(gfnYmdFormat(result.dataOne.taskReviewDt, "-"));
			$("#taskReviewContent").val(gfnUnescapeHTML(result.dataOne.taskReviewContent));
			
			//fnSetTaskEmp(result.dataOne.taskReceiverMemberId, result.dataOne.taskReceiverMemberNm);
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
	    htmlData += '</div>';
	    
	    $('#taskReceiverMemberSpan').append(htmlData);
	    empArr.push({
    		email: taskEmpList[i].email
    	});
	}
}

/*
function fnSetTaskEmp(taskReceiverMemberId, taskReceiverMemberNm){
	let num = empHeight + 0;
	let htmlData = '';
	let buttonStyle = "primary";
	
    htmlData += '<div class="me-2" id="empAddGroup' + num + '" aria-label="First group" role="group">';
    htmlData += '<input type="text" id="empAddEmail' + num + '" value="'+ taskReceiverMemberId +'" hidden>';
    htmlData += '<button id="btnEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + ' mb-2">'+ taskReceiverMemberNm + '</button>';
//     htmlData += '<button class="btn btn-'+ buttonStyle + ' mb-2" type="button" onclick="fnDeleteEmpTask(' + num + ')">';
    //htmlData += '<i class="fas fa-times"></i>';
//     htmlData += '</button>';
    htmlData += '</div>';

    $('#taskReceiverMemberSpan').append(htmlData);
	empArr.push({
		email: taskReceiverMemberId
	});
}
*/

function fnGoList() {
	location.href = "/user/reporttasks/sendreporttasksform";
}
</script>

</body>

</html>