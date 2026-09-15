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
						<button class="btn btn-danger mt-n1" id="btnTaskDelete"><i class="fas fa-trash"></i> 삭제</button>
						<button class="btn btn-warning mt-n1" id="btnGoTaskList"><i class="fas fa-list"></i> 목록</button>
					</div>
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><i class="align-middle" data-feather="edit"></i> <b>업무 상세</b></h1>
					</div>

					<div class="row">

						<div class="col-md-12">
							<div class="card">
								<div class="card-header">
									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-angle-double-right"></i> 업무 상세정보 조회</h5>
									<h6 class="card-subtitle text-muted"></h6>
								</div>
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-6">
											<form id ="taskform">
												<div class="mb-3 row">
													<label for="taskNm" class="col-form-label col-sm-2 text-sm-end"><b>업무명</b></label>
													<div class="col-sm-9">
														<input type="text" id="taskNm" class="form-control is-valid" disabled required autocomplete="off">
													</div>
												</div>
												<div class="mb-3 row" id="parentTaskDiv">
													<label class="col-form-label col-sm-2 text-sm-end"><b>상위 업무</b></label>
													<div id="parentTask" class="col-sm-9">
														
														<div class="btn-group me-2" id="parentTaskGroup" role="group" aria-label="First group">
															<button id="btnParentTask" type="button" class="btn btn-secondary"></button>
															<input id="parentTaskId" type="text" hidden>
															<button class="btn btn-secondary" type="button">
																<i class="fas fa-times"></i>
															</button>
														</div>
														<button id="btnParentAdd" type="button" class="btn btn-secondary"><i class="far fa-fw fa-folder-open"></i> 추가</button>
												
													</div>
												</div>
												<div class="mb-3 row">
													<label for="taskOwnerMember" class="col-form-label col-sm-2 text-sm-end"><b>소유자</b></label>
													<div class="col-sm-4">
														<input type="text" id="taskOwnerMember" class="form-control" disabled readonly>
														<input type="text" id="taskOwnerMemberId" class="form-control" readonly hidden>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="taskStateCd" class="col-form-label col-sm-2 text-sm-end"><b>상태</b></label>
													<div class="col-sm-4">
														<select id="taskStateCd" class="form-select is-valid" disabled required>
															<option selected value="">-선택-</option>
															<option value="CM001CD001">할 일</option>
															<option value="CM001CD002">진행중</option>
															<option value="CM001CD003">보류</option>
															<option value="CM001CD004">완료</option>
														</select>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="taskImportanceCd" class="col-form-label col-sm-2 text-sm-end"><b>중요도</b></label>
													<div class="col-sm-4">
														<select id="taskImportanceCd" class="form-select" disabled>
															<option selected value="">-선택-</option>
															<option value="CM002CD001">상</option>
															<option value="CM002CD002">중</option>
															<option value="CM002CD003">하</option>
														</select>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="taskDetail" class="col-form-label col-sm-2 text-sm-end"><b>내용</b></label>
													<div class="col-sm-9">
														<textarea id="taskDetail" class="form-control" disabled style="min-height: 15rem;" onkeydown="fnTaskDetailResize(this)" onkeyup="fnTaskDetailResize(this)"></textarea>
													</div>
												</div>
												<div class="mb-3 row">
													<label class="col-form-label col-sm-2 text-sm-end"><b>참여자</b></label>
													
													<div id ="empAdd" class="col-sm-9">
														<span id="empAddSpan"></span>
														<button id="btnEmpAdd" type="button" class="btn btn-secondary"style="margin-top:4px;"><i class="far fa-fw fa-user"></i> 추가</button>
													</div>
												</div>
											</form>
										</div>
										
										<div class="col-12 col-xl-6">
											<form>
												<div class="mb-3 row">
													<label for="taskStartDt" class="col-form-label col-sm-2 text-sm-end"><b>시작일</b></label>
													<div class="col-sm-4">
														<input id="taskStartDt" type="text" class="form-control flatpickr-minimum" disabled placeholder="Select date" autocomplete="off"/>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="taskEndDt" class="col-form-label col-sm-2 text-sm-end"><b>종료일</b></label>
													<div class="col-sm-4">
														<input id="taskEndDt" type="text" class="form-control flatpickr-minimum" disabled placeholder="Select date" autocomplete="off"/>
													</div>
												</div>
												
												<div class="mb-3 row">
													<label for="taskProgress" class="col-form-label col-sm-2 text-sm-end"><b>진행도</b></label>
													<div class="col-sm-4">
														<div class="input-group">
															<select id="taskProgress" class="form-select" disabled>
																<option selected value="0">0</option>
																<option value="10">10</option>
																<option value="20">20</option>
																<option value="30">30</option>
																<option value="40">40</option>
																<option value="50">50</option>
																<option value="60">60</option>
																<option value="70">70</option>
																<option value="80">80</option>
																<option value="90">90</option>
																<option value="100">100</option>
															</select>
															<span class="input-group-text">%</span> 
														</div>
													</div>
												</div>
												<div class="mb-3 row">
													<label class="col-form-label col-sm-2 text-sm-end"><b>체크리스트</b></label>
													<div class="col-sm-9">
														<button class="btn btn-secondary" type="button" id="btnAddCheckList"><i class="far fa-fw fa-list-alt"></i> 추가</button>
													</div>
												</div>
												<div class="row" id="checkList">
												</div>
												
												<div class="mb-3 row">
													<label class="col-form-label col-sm-2 text-sm-end"><b>파일</b></label>
													<div class="col-sm-9">
														<label class="btn btn-secondary"><i class="far fa-fw fa-file"></i> 파일첨부</label>
														<form method="POST" onsubmit="return false;" enctype="multipart/form-data" >
													        <input type="file" id="input-file" onchange="fnUploadFile(this);" multiple hidden/>
													    </form>
													</div>
												</div>
												<div class="row" id="fileList">
												</div>
												
												
												<div class="mb-3 row" id="childTaskDiv">
													<label class="form-label col-sm-2 text-sm-end"><b>하위업무</b></label>
													<div class="col-sm-9">
														<table id="childTaskTable" class="table table-striped" style="width:100%">
															<thead>
																<tr>
																	<th>상세</th>
																	<th>업무명</th>
																</tr>
															</thead>
														</table>
													</div>
												</div>
												
											</form>
										</div>
										<div class="row" style="margin-top:10px;">
											<div class="col-12 col-lg-12">
												<div class="mb-3 row">
													<label for="taskComment" class="col-form-label col-sm-1 text-sm-end"><b>댓글</b></label>
										
													<div id="commentDiv" class="col-sm-11">
													</div>
												</div>
											</div>
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
  <input type="hidden" id="pParentTaskId" name="pParentTaskId" value=""/>
  <input type="hidden" id="pEmail" name="pEmail" value="<c:out value="${email}"/>"/>
  <input type="hidden" id="pTaskId" name="pTaskId" value="<c:out value="${taskId}"/>"/>
</form>

<%@ include file="/WEB-INF/views/admin/include/script.jsp" %>

<script>
let fileHeight = 0;
let checkHeight = 0;
let empHeight = 0;
let selFile;
let empArr = new Array();
let filesArr = new Array();
let checkArr = new Array();
let gCommentId = '';
let gCommentUpdateYn = 'Y';
let fpTaskStartDt;
let fpTaskEndDt;
let referrer = document.referrer;

$(function() {
	fnSetMenuSelection();
	fnSetEvent();
	fnSetComponent();
	fnSetData();
})

function fnSetMenuSelection() {
	gfnSelectMenu("taskmngform", "", "");
}

function fnSetComponent() {
	// Flatpickr
	fpTaskStartDt = flatpickr("#taskStartDt", {
		dateFormat: "Y-m-d"
	});
	fpTaskEndDt = flatpickr("#taskEndDt", {
		dateFormat: "Y-m-d"
	});
	selFile = document.querySelector("input[type=file]");
}

function fnSetEvent() {
	$("#btnTaskDelete").off("click").on("click", function (e) {
		e.preventDefault();
		let msg = "해당 태스크 건을 삭제하시겠습니까?";
		let callback = fnDeleteTask;
		gfnInitWrnCfmMdlDialog(msg, callback);
		
		//fnDeleteTask();
	});
	
	$("#btnGoTaskList").off("click").on("click", function (e) {
		e.preventDefault();
		let ref = referrer.substring(referrer.lastIndexOf('/')+1, referrer.length);
		if(ref != 'taskmngform') sessionStorage.clear();
		location.href = "/admin/tasks/taskmngform";
	});
}

//업무 삭제
function fnDeleteTask() {
	let taskId = $('#pTaskId').val();
	let apiUrl = '/rest/admin/tasks/' + taskId;

	gfnShowLoadingBar();
	
	$.ajax({
        url: apiUrl,
        type: 'delete',
        beforeSend : function(xmlHttpRequest) {
        	xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
	}).done(function(data) {
		gfnSuccessAlert("태스크가 삭제되었습니다.",5000);
		location.href = "/admin/tasks/taskmngform";
	}).fail(function(request, status, error) {
		gfnFailAlert(error, 5000);
	}).always(function(msg) {
		gfnHideLoadingBar();
	});
}

//업무상세 데이터 Set
function fnSetData() {
	let taskId = $('#pTaskId').val();
	let apiUrl = '/rest/admin/tasks/' + taskId;
	
	$.ajax({
        url: apiUrl,
        type: 'get',
        beforeSend : function(xmlHttpRequest) {
        	xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
     }).done(function(data) {
    	 if(data.childCnt > 0) { //상위업무
    		 $('#parentTaskDiv').hide();
    		 $('#childTaskDiv').show();
        	 fnLoadChildTask();
    	 }
    	 else {
    		 $('#childTaskDiv').hide();
    	 }
    	 
         $('#taskNm').val(gfnUnescapeHTML(data.taskNm));
         $('#taskOwnerMember').val(gfnUnescapeHTML(data.empNm));
         $('#taskDetail').val(gfnUnescapeHTML(data.taskDetail));
         $('#taskStateCd').val(data.taskStateCd);
         fpTaskStartDt.setDate(gfnYmdFormat(data.taskStartDt, "-"));
         fpTaskEndDt.setDate(gfnYmdFormat(data.taskEndDt, "-"));
         $('#taskImportanceCd').val(data.taskImportanceCd);
         $('#taskOwnerMemberId').val(data.taskOwnerMemberId);
         $('#taskProgress').val(data.taskProgress);

         let parentTaskId = data.parentTaskId;
         if(parentTaskId == '' || parentTaskId == null) {
        	 $('#parentTaskGroup').hide();
         }
         else {
        	 $('#parentTaskGroup').show();
        	 $('#pParentTaskId').val(parentTaskId);
        	 $('#btnParentTask').text(data.parentTaskNm);
         }
         
         fnSetTaskEmp(data.taskEmpList);
         fnSetChecklist(data.checklist);
         fnSetComment();    
         for(let i = 0; i < data.fileList.length; i++) {
 			filesArr.push(data.fileList[i]);
			fnSetFile(fileHeight, data.fileList[i]);
         };
	});
}

//업무상세 - 참여자 Set
function fnSetTaskEmp(taskEmpList){
	for(let i = 0; i < taskEmpList.length; i++) {		
		let num = empHeight+i;
		let htmlData = '';
		let buttonStyle = '';
		if(taskEmpList[i].taskEmpCd == 'CM004CD002') buttonStyle = 'danger';
		else buttonStyle = 'warning'; 

	    htmlData += '<div class="btn-group me-2" id="empAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
	    htmlData += '<button id="btnEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ taskEmpList[i].empNm + '</button>';
	    htmlData += '<input type="text" id="empAddEmail' + num + '" value="'+ taskEmpList[i].email +'" hidden>';
	    htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button">';
	    htmlData += '<i class="fas fa-times"></i>';
	    htmlData += '</button>';
	    htmlData += '</div>';
	    
	    $('#empAddSpan').append(htmlData);
	    if(taskEmpList[i].taskEmpCd == 'CM004CD002') {
	    	empArr.push({
	    		email: taskEmpList[i].email,
	    		taskEmpCd: taskEmpList[i].taskEmpCd
	    	});
	    }
		else {
			empArr.push({
	    		email: taskEmpList[i].email,
	    		taskEmpCd: taskEmpList[i].taskEmpCd
	    	});
		}
	}
}

//업무상세 - 체크리스트 Set
function fnSetChecklist(checklist) {
	for(let i = 0; i < checklist.length; i++) {
		let htmlData = '';
	    htmlData += '<label id="checkLabel' + checkHeight + '" class="form-label col-sm-2 text-sm-end"></label>';
	    htmlData += '<div id="checkDiv' + checkHeight + '" class="col-sm-9">'
	    htmlData += '<div class="input-group mb-3">';
	    htmlData += '<div class="input-group-text">';
	    htmlData += '<input type="checkbox" id="taskCheckYn' + checkHeight + '">';
	    htmlData += '</div>';
	    htmlData += '<input type="text" id="taskCheck' + checkHeight + '" class="form-control" placeholder="To do" value="" disabled>';
	    htmlData += '<button class="btn btn-secondary" type="button">';
	    htmlData += '<i class="fas fa-times"></i>';
	    htmlData += '</button>';
	   	htmlData += '</div>';
	   	htmlData += '</div>';
	    $('#checkList').append(htmlData);
	    
	    if(checklist[i].checkYn == 'Y') $('#taskCheckYn'+checkHeight).attr("checked", true);
	   	else $('#taskCheckYn'+checkHeight).attr("checked", false);
	    $('#taskCheck'+checkHeight).val(checklist[i].checkNm);
	    
	    checkArr.push(checkHeight);
	    checkHeight += 1;
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
		let downUrl = "/api/task/user/files/azure";
		downUrl = downUrl + "?fileDispNm=" + fileDispNm;
		downUrl = downUrl + "&fileNm=" + fileNm;
		
		const encFileName = encodeURI(downUrl);
		window.open(encFileName);
	}
}

//하위업무 목록 조회
function fnLoadChildTask() {
	let apiUrl = "/rest/user/tasks/" + $("#pTaskId").val() + "/childs";
	$.ajax({
        url: apiUrl,
        type: 'get',
        beforeSend : function(xmlHttpRequest) {
        	xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
     }).done(function(data) {
         $("#childTaskTable").dataTable({
               	data: data,
               	columns: [
	       			{
	       				data: 'taskId',
	       				className: 'text-center',
	       				width : "120px", 
	       				render: function(data) {
	       					return '<button class="btn btn-secondary btn-sm" type="button" onclick="fnChildTaskDetail(' + data + ')"><i class="fas fa-search"> 상세</i></button>';
	       				}
	       			},
	       			{
	       				data: 'taskNm',
	       			}
               	],
               	destroy: true,
               	ordering : false,
               	responsive: true,
               	info: false,
               	searching: false,
				select: false,
				//scrollY: '200',
				//scroller: true,
				lengthMenu: [ 5, 10 ],
				loadBeforeSend: function(jqXHR) {
					jqXHR.setRequestHeader("AJAX", "true");
				}
         });
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
    htmlData += '<button class="btn btn-secondary" type="button">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
   	htmlData += '</div>';
   	htmlData += '</div>';
   	$('#fileList').append(htmlData);
   	
   	fileHeight += 1;
}

//하위업무 상세버튼 클릭시 이동
function fnChildTaskDetail(taskId) {
	let apiUrl = '/admin/tasks/taskdetailform';
	let params = new Object();
	params.taskId = taskId;
	fnPostMove(apiUrl, params);
}

//댓글 조회
function fnSetComment() {
    let taskId = $("#pTaskId").val();

	$.ajax({
		url:"/rest/user/tasks/" + taskId + "/comments",
		type:'GET',
		beforeSend : function(xmlHttpRequest) {
        	xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
	}).done(function(data) {
		$.each(data, function(idx, item){
			let htmlData = '';
            htmlData += '<div class="row mb-3" id="commentGroup' + item.commentId +'">';
            htmlData += '<div class="col-sm-1">' + item.empNm + '</div>';
            htmlData += '<div class="col-sm-8 ps-2">';
            htmlData += '<div class="text-dark" id="commentContentDiv' + item.commentId + '">' + item.commentContent + '</div>';
            htmlData += '<textarea id="commentContentText' + item.commentId + '" class="form-control" rows="2" style="display:none;">' + item.commentContent + '</textarea>';
            htmlData += '<div class="text-muted small mt-1">' + item.updateDt + '</div>';
            htmlData += '</div>';
           	htmlData += '</div>';
           	$('#commentDiv').append(htmlData);
		});
	}).fail(function(request, status, error) {
		gfnFailAlert(error, 5000);
	});
}

//업무상세 text-area 높이 조절
function fnTaskDetailResize(obj) {
    obj.style.height = '1px';
    obj.style.height = (12 + obj.scrollHeight) + 'px';
}
</script>

</body>

</html>