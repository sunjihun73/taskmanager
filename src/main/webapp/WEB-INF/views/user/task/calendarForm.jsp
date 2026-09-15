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
						<h1 class="h3 d-inline align-middle"><b><i class="far fa-calendar-check"></i> 캘린더</b></h1>
					</div>
					
					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskState" class="col-form-label col-sm-3 text-sm-end"><b>상태</b></label>
												<div class="col-sm-8">
													<select id="taskState" class="form-select">
														<option selected value="">전체</option>
														<option value="CM001CD001">할일</option>
														<option value="CM001CD002">진행</option>
														<option value="CM001CD003">보류</option>
														<option value="CM001CD004">완료</option>
													</select>
												</div>  
											</div>
										</div>
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskEmpCd" class="col-form-label col-sm-3 text-sm-end"><b>권한</b></label>
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
										
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskLevel" class="col-form-label col-sm-3 text-sm-end"><b>업무 Level</b></label>
												<div class="col-sm-8">
													<select id="taskLevel" class="form-select">
														<option selected value="">전체</option>
														<option value="Y">Level 1</option>
														<option value="N">Level 2</option>
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
						<div class="col-md-2">
							<div class="card">
								<div class="card-header">
									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 라벨 목록</h5>
								</div>
								<div class="card-body" style="height:520px;">
									<table id="labelTable" class="table table-striped" style="width:100%">
										<thead>
											<tr>
												<th>라벨</th>
											</tr>
										</thead>
									</table>
								</div>
							</div>
						</div>
						<div class="col-md-10">
							<div class="card">
<!-- 								<div class="card-header"> -->
<!-- 									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 캘린더</h5> -->
<!-- 								</div> -->
								<div class="card-body">
									<div id="fullcalendar"></div>
								</div>
							</div>
						</div>
					</div>
					
				</div>
			</main>

			<%@ include file="/WEB-INF/views/user/include/footer.jsp"%>
		</div>
		
		
	</div>

<%@ include file="/WEB-INF/views/user/include/script.jsp" %>
<script src="/adminkit/js/fullcalendar.js"></script>
<script>
let dtLabels;

$(function() {
	fnSetMenuSelection();
	fnSetComponent();
	fnSetEvent();
})

function fnSetMenuSelection() {
	gfnSelectMenu("taskManage", "taskSide", "calendarform");
}

function fnSetComponent() {
	// Flatpickr
	flatpickr(".flatpickr-minimum", {
		dateFormat: "Ymd"
	});
	flatpickr(".flatpickr-datetime", {
		enableTime: true,
		dateFormat: "Y-m-d H:i",
	});
	
	fnSetCalendar();
	fnSetLabels();
}

function fnSetEvent() {
	$("#btnSearch").off("click").on("click", function (e) {
		e.preventDefault();
		//dtLabels.row('.selected').deselect();
		fnSetCalendar();
	});

 	// 라벨 선택 이벤트
    dtLabels.on('select', function (e, dt, type, indexes) {
        if (type === 'row') {
            let data = dtLabels.rows(indexes).data().pluck('labelId');
            fnSetCalendar(data[0]);
        }
    });

     // 라벨 선택 해제 이벤트
    dtLabels.on('deselect', function (e, dt, type, indexes) {
        if (type === 'row') {
            let data = dtLabels.rows(indexes).data().pluck('labelId');
            fnSetCalendar('');
        }
    });
}

//캘린더 그리기
function fnSetCalendar(labelId) {
	let today = new Date();
	let year = today.getFullYear(); // 년도
	let month = today.getMonth() + 1;  // 월
	if (month <= 9){
	    month = "0" + month;
	}
	let date = today.getDate();  // 날짜
	if (date <= 9){
		date = "0" + date;
	}
	let initialDate = year + '-' + month + '-' + date;
	
	let params = new Object();
	
	params.taskState = $("#taskState").val();
	params.childTaskAddYn = $("#taskLevel").val();
	params.taskEmpCd = $("#taskEmpCd").val();
	params.labelId = labelId;
	
	var calendarEl = document.getElementById("fullcalendar");
	var calendar = new FullCalendar.Calendar(calendarEl, {
		themeSystem: "bootstrap",
		initialView: "dayGridMonth",
		initialDate: initialDate,
		headerToolbar: {
			left: "prev,next today",
			center: "title",
			right: "dayGridMonth,timeGridWeek,timeGridDay"
		},
		eventSources: [{
			events: function(info, successCallback, failureCallback) {
				gfnShowLoadingBar();
				$.ajax({
					type:'get',
					url:'/rest/user/tasks/calendar',
					data: params,
					dataType: 'json',
					beforeSend : function(xmlHttpRequest) {
						xmlHttpRequest.setRequestHeader("AJAX", "true");
					}
				}).done(function(data) {
					let events = [];
					$.each(data, function(idx, item){
						let color = '';
						if(item.taskStateCd == 'CM001CD001') color = 'rgba(252,185,44)';
						else if(item.taskStateCd == 'CM001CD002') color = 'rgba(59,125,221)';
						else if(item.taskStateCd == 'CM001CD003') color = 'rgba(108,117,125)';
						else if(item.taskStateCd == 'CM001CD004') color = 'rgba(62,197,157)';
						let endDate = parseInt(gfnNoFormatDate(item.end))+1; //종료일+1해줘야 캘린더 표시날짜와 맞음
						events.push({
							title: gfnUnescapeHTML(item.title) + " (" + item.taskState + ")",
							id: item.taskId,
							start: item.start,
							end: gfnYmdFormat(String(endDate), "-"),
							color: color
						});
					});
					successCallback(events);
					gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_List, gDelay_Short);
				}).fail(function(request, status, error) {
					gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, gDelay_Long);
				}).always(function(msg) {
					gfnHideLoadingBar();
				});
			}
		}],
		eventClick: function(info) { 
			let taskId = info.event._def.publicId;
			fnGoTaskDetail(taskId);
		},
		locale: 'ko',
		height: '525px',
		expandRows: true,
	});
	setTimeout(function() {
		calendar.render();
	}, 250);
	
}

//라벨 목록 조회
function fnSetLabels() {
	dtLabels = $("#labelTable").DataTable({
		ajax: {
			url : "/rest/user/labels/me",
			dataSrc : "data",
		    error : function (xhr, error, code) {
		    	gfnFailAlert(gCmmnLabelNm + gCmmnEM_ServiceError, gDelay_Long);
			}				
		},
       	columns: [
   			{
   				data: 'labelNm',
   				className: 'text-center'
   			}
       	],
		ordering : false,
       	destroy: true,
       	responsive: true,
       	info: true,
		select: true,
		scrollCollapse : false,
		lengthChange : false,
		scrollY: '450',
		searching: false,
		ordering: false,
		info: false,
		paging: false,
		lengthMenu : [10, 50, 100, 500],
		loadBeforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", "true");
		}	
 	});
	
	dtLabels.tables()
		.header()
	    .to$()
	    .css('display','none');
}

//검색조건 초기화
function fnResetSearchCond() {
	$("#taskState").val("");
	$("#taskLevel").val("");
	$("#taskEmpCd").val("");
}

//업무 상세버튼 클릭시 이동
function fnGoTaskDetail(taskId) {
	let apiUrl = '/user/tasks/taskdetailform';
	let params = new Object();
	params.taskId = taskId;
	fnPostMove(apiUrl, params);
}

</script>
</body>

</html>