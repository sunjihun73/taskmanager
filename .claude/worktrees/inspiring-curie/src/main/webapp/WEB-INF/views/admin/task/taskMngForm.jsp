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
						<h1 class="h3 d-inline align-middle"><b><i class="fas fa-tasks"></i> 태스크목록</b></h1>
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
													<select id="taskState" class="form-select mb-2">
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
												<label for="taskNm" class="col-form-label col-sm-3 text-sm-end"><b>업무명</b></label>
												<div class="col-sm-8">
													<input type="text" id="taskNm" class="form-control" autocomplete="off">
												</div>
											</div>
										</div>
										
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="empNm" class="col-form-label col-sm-3 text-sm-end"><b>소유자</b></label>
												<div class="col-sm-8">
													<input type="text" id="empNm" class="form-control" autocomplete="off">
												</div>
											</div>
										</div>
										
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for=taskEmpNm class="col-form-label col-sm-3 text-sm-end"><b>참여자</b></label>
												<div class="col-sm-8">
													<input type="text" id="taskEmpNm" class="form-control" autocomplete="off">
												</div>
											</div>
										</div>
										
									</div>
									
									<div class="row">
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskStartDt" class="col-form-label col-sm-3 text-sm-end"><b>시작일</b></label>
												<div class="col-sm-8">
													<div class="input-group">
														<input id="taskStartDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" />
														<button id="btnClearTaskStartDt" class="btn btn-secondary" type="button"><i class="fas fa-times"></i></button>
													</div>
												</div>  
											</div>
										</div>
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskEndDt" class="col-form-label col-sm-3 text-sm-end"><b>종료일</b></label>
												<div class="col-sm-8">
													<div class="input-group">
														<input id="taskEndDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" />
														<button id="btnClearTaskEndDt" class="btn btn-secondary" type="button"><i class="fas fa-times"></i></button>
													</div>
												</div>
											</div>
										</div>
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskLevel" class="col-form-label col-sm-3 text-sm-end"><b>업무 Level</b></label>
												<div class="col-sm-8">
													<select id="taskLevel" class="form-select mb-2">
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
						<div class="col-md-12">
							<div class="card" >
								<div class="card-header">
									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 태스크 목록</h5>
								</div>
								<div class="card-body">
									<table id="taskTable" class="table table-striped" style="width:100%">
										<thead>
											<tr>
												<th>구분</th>
												<th>상세</th>
												<th>유형</th>
												<th>상태</th>
												<th>업무명</th>
												<th>회사</th>
												<th>소유자</th>
												<th>참여자</th>
												<th>시작일</th>
												<th>종료일</th>
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
let dtTasks;
let fpTaskStartDt;
let fpTaskEndDt;
let referrer = document.referrer;
let gTaskStartDt;
let gTaskEndDt;

//검색조건 유지
// window.onpageshow = function(event) {
// 	let ref = referrer.substring(referrer.lastIndexOf('/')+1, referrer.length);
// 	if(event.persisted || (window.performance && window.performance.navigation.type == 2) || ref == "taskdetailform") {
//    		$("#taskState").val(sessionStorage.getItem("tasksTaskState"));
//         $("#taskNm").val(sessionStorage.getItem("tasksTaskNm"));
//         $("#empNm").val(sessionStorage.getItem("tasksEmpNm"));
//         $("#taskEmpNm").val(sessionStorage.getItem("tasksTaskEmpNm"));
//         $("#taskLevel").val(sessionStorage.getItem("tasksTaskLevel"));
//         gTaskStartDt = sessionStorage.getItem("tasksTaskStartDt");
//         gTaskEndDt = sessionStorage.getItem("tasksTaskEndDt");
//         $("#taskEmpCd").val(sessionStorage.getItem("tasksTaskEmpCd"));
//     }
//     sessionStorage.clear();
// }

$(function() {
	fnSetMenuSelection();
	fnSetComponent();
	// fnSetEvent();
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
	
	//검색조건에 시작일or종료일이 존재했다면 Set
	if(gTaskStartDt) fpTaskStartDt.setDate(gfnYmdFormat(gTaskStartDt, "-"));
    if(gTaskEndDt) fpTaskEndDt.setDate(gfnYmdFormat(gTaskEndDt, "-"));
	
	fnSetTasks();
}

function fnSetEvent() {
	$("#btnSearch").off("click").on("click", function (e) {
		e.preventDefault();
		fnReselGrid();
	});
	
	$("#taskNm").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnReselGrid();
		}
	});
	
	$("#empNm").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnReselGrid();
		}
	});
	
	$("#taskEmpNm").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnReselGrid();
		}
	});

	$("#btnClearTaskStartDt").off("click").on("click", function (e) {
		e.preventDefault();
		fpTaskStartDt.clear();
	});

	$("#btnClearTaskEndDt").off("click").on("click", function (e) {
		e.preventDefault();
		fpTaskEndDt.clear();
	});

    fnGetSeacrhCondition();
    fnReselGrid();
}

// 업무목록 조회
function fnSetTasks() {
    let apiUrl = "/rest/admin/tasklist";
	dtTasks = $("#taskTable").DataTable({
		ajax: {
			url : apiUrl,
            type: "POST",
			dataSrc : "data",
			data : function (d) {
				d.taskState = $("#taskState").val();
				d.taskNm = $("#taskNm").val();
				d.empNm = $("#empNm").val();
				d.taskEmpNm = $("#taskEmpNm").val();
				d.childTaskAddYn = $("#taskLevel").val();
				d.taskStartDt = gfnNoFormatDate(fpTaskStartDt.selectedDates);
				d.taskEndDt = gfnNoFormatDate(fpTaskEndDt.selectedDates);
		    },
		    error : function (xhr, error, code) {
		    	gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, gDelay_Long);
			}
		},
       	columns: [{
       		    title: '',
       		    target: 0,
       		    className: 'treegrid-control',
       		    data: function (item) {
       		        if (item.children) {
       		            return '<span><i class="far fa-fw fa-plus-square"></i></span>';
       		        }
       		        return '';
       		    },
       		 	width : "1%",
       		},{
       			data: function (item) {
   					if(item.childYn == 'Y') return '<button class="btn btn-outline-info btn-sm" type="button" onclick="fnGoTaskDetail(' + item.taskId + ')"><i class="fas fa-search"> 상세</i></button>';
   					return '<button class="btn btn-info btn-sm" type="button" onclick="fnGoTaskDetail(' + item.taskId + ')"><i class="fas fa-search"> 상세</i></button>';
       		    },
   				className: 'text-center',
   				width : "9%",
   			},
            {data: 'taskTypeNm', width : "8%"},
            {data: 'taskState', width : "5%"},
            {data: 'taskNm'},
            {data: 'empCompanyNm', width : "8%"},
            {data: 'empNm', width : "6%"},
            {data: 'taskEmpList[].empNm', width: '10%',
				render: function(data) {
					if(data.length == 0) return '';
					else if(data.length == 1) return data[0];
					return data[0] + '외 ' + (data.length-1) + '명';
				}
   	   		},
            {
   				data: 'taskStartDt',
   				width : "100px",
   				render: function(data) {
   					if(data == null || data == '') return "";
   					else return gfnYmdFormat(data, "-");
   				}
   			},
            {
   				data: 'taskEndDt',
   				width : "100px",
   				render: function(data) {
   					if(data == null || data == '') return "";
   					else return gfnYmdFormat(data, "-");
   				}
   			}
       	],
        treeGrid: {
            left: 15,
            expandIcon: '<span><i class="far fa-fw fa-plus-square"></i></span>',
            collapseIcon: '<span><i class="far fa-fw fa-minus-square"></i></span>',
            expandAll: true
        },
       	processing: true,
		serverSide: true,
		ordering : false,
       	destroy: true,
       	responsive: true,
       	info: true,
		searching: false,
		scrollY: 325,
		scrollCollapse : false,
		paging : true,
        searching : false,
		lengthChange : true,
		lengthMenu : [10, 50, 100, 500],
		loadBeforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", "true");
		},
		initComplete: function () {
			// gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_List, gDelay_Short);
            fnSetEvent();
		}
 	});
}

//태스크목록 재조회
function fnReselGrid() {
	dtTasks.ajax.reload(function (json) {
		if (json.resultCode === "SUCCESS") {
			gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_List, gDelay_Short);
		}
		else {
			gfnFailAlert(gCmmnUsrAdmNm + gCmmnEM_ServiceError, gDelay_Long);
		}
	});
}

//검색조건 초기화
function fnResetSearchCond() {
	$("#taskState").val("");
	$("#taskNm").val("");
	$("#empNm").val("");
	$("#taskEmpNm").val("");
	$("#taskLevel").val("");
	$("#taskStartDt").val("");
	$("#taskEndDt").val("");
}

//업무 삭제
function fnDeleteTask() {
	let data = $('#taskTable').DataTable().rows('.selected').data()[0];
	let apiUrl = '/rest/admin/tasks/' + data.taskId;
	
	gfnShowLoadingBar();
	$.ajax({
        url: apiUrl,
        method: 'delete',
        beforeSend : function(xmlHttpRequest) {
        	xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
	}).done(function(data) {
		gfnSuccessAlert("해당 태스크가 삭제되었습니다.", gDelay_Long);
		fnReselGrid();
	}).fail(function(request, status, error) {
		gfnFailAlert(error, gDelay_Long);
	}).always(function(msg) {
		gfnHideLoadingBar();
	});
}

//업무 상세버튼 클릭시 이동
function fnGoTaskDetail(taskId) {
    fnSetSessionStorage();
	let apiUrl = '/admin/tasks/taskdetailform';
	let params = new Object();
	params.taskId = taskId;
	fnPostMove(apiUrl, params);
}

// 검색조건 유지 (세션스토리지에서 저장했던 검색조건을 가지고옴)
function fnGetSeacrhCondition() {
    $("#taskState").val(sessionStorage.getItem("ADMIN_TASK_MNG_FORM_TASK_STATE"));
    $("#taskNm").val(sessionStorage.getItem("ADMIN_TASK_MNG_FORM_TASK_NM"));
    $("#empNm").val(sessionStorage.getItem("ADMIN_TASK_MNG_FORM_EMP_NM"));
    $("#taskEmpNm").val(sessionStorage.getItem("ADMIN_TASK_MNG_FORM_TASK_EMP_NM"));

    let taskStartDt = sessionStorage.getItem("ADMIN_TASK_MNG_FORM_TASK_START_DT");
    let taskEndDt = sessionStorage.getItem("ADMIN_TASK_MNG_FORM_TASK_END_DT");
    if(taskStartDt) fpTaskStartDt.setDate(gfnYmdFormat(taskStartDt, "-"));
    if(taskEndDt) fpTaskEndDt.setDate(gfnYmdFormat(taskEndDt, "-"));

    $("#taskLevel").val(sessionStorage.getItem("ADMIN_TASK_MNG_FORM_TASK_LEVEL"));

    sessionStorage.clear();
}

//검색조건 세션스토리지에 저장
function fnSetSessionStorage() {
    sessionStorage.setItem("ADMIN_TASK_MNG_FORM_TASK_STATE",$("#taskState").val());
    sessionStorage.setItem("ADMIN_TASK_MNG_FORM_TASK_NM",$("#taskNm").val());
    sessionStorage.setItem("ADMIN_TASK_MNG_FORM_EMP_NM",$("#empNm").val());
    sessionStorage.setItem("ADMIN_TASK_MNG_FORM_TASK_EMP_NM",$("#taskEmpNm").val());
    sessionStorage.setItem("ADMIN_TASK_MNG_FORM_TASK_START_DT",gfnNoFormatDate(fpTaskStartDt.selectedDates));
    sessionStorage.setItem("ADMIN_TASK_MNG_FORM_TASK_END_DT",gfnNoFormatDate(fpTaskEndDt.selectedDates));
    sessionStorage.setItem("ADMIN_TASK_MNG_FORM_TASK_LEVEL",$("#taskLevel").val());
}

</script>
</body>

</html>