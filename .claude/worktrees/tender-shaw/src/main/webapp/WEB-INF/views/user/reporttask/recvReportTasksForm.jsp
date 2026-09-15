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
					</div>
					
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><b><i class="fas fa-list"></i> 일일업무보고 수신 목록</b></h1>
					</div>
					
					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskTitle" class="col-form-label col-sm-3 text-sm-end"><b>업무명</b></label>
												<div class="col-sm-8">
													<input type="text" id="taskTitle" class="form-control" autocomplete="off">
												</div>
											</div>
										</div>
										
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskStateCd" class="col-form-label col-sm-3 text-sm-end"><b>상태</b></label>
												<div class="col-sm-8">
													<select id="taskStateCd" class="form-select mb-2">
														<option selected value="">전체</option>
														<option value="CM005CD002" selected>보고</option>
														<option value="CM005CD003">확인</option>
													</select>
												</div>
											</div>
										</div>
										
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskOnwerMemberNm" class="col-form-label col-sm-3 text-sm-end"><b>작성자</b></label>
												<div class="col-sm-8">
													<input type="text" id="taskOnwerMemberNm" class="form-control" autocomplete="off">
												</div>
											</div>
										</div>										
									</div>
									
									<div class="row">
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskStartDt" class="col-form-label col-sm-3 text-sm-end"><b>From</b></label>
												<div class="col-sm-8">
													<div class="input-group">
														<input id="fromDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" />
														<button id="btnClearFromDt" class="btn btn-secondary" type="button"><i class="fas fa-times"></i></button>
													</div>
												</div>  
											</div>
										</div>
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskEndDt" class="col-form-label col-sm-3 text-sm-end"><b>To</b></label>
												<div class="col-sm-8">
													<div class="input-group">
														<input id="toDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" />
														<button id="btnClearToDt" class="btn btn-secondary" type="button"><i class="fas fa-times"></i></button>
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
						<div class="col-md-12">
							<div class="card" >
								<div class="card-header">
									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 일일업무보고 수신 목록</h5>
								</div>
								<div class="card-body">
									<table id="taskTable" class="table table-striped" style="width:100%">
										<thead>
											<tr>
												<th>No</th>
												<th>상세</th>
												<th>업무명</th>
												<th>작성자</th>
												<th>보고대상자</th>
												<th>상태</th>
												<th>업무일자</th>
												<th>확인일자</th>
											</tr>
										</thead>
									</table>
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

<script>
let fpFromDt;
let fpToDt;
let dtReportTask;

$(function() {
	fnSetMenuSelection();
	fnSetComponent();
	fnSetEvent();
})

function fnSetMenuSelection() {
	gfnSelectMenu("reportTaskManage", "reportTaskSide", "recvReportTasks");
}

function fnSetComponent() {
	// Flatpickr
	fpFromDt = flatpickr("#fromDt", {
		dateFormat: "Y-m-d"
	});

	fpToDt = flatpickr("#toDt", {
		dateFormat: "Y-m-d"
	});

	fpFromDt.setDate(gfnGetCurYM() + "-01");
	
	// 그리드초기화 
	fnSetGrid();
}

function fnSetEvent() {
	$("#btnSearch").off("click").on("click", function (e) {
		e.preventDefault();
		fnReselGrid();
	});

	$("#btnClearFromDt").off("click").on("click", function (e) {
		e.preventDefault();
		fpFromDt.clear();
	});

	$("#btnClearToDt").off("click").on("click", function (e) {
		e.preventDefault();
		fpToDt.clear();
	});
	
	$("#taskTitle").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnReselGrid();
		}
	});
	
	$("#taskOnwerMemberNm").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnReselGrid();
		}
	});
}

// 일일 업무보고 수신 목록 그리드 재조회
function fnReselGrid() {
	dtReportTask.ajax.reload(function (json) {
		if (json.resultCode === "SUCCESS") {
			gfnSuccessAlert(gCmmnRptTaskRcv + gCmmnSM_List, 2000);
		}
		else {
			gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, 5000);
		}
	});
}

// 일일 업무보고 수신 목록 그리드 초기화 
function fnSetGrid() {
	dtReportTask = $("#taskTable").DataTable({
		ajax: {
			url : "/rest/user/reporttasks/recv/me",
            type : "POST",
			dataSrc : "data",
			data : function (d) {
		        d.taskTitle = $("#taskTitle").val();
		        d.taskStateCd = $("#taskStateCd").val();
		        d.taskOnwerMemberNm = $("#taskOnwerMemberNm").val();
		        d.fromDt = gfnNoFormatDate(fpFromDt.selectedDates); 
		        d.toDt = gfnNoFormatDate(fpToDt.selectedDates);
		    },
		    error : function (xhr, error, code) {
		    	gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, gDelay_Long);
			}
		},
		columns: [
			{
				data : 'taskId',
				className: 'text-center',
				width : "30px",
				render: function (data, type, row, meta) {
			        return meta.row + meta.settings._iDisplayStart + 1;
			    }
			},
       		{
   				data: 'taskId',
   				className: 'text-center',
   				width : "60px",
   				render: function(data) {
   					return '<button class="btn btn-info btn-sm" type="button" onclick="fnGoReportTaskDetail(' + "'" + data + "'" + ')"><i class="fas fa-search"> 상세</i></button>';
   				}
   			},
           	{data: 'taskTitle'},
           	{
               	data: 'taskOwnerMemberNm',
               	width : "140px"
            },
            {
   	   			data: 'taskEmpList[].empNm',
				width: '140px',
				render: function(data) {
					if(data.length == 0) return '';
					else if(data.length == 1) return data[0];
					return data[0] + '외 ' + (data.length-1) + '명';
				}
   	   		},
   			{
       			data: 'taskEmpNm',
       			width : "140px"
           	},
   			{
   				data: 'taskDt',
   				width : "120px",
   				render: function(data) {
   					if(data == null || data == '') return "";
   					else return gfnYmdFormat(data, "-");
   				}
   			},
   			{
   				data: 'taskEmpReviewDt',
   				width : "120px",
   				render: function(data) {
   					if(data == null || data == '') return "";
   					else return gfnYmdFormat(data, "-");
   				}
   			}     			
       	],	
		processing: true,
		serverSide: true,
		ordering : false,
       	destroy: true,
       	responsive: true,
       	info: true,
		select: false,
		searching: false,
		scrollY: '325',
		scrollCollapse : false,
		paging : true,
		searching : false,
		lengthChange : true,
		lengthMenu : [10, 50, 100, 500],
		loadBeforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", "true");
		},
        stateSave: false,
		initComplete: function () {
			gfnSuccessAlert(gCmmnRptTaskRcv + gCmmnSM_List, gDelay_Short);
            fnGetSeacrhCondition();
		}
	});
}

//업무 상세버튼 클릭시 이동
function fnGoReportTaskDetail(taskId) {
    fnSaveSearchCondition();
	let apiUrl = '/user/reporttasks/recvreporttaskupdateform';
	let params = new Object();
	params.pTaskId = taskId;
	fnPostMove(apiUrl, params);
}

// 검색조건 유지 (세션스토리지에서 저장했던 검색조건을 가지고옴)
function fnGetSeacrhCondition() {
    $("#taskTitle").val(sessionStorage.getItem("REPORT_TASK_TASK_TITLE"));

    let taskStateCd = sessionStorage.getItem("REPORT_TASK_TASK_STATE_CD")
    if (taskStateCd) {
        $("#taskStateCd").val(sessionStorage.getItem("REPORT_TASK_TASK_STATE_CD"));
    }
    else if (taskStateCd == "") {
        $("#taskStateCd").val(sessionStorage.getItem("REPORT_TASK_TASK_STATE_CD"));
    }

    $("#taskOnwerMemberNm").val(sessionStorage.getItem("REPORT_TASK_TASK_OWNER_NM"));
    let fromDt = sessionStorage.getItem("REPORT_TASK_FROM_DT");
    let toDt = sessionStorage.getItem("REPORT_TASK_TO_DT");
    if(fromDt) fpFromDt.setDate(gfnYmdFormat(fromDt, "-"));
    if(toDt) fpToDt.setDate(gfnYmdFormat(toDt, "-"));
    let curPage = sessionStorage.getItem("REPORT_TASK_CUR_PAGE");
    if(curPage) dtReportTask.page(Number(curPage)).draw('page');
    sessionStorage.clear();
}

//검색조건 세션스토리지에 저장
function fnSaveSearchCondition() {
    sessionStorage.setItem("REPORT_TASK_TASK_TITLE",$("#taskTitle").val());
    sessionStorage.setItem("REPORT_TASK_TASK_STATE_CD",$("#taskStateCd").val());
    sessionStorage.setItem("REPORT_TASK_TASK_OWNER_NM",$("#taskOnwerMemberNm").val());
    sessionStorage.setItem("REPORT_TASK_FROM_DT",gfnNoFormatDate(fpFromDt.selectedDates));
    sessionStorage.setItem("REPORT_TASK_TO_DT",gfnNoFormatDate(fpToDt.selectedDates));
    sessionStorage.setItem("REPORT_TASK_CUR_PAGE", dtReportTask.page.info().page);
}

</script>
</body>

</html>