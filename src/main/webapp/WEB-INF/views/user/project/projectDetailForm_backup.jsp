<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="en">

<%@ include file="/WEB-INF/views/user/include/meta.jsp"%>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<style>
    /* 컨테이너 크기 설정 */
    #workSpace {
        width: 98%;
        height: 500px;
        overflow: auto; /* 내용이 넘칠 때 스크롤바 표시 */
        border: 1px solid #ccc;
        margin: 10px auto;
    }
</style>

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
	<div class="wrapper">
		<%@ include file="/WEB-INF/views/user/include/sidebar.jsp"%>

		<div class="main">
			<%@ include file="/WEB-INF/views/user/include/header.jsp"%>
			<main class="content">
				<div class="container-fluid p-0">

                    <div style="float:right;">
                        <button class="btn btn-warning mt-n1" id="btnGoProjectList"><i class="fas fa-list"></i> 목록</button>
                    </div>

					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><b id="bProjectNm"><i class="fas fa-folder-open"></i> </b></h1>
					</div>
					
					<div class="row">
                        <div class="col-12">
                            <div class="tab" style="margin-bottom: 0 !important;">
                                <ul class="nav nav-tabs" role="tablist">
                                    <li class="nav-item"><a class="nav-link" href="#tab-0" data-bs-toggle="tab" role="tab">상세</a></li>
                                    <li class="nav-item"><a class="nav-link active" href="#tabTasks" data-bs-toggle="tab" role="tab">목록</a></li>
                                    <li class="nav-item"><a class="nav-link" href="#tab-2" data-bs-toggle="tab" role="tab">타임라인</a></li>
                                    <li class="nav-item"><a class="nav-link" href="#tab-3" data-bs-toggle="tab" role="tab">캘린더</a></li>
                                    <li class="nav-item"><a class="nav-link" href="#tabFiles" data-bs-toggle="tab" role="tab">첨부파일</a></li>
                                </ul>
                                <div class="tab-content">
                                    <div class="tab-pane" id="tab-0" role="tabpanel">
                                        <%-- //////////////// 탭 0 내용 (상세) /////////////// --%>
                                        <div class="row">
                                            <div class="col-12 col-xl-12">
                                                <div class="row">
                                                    <form id ="projectform">
                                                        <div class="mb-3 row">
                                                            <input type="hidden" id="hidDomainId"/>
                                                            <input type="hidden" id="hidCompanyCd"/>

                                                            <label for="projectNm" class="col-form-label col-sm-1 text-sm-end"><b>프로젝트명</b></label>
                                                            <div class="col-sm-9">
                                                                <input type="text" id="projectNm" class="form-control is-valid" required autocomplete="off">
                                                            </div>
                                                            <div class="col-sm-2">
                                                                <div class="row">
                                                                    <div style="float:right; display:none;" id="dvModButtonDiv">
                                                                        <button id="btnSaveProject" class="btn btn-info mt-n1"><i class="fas fa-save"></i> 저장</button>
                                                                        <button id="btnDeleteProject" class="btn btn-danger mt-n1"><i class="fas fa-trash"></i> 삭제</button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="mb-3 row">
                                                            <label for="projectStateCd" class="col-form-label col-sm-1 text-sm-end"><b>상태</b></label>
                                                            <div class="col-sm-2">
                                                                <select id="projectStateCd" class="form-select is-valid" required>
                                                                    <option selected value="">-선택-</option>
                                                                    <c:forEach var="item" items="${PROJECT_STATE_CD_LIST}">
                                                                        <option value="${item.code}">${item.codeNm}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </div>

                                                        <div class="mb-3 row">
                                                            <label for="projectDesc" class="col-form-label col-sm-1 text-sm-end"><b>설명</b></label>
                                                            <div class="col-sm-9">
                                                                <textarea id="projectDesc" class="form-control" style="min-height: 17rem;" ></textarea>
                                                            </div>
                                                        </div>

                                                        <div class="mb-3 row">
                                                            <label class="col-form-label col-sm-1 text-sm-end"><b>소유자</b></label>
                                                            <div id ="empAdd" class="col-sm-9">
                                                                <span id="empAddSpan"></span>
                                                                <button id="btnEmpAdd" type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#empAddModal" style="margin-top:4px;"><i class="far fa-fw fa-user"></i> 변경</button>
                                                            </div>
                                                        </div>

                                                        <div class="mb-3 row">
                                                            <label class="col-form-label col-sm-1 text-sm-end"><b>참여자</b></label>
                                                            <div id ="shareEmpAdd" class="col-sm-9">
                                                                <span id="shareEmpAddSpan"></span>
                                                                <button id="btnShareEmpAdd" type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#shareEmpAddModal" style="margin-top:4px;"><i class="far fa-fw fa-user"></i> 추가</button>
                                                            </div>
                                                        </div>

                                                        <div class="mb-3 row">
                                                            <label for="projectStartDt" class="col-form-label col-sm-1 text-sm-end"><b>시작일</b></label>
                                                            <div class="col-sm-2">
                                                                <input id="projectStartDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" autocomplete="off"/>
                                                            </div>
                                                        </div>
                                                        <div class="mb-3 row">
                                                            <label for="projectEndDt" class="col-form-label col-sm-1 text-sm-end"><b>종료일</b></label>
                                                            <div class="col-sm-2">
                                                                <input id="projectEndDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" autocomplete="off"/>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                        <%-- //////////////// 탭 0 내용 /////////////// --%>
                                    </div>
                                    <div class="tab-pane active" id="tabTasks" role="tabpanel">
                                        <%-- //////////////// 탭 1 (목록)내용 /////////////// --%>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="row" style="margin-bottom: 10px;">
                                                    <div class="col-12 col-xl-2">
                                                        <div class="row">
                                                            <label for="taskState" class="col-form-label col-sm-3 text-sm-end"><b>상태</b></label>
                                                            <div class="col-sm-8">
                                                                <select id="taskState" class="form-select mb-2">
                                                                    <option selected value="">전체</option>
                                                                    <c:forEach var="item" items="${TASK_STATE_CD_LIST}">
                                                                        <option value="${item.code}">${item.codeNm}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-xl-4">
                                                        <div class="row">
                                                            <label for="taskNm" class="col-form-label col-sm-3 text-sm-end"><b>업무명</b></label>
                                                            <div class="col-sm-8">
                                                                <input type="text" id="taskNm" class="form-control" autocomplete="off">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-xl-2">
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
                                                    <div class="col-12 col-xl-2">
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
                                                    <div class="col-12 col-xl-2">
                                                        <div class="row">
                                                            <div style="float:right;">
                                                                <button id="btnSearch" class="btn btn-primary mt-n1"><i class="fas fa-search"></i> 조회</button>
                                                                <button id="btnAddTask" class="btn btn-success mt-n1"><i class="fas fa-plus"></i> 등록</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <table id="taskTable" class="table table-striped" style="width:100%">
                                                        <thead>
                                                        <tr>
                                                            <th>구분</th>
                                                            <th>상세</th>
                                                            <th>유형</th>
                                                            <th>상태</th>
                                                            <th>업무명</th>
                                                            <th>소유자</th>
                                                            <th>시작일</th>
                                                            <th>종료일</th>
                                                        </tr>
                                                        </thead>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                        <%-- //////////////// 탭 1 내용 끝 /////////////// --%>
                                    </div>

                                    <div class="tab-pane" id="tab-2" role="tabpanel">
                                        <%-- //////////////// 탭 2 (타임라인) 내용 /////////////// --%>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="row" style="margin-bottom: 10px;">
                                                    <div class="col-12 col-xl-2">
                                                        <div class="row">
                                                            <label for="tab2TaskStateCd" class="col-form-label col-sm-3 text-sm-end"><b>상태</b></label>
                                                            <div class="col-sm-8">
                                                                <select id="tab2TaskStateCd" class="form-select mb-2">
                                                                    <option selected value="">전체</option>
                                                                    <c:forEach var="item" items="${TASK_STATE_CD_LIST}">
                                                                        <option value="${item.code}">${item.codeNm}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-xl-4">
                                                        <div class="row">
                                                            <label for="tab2TaskNm" class="col-form-label col-sm-3 text-sm-end"><b>업무명</b></label>
                                                            <div class="col-sm-8">
                                                                <input type="text" id="tab2TaskNm" class="form-control" autocomplete="off">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-xl-2">
                                                        <div class="row">
                                                            <label for="tab2TaskStartDt" class="col-form-label col-sm-3 text-sm-end"><b>시작일</b></label>
                                                            <div class="col-sm-8">
                                                                <div class="input-group">
                                                                    <input id="tab2TaskStartDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" />
                                                                    <button id="btnTab2ClearTaskStartDt" class="btn btn-secondary" type="button"><i class="fas fa-times"></i></button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-xl-2">
                                                        <div class="row">
                                                            <label for="tab2TaskEndDt" class="col-form-label col-sm-3 text-sm-end"><b>종료일</b></label>
                                                            <div class="col-sm-8">
                                                                <div class="input-group">
                                                                    <input id="tab2TaskEndDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" />
                                                                    <button id="btnTab2ClearTaskEndDt" class="btn btn-secondary" type="button"><i class="fas fa-times"></i></button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-xl-2">
                                                        <div class="row">
                                                            <div style="float:right;">
                                                                <button id="btnTab2Search" class="btn btn-primary mt-n1"><i class="fas fa-search"></i> 조회</button>
                                                                <button id="btnTab2AddTask" class="btn btn-success mt-n1"><i class="fas fa-plus"></i> 등록</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div style="max-height:555px; overflow-y:auto;">
                                                    <div id="tab2GanttChart"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <%-- //////////////// 탭 2 내용 끝 /////////////// --%>
                                    </div>
                                    <div class="tab-pane" id="tab-3" role="tabpanel">
                                        <%-- //////////////// 탭 3 (캘린더) 내용 /////////////// --%>
                                        <h4 class="tab-title">One more</h4>
                                        <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor tellus eget condimentum
                                            rhoncus. Aenean massa. Cum sociis natoque penatibus et magnis neque dis parturient montes, nascetur ridiculus mus.
                                        </p>
                                        <p>Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede
                                            justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae,
                                            justo.</p>
                                        <%-- //////////////// 탭 3 내용 끝 /////////////// --%>
                                    </div>
                                    <div class="tab-pane" id="tabFiles" role="tabpanel">
                                        <%-- //////////////// 탭 tabFiles 내용 /////////////// --%>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="row" style="margin-bottom: 10px;">
                                                    <div class="col-12 col-xl-10">
                                                        <div class="row">
                                                            <label for="fileDispNm" class="col-form-label col-sm-1 text-sm-end"><b>파일명</b></label>
                                                            <div class="col-sm-11">
                                                                <input type="text" id="fileDispNm" class="form-control" autocomplete="off">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-xl-2">
                                                        <div class="row">
                                                            <div style="float:right;">
                                                                <button id="btnFileSearch" class="btn btn-primary mt-n1"><i class="fas fa-search"></i> 조회</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <table id="filesTable" class="table table-striped" style="width:100%">
                                                        <thead>
                                                            <tr>
                                                                <th>다운로드</th>
                                                                <th>파일명</th>
                                                                <th>유형</th>
                                                                <th>업무명</th>
                                                                <th>FILE_ID</th>
                                                                <th>FILE_NM</th>
                                                                <th>생성일시</th>
                                                            </tr>
                                                        </thead>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                        <%-- //////////////// 탭 tabFiles 내용 /////////////// --%>
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

    <%--소유자 변경을 위한 모달 --%>
    <div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" style=" --bs-modal-width:1100px">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-angle-double-right"></i> 사용자 검색</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body m-3">
                    <div class="row">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-12 col-xl-4">
                                        <div class="row">
                                            <label for="empCompanyCd_Modal" class="col-form-label col-sm-3 text-sm-end"><b>회사</b></label>
                                            <div class="col-sm-8">
                                                <select id="empCompanyCd_Modal" class="form-select mb-2">
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-xl-4">
                                        <div class="row">
                                            <label for="empEmpNm_Modal" class="col-form-label col-sm-3 text-sm-end"><b>성명</b></label>
                                            <div class="col-sm-8">
                                                <div class="input-group">
                                                    <input type="text" id="empEmpNm_Modal" class="form-control">
                                                    <button class="btn btn-secondary" id="btnEmpNmSearch_Modal"><i class="fas fa-search"></i></button>
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
                                        <input type="text" id="empDeptNm_Modal" class="form-control" placeholder="부서명">
                                        <button class="btn btn-secondary" id="btnEmpDeptNmSearch_Modal"><i class="fas fa-search"></i></button>
                                    </div>
                                    <div id="treeDeptList_Modal" style="height:440px;overflow:auto;"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-xl-8">
                            <div class="card">
                                <div class="card-body">
                                    <table id="empAddTable_Modal" class="table table-striped" style="width:100%">
                                        <thead>
                                            <tr>
                                                <th>회사</th>
                                                <th>도메인ID</th>
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
                    <button type="button" id="btnEmpSelect_Modal" class="btn btn-vimeo">선택</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <%-- 참여자 추가 모달 --%>
    <div class="modal fade" id="shareEmpAddModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" style=" --bs-modal-width:1100px">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-angle-double-right"></i> 사용자 검색</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body m-3">
                    <div class="row">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-12 col-xl-4">
                                        <div class="row">
                                            <label for="shareEmpCompanyCd_Modal" class="col-form-label col-sm-3 text-sm-end"><b>회사</b></label>
                                            <div class="col-sm-8">
                                                <select id="shareEmpCompanyCd_Modal" class="form-select mb-2">
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-xl-4">
                                        <div class="row">
                                            <label for="shareEmpNm_Modal" class="col-form-label col-sm-3 text-sm-end"><b>성명</b></label>
                                            <div class="col-sm-8">
                                                <div class="input-group">
                                                    <input type="text" id="shareEmpNm_Modal" class="form-control">
                                                    <button class="btn btn-secondary" id="btnShareEmpNmSearch_Modal"><i class="fas fa-search"></i></button>
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
                                        <input type="text" id="shareEmpDeptNm_Modal" class="form-control" placeholder="부서명">
                                        <button class="btn btn-secondary" id="btnShareEmpDeptNmSearch_Modal"><i class="fas fa-search"></i></button>
                                    </div>
                                    <div id="shareEmpTreeDeptList_Modal" style="height:440px;overflow:auto;"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-xl-8">
                            <div class="card">
                                <div class="card-body">
                                    <table id="shareEmpAddTable_Modal" class="table table-striped" style="width:100%">
                                        <thead>
                                        <tr>
                                            <th>회사</th>
                                            <th>도메인ID</th>
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
                    <button type="button" id="btnShareEmpSelect_Modal" class="btn btn-vimeo">선택</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <form id="frmHiddenParam">
        <input type="hidden" id="pLoginEmail" name="pLoginEmail" value="<c:out value="${LOGIN_EMAIL}"/>"/>
        <input type="hidden" id="pProjectId" name="pProjectId" value="<c:out value="${PROJECT_ID}"/>"/>
        <input type="hidden" id="pDomainId" name="pDomainId" value="<c:out value="${DOMAIN_ID}"/>"/>
        <input type="hidden" id="pCompanyCd" name="pCompanyCd" value="<c:out value="${COMPANY_CD}"/>"/>
        <input type="hidden" id="pEmail" name="pEmail" value="<c:out value="${EMAIL}"/>"/>
        <input type="hidden" id="pEmpNm" name="pEmpNm" value="<c:out value="${empNm}"/>"/>
        <input type="hidden" id="pDeptCd" name="pDeptCd" value="<c:out value="${DEPT_CD}"/>"/>
    </form>

<%@ include file="/WEB-INF/views/user/include/script.jsp" %>

<script>
let dtTasks;
let dtEmpList;
let dtShareEmpList;
let dtFiles;
let fpTaskStartDt;
let fpTaskEndDt;
let fpProjectStartDt;
let fpProjectEndDt;
let shareEmpHeight = 0;
let shareEmpArr = new Array();
let empHeight = 0;
let empOwnerArr = new Array();
let gDeptCd = "";
let gShareDeptCd = "";
let isInitFilesTab = false;
let taskGanttChart;



$(function() {
	fnSetMenuSelection();
	fnSetComponent();
    fnSetEvent();
    fnSetData();
})

// ************************* 좌측 메뉴 선택 ******************************* //
function fnSetMenuSelection() {
    gfnSelectMenu("projectManage", "projectSide", "projectsform");
}
// ************************* 좌측 메뉴 선택 끝 **************************** //

// ************************* Component 초기화 ******************************* //
function fnSetComponent() {
    flatpickr.localize(flatpickr.l10ns.ko);

    fpProjectStartDt = flatpickr("#projectStartDt", {
		dateFormat: "Y-m-d"
	});

    fpProjectEndDt = flatpickr("#projectEndDt", {
		dateFormat: "Y-m-d"
	});

    fpTaskStartDt = flatpickr("#taskStartDt", {
        dateFormat: "Y-m-d"
    });

    fpTaskEndDt = flatpickr("#taskEndDt", {
        dateFormat: "Y-m-d"
    });

    // ====== 소유자 변경용 사용자 검색 컴포넌트 초기화 ====== //
    fnSetCompany_Modal();
    // ====== 소유자 변경용 사용자 검색 컴포넌트 초기화 끝. ====== //

    // ====== 참여자 추가용 사용자 검색 컴포넌트 초기화 ====== //
    fnSetShareEmpCompany_Modal();
    // ====== 참여자 추가용 사용자 검색 컴포넌트 초기화 끝. ====== //
}
// ************************* Component 초기화 끝 *************************** //

// ************************* Event 초기화  ******************************** //
function fnSetEvent() {

    $(window).on('resize', function(){
        if ($('#tab-2').is(':visible')) {
            fnDrawChart();
        }
    });

    // 목록 이동
    $("#btnGoProjectList").off("click").on("click", function (e) {
        e.preventDefault();
        location.href = "/user/projects/projectsform";
    });

    //////////////////////////상세 탭 이벤트 /////////////////////////////
    // PROJECT 저장
    $("#btnSaveProject").off("click").on("click", function (e) {
        e.preventDefault();
        fnSaveProject();
    });

    // 프로젝트 삭제
    $("#btnDeleteProject").off("click").on("click", function (e) {
        e.preventDefault();
        let msg = "해당 프로젝트를 삭제하시겠습니까?";
        let callback = fnDeleteProject;
        gfnInitWrnCfmMdlDialog(msg, callback);
    });

    // ========== 소유자 변경용 사용자 검색 팝업 이벤트 처리 ========= //
    // 소유자 변경용 사용자 검색 팝업 호출
    $("#btnEmpAdd").off("click").on("click", function (e) {
        e.preventDefault();
        setTimeout(fnOpenEmpModal_Modal, 500);
    });

    $("#empCompanyCd_Modal").change(function (e) {
        e.preventDefault();
        fnChangeCompany_Modal();
    });

    $("#btnEmpSelect_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnUpdateProjectOwnerEmp();
    });

    $("#empDeptNm_Modal").keydown(function(e) {
        if (e.keyCode == 13) {
            e.preventDefault();
            let searchString = $("#empDeptNm_Modal").val();
            $('#treeDeptList_Modal').jstree(true).search(searchString);
        }
    });

    $("#btnEmpDeptNmSearch_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        let searchString = $("#empDeptNm_Modal").val();
        $('#treeDeptList_Modal').jstree(true).search(searchString);
    });

    $("#empEmpNm_Modal").keydown(function(e) {
        if (e.keyCode == 13) {
            e.preventDefault();
            fnResetDeptSearch_Modal();
            fnReselEmpList_Modal();
        }
    });

    $("#btnEmpNmSearch_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnResetDeptSearch_Modal();
        fnReselEmpList_Modal();
    });
    // ========= 소유자 변경용 사용자 검색 팝업 이벤트 처리 끝.========= //

    // ========== 참여자 추가용 사용자 검색 팝업 이벤트 처리 ========= //
    // 참여자 추가용 사용자 검색 팝업 호출
    $("#btnShareEmpAdd").off("click").on("click", function (e) {
        e.preventDefault();
        setTimeout(fnOpenShareEmpModal_Modal, 500);
    });

    $("#shareEmpCompanyCd_Modal").change(function (e) {
        e.preventDefault();
        fnChangeShareEmpCompany_Modal();
    });

    $("#btnShareEmpSelect_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnSetProjectShareEmp_Modal();
    });

    $("#shareEmpDeptNm_Modal").keydown(function(e) {
        if (e.keyCode == 13) {
            e.preventDefault();
            let searchString = $("#shareEmpDeptNm_Modal").val();
            $('#shareEmpTreeDeptList_Modal').jstree(true).search(searchString);
        }
    });

    $("#btnShareEmpDeptNmSearch_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        let searchString = $("#shareEmpDeptNm_Modal").val();
        $('#shareEmpTreeDeptList_Modal').jstree(true).search(searchString);
    });

    $("#shareEmpNm_Modal").keydown(function(e) {
        if (e.keyCode == 13) {
            e.preventDefault();
            fnResetShareEmpDeptSearch_Modal();
            fnReselShareEmpList_Modal();
        }
    });

    $("#btnShareEmpNmSearch_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnResetShareEmpDeptSearch_Modal();
        fnReselShareEmpList_Modal();
    });
    // ======= 참여자 추가용 사용자 검색 팝업 이벤트 처리 끝.========== //
    //////////////////////////상세 탭 이벤트 끝/////////////////////////////

    //////////////////////////목록 탭 이벤트 /////////////////////////////
    $('a[href="#tabTasks"]').on('shown.bs.tab', function (e) {
        fnReselGrid();
    });

    $("#btnSearch").off("click").on("click", function (e) {
        e.preventDefault();
        fnReselGrid();
    });

    $("#btnAddTask").off("click").on("click", function (e) {
        e.preventDefault();
        fnGoAddTaskForm();
    });

    $("#taskNm").keydown(function(e) {
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
    //////////////////////////목록 탭 이벤트 끝/////////////////////////////

    //////////////////////////타임라인 탭 이벤트 ///////////////////////////////
    $('a[data-bs-toggle="tab"][href="#tab-2"]').on('shown.bs.tab', function () {
        // 구글 로드 완료 후 그리도록 보장
        if (google && google.charts && google.visualization) {
            fnSelectPrjTasks();
        } else {
            google.charts.setOnLoadCallback(fnSelectPrjTasks);
        }
    });
    //////////////////////////타임라인 탭 이벤트 끝/////////////////////////////


    //////////////////////////첨부파일 탭 이벤트 /////////////////////////////
    // 첨부파일 탭 활성화 시에 그리드를 생성한다.
    $('a[href="#tabFiles"]').on('shown.bs.tab', function (e) {
        fnInitFilesGrid();
    });
    //////////////////////////첨부파일 탭 이벤트 끝/////////////////////////////
}
// ************************* Event 초기화 끝 **************************** //

// ************************* 초기 데이터 조회 **************************** //
function fnSetData() {
    fnGetProject();
    fnInitTasksGrid();
    google.charts.load('current', {'packages':['gantt']});
}
// ************************* 초기 데이터 조회 끝 **************************** //

//*****************************상세 탭 처리 ******************************** //
// 소유자 여부에 따른 화면 처리
function fnSetScreenAuth(projectData) {
    let loginEmail = $("#pLoginEmail").val();
    //로그인한 사용자와 소유자가 같으면 버튼 표시
    if(loginEmail == projectData.projectOwnerMemberId) {
        $("#dvModButtonDiv").show();
        // form 내부의 컴포넌트를 수정 가능하도록 설정
        $("#projectform input, #projectform textarea").prop("readonly", false);
        $("#projectform select, #projectform button").prop("disabled", false);
        // flatpickr 활성화
        $("#projectStartDt, #projectEndDt").prop("disabled", false);
        fpProjectStartDt._input.disabled = false;
        fpProjectEndDt._input.disabled = false;
        // 소유자 변경, 참여자 추가 버튼 표시
        $("#btnEmpAdd").show();
        $("#btnShareEmpAdd").show();
    }
    else {
        $("#dvModButtonDiv").hide();
        // form 내부의 모든 컴포넌트를 읽기 전용으로 설정
        $("#projectform input, #projectform textarea").prop("readonly", true);
        $("#projectform select, #projectform button").prop("disabled", true);
        // flatpickr 비활성화
        $("#projectStartDt, #projectEndDt").prop("disabled", true);
        fpProjectStartDt._input.disabled = true;
        fpProjectEndDt._input.disabled = true;
        // 소유자 변경, 참여자 추가 버튼 숨김
        $("#btnEmpAdd").hide();
        $("#btnShareEmpAdd").hide();
    }
}

// 프로젝트 정보 조회
function fnGetProject() {
    let projectId = $('#pProjectId').val();
    let apiUrl = '/rest/user/projects/' + projectId;
    gfnShowLoadingBar();

    $.ajax({
        url: apiUrl,
        type: 'GET',
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        if (data.resultCode == "SUCCESS") {
            $("#bProjectNm").html("<i class='fas fa-folder-open'></i> 프로젝트 : " + data.dataOne.projectNm);
            $("#hidDomainId").val(data.dataOne.domainId);
            $("#hidCompanyCd").val(data.dataOne.companyCd);
            $("#projectNm").val(data.dataOne.projectNm);
            $("#projectDesc").val(data.dataOne.projectDesc);
            $("#projectStateCd").val(data.dataOne.projectStateCd);
            fpProjectStartDt.setDate(gfnYmdFormat(data.dataOne.projectStartDt, "-"));
            fpProjectEndDt.setDate(gfnYmdFormat(data.dataOne.projectEndDt, "-"));

            // 소유자와 참여자 정보를 초기화하고 다시 설정
            $('#empAddSpan').empty();
            empOwnerArr.length = 0;
            empHeight = 0;

            $('#shareEmpAddSpan').empty();
            shareEmpArr.length = 0;
            shareEmpHeight = 0;

            fnSetProjectOwnerEmp(data.dataOne);
            fnSetShareEmp(data.dataOne.shareEmpList);

            // 화면 권한 처리
            fnSetScreenAuth(data.dataOne);
            gfnSuccessAlert(gCmmnProjectNm + gCmmnSM_One, gDelay_Short);
        }
        else {
            gfnFailAlert(gCmmnProjectNm + gCmmnEM_ServiceError, gDelay_Long);
        }
    }).fail(function(request, status, error) {
        let errMsg = JSON.parse(request.responseText).code;
        if(errMsg == "UNAUTHORIZED_ACCESS") {
            gfnFailAlert(gCmmnSM_UNAUTHORIZED_ACCESS, gDelay_Long);
            return;
        }
        else if(errMsg == "NOT_EXIST_TASK"){
            gfnFailAlert(gCmmnSM_NOT_EXIT_TASK, gDelay_Long);
            return;
        }
        gfnFailAlert(gCmmnProjectNm + gCmmnEM_ServiceError, gDelay_Long);
    }).always(function(msg) {
        gfnHideLoadingBar();
    });
}

// 프로젝트 저장
function fnSaveProject() {
    // 필수값 체크
    if (!gfnCheckRequired($("#projectform"))) {
        return;
    }

    // 프로젝트 소유자 이메일 체크
    if (!empOwnerArr || empOwnerArr.length === 0 || !empOwnerArr[0] || !empOwnerArr[0].email) {
        gfnFailAlert("프로젝트 소유자를 지정해주세요.", gDelay_Long);
        return;
    }

    let projectId = $('#pProjectId').val();
    let params = new Object();
    params.projectNm = $("#projectNm").val();
    params.projectStateCd = $("#projectStateCd").val();
    params.projectDesc = $("#projectDesc").val();

    if($("#projectStartDt").val() != '') params.projectStartDt = gfnNoFormatDate($("#projectStartDt").val());
    if($("#projectEndDt").val() != '') params.projectEndDt = gfnNoFormatDate($("#projectEndDt").val());
    if($("#projectStartDt").val() != '' && $("#projectEndDt").val() != '' && $("#projectStartDt").val() > $("#projectEndDt").val()) {
        gfnFailAlert("시작일이 종료일보다 이전이어야 합니다.", gDelay_Long);
        return false;
    }

    // 프로젝트 오너 관련 정보
    params.projectOwnerMemberId = empOwnerArr[0].email;
    params.domainId = empOwnerArr[0].domainId;
    params.companyCd = empOwnerArr[0].companyCd;

    // 참여자 정보
    for(let i = 0; i < shareEmpArr.length; i++) {
        params['shareEmpList[' + i +'].email'] = shareEmpArr[i].email;
        params['shareEmpList[' + i +'].companyCd'] = shareEmpArr[i].companyCd;
        params['shareEmpList[' + i +'].projectEmpCd'] = shareEmpArr[i].projectEmpCd;
    }

    gfnShowLoadingBar();
    $.ajax({
        type:'PUT',
        url:'/rest/user/projects/' + projectId,
        data: params,
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        if (data.resultCode == "SUCCESS") {
            gfnSuccessAlert(gCmmnProjectNm + gCmmnSM_Update, gDelay_Short);
            fnGetProject();
        }
        else {
            gfnFailAlert(gCmmnProjectNm + gCmmnEM_ServiceError, gDelay_Long);
        }
    }).fail(function(request, status, error) {
        gfnFailAlert(gCmmnProjectNm + gCmmnEM_ServiceError, gDelay_Long);
    }).always(function(msg) {
        gfnHideLoadingBar();
    });
}

// 프로젝트 삭제
function fnDeleteProject() {
    let projectId = $('#pProjectId').val();
    gfnShowLoadingBar();
    $.ajax({
        type:'PATCH',
        url:'/rest/user/projects/' + projectId,
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        if (data.resultCode == "SUCCESS") {
            gfnSuccessAlert(gCmmnProjectNm + gCmmnSM_Delete, gDelay_Short);
            location.href = "/user/projects/projectsform";
        }
        else {
            gfnFailAlert(gCmmnProjectNm + gCmmnEM_ServiceError, gDelay_Long);
        }
    }).fail(function(request, status, error) {
        gfnFailAlert(gCmmnProjectNm + gCmmnEM_ServiceError, gDelay_Long);
    }).always(function(msg) {
        gfnHideLoadingBar();
    });
}

// 프로젝트 상세 - 초기 소유자 Set
function fnSetProjectOwnerEmp(data) {
    let domainId = data.domainId;
    let companyCd = data.companyCd;
    let email = data.projectOwnerMemberId;
    let empNm = data.projectOwnerMemberNm;
    let buttonStyle = 'vimeo';
    let num = empHeight;
    let htmlData = '';
    htmlData += '<div class="btn-group me-2" id="empAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
    htmlData += '<button id="btnEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ empNm + '</button>';
    htmlData += '<input type="text" id="empAddEmail' + num + '" value="'+ email +'" hidden>';
    htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteEmpTask(' + num + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
    htmlData += '</div>';

    $('#empAddSpan').append(htmlData);

    empOwnerArr.push({
        email: email,
        domainId: domainId,
        companyCd: companyCd
    });

    empHeight += 1;
}

// 프로젝트 상세 - 초기 참여자 Set
function fnSetShareEmp(shareEmpList) {
    for(let i = 0; i < shareEmpList.length; i++) {
        let num = shareEmpHeight + i;
        let htmlData = '';
        let buttonStyle = 'facebook';

        htmlData += '<div class="btn-group me-2" id="shareEmpAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
        htmlData += '<button id="btnShareEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ gfnUnescapeHTML(shareEmpList[i].empNm) + '</button>';
        htmlData += '<input type="text" id="shareEmpAddEmail' + num + '" value="'+ shareEmpList[i].email +'" hidden>';
        htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteShareEmpTask(' + num + ')">';
        htmlData += '<i class="fas fa-times"></i>';
        htmlData += '</button>';
        htmlData += '</div>';

        $('#shareEmpAddSpan').append(htmlData);
        shareEmpArr.push({
            email: shareEmpList[i].email,
            companyCd: shareEmpList[i].companyCd,
            projectEmpCd: shareEmpList[i].projectEmpCd,
            empNm: shareEmpList[i].empNm
        });
    }
    shareEmpHeight += shareEmpList.length;
}

// 참여자 삭제
function fnDeleteShareEmpTask(num) {
    for(let i = 0; i < shareEmpArr.length; i++) {
        let email = $('#shareEmpAddEmail'+num).val();
        if(shareEmpArr[i].email == email) {
            shareEmpArr.splice(i, 1);
        }
    }
    $("#shareEmpAddGroup" + num).remove();
}

// 소유자 삭제
function fnDeleteEmpTask(num) {
    for(let i = 0; i < empOwnerArr.length; i++) {
        let email = $('#empAddEmail'+num).val();
        if(empOwnerArr[i].email == email) {
            empOwnerArr.splice(i, 1);
        }
    }
    $("#empAddGroup" + num).remove();
}

////////////////////// 소유자 변경용 사용자 검색 팝업 처리 //////////////////////
// 소유자 변경을 위한 modal Open시 초기 처리
function fnOpenEmpModal_Modal() {
    $("#empCompanyCd_Modal option:eq(0)").prop("selected", true);
    fnResetEmpAdd_Modal();
    fnReselTree_Modal();
    fnLoadEmpList_Modal();
}

// 사용자 검색 팝업의 회사목록 조회
function fnSetCompany_Modal() {
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
            $('#empCompanyCd_Modal').append(option);
        });
        fnInitTree_Modal();
    });
}

// 사용자 검색 팝업의 사용자목록 재조회
function fnReselEmpList_Modal() {
    dtEmpList.ajax.reload();
}

// 사용자 검색 팝업의 사용자목록 조회
function fnLoadEmpList_Modal() {
    let apiUrl = '/rest/user/employees/all';

    dtEmpList = $("#empAddTable_Modal").DataTable({
        ajax: {
            url : apiUrl,
            dataSrc : "data",
            data : function (d) {
                d.companyCd = $("#empCompanyCd_Modal").val();
                d.deptCd = gDeptCd;
                d.empNm = $("#empEmpNm_Modal").val();
            }
        },
        columns: [
            {data: 'companyNm', visible: false},
            {data: 'domainId', visible: true},
            {data: 'companyCd', visible: false},
            {data: 'empNm', width : "18%"},
            {data: 'posNm', width : "15%"},
            {data: 'deptNm', width : "120px"},
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
            style: 'single'
        },
        loadBeforeSend: function(jqXHR) {
            jqXHR.setRequestHeader("AJAX", "true");
        }
    });
    gDeptCd = '';
}

// 사용자검색 팝업의 부서트리 생성
function fnInitTree_Modal() {
    let apiUrl = "/rest/user/depts";
    let params = new Object();
    params.companyCd = $("#empCompanyCd_Modal").val();

    let deptList = new Array();
    $.ajax({
        type:'get',
        url:apiUrl,
        data: params,
        dataType:'json',
        success: function(data) {
            $.each(data, function(idx, item){
                if(item.parentDeptCd == '0') deptList[idx] = {id:item.deptCd, parent:'#', text:item.deptNm, icon:'/adminkit/common/common/images/company.png'};
                else deptList[idx] = {id:item.deptCd, parent:item.parentDeptCd, text:item.deptNm};
            });
            $('#treeDeptList_Modal').jstree({
                'core': {
                    'data': deptList
                },
                'types': {
                    'default': {
                        'icon': '/adminkit/common/common/images/dept.png'
                    }
                },
                'plugins' : ["search", "types"]
            })
                .bind('load_all.jstree', function(event, data){
                    $('#treeDeptList_Modal').jstree(true).select_node($("#pDeptCd").val());
                })
                // 노드 선택시 발생하는 이벤트
                .bind('select_node.jstree', function(event, data){
                    $("#empEmpNm_Modal").val("");
                    gDeptCd = data.instance.get_node(data.selected).id;
                    fnReselEmpList_Modal();
                });
        },
        error:function (data) {
        }
    });
}

//부서트리 검색 초기화
function fnResetDeptSearch_Modal() {
    gDeptCd = '';
    $("#empDeptNm_Modal").val("");
    $("#treeDeptList_Modal").jstree("deselect_all");
    $("#treeDeptList_Modal").jstree(true).clear_search()
}

//회사 select box 변경
function fnChangeCompany_Modal() {
    fnResetEmpAdd_Modal();
    fnReselTree_Modal();
    fnReselEmpList_Modal();
}

//트리 재조회
function fnReselTree_Modal() {
    let apiUrl = "/rest/user/depts";
    let params = new Object();
    params.companyCd = $("#empCompanyCd_Modal").val();
    let deptList = new Array();
    $.ajax({
        type:'get',
        url:apiUrl,
        data: params,
        dataType:'json',
        success: function(data) {
            $.each(data, function(idx, item){
                if(item.parentDeptCd == '0') deptList[idx] = {id:item.deptCd, parent:'#', text:item.deptNm, icon:'/adminkit/common/common/images/company.png'};
                else deptList[idx] = {id:item.deptCd, parent:item.parentDeptCd, text:item.deptNm};
            });
            $('#treeDeptList_Modal').jstree(true).settings.core.data = deptList;
            $('#treeDeptList_Modal').jstree(true).refresh();
            $('#treeDeptList_Modal').bind("refresh.jstree", function(e,d) {
                $('#treeDeptList_Modal').jstree(true).select_node($("#pDeptCd").val());
            }.bind(this));
        }
    });
}

//사용자팝업 초기화
function fnResetEmpAdd_Modal() {
    $("#empEmpNm_Modal").val("");
    fnResetDeptSearch_Modal();
    $('#empAddTable_Modal').DataTable().rows('.selected').deselect();
}

// 사용자검색 팝업에서 선택한 사용자를 소유자 항목에 셋팅
function fnUpdateProjectOwnerEmp() {
    $('#empAddModal').modal('hide');
    let buttonStyle = 'vimeo';
    let len = $('#empAddTable_Modal').DataTable().rows('.selected').data().length;
    $('#empAddSpan').empty();
    empOwnerArr.length = 0;

    for(let i = 0; i < len; i++) {
        let data = $('#empAddTable_Modal').DataTable().rows('.selected').data()[i];

        if(empOwnerArr.some(v => v.email === data.email)) {
            gfnFailAlert("이미 추가된 참여자가 존재합니다.", 5000);
            continue;
        }

        let num = empHeight + i;
        let htmlData = '';
        htmlData += '<div class="btn-group me-2" id="empAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
        htmlData += '<button id="btnEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ data.empNm + '</button>';
        htmlData += '<input type="text" id="empAddEmail' + num + '" value="'+ data.email +'" hidden>';
        htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteEmpTask(' + num + ')">';
        htmlData += '<i class="fas fa-times"></i>';
        htmlData += '</button>';
        htmlData += '</div>';

        $('#empAddSpan').append(htmlData);
        console.log(data.email);
        console.log(data.domainId);
        console.log(data.companyCd);

        empOwnerArr.push({
            email: data.email,
            domainId : data.domainId,
            companyCd: data.companyCd
        });
    }

    empHeight += len;
    fnResetEmpAdd_Modal();
}
/////////////////// 소유자 변경용 사용자 검색 팝업 처리 끝 ////////////////////

////////////////////// 참여자 추가용 사용자 검색 팝업 처리 //////////////////////
// 참여자 추가 modal Open시 초기 처리
function fnOpenShareEmpModal_Modal() {
    $("#shareEmpCompanyCd_Modal option:eq(0)").prop("selected", true);
    fnResetShareEmpAdd_Modal();
    fnReselShareEmpTree_Modal();
    fnLoadShareEmpList_Modal();
}

// 참여자 추가 사용자팝업 초기화
function fnResetShareEmpAdd_Modal() {
    $("#shareEmpNm_Modal").val("");
    fnResetShareEmpDeptSearch_Modal();
    $('#shareEmpAddTable_Modal').DataTable().rows('.selected').deselect();
}

// 참여자 추가 부서트리 검색 초기화
function fnResetShareEmpDeptSearch_Modal() {
    gShareDeptCd = '';
    $("#shareEmpDeptNm_Modal").val("");
    $("#shareEmpTreeDeptList_Modal").jstree("deselect_all");
    $("#shareEmpTreeDeptList_Modal").jstree(true).clear_search()
}

// 참여자 추가 사용자 검색 팝업의 회사목록 조회
function fnSetShareEmpCompany_Modal() {
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
            $('#shareEmpCompanyCd_Modal').append(option);
        });
        fnShareEmpInitTree_Modal();
    });
}

// 참여자 추가 사용자 검색 팝업의 사용자목록 재조회
function fnReselShareEmpList_Modal() {
    dtShareEmpList.ajax.reload();
}

// 참여자 추가 사용자 검색 팝업의 사용자목록 조회
function fnLoadShareEmpList_Modal() {
    let apiUrl = '/rest/user/employees/all';

    dtShareEmpList = $("#shareEmpAddTable_Modal").DataTable({
        ajax: {
            url : apiUrl,
            dataSrc : "data",
            data : function (d) {
                d.companyCd = $("#shareEmpCompanyCd_Modal").val();
                d.deptCd = gShareDeptCd;
                d.empNm = $("#shareEmpNm_Modal").val();
            }
        },
        columns: [
            {data: 'companyNm', visible: false},
            {data: 'domainId', visible: false},
            {data: 'companyCd', visible: false},
            {data: 'empNm', width : "18%"},
            {data: 'posNm', width : "15%"},
            {data: 'deptNm', width : "120px"},
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
        }
    });
    gShareDeptCd = '';
}

// 참여자 추가 사용자검색 팝업의 부서트리 생성
function fnShareEmpInitTree_Modal() {
    let apiUrl = "/rest/user/depts";
    let params = new Object();
    params.companyCd = $("#shareEmpCompanyCd_Modal").val();

    let deptList = new Array();
    $.ajax({
        type:'get',
        url:apiUrl,
        data: params,
        dataType:'json',
        success: function(data) {
            $.each(data, function(idx, item){
                if(item.parentDeptCd == '0') deptList[idx] = {id:item.deptCd, parent:'#', text:item.deptNm, icon:'/adminkit/common/common/images/company.png'};
                else deptList[idx] = {id:item.deptCd, parent:item.parentDeptCd, text:item.deptNm};
            });
            $('#shareEmpTreeDeptList_Modal').jstree({
                'core': {
                    'data': deptList
                },
                'types': {
                    'default': {
                        'icon': '/adminkit/common/common/images/dept.png'
                    }
                },
                'plugins' : ["search", "types"]
            })
                .bind('load_all.jstree', function(event, data){
                    $('#shareEmpTreeDeptList_Modal').jstree(true).select_node($("#pDeptCd").val());
                })
                // 노드 선택시 발생하는 이벤트
                .bind('select_node.jstree', function(event, data){
                    $("#shareEmpNm_Modal").val("");
                    gShareDeptCd = data.instance.get_node(data.selected).id;
                    fnReselShareEmpList_Modal();
                });
        },
        error:function (data) {
        }
    });
}

// 참여자 추가 트리 재조회
function fnReselShareEmpTree_Modal() {
    let apiUrl = "/rest/user/depts";
    let params = new Object();
    params.companyCd = $("#shareEmpCompanyCd_Modal").val();
    let deptList = new Array();
    $.ajax({
        type:'get',
        url:apiUrl,
        data: params,
        dataType:'json',
        success: function(data) {
            $.each(data, function(idx, item){
                if(item.parentDeptCd == '0') deptList[idx] = {id:item.deptCd, parent:'#', text:item.deptNm, icon:'/adminkit/common/common/images/company.png'};
                else deptList[idx] = {id:item.deptCd, parent:item.parentDeptCd, text:item.deptNm};
            });
            $('#shareEmpTreeDeptList_Modal').jstree(true).settings.core.data = deptList;
            $('#shareEmpTreeDeptList_Modal').jstree(true).refresh();
            $('#shareEmpTreeDeptList_Modal').bind("refresh.jstree", function(e,d) {
                $('#shareEmpTreeDeptList_Modal').jstree(true).select_node($("#pDeptCd").val());
            }.bind(this));
        }
    });
}

// 참여자 추가 회사 select box 변경
function fnChangeShareEmpCompany_Modal() {
    fnResetShareEmpAdd_Modal();
    fnReselShareEmpTree_Modal();
    fnReselShareEmpList_Modal();
}

// 참여자추가 팝업에서 선택한 사용자 화면에 Set
function fnSetProjectShareEmp_Modal() {
    $('#shareEmpAddModal').modal('hide');
    let buttonStyle = 'facebook';
    let len = $('#shareEmpAddTable_Modal').DataTable().rows('.selected').data().length;

    for(let i = 0; i < len; i++) {
        let data = $('#shareEmpAddTable_Modal').DataTable().rows('.selected').data()[i];

        if(shareEmpArr.some(v => v.email === data.email)) {
            gfnFailAlert("이미 추가한 사용자입니다.", gDelay_Long);
            continue;
        }

        let num = shareEmpHeight+i;
        let htmlData = '';
        htmlData += '<div class="btn-group me-2" id="shareEmpAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
        htmlData += '<button id="btnShareEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ data.empNm + '</button>';
        htmlData += '<input type="text" id="shareEmpAddEmail' + num + '" value="'+ data.email +'" hidden>';
        htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteShareEmpTask(' + num + ')">';
        htmlData += '<i class="fas fa-times"></i>';
        htmlData += '</button>';
        htmlData += '</div>';

        $('#shareEmpAddSpan').append(htmlData);
        shareEmpArr.push({
            email: data.email,
            companyCd: data.companyCd,
            projectEmpCd: "CM004CD002",
            empNm: data.empNm
        });
    }

    shareEmpHeight += len;
    fnResetShareEmpAdd_Modal();
}
/////////////////// 참여자 추가용 사용자 검색 팝업 처리 끝 ////////////////////
//*****************************상세 탭 처리 끝 ***************************** //

//*****************************목록 탭 처리 ******************************* //
// 등록버튼 클릭시 이동
function fnGoAddTaskForm() {
    let projectId = $("#pProjectId").val();
    let apiUrl = '/user/tasks/taskaddform';
    let params = new Object();
    params.projectId = projectId;
    fnPostMove(apiUrl, params);
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

// 프로젝트의 태스크 목록 조회
function fnInitTasksGrid() {
    let projectId = $('#pProjectId').val();
	dtTasks = $("#taskTable").DataTable({
		ajax: {
			url : "/rest/user/tasks/projects/" + projectId,
            type : "POST",
			dataSrc : "data",
			data : function (d) {
				d.taskState = $("#taskState").val();
				d.taskNm = $("#taskNm").val();
				d.taskStartDt = gfnNoFormatDate(fpTaskStartDt.selectedDates);
				d.taskEndDt = gfnNoFormatDate(fpTaskEndDt.selectedDates); 
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
       		        if (item.children && item.children.length > 0) {
       		        	return '<span><i class="far fa-fw fa-plus-square"></i></span>';
       		        }
       		        return '';
       		    },
       			width : "5%"
       		},
   			{
   				data: function (item) {
   					if(item.level != '1') {
   						return '<button class="btn btn-outline-info btn-sm" type="button" onclick="fnGoTaskDetail(' + item.taskId + ')"><i class="fas fa-search"> </i></button>';
   					}
                    else {
   					    return '<button class="btn btn-info btn-sm" type="button" onclick="fnGoTaskDetail(' + item.taskId + ')"><i class="fas fa-search"> </i></button>';
                    }
       		    },
   				className: 'text-center',
   				width : "5%",
   			},
            {data: 'taskTypeNm', width : "8%", defaultContent: ''},
            {
                data: function (item) {
                    if(item.taskStateCd == 'CM001CD001') {
                        return '<span class="badge bg-secondary">' + item.taskState + '</span>';
                    }
                    else if (item.taskStateCd == 'CM001CD002') {
                        return '<span class="badge bg-primary">' + item.taskState + '</span>';
                    }
                    else if (item.taskStateCd == 'CM001CD004') {
                        return '<span class="badge bg-info">' + item.taskState + '</span>';
                    }
                    else if (item.taskStateCd == 'CM001CD003') {
                        return '<span class="badge bg-danger">' + item.taskState + '</span>';
                    }
                    else {
                        return "";
                    }
                },
                className: 'text-center',
                width : "5%",
            },
   			{data: 'taskNm', width: "35%", defaultContent: ''},
   			{data: 'taskOwnerMemberNm', width : "8%", defaultContent: ''},
   			{data: 'taskStartDt', width : "10%", defaultContent: '',
   				render: function(data) {
   					if(data == null || data == '') return "";
   					else return gfnYmdFormat(data, "-");
   				}
   			},
   			{data: 'taskEndDt', width : "10%", defaultContent: '',
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
            expandAll: false
        },
       	processing: true,
		serverSide: true,
		ordering : false,
       	destroy: true,
       	responsive: true,
       	info: true,
		select: false,
		scrollY: '440',
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
            // fnSetEvent();
		}
 	});
}

// 태스크 상세버튼 클릭시 이동
function fnGoTaskDetail(taskId) {
    fnSessionStorageSet();
    let projectId = $("#pProjectId").val();
    let apiUrl = '/user/tasks/taskdetailform';
    let params = new Object();
    params.projectId = projectId;
    params.taskId = taskId;
    fnPostMove(apiUrl, params);
}
//*****************************목록 탭 처리 끝 ***************************** //

//*****************************타임라인 탭 처리 ******************************* //
// 타임라인(간트차트) 초기화
function fnSelectPrjTasks() {
    let projectId = $('#pProjectId').val();
    let apiUrl = "/rest/user/tasks/tree/projects/" + projectId;
    let params = new Object();

    params.taskState = $("#taskState").val();
    params.taskNm = $("#taskNm").val();
    params.taskStartDt = gfnNoFormatDate(fpTaskStartDt.selectedDates);
    params.taskEndDt = gfnNoFormatDate(fpTaskEndDt.selectedDates);

    gfnShowLoadingBar();

    $.ajax({
        type:'POST',
        url: apiUrl,
        data: params,
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        if (data.resultCode == "SUCCESS") {
            console.log(data.data);
            fnDrawChart(data.data);
            gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_List, 2000);
        }
        else {
            gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, 5000);
        }
    }).fail(function(request, status, error) {
        gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, 5000);
    }).always(function(msg) {
        gfnHideLoadingBar();
    });
}

function fnDrawChart(chartData) {
    try {
        let data = new google.visualization.DataTable();
        data.addColumn('string', 'Task ID');
        data.addColumn('string', 'Task Name');
        data.addColumn('string', 'Resource');
        data.addColumn('date', 'Start Date');
        data.addColumn('date', 'End Date');
        data.addColumn('number', 'Duration');
        data.addColumn('number', 'Percent Complete');
        data.addColumn('string', 'Dependencies');

        // Helpers
        const toDate = function (yyyymmdd) {
            if (!yyyymmdd || typeof yyyymmdd !== 'string') return null;
            const s = yyyymmdd.trim();
            if (s.length !== 8) return null;
            const y = parseInt(s.substring(0, 4), 10);
            const m = parseInt(s.substring(4, 6), 10) - 1;
            const d = parseInt(s.substring(6, 8), 10);
            if (isNaN(y) || isNaN(m) || isNaN(d)) return null;
            return new Date(y, m, d);
        };
        const toPercent = function (val) {
            const n = parseInt(val, 10);
            return isNaN(n) ? 0 : n;
        };

        // Flatten tasks up to any depth (input provides up to 3 levels)
        const rows = [];
        const addTask = function (t) {
            if (!t) return;
            const row = [
                String(t.taskId ?? ''),
                String(t.taskNm ?? ''),
                t.parentTaskId ? String(t.parentTaskId) : null,
                toDate(t.taskStartDt),
                toDate(t.taskEndDt),
                null, // Duration must be null per requirement
                toPercent(t.taskProgress),
                t.parentTaskId ? String(t.parentTaskId) : null,
            ];
            rows.push(row);
        };

        if (Array.isArray(chartData)) {
            chartData.forEach(addTask);
        } else {
            addTask(chartData);
        }

        console.log(rows);
        data.addRows(rows);
        // data.addRows([
        //     ['11244', 'Find sources', null, new Date(2025, 0, 1), new Date(2015, 0, 5), null,  100,  null],
        //     ['Write', 'Write paper', '11244', null, new Date(2025, 0, 9), gfnDaysToMilliseconds(3), 25, "11244"],
        //     ['Cite', 'Create bibliography', '11244',  null, new Date(2025, 0, 7), gfnDaysToMilliseconds(1), 20, "11244"],
        //     ['Complete', 'Hand in paper', 'complete',  null, new Date(2025, 0, 10), gfnDaysToMilliseconds(1), 0, null],
        //     ['Outline', 'Outline paper', '11244', null, new Date(2025, 0, 6), gfnDaysToMilliseconds(1), 100, "11244"]
        // ]);

        // Height auto-fit with a minimum
        const rowHeight = 42; // approx row height for Google Gantt
        const height = Math.max(555, rows.length * rowHeight + 100);
        let options = {
            height: height,
            width: document.getElementById('tab2GanttChart').parentElement.clientWidth - 15
        };

        let chart = new google.visualization.Gantt(document.getElementById('tab2GanttChart'));
        chart.draw(data, options);
    } catch (e) {
        console.error('fnDrawChart error:', e);
    }
}

//*****************************타임라인 탭 처리 끝 ***************************** //

//*****************************첨부파일 탭 처리 ***************************** //
//첨부파일 목록 재조회
function fnReselFilesGrid() {
    dtFiles.ajax.reload(function (json) {
        if (json.resultCode === "SUCCESS") {
            gfnSuccessAlert(gCmmnFileNm + gCmmnSM_List, gDelay_Short);
        }
        else {
            gfnFailAlert(gCmmnFileNm + gCmmnEM_ServiceError, gDelay_Long);
        }
    });
}

// 첨부파일의 태스크 목록 조회
function fnInitFilesGrid() {
    let projectId = $('#pProjectId').val();
    dtFiles = $("#filesTable").DataTable({
        ajax: {
            url: "/rest/user/projects/files/" + projectId,
            type: "POST",
            dataSrc: "data",
            data: function (d) {
                d.fileDispNm = $("#fileDispNm").val();
            },
            error: function (xhr, error, code) {
                gfnFailAlert(gCmmnFileNm + gCmmnEM_ServiceError, gDelay_Long);
            }
        },
        columns: [
            {
                data: function (item) {
                    return '<button class="btn btn-info btn-sm" type="button" onclick="fnDownloadFile(\'' + item.fileDispNm + '\', \'' + item.fileNm + '\')"><i class="fas fa-download"> </i></button>';
                },
                className: 'text-center',
                width: "5%",
            },
            {data: 'fileDispNm', width: "20%", defaultContent: ''},
            {data: 'taskTypeNm', width: "10%", defaultContent: ''},
            {data: 'taskNm', width: "10%", defaultContent: ''},
            {data: 'fileId', width: "5%", defaultContent: '', visible: false},
            {data: 'fileNm', width: "5%", defaultContent: '', visible: false},
            {data: 'createDt', width: "10%", defaultContent: ''}
        ],
        processing: true,
        serverSide: true,
        ordering: false,
        destroy: true,
        responsive: true,
        info: true,
        select: false,
        scrollY: '440',
        scrollCollapse: false,
        paging: true,
        searching: false,
        lengthChange: true,
        lengthMenu: [10, 50, 100, 500],
        loadBeforeSend: function (jqXHR) {
            jqXHR.setRequestHeader("AJAX", "true");
        },
        stateSave: false,
        stateLoadParams: function (settings, data) {
        },
        initComplete: function (settings, json) {
            gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_List, gDelay_Short);
        }
    });
}

//파일 다운로드
function fnDownloadFile(fileDispNm, fileNm) {
    if (typeof fileDispNm == "undefiled" || typeof fileNm == "undefined") {
        let msg = "다운로드 할 수 없는 파일입니다.";
        gfnFailAlert(msg, gDelay_Long);
    }
    else {
        let downUrl = "/rest/files/azure";
        downUrl = downUrl + "?fileDispNm=" + fileDispNm;
        downUrl = downUrl + "&fileNm=" + fileNm;

        const encFileName = encodeURI(downUrl);
        window.open(encFileName);
    }
}

//*****************************첨부파일 탭 처리 끝 *************************** //























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

    // gLabelId = sessionStorage.getItem("tasksLabelId");
    // if (gLabelId) {
    // 	dtLabels.rows().every (function (rowIdx, tableLoop, rowLoop) {
   	// 	  if (this.data().labelId === gLabelId) {
   	// 	    this.select ();
   	// 	  }
   	//   });
    // } else {
    //     gLabelId = "";
    // }

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
	// sessionStorage.setItem("tasksLabelId",gLabelId);
	sessionStorage.setItem("tasksPage", dtTasks.page.info().page);
}



</script>
</body>

</html>