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
						<h1 class="h3 d-inline align-middle"><b><i class="fas fa-list"></i> 태스크목록</b></h1>
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
												<label for="taskEmpNm" class="col-form-label col-sm-3 text-sm-end"><b>참여자</b></label>
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
						<div class="col-md-2">
							<div class="card" >
								<div class="card-header">
									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 라벨 목록</h5>
								</div>
								<div class="card-body" id="labelCardBody">
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
												<th>소유자</th>
												<th>권한</th>
												<th>라벨</th>
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

			<%@ include file="/WEB-INF/views/user/include/footer.jsp"%>
		</div>
		
		
	</div>

<%@ include file="/WEB-INF/views/user/include/script.jsp" %>

<script>
let dtTasks;
let dtLabels;
let gLabelId = '';
let fpTaskStartDt;
let fpTaskEndDt;

$(function() {
	fnSetMenuSelection();
	fnSetComponent();
})

function fnSetMenuSelection() {
	gfnSelectMenu("taskManage", "taskSide", "tasksform");
}

function fnSetComponent() {
	fpTaskStartDt = flatpickr("#taskStartDt", {
		dateFormat: "Y-m-d"
	});
	fpTaskEndDt = flatpickr("#taskEndDt", {
		dateFormat: "Y-m-d"
	});

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

    // 라벨 선택 이벤트
    dtLabels.on('select', function (e, dt, type, indexes) {
        if (type === 'row') {
            let data = dtLabels.rows(indexes).data().pluck('labelId');
            fnLabelSearch(data[0]);
        }
    });

    // 라벨 선택 해제 이벤트
    dtLabels.on('deselect', function (e, dt, type, indexes) {
        if (type === 'row') {
            let data = dtLabels.rows(indexes).data().pluck('labelId');
            fnLabelSearch('');
        }
    });

    fnGetSeacrhCondition();
}

//태스크목록 재조회
function fnReselGrid() {
    dtTasks.ajax.reload(function (json) {
        if (json.resultCode === "SUCCESS") {
            gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_List, gDelay_Short);
        }
        else {
            gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, gDelay_Long);
        }
    });
}

//업무목록 조회
function fnSetTasks(labelId) {
	dtTasks = $("#taskTable").DataTable({
		ajax: {
			url : "/rest/user/tasks/me",
            type : "POST",
			dataSrc : "data",
			data : function (d) {
				d.taskState = $("#taskState").val();
				d.taskNm = $("#taskNm").val();
				d.empNm = $("#empNm").val();
				d.taskEmpNm = $("#taskEmpNm").val();
				d.childTaskAddYn = $("#taskLevel").val();
				d.taskStartDt = gfnNoFormatDate(fpTaskStartDt.selectedDates); 
				d.taskEndDt = gfnNoFormatDate(fpTaskEndDt.selectedDates); 
				d.taskEmpCd = $("#taskEmpCd").val();
				d.labelId = gLabelId;
		    }, 
		    error : function (xhr, error, code) {
		    	gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, gDelay_Long);
			}
		},
       	columns: [
       		{
       		    title: '',
       		    target: 0,
       		    className: 'treegrid-control',
       		    data: function (item) {
       		        if (item.children) return '<span><i class="far fa-fw fa-plus-square"></i></span>';
       		        //else if(item.childYn == 'Y') return '<span><i class="fas fa-fw fa-angle-right"></i></span>';
       		        return '';
       		    },
       			width : "1%"
       		},
   			{
   				data: function (item) {
   					if(item.childYn == 'Y') return '<button class="btn btn-outline-info btn-sm" type="button" onclick="fnGoTaskDetail(' + item.taskId + ')"><i class="fas fa-search"> 상세</i></button>';
   					return '<button class="btn btn-info btn-sm" type="button" onclick="fnGoTaskDetail(' + item.taskId + ')"><i class="fas fa-search"> 상세</i></button>';
       		    },
   				className: 'text-center',
   				width : "9%",
   			},
            {data: 'taskTypeNm', width : "8%"},
            {data: 'taskState', width : "5%"},
   			{data: 'taskNm', width: "25%"},
            // {data: 'empCompanyNm', width : "8%"},
   			{data: 'empNm', width : "6%"},
   	   		// {
   	   		// 	data: 'taskEmpList[].empNm',
				// width: '10%',
				// render: function(data) {
				// 	if(data.length == 0) return '';
				// 	else if(data.length == 1) return data[0];
				// 	return data[0] + '외 ' + (data.length-1) + '명';
				// }
   	   		// },
   	   		{data: 'taskEmp', width : "60px"},
   			{data: 'label[].labelNm', width: '13%',
   				render: function(data) {
   					let drawLabel = '';
   					for(let i = 0; i < data.length; i++) {
   	   					let labelNm = gfnUnescapeHTML(data[i]);
   	   					if(labelNm == null) labelNm = '';
   						drawLabel += '<div class="badge bg-secondary" style="margin:1px;">' + labelNm +'</div>';
   					}
   					return drawLabel;
   					//return data;
   				}
   			},
   			{data: 'taskStartDt', width : "90px",
   				render: function(data) {
   					if(data == null || data == '') return "";
   					else return gfnYmdFormat(data, "-");
   				}
   			},
   			{data: 'taskEndDt', width : "90px",
   				render: function(data) {
   					if(data == null || data == '') return "";
   					else return gfnYmdFormat(data, "-");
   				}
   			},
   			/*
   			{
   				data: 'taskImportance',
   				width : "50px",
   				className: 'text-center',
   				render: function(data) {
   					let taskImportance = '';
   					if(data == '상') taskImportance = 'bg-danger';
   					else if(data == '중') taskImportance = 'bg-success';
   					else if(data == '하') taskImportance = 'bg-warning';
   					//return '<div class="badge '+ taskImportance + '">' + data +'</div>';
   					return data;
   				}
   			}
   			*/
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
		select: false,
		scrollY: '325',
		scrollCollapse : false,
		paging : true,
		searching: false,
		lengthChange : true,
		lengthMenu : [10, 50, 100, 500],
		loadBeforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", "true");
		},
		stateSave: false,
		stateLoadParams: function (settings, data) {
		},
		initComplete: function (settings, json) {
			gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_List, gDelay_Short);
            fnSetLabels();
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
	$("#taskEmpCd").val("");
}

//라벨 목록 조회
function fnSetLabels() {
	dtLabels = $("#labelTable").DataTable({
		ajax: {
			url : "/rest/user/labels/all",
            type : "POST",
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
		scrollY: '435',
		paging : false,
		lengthChange : false,
		searching: false,
		ordering: false,
		info: false,
		lengthMenu : [10, 50, 100, 500],
		loadBeforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", "true");
		},
		initComplete: function (settings, json) {
            fnSetEvent();
		}
 	});
	
	dtLabels.tables()
		.header()
	    .to$()
	    .css('display','none');
}

//라벨 검색(라벨목록에서 라벨 클릭)
function fnLabelSearch(labelId) {
	gLabelId = labelId;
    dtTasks.ajax.reload(function (json) {
        if (json.resultCode === "SUCCESS") {
            gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_List, gDelay_Short);
        }
        else {
            gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, gDelay_Long);
        }
    });
}

//업무 상세버튼 클릭시 이동
function fnGoTaskDetail(taskId) {
	fnSessionStorageSet();
	let apiUrl = '/user/tasks/taskdetailform';
	let params = new Object();
	params.taskId = taskId;
	fnPostMove(apiUrl, params);
}

// 검색조건 유지 (세션스토리지에서 저장했던 검색조건을 가지고옴)
function fnGetSeacrhCondition() {
    $("#taskState").val(sessionStorage.getItem("tasksTaskState"));
    $("#taskNm").val(sessionStorage.getItem("tasksTaskNm"));
    $("#empNm").val(sessionStorage.getItem("tasksEmpNm"));
    $("#taskEmpNm").val(sessionStorage.getItem("tasksTaskEmpNm"));
    $("#taskEmpCd").val(sessionStorage.getItem("tasksTaskEmpCd"));
    $("#taskLevel").val(sessionStorage.getItem("tasksTaskLevel"));
    let taskStartDt = sessionStorage.getItem("tasksTaskStartDt");
    let taskEndDt = sessionStorage.getItem("tasksTaskEndDt");
    if(taskStartDt) fpTaskStartDt.setDate(gfnYmdFormat(taskStartDt, "-"));
    if(taskEndDt) fpTaskEndDt.setDate(gfnYmdFormat(taskEndDt, "-"));

    gLabelId = sessionStorage.getItem("tasksLabelId");
    if (gLabelId) {
    	dtLabels.rows().every (function (rowIdx, tableLoop, rowLoop) {
   		  if (this.data().labelId === gLabelId) {
   		    this.select ();
   		  }
   	  });
    } else {
        gLabelId = "";
    }

    let curPage = sessionStorage.getItem("tasksPage");
    if(curPage) dtTasks.page(Number(curPage)).draw('page');

    sessionStorage.clear();
}

//검색조건 세션스토리지에 저장
function fnSessionStorageSet() {
	sessionStorage.setItem("tasksTaskState",$("#taskState").val());
	sessionStorage.setItem("tasksTaskNm",$("#taskNm").val());
	sessionStorage.setItem("tasksEmpNm",$("#empNm").val());
	sessionStorage.setItem("tasksTaskEmpNm",$("#taskEmpNm").val());
	sessionStorage.setItem("tasksTaskStartDt",gfnNoFormatDate(fpTaskStartDt.selectedDates));
	sessionStorage.setItem("tasksTaskEndDt",gfnNoFormatDate(fpTaskEndDt.selectedDates));
	sessionStorage.setItem("tasksTaskEmpCd",$("#taskEmpCd").val());
	sessionStorage.setItem("tasksTaskLevel",$("#taskLevel").val());
	sessionStorage.setItem("tasksLabelId",gLabelId);
	sessionStorage.setItem("tasksPage", dtTasks.page.info().page);
}

</script>
</body>

</html>