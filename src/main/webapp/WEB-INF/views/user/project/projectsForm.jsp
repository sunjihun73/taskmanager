<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="en">

<%@ include file="/WEB-INF/views/user/include/meta.jsp"%>

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
	<div class="wrapper">
		<%@ include file="/WEB-INF/views/user/include/sidebar.jsp"%>

		<div class="main">
			<%@ include file="/WEB-INF/views/user/include/header.jsp"%>
			<main class="content">
				<div class="container-fluid p-0">
					<div style="float:right;">
						<button id="btnSearch" class="btn btn-primary mt-n1"><i class="fas fa-search"></i> 조회</button>
						<a href="/user/projects/projectaddform" class="btn btn-success mt-n1"><i class="fas fa-plus"></i> 등록</a>
					</div>
					
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><b><i class="fas fa-list"></i> 프로젝트 목록</b></h1>
					</div>
					
					<div class="row">
						<div class="col-md-12">
                            <div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="projectStateCd" class="col-form-label col-sm-3 text-sm-end"><b>상태</b></label>
												<div class="col-sm-8">
													<select id="projectStateCd" class="form-select mb-2">
														<option selected value="">전체</option>
														<c:forEach var="item" items="${PROJECT_STATE_CD_LIST}">
															<option value="${item.code}">${item.codeNm}</option>
														</c:forEach>
													</select>
												</div>
											</div>
										</div>
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="projectNm" class="col-form-label col-sm-3 text-sm-end"><b>프로젝트명</b></label>
												<div class="col-sm-8">
													<input type="text" id="projectNm" class="form-control" autocomplete="off">
												</div>
											</div>
										</div>
                                        <div class="col-12 col-xl-3">
                                            <div class="row">
                                                <label for="projectStartDt" class="col-form-label col-sm-3 text-sm-end"><b>시작일</b></label>
                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <input id="projectStartDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" />
                                                        <button id="btnClearProjectStartDt" class="btn btn-secondary" type="button"><i class="fas fa-times"></i></button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-12 col-xl-3">
                                            <div class="row">
                                                <label for="projectEndDt" class="col-form-label col-sm-3 text-sm-end"><b>종료일</b></label>
                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <input id="projectEndDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" />
                                                        <button id="btnClearProjectEndDt" class="btn btn-secondary" type="button"><i class="fas fa-times"></i></button>
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
                            <div class="card" style="margin-bottom: 0 !important;">
								<div class="card-body">
									<table id="projectTable" class="table table-striped" style="width:100%">
										<thead>
											<tr>
												<th>상세</th>
												<th>상태</th>
												<th>프로젝트명</th>
												<th>소유자</th>
												<th>범주</th>
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
let dtProjects;
let fpProjectStartDt;
let fpProjectEndDt;

$(function() {
	fnSetMenuSelection();
	fnSetComponent();
})

function fnSetMenuSelection() {
	gfnSelectMenu("projectManage", "projectSide", "projectsform");
}

function fnSetComponent() {
    flatpickr.localize(flatpickr.l10ns.ko);

    fpProjectStartDt = flatpickr("#projectStartDt", {
        dateFormat: "Y-m-d"
    });

    fpProjectEndDt = flatpickr("#projectEndDt", {
        dateFormat: "Y-m-d"
    });

	fnSetProjects();
}

function fnSetEvent() {
    $("#btnSearch").off("click").on("click", function (e) {
        e.preventDefault();
        fnReselGrid();
    });

    $("#projectNm").keydown(function(e) {
        if (e.keyCode == 13) {
            e.preventDefault();
            fnReselGrid();
        }
    });

    $("#btnClearProjectStartDt").off("click").on("click", function (e) {
        e.preventDefault();
        fpProjectStartDt.clear();
    });

    $("#btnClearProjectEndDt").off("click").on("click", function (e) {
        e.preventDefault();
        fpProjectEndDt.clear();
    });

    fnGetSeacrhCondition();
}

// 프로젝트 목록 재조회
function fnReselGrid() {
    dtProjects.ajax.reload(function (json) {
        if (json.resultCode === "SUCCESS") {
            gfnSuccessAlert(gCmmnProjectNm + gCmmnSM_List, gDelay_Short);
        }
        else {
            gfnFailAlert(gCmmnProjectNm + gCmmnEM_ServiceError, gDelay_Long);
        }
    });
}

// 프로젝트 목록 조회
function fnSetProjects() {
    dtProjects = $("#projectTable").DataTable({
		ajax: {
			url : "/rest/user/projects/me",
            type : "POST",
			dataSrc : "data",
			data : function (d) {
				d.projectStateCd = $("#projectStateCd").val();
				d.projectNm = $("#projectNm").val();
				d.projectStartDt = gfnNoFormatDate(fpProjectStartDt.selectedDates);
				d.projectEndDt = gfnNoFormatDate(fpProjectEndDt.selectedDates);
		    },
		    error : function (xhr, error, code) {
		    	gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, gDelay_Long);
			}
		},
       	columns: [
   			{
   				data: function (item) {
   					return '<button class="btn btn-success btn-sm" type="button" onclick="fnGoProjectDetail(' + "'" + item.projectId + "'" + ')"><i class="fas fa-search"> </i></button>';
       		    },
   				className: 'text-center',
   				width : "8%",
   			},
            {
                data: function (item) {
                    if(item.projectStateCd == 'CM008CD001') {
                        return '<span class="badge bg-secondary">' + item.projectStateNm + '</span>';
                    }
                    else if (item.projectStateCd == 'CM008CD002') {
                        return '<span class="badge bg-primary">' + item.projectStateNm + '</span>';
                    }
                    else if (item.projectStateCd == 'CM008CD004') {
                        return '<span class="badge bg-info">' + item.projectStateNm + '</span>';
                    }
                    else if (item.projectStateCd == 'CM008CD003') {
                        return '<span class="badge bg-danger">' + item.projectStateNm + '</span>';
                    }
                    else {
                        return "";
                    }
                },
                className: 'text-center',
                width : "5%",
            },
   			{data: 'projectNm', width: "30%"},
   			{data: 'projectOwnerMemberNm', width : "10%"},
   			{data: 'projectCategoryNm', width : "12%"},
   			{data: 'projectStartDt', width : "10%",
   				render: function(data) {
   					if(data == null || data == '') return "";
   					else return gfnYmdFormat(data, "-");
   				}
   			},
   			{data: 'projectEndDt', width : "10%",
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
		scrollY: '420',
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
			gfnSuccessAlert(gCmmnProjectNm + gCmmnSM_List, gDelay_Short);
            fnSetEvent();
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

// 프로젝트 상세버튼 클릭시 이동
function fnGoProjectDetail(projectId) {
	fnSessionStorageSet();
	let apiUrl = '/user/projects/projectdetailform';
	let params = new Object();
	params.projectId = projectId;
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
    if(taskStartDt) fpProjectStartDt.setDate(gfnYmdFormat(taskStartDt, "-"));
    if(taskEndDt) fpProjectEndDt.setDate(gfnYmdFormat(taskEndDt, "-"));

    let curPage = sessionStorage.getItem("tasksPage");
    if(curPage) dtProjects.page(Number(curPage)).draw('page');

    sessionStorage.clear();
}

//검색조건 세션스토리지에 저장
function fnSessionStorageSet() {
	sessionStorage.setItem("tasksTaskState",$("#taskState").val());
	sessionStorage.setItem("tasksTaskNm",$("#taskNm").val());
	sessionStorage.setItem("tasksEmpNm",$("#empNm").val());
	sessionStorage.setItem("tasksTaskEmpNm",$("#taskEmpNm").val());
	sessionStorage.setItem("tasksTaskStartDt",gfnNoFormatDate(fpProjectStartDt.selectedDates));
	sessionStorage.setItem("tasksTaskEndDt",gfnNoFormatDate(fpProjectEndDt.selectedDates));
	sessionStorage.setItem("tasksTaskEmpCd",$("#taskEmpCd").val());
	sessionStorage.setItem("tasksTaskLevel",$("#taskLevel").val());
	sessionStorage.setItem("tasksPage", dtProjects.page.info().page);
}

</script>
</body>

</html>