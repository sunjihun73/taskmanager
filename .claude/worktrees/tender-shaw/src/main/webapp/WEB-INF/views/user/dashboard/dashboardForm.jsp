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
						<button id="btnSearch" class="btn btn-primary mt-n1"><i class="fas fa-search"></i> 조회</button>
						<a href="/user/tasks/taskaddform" class="btn btn-warning mt-n1"><i class="fas fa-plus"></i> 등록</a>
					</div>
					
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><b><i class="align-middle" data-feather="grid"></i> 대시보드</b></h1>
					</div>
					
					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskLevel" class="col-form-label col-sm-4 text-sm-end"><b>태스크 Level</b></label>
												<div class="col-sm-8">
													<select id="taskLevel" class="form-select">
														<option selected value="">전체</option>
														<option value="Y">Level 1</option>
														<option value="N">Level 2</option>
													</select>
												</div>  
											</div>
										</div>
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskEmpCd" class="col-form-label col-sm-4 text-sm-end"><b>태스크 권한</b></label>
												<div class="col-sm-8">
													<select id="taskEmpCd" class="form-select">
														<option selected value="">전체</option>
														<option value="CM004CD001">소유</option>
														<option value="CM004CD002">할당</option>
														<option value="CM004CD003">공유</option>
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
					
						<div class="col-12 col-lg-6 col-xl-3">
							<div class="card">
								<div class="card-header" style="padding-bottom:0px;">
									<div class="card-actions float-end">
									</div>
									<div class="d-grid">
										<a href="#" class="btn btn-warning">할일</a>
									</div>										
								</div>
								<div class="card-body">

									<div id="tasks-todo" style="min-height:50px;">
										<!-- 카드 추가되는 곳 -->
									</div>
									<div class="d-grid">
										<button onclick="fnSetTasks('CM001CD001')" class="btn btn-outline-primary">더보기</button>
									</div>
								</div>
							</div>
						</div>
						
						<div class="col-12 col-lg-6 col-xl-3">
							<div class="card">
								<div class="card-header" style="padding-bottom:0px;">
									<div class="card-actions float-end">
									</div>
									<div class="d-grid">
										<a href="#" class="btn btn-primary">진행</a>
									</div>										
								</div>
								<div class="card-body">

									<div id="tasks-progress" style="min-height:50px;">
										
									</div>
									<div class="d-grid">
										<button onclick="fnSetTasks('CM001CD002')" class="btn btn-outline-primary">더보기</button>
									</div>

								</div>
							</div>
						</div>
						
						<div class="col-12 col-lg-6 col-xl-3">
							<div class="card">
								<div class="card-header" style="padding-bottom:0px;">
									<div class="card-actions float-end">
									</div>
									<div class="d-grid">
										<a href="#" class="btn btn-secondary">보류</a>
									</div>										
								</div>
								<div class="card-body">

									<div id="tasks-holding" style="min-height:50px;">
									</div>
									<div class="d-grid">
										<button onclick="fnSetTasks('CM001CD003')" class="btn btn-outline-primary">더보기</button>
									</div>

								</div>
							</div>
						</div>
					
						<div class="col-12 col-lg-6 col-xl-3">
							<div class="card">
								<div class="card-header" style="padding-bottom:0px;">
									<div class="card-actions float-end">
									</div>
									<div class="d-grid">
										<a href="#" class="btn btn-success">완료</a>
									</div>									
								</div>
								<div class="card-body">

									<div id="tasks-completed" style="min-height:50px;">
									</div>
									<div class="d-grid">
										<button onclick="fnSetTasks('CM001CD004')" class="btn btn-outline-primary">더보기</button>
									</div>

								</div>
							</div>
						</div>
						
					</div>
				</div>
			</main>

<%--            <script id="serengeti_function" src="https://functions.serengeti.aifrica.co.kr/assets/agent.embed.js?url=https://ui-ff772584-1d75-4795-918b-0343d4bbd165.agent.serengeti.app" async></script>--%>


            <%@ include file="/WEB-INF/views/user/include/footer.jsp"%>
		</div>
	</div>

	<div class="modal fade" id="progressUpdateModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-sm" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">
						<i class="fas fa-angle-double-right"></i> 진행도 변경
					</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body m-3">
					<div class="card">
						<form id="progressUpdateForm">
							<div class="mb-3">
								<label for="updateProgress" class="form-label"><b>진행도</b></label>
								<div class="input-group">
									<select id="updateProgress" class="form-select">
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
								<input type="text" id="updateProgressIdx" class="form-control" hidden>
							</div>
						</form>
					</div>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
					<button type="button" id="btnProgressUpdateModal" class="btn btn-primary">저장</button>
				</div>
			</div>
		</div>
	</div>

<%@ include file="/WEB-INF/views/user/include/script.jsp" %>

<script>
let cardCnt = 0; //card index
let todoCnt = 0;
let progressCnt = 0;
let holdingCnt = 0;
let completedCnt = 0;
let taskIdArr = new Array();

$(function() {
	fnSetMenuSelection();
	fnSetComponent();
	fnSetTasks();
	fnSetEvent();
})

function fnSetMenuSelection() {
	gfnSelectMenu("dashboard", "", "");
}

function fnSetComponent() {

	let drake = dragula([
		document.querySelector("#tasks-todo"),
		document.querySelector("#tasks-progress"),
		document.querySelector("#tasks-holding"),
		document.querySelector("#tasks-completed")
	]);
	
	drake.on('drop', (el, target, source, sibling) => {
	  // el: 드래그하고 있는 요소
	  // target: el이 드래그 후 놓아진 리스트 요소
	  // sibling: 자리에 놓았을 때, 바로 그 다음 요소
	  // source: 원래 el이 있던 리스트 요소
	  
	  let taskId = el.firstChild.nextSibling.firstChild.firstChild.value;
	  let taskState = target.id;
	  
	  if(taskState == 'tasks-todo') taskState = 'CM001CD001';
	  else if(taskState == 'tasks-progress') taskState = 'CM001CD002';
	  else if(taskState == 'tasks-holding') taskState = 'CM001CD003';
	  else taskState = 'CM001CD004';
	  
	  fnUpdateTaskState(taskId, taskState);
	  
	});
}

function fnSetEvent() {
	$("#btnSearch").off("click").on("click", function (e) {
		e.preventDefault();
		fnTaskSearch();
	});
	
	$("#btnProgressUpdateModal").off("click").on("click", function (e) {
		e.preventDefault();
		fnProgressUpdate();
	});
}

//태스크조회(조회조건 포함)
function fnTaskSearch() {
	$('#tasks-todo').empty();
	$('#tasks-progress').empty();
	$('#tasks-holding').empty();
	$('#tasks-completed').empty();
	todoCnt = 0; progressCnt = 0; holdingCnt = 0; completedCnt = 0; cardCnt = 0;
	taskIdArr = [];
	fnSetTasks();
}

//태스크목록 조회 api 호출
function fnSetTasks(taskStateCd) {
	gfnShowLoadingBar();
	let params = new Object();
	params.taskEmpCd = $("#taskEmpCd").val();
	params.childTaskAddYn = $("#taskLevel").val();
	params.start = 0;
	if(typeof taskStateCd != "undefined") {
		if(taskStateCd == "CM001CD001") params.start = todoCnt;
		else if(taskStateCd == "CM001CD002") params.start = progressCnt;
		else if(taskStateCd == "CM001CD003") params.start = holdingCnt;
		else if(taskStateCd == "CM001CD004") params.start = completedCnt;
		params.taskState = taskStateCd;
	}
	$.ajax({
		type:'get',
		url:'/rest/user/tasks/dashboards/me',
		data: params,
		beforeSend : function(xmlHttpRequest) {
			xmlHttpRequest.setRequestHeader("AJAX", "true");
		}
	}).done(function(data) {
		$.each(data, function(idx, item){
			//더보기 누른 경우 중복 태스크 Check
			if(typeof taskStateCd != "undefined") {
				for(let i = 0; i < taskIdArr.length; i++) {
					if(taskIdArr[i] == item.taskId) {
						gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, 5000);
						return true;
					}
				}
			}
			if(item.taskStateCd == 'CM001CD001') fnAddTodo(cardCnt);
			else if(item.taskStateCd == 'CM001CD002') fnAddProgress(cardCnt);
			else if(item.taskStateCd == 'CM001CD003') fnAddHolding(cardCnt);
			else if(item.taskStateCd == 'CM001CD004') fnAddCompleted(cardCnt);
			
			fnSetCard(cardCnt, item);
			cardCnt += 1;
			taskIdArr.push(item.taskId); //태스크id 중복 체크용
        	
   		});
		gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_List, 2000);
	}).fail(function(request, status, error) {
		gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, 5000);
	}).always(function(msg) {
		gfnHideLoadingBar();
	});
		
}

//태스크 카드에 Data Set
function fnSetCard(idx, item) {
	$("#taskId"+idx).val(item.taskId);
	$("#taskNm"+idx).val(gfnUnescapeHTML(item.taskNm));

	if(item.taskStartDt == null || item.taskStartDt == '') item.taskStartDt = "";
	else item.taskStartDt = gfnYmdFormat(item.taskStartDt, "-");
	if(item.taskEndDt == null || item.taskEndDt == '') item.taskEndDt = "";
	else {
		item.taskEndDt = gfnYmdFormat(item.taskEndDt, "-");
		let taskEndDt = new Date(item.taskEndDt);
		let today = new Date();
		today = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 9); //날짜만 비교하기위해 시간 맞춰줌
		if(taskEndDt < today && item.taskState != '완료') $("#taskDate"+idx).css("color", "#FF6666");
	}
	$("#taskDate"+idx).val(item.taskStartDt + "~" + item.taskEndDt);
	 	
	$("#taskOwnerMemberNm"+idx).val(gfnUnescapeHTML(item.empNm));
	var taskProgress = item.taskProgress + '%';
	$("#taskProgress"+idx).text(taskProgress);
	$("#taskProgressBar"+idx).css('width', taskProgress);
	
	if(item.taskImportance == '상') $("#taskImportance"+idx).addClass('btn-danger');
	else if(item.taskImportance == '중') $("#taskImportance"+idx).addClass('btn-success');
	else if(item.taskImportance == '하')$("#taskImportance"+idx).addClass('btn-warning');
	else $("#taskImportance"+idx).hide();
	$("#taskImportance"+idx).text(item.taskImportance);
	
	if(item.childTaskAddYn == 'N') $("#taskLevel"+idx).text("Level 2");
	else $("#taskLevel"+idx).text("Level 1");
	
	if(item.taskEmpCd == 'CM004CD002') {
		$("#taskEmp"+idx).text("할당");
		$("#cardDiv"+idx).css('padding-bottom', '0px');
	}
	else if(item.taskEmpCd == 'CM004CD003') {
		$("#taskEmp"+idx).text("공유");
		$("#cardDiv"+idx).css('padding-bottom', '0px');
		$("#cardDiv"+idx).css('margin-top', '0px');
	}
}

//할일 태스크 추가
function fnAddTodo(idx) {
	let htmlData = fnAddCard(idx);
	$('#tasks-todo').append(htmlData);
	todoCnt += 1;
}

//진행중 태스크 추가
function fnAddProgress(idx) {
	let htmlData = fnAddCard(idx);
	$('#tasks-progress').append(htmlData);
	progressCnt += 1;
}

//보류 태스크 추가
function fnAddHolding(idx) {
	let htmlData = fnAddCard(idx);
	$('#tasks-holding').append(htmlData);
	holdingCnt += 1;
}

//완료 태스크 추가
function fnAddCompleted(idx) {
	let htmlData = fnAddCard(idx);
	$('#tasks-completed').append(htmlData);
	completedCnt += 1;
}

//태스크 카드 생성
function fnAddCard(idx){
    let htmlData = '';
    htmlData += '<div class="card mb-3 bg-light cursor-grab border">';
    htmlData += '<span id="taskEmp' + idx + '" class="badge bg-info" style="width:40px;"></span>';
    htmlData += '<div class="card-body px-4 pt-2" id="cardDiv' + idx + '">'
    htmlData += '<div class="p-1"><input id="taskId' + idx + '" class="form-control" readonly hidden></div>'
    
    htmlData += '<div class="mb-1 row">';
    htmlData += '<label class="col-form-label col-sm-3 text-sm-end">태스크</label>';
    htmlData += '<div class="col-sm-9">';
    htmlData += '<input id="taskNm' + idx + '" class="form-control" readonly>';
    htmlData += '</div>';
    htmlData += '</div>';
    
    htmlData += '<div class="mb-1 row">';
    htmlData += '<label class="col-form-label col-sm-3 text-sm-end">기간</label>';
    htmlData += '<div class="col-sm-9">';
    htmlData += '<input id="taskDate' + idx + '" class="form-control" readonly>';
    htmlData += '</div>';
    htmlData += '</div>';
    
    htmlData += '<div class="mb-1 row">';
    htmlData += '<label class="col-form-label col-sm-3 text-sm-end">소유자</label>';
    htmlData += '<div class="col-sm-9">';
    htmlData += '<input id="taskOwnerMemberNm' + idx + '" class="form-control" readonly>';
    htmlData += '</div>';
    htmlData += '</div>';
    
    htmlData += '<div class="mb-1 row">';
    htmlData += '<label class="col-form-label col-sm-3 text-sm-end">진행도</label>';
    htmlData += '<div class="col-form-label col-sm-6">';
    htmlData += '<div class="progress" data-bs-toggle="modal" data-bs-target="#progressUpdateModal" onclick="fnProgressUpdateModal(' + idx + ')">';
    htmlData += '<div class="progress-bar" id="taskProgressBar' + idx + '" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100">';
    htmlData += '</div>';
    htmlData += '</div>';
    htmlData += '</div>';
    htmlData += '<span class="col-form-label col-sm-3" id="taskProgress' + idx + '"></span>';
    htmlData += '</div>';

    htmlData += '<div class="p-3">';
    htmlData += '<a class="btn btn-sm btn-secondary" onclick="fnGoTaskDetail('+ idx + ')" href="#" style="margin-right:10px;">상세</a>';
    htmlData += '<button id="taskImportance' + idx + '" class="btn btn-sm" style="margin-right:10px;"></button>';
    htmlData += '<button id="taskLevel' + idx + '" class="btn btn-sm btn-outline-secondary"></button>';
    htmlData += '</div>';
    
   	htmlData += '</div>';
   	htmlData += '</div>';
    
   	return htmlData;
}

//태스크상태 변경
function fnUpdateTaskState(taskId, taskState) {
	let params = new Object();
	params.taskStateCd = taskState;
	
	$.ajax({
		type:'patch',
		url:'/rest/user/tasks/' + taskId + '/editstate',
		data: params,
		beforeSend : function(xmlHttpRequest) {
			xmlHttpRequest.setRequestHeader("AJAX", "true");
		}
	}).done(function(data) {
		gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_Update, 2000);
	}).fail(function(request, status, error) {
		gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, 5000);
	});
}

// Task 상세보기
function fnGoTaskDetail(idx) {
	let apiUrl = '/user/tasks/taskdetailform';
	let params = new Object();
	params.taskId = $("#taskId"+idx).val();
	fnPostMove(apiUrl, params);
}

//진행도 클릭시 modal Set
function fnProgressUpdateModal(idx) {
	let progressText = $('#taskProgress' + idx).text();
	let progress = progressText.substr(0, progressText.length-1);
	$('#updateProgress').val(progress);
	$('#updateProgressIdx').val(idx);
}

//진행도 변경
function fnProgressUpdate() {
	let idx = $('#updateProgressIdx').val();
	let taskId = $('#taskId' + idx).val();
	let taskProgress = $('#updateProgress').val();
	
	gfnShowLoadingBar();
	let apiUrl = '/rest/user/tasks/' + taskId + '/progress';
	let params = new Object();
	params.taskProgress = taskProgress;

	$.ajax({
        url: apiUrl,
        data: params,
        type: 'PATCH',
        beforeSend : function(xmlHttpRequest) {
        	xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
	}).done(function(data) {
		gfnSuccessAlert("진행도" + gCmmnSM_Update, 2000);
		$('#progressUpdateModal').modal('hide');
		//fnReselGrid();
    	$("#taskProgress"+idx).text(taskProgress + '%');
    	$("#taskProgressBar"+idx).css('width', taskProgress + '%');
	}).fail(function(request, status, error) {
		gfnFailAlert("진행도" + gCmmnEM_ServiceError, 5000);
	}).always(function(msg) {
		gfnHideLoadingBar();
	});
}

</script>
</body>

</html>