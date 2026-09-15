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
						<button class="btn btn-info mt-n1" id="btnTaskUpdate"><i class="fas fa-save"></i> 저장</button>
						<button class="btn btn-danger mt-n1" id="btnTaskDelete" style="display:none;"><i class="fas fa-trash"></i> 삭제</button>
						<button class="btn btn-warning mt-n1" id="btnGoList"><i class="fas fa-list"></i> 목록</button>
					</div>
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><b id="bTaskNm"><i class="far fa-fw fa-edit"></i> 업무 상세</b></h1>
					</div>

					<div class="row">

						<div class="col-md-12">
							<div class="card">
<%--								<div class="card-header">--%>
<%--									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-angle-double-right"></i> 업무 상세정보 조회 및 수정</h5>--%>
<%--									<h6 id="divUpdate" class="card-subtitle text-muted"></h6>--%>
<%--								</div>--%>
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-6">
											<form id ="taskform">
                                                <div class="mb-3 row" id="parentTaskDiv">
                                                    <label class="col-form-label col-sm-2 text-sm-end"><b>상위 업무</b></label>
                                                    <div id="parentTask" class="col-sm-9">
                                                        <div class="btn-group me-2" id="parentTaskGroup" role="group" aria-label="First group">
                                                            <button id="btnParentTask" type="button" class="btn btn-secondary"></button>
                                                            <button class="btn btn-secondary" type="button" onclick="fnDeleteParentTask()">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </div>
                                                        <button id="btnParentAdd" type="button" class="btn btn-secondary" onclick="setTimeout(fnLoadParentTask, 500)" data-bs-toggle="modal" data-bs-target="#parentTaskAddModal"><i class="far fa-fw fa-folder-open"></i> 추가</button>
                                                    </div>
                                                </div>

                                                <div class="mb-3 row">
                                                    <label for="taskTypeNm" class="col-form-label col-sm-2 text-sm-end"><b>유형</b></label>
                                                    <div class="col-sm-9">
                                                        <label for="taskTypeNm" class="col-form-label col-sm-2"><b id="lblTaskTypeNm"></b></label>
                                                    </div>
                                                </div>
												<div class="mb-3 row">
													<label for="taskNm" class="col-form-label col-sm-2 text-sm-end"><b>업무명</b></label>
													<div class="col-sm-9">
														<input type="text" id="taskNm" class="form-control is-valid" required autocomplete="off">
													</div>
												</div>

												<div class="mb-3 row">
													<label for="taskStateCd" class="col-form-label col-sm-2 text-sm-end"><b>상태</b></label>
													<div class="col-sm-4">
														<select id="taskStateCd" class="form-select is-valid" required>
															<option selected value="">-선택-</option>
                                                            <c:forEach var="item" items="${TASK_STATE_CD_LIST}">
                                                                <option value="${item.code}">${item.codeNm}</option>
                                                            </c:forEach>
														</select>
													</div>
												</div>

                                                <div class="mb-3 row">
                                                    <label class="col-form-label col-sm-2 text-sm-end"><b>소유자</b></label>
                                                    <div id ="empOwnerAdd" class="col-sm-9">
                                                        <span id="ownerEmpAddSpan"></span>
                                                        <button id="btnOwnerEmpAdd_Modal" type="button" class="btn btn-secondary" onclick="setTimeout(fnOpenOwnerEmp_Modal, 500)" data-bs-toggle="modal" data-bs-target="#ownerEmpAdd_Modal" style="margin-top:4px;"><i class="far fa-fw fa-user"></i> 변경</button>
                                                    </div>
                                                </div>

                                                <div class="mb-3 row">
                                                    <label class="col-form-label col-sm-2 text-sm-end"><b>보고대상자</b></label>
                                                    <div id ="reportObjEmpAdd" class="col-sm-9">
                                                        <span id="reportObjEmpAddSpan"></span>
                                                        <button id="btnReportObjEmpAdd_Modal" type="button" class="btn btn-secondary" onclick="setTimeout(fnOpenReportObjEmp_Modal, 500)" data-bs-toggle="modal" data-bs-target="#reportObjEmpAdd_Modal" style="margin-top:4px;"><i class="far fa-fw fa-user"></i> 변경</button>
                                                    </div>
                                                </div>

												<div class="mb-3 row">
													<label for="taskImportanceCd" class="col-form-label col-sm-2 text-sm-end"><b>중요도</b></label>
													<div class="col-sm-4">
														<select id="taskImportanceCd" class="form-select">
															<option selected value="">-선택-</option>
                                                            <c:forEach var="item" items="${TASK_IMPORTANCE_CD_LIST}">
                                                                <option value="${item.code}">${item.codeNm}</option>
                                                            </c:forEach>
														</select>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="taskDetail" class="col-form-label col-sm-2 text-sm-end"><b>내용</b></label>
													<div class="col-sm-9">
														<textarea id="taskDetail" class="form-control" style="min-height: 15rem;" ></textarea>
													</div>
												</div>
											</form>
										</div>
										
										<div class="col-12 col-xl-6">
											<form>
												<div class="mb-3 row">
													<label for="taskStartDt" class="col-form-label col-sm-2 text-sm-end"><b>시작일</b></label>
													<div class="col-sm-3">
														<input id="taskStartDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" autocomplete="off"/>
													</div>

                                                    <label for="taskEndDt" class="col-form-label col-sm-3 text-sm-end"><b>종료일</b></label>
                                                    <div class="col-sm-3">
                                                        <input id="taskEndDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" autocomplete="off"/>
                                                    </div>
												</div>

												<div class="mb-3 row">
													<label for="taskProgress" class="col-form-label col-sm-2 text-sm-end"><b>진행도</b></label>
													<div class="col-sm-3">
														<div class="input-group">
															<select id="taskProgress" class="form-select">
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
														<label class="btn btn-secondary" for="input-file"><i class="far fa-fw fa-file"></i> 첨부</label>
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
                                                        <button class="btn btn-secondary" type="button" id="btnAddSubTask"><i class="fas fa-fw fa-link"></i> 추가</button>
                                                    </div>
												</div>

                                                <div class="mb-3 row" id="divChildTaskTable">
                                                    <div class="col-sm-2"></div>
                                                    <div class="col-sm-9">
                                                        <table id="childTaskTable" class="table table-striped" style="width:100%">
                                                            <thead>
                                                            <tr>
                                                                <th>상세</th>
                                                                <th>태스크명</th>
                                                                <th>상태</th>
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
													<div class="col-sm-9 ps-2">
														<div class="row">
															<div class="col-sm-2">
																<select id="taskCommentEmp" class="form-select mb-2">
																</select>
															</div>
															<div class="col-sm-10">
																<textarea id="taskComment" class="form-control" rows="3"></textarea>
															</div>
														</div>
														
													</div>
													<button id="btnCommentAdd" style="width:100px; height:73px; margin-left:5px;" class="btn btn-success col-sm-1">등록</button>
												</div>
												
												<div id="commentDiv">
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
			<%@ include file="/WEB-INF/views/user/include/footer.jsp"%>
		</div>
	</div>

    <!-- 상위 태스크 추가 모달 -->
	<div class="modal fade" id="parentTaskAddModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title"><i class="fas fa-angle-double-right"></i> 상위업무 추가</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body m-3">
					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-6">
											<div class="row">
												<label for="parentTaskState" class="col-form-label col-sm-3 text-sm-end"><b>상태</b></label>
												<div class="col-sm-8">
													<select id="parentTaskState" class="form-select mb-2">
														<option selected value="">전체</option>
														<c:forEach var="item" items="${TASK_STATE_CD_LIST}">
                                                            <option value="${item.code}">${item.codeNm}</option>
                                                        </c:forEach>
													</select>
												</div>
											</div>
										</div>
										<div class="col-12 col-xl-6">
											<div class="row">
												<label for="parentTaskNm" class="col-form-label col-sm-4 text-sm-end"><b>업무명</b></label>
												<div class="col-sm-8">
													<div class="input-group">
														<input type="text" id="parentTaskNm" class="form-control">
														<button class="btn btn-secondary" id="btnParentTaskNmSearch"><i class="fas fa-search"></i></button>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="card">
						<table id="parentTaskTable" class="table table-striped" style="width:100%">
							<thead>
								<tr>
									<th>No</th>
									<th>상태</th>
									<th>유형</th>
									<th>업무명</th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" id="btnParentAddModal" class="btn btn-info">선택</button>
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

    <%-- 소유자 선택 모달 --%>
    <div class="modal fade" id="ownerEmpAdd_Modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" style=" --bs-modal-width:1100px">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-angle-double-right"></i> 프로젝트 사용자 검색</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body m-3">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-12 col-xl-4">
                                            <div class="row">
                                                <label for="ownerEmpNm_Modal" class="col-form-label col-sm-3 text-sm-end"><b>성명</b></label>
                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <input type="text" id="ownerEmpNm_Modal" class="form-control">
                                                        <button class="btn btn-secondary" id="btnOwnerEmpNmSearch_Modal"><i class="fas fa-search"></i></button>
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
                        <div class="col-12 col-xl-12">
                            <div class="col-md-12">
                                <div class="card" style="margin-bottom: 0 !important;">
                                    <div class="card-body">
                                        <table id="ownerEmpAddTable_Modal" class="table table-striped" style="width:100%">
                                            <thead>
                                            <tr>
                                                <th>도메인</th>
                                                <th>회사</th>
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
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnEmpAssign_Modal" class="btn btn-vimeo">선택</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <%-- 보고 대상자 선택 모달 --%>
    <div class="modal fade" id="reportObjEmpAdd_Modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" style=" --bs-modal-width:1100px">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-angle-double-right"></i> 프로젝트 사용자 검색</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body m-3">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-12 col-xl-4">
                                            <div class="row">
                                                <label for="reportObjEmpNm_Modal" class="col-form-label col-sm-3 text-sm-end"><b>성명</b></label>
                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <input type="text" id="reportObjEmpNm_Modal" class="form-control">
                                                        <button class="btn btn-secondary" id="btnReportObjEmpNmSearch_Modal"><i class="fas fa-search"></i></button>
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
                        <div class="col-12 col-xl-12">
                            <div class="col-md-12">
                                <div class="card" style="margin-bottom: 0 !important;">
                                    <div class="card-body">
                                        <table id="reportObjEmpAddTable_Modal" class="table table-striped" style="width:100%">
                                            <thead>
                                            <tr>
                                                <th>도메인</th>
                                                <th>회사</th>
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
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnReportObjEmpAssign_Modal" class="btn btn-vimeo">선택</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 하위업무 추가 모달 : 여기 -->
    <div class="modal fade" id="subTaskNewModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-md" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">
                        <i class="fas fa-angle-double-right"></i> 하위업무 추가
                    </h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body m-3">
                    <div class="card">
                        <form id="subTaskNewform" onsubmit="return false;">
                            <div class="mb-3 row">
                                <label for="newSubTaskNm" class="col-form-label col-sm-2 text-sm-end"><b>업무명</b></label>
                                <div class="col-sm-10">
                                    <input type="text" id="newSubTaskNm" class="form-control is-valid" required autocomplete="off">
                                </div>
                            </div>

                            <div class="mb-3 row">
                                <label for="subTaskStateCd" class="col-form-label col-sm-2 text-sm-end"><b>상태</b></label>
                                <div class="col-sm-5">
                                    <select id="subTaskStateCd" class="form-select is-valid" required>
                                        <option selected value="">-선택-</option>
                                        <c:forEach var="item" items="${TASK_STATE_CD_LIST}">
                                            <option value="${item.code}">${item.codeNm}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3 row">
                                <label for="newSubTaskOwnerMemberId_Modal" class="col-form-label col-sm-2 text-sm-end"><b>소유자</b></label>
                                <div class="col-sm-5">
                                    <div class="input-group">
                                        <input type="text" id="newSubTaskOwnerMemberNm_Modal" class="form-control is-valid" required autocomplete="off" readonly placeholder="업무 소유자">
                                        <button id="btnClearNewSubTaskOwnerMember_Modal" class="btn btn-secondary" type="button"><i class="fas fa-times"></i></button>
                                    </div>
                                    <input type="hidden" id="newSubTaskOwnerMemberId_Modal" value="">
                                </div>
                                <div class="col-sm-3">
                                    <button class="btn btn-secondary" type="button" id="btnNewSubTaskOwnerMemberAdd_Modal"><i class="far fa-fw fa-user"></i> 변경</button>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="newSubTaskReportMemberNm_Modal" class="col-form-label col-sm-2 text-sm-end"><b>보고자</b></label>
                                <div class="col-sm-5">
                                    <div class="input-group">
                                        <input type="text" id="newSubTaskReportMemberNm_Modal" class="form-control" autocomplete="off" readonly placeholder="업무 보고 대상자">
                                        <button id="btnClearNewSubTaskReportMember_Modal" class="btn btn-secondary" type="button"><i class="fas fa-times"></i></button>
                                    </div>
                                    <input type="hidden" id="newSubTaskReportMemberId_Modal" value="">
                                </div>
                                <div class="col-sm-3">
                                    <button class="btn btn-secondary" type="button" id="btnNewSubTaskReportMemberAdd_Modal"><i class="far fa-fw fa-user"></i> 변경</button>
                                </div>
                            </div>
                        </form>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" id="btnNewSubTaskAddModal" class="btn btn-info">저장</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <%-- 소유자/보고자 선택 모달 (하위업무추가모달에서 사용) --%>
    <div class="modal fade" id="sutaskOwnerEmpAdd_Modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" style=" --bs-modal-width:1100px">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-angle-double-right"></i> 프로젝트 사용자 검색</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body m-3">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-12 col-xl-4">
                                            <div class="row">
                                                <label for="subtaskOwnerEmpNm_Modal" class="col-form-label col-sm-3 text-sm-end"><b>성명</b></label>
                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <input type="text" id="subtaskOwnerEmpNm_Modal" class="form-control">
                                                        <button class="btn btn-secondary" id="btnSubtaskOwnerEmpNmSearch_Modal"><i class="fas fa-search"></i></button>
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
                        <div class="col-12 col-xl-12">
                            <div class="col-md-12">
                                <div class="card" style="margin-bottom: 0 !important;">
                                    <div class="card-body">
                                        <table id="subtaskOwnerEmpAddTable_Modal" class="table table-striped" style="width:100%">
                                            <thead>
                                            <tr>
                                                <th>도메인</th>
                                                <th>회사</th>
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
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnSubtaskOwnerEmpAssign_Modal" class="btn btn-vimeo">선택</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

	<form id="frmHiddenParam">
	  <input type="hidden" id="pParentTaskId" name="pParentTaskId" value=""/>
	  <input type="hidden" id="pProjectId" name="pProjectId" value="<c:out value="${PROJECT_ID}"/>"/>
	  <input type="hidden" id="pEmail" name="pEmail" value="<c:out value="${email}"/>"/>
	  <input type="hidden" id="pTaskId" name="pTaskId" value="<c:out value="${taskId}"/>"/>
	  <input type="hidden" id="pDeptCd" name="pDeptCd" value="<c:out value="${deptCd}"/>"/>
	</form>

<%@ include file="/WEB-INF/views/user/include/script.jsp" %>

<script>
let fileHeight = 0;
let checkHeight = 0;
let selFile;
let empArr = new Array();
let empOrgArr = new Array();
let toEmpList = new Array(); // 댓글 대상자 목록
let filesArr = new Array();
let gCommentId = '';
let gCommentUpdateYn = 'Y';
let fpTaskStartDt;
let fpTaskEndDt;
let dtEmpList;
let dtParents;
let dtSubtaskOwnerEmpGrid;
let gSubtaskMemberFlag = "O"; // O : OWNER , R : REPORTER
let gDeptCd = '';
let gTaskTypeCd = "";
let empOwnerHeight = 0;
let empOwnerArr = new Array(); // 소유자 저장을 위한 배열
let reportObjEmpHeight = 0;
let reportObjEmpArr = new Array(); // 보고 대상자 저장을 위한 배열
let referrer = document.referrer;

$(function() {
	fnSetComponent();
	fnSetMenuSelection();
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

	fpTaskStartDt = flatpickr("#taskStartDt", {
		dateFormat: "Y-m-d"
	});
	fpTaskEndDt = flatpickr("#taskEndDt", {
		dateFormat: "Y-m-d"
	});
	
	let drake = dragula([
		document.querySelector("#checkList")
	]);
	
	drake.on('drop', (el, target, source, sibling) => {
	  // el: 드래그하고 있는 요소
	  // target: el이 드래그 후 놓아진 리스트 요소
	  // sibling: 자리에 놓았을 때, 바로 그 다음 요소
	  // source: 원래 el이 있던 리스트 요소
	});

	selFile = document.querySelector("input[type=file]");
}
// ************************* Component 초기화 끝 *************************** //

// ************************* Event 초기화  ******************************** //
function fnSetEvent() {
    // 태스크 저장 이벤트 처리
	$("#btnTaskUpdate").off("click").on("click", function (e) {
		e.preventDefault();
        fnUpdateTask();
	});

    // 태스크 삭제 버튼 이벤트 처리
	$("#btnTaskDelete").off("click").on("click", function (e) {
		e.preventDefault();
		let msg = "해당 태스크를 삭제하시겠습니까?";
		let callback = fnDeleteTask;
		gfnInitWrnCfmMdlDialog(msg, callback);
	});

    // 목록 이동 이벤트 처리 (프로젝트 디테일)
	$("#btnGoList").off("click").on("click", function (e) {
		e.preventDefault();
        fnGoProjectDetail();
	});

    // 상위 태스크 버튼 클릭 이벤트 처리
    $("#btnParentTask").off("click").on("click", function (e) {
        e.preventDefault();
        fnGoUpperTaskDetail();
    });

    // 체크리스트 추가 버튼 이벤트
	$("#btnAddCheckList").off("click").on("click", function (e) {
		e.preventDefault();
		fnAddCheckList();
	});
	
	$("#btnParentAddModal").off("click").on("click", function (e) {
		e.preventDefault();
		fnSetParentTask();
	});
	
    // 댓글 등록 버튼 이벤트
	$("#btnCommentAdd").off("click").on("click", function (e) {
		e.preventDefault();
		fnAddComment();
	});
	
	$("#parentTaskState").on("change", function(){
		fnReselParents();
	});
	
	$("#parentTaskNm").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnReselParents();
		}
	});
	$("#btnParentTaskNmSearch").off("click").on("click", function (e) {
		e.preventDefault();
		fnReselParents();
	});
	
	$("#taskProgress").on("change", function(){
	    let progress = $("#taskProgress").val();
	    let stateCd = $("#taskStateCd").val();
	    if(stateCd != "CM001CD003" && progress == 100) $("#taskStateCd").val("CM001CD004");
	    else if(stateCd != "CM001CD003" && progress > 0) $("#taskStateCd").val("CM001CD002");
	    else if(stateCd != "CM001CD003" && progress == 0) $("#taskStateCd").val("CM001CD001");
	});

    $("#taskDetail").on("keydown keyup", function(e) {
        gfnTextAreaResize(this);
    });

    ///////////////////// 소유자 선택 팝업 이벤트 ///////////////////////
    $("#btnEmpAssign_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnSetTaskOwnerEmp_Modal();
    });

    // 사용자 검색
    $("#ownerEmpNm_Modal").keydown(function(e) {
        if (e.keyCode == 13) {
            e.preventDefault();
            fnReselOwnerEmpGrid_Modal();
        }
    });

    // 사용자 검색
    $("#btnOwnerEmpNmSearch_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnReselOwnerEmpGrid_Modal();
    });
    ///////////////////// 소유자 선택 팝업 이벤트 끝 ///////////////////////

    ///////////////////// 보고 대상자 선택 팝업 이벤트 ///////////////////////
    $("#btnReportObjEmpAssign_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnSetTaskReportObjEmp_Modal();
    });

    $("#reportObjEmpNm_Modal").keydown(function(e) {
        if (e.keyCode == 13) {
            e.preventDefault();
            fnReselReportObjEmpGrid_Modal();
        }
    });

    $("#btnReportObjEmpNmSearch_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnReselReportObjEmpGrid_Modal();
    });
    ///////////////////// 소유자 선택 팝업 이벤트 끝 ///////////////////////

    ///////////////////// 하위업무추가 팝업 이벤트 ///////////////////////
    // 하위업무 모달 호출
    $("#btnAddSubTask").off("click").on("click", function (e) {
        e.preventDefault();
        fnOpenAddSubTaskModal();
    });

    // 하위업무 추가
    $("#btnNewSubTaskAddModal").off("click").on("click", function (e) {
        e.preventDefault();
        fnAddSubTask();
    });

    // 소유자 초기화
    $("#btnClearNewSubTaskOwnerMember_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        $("#newSubTaskOwnerMemberNm_Modal").val("");
        $("#newSubTaskOwnerMemberId_Modal").val("");
    });

    // 보고자 초기화
    $("#btnClearNewSubTaskReportMember_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        $("#newSubTaskReportMemberNm_Modal").val("");
        $("#newSubTaskReportMemberId_Modal").val("");
    });
    ///////////////////// 하위업무추가 팝업 이벤트 끝 ////////////////////

    ///////////////////// 하위업무추가 팝업의 소유자/보고자검색 팝업 이벤트 ///////////////////////
    // 소유자 추가를 위한 Modal Open
    $("#btnNewSubTaskOwnerMemberAdd_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        gSubtaskMemberFlag = "O";
        fnOpenNewSubTaskOwnerMemberAdd_Modal();
    });

    // 보고자 추가를 위한 Modal Open
    $("#btnNewSubTaskReportMemberAdd_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        gSubtaskMemberFlag = "R";
        fnOpenNewSubTaskOwnerMemberAdd_Modal();
    });

    // Modal이 오픈되고 나서의 이벤트
    $("#sutaskOwnerEmpAdd_Modal").off("shown.bs.modal").on("shown.bs.modal", function (e) {
        fnInitNewSubTaskOwnerMemberAdd_Modal();
    });

    // 사용자 검색 (타이핑 후 엔터)
    $("#subtaskOwnerEmpNm_Modal").keydown(function(e) {
        if (e.keyCode == 13) {
            e.preventDefault();
            fnReselSubtaskOwnerEmpGrid_Modal();
        }
    });

    // 사용자 검색 (타이핑 후 버튼 클릭)
    $("#btnSubtaskOwnerEmpNmSearch_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnReselSubtaskOwnerEmpGrid_Modal();
    });

    // 사용자(소유자) 선택 버튼 클릭
    $("#btnSubtaskOwnerEmpAssign_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnSetSubTaskOwnerEmp_Modal();
    });
    ///////////////////// 하위업무추가 팝업의 소유자/보고자검색 이벤트 끝 ////////////////////
}
// ************************* Event 초기화 끝 **************************** //

// ************************* 초기 데이터 조회 **************************** //
function fnSetData() {
    fnGetTask("Y");
}
// ************************* 초기 데이터 조회 끝 **************************** //

// 태스크 데이터 한건 조회
function fnGetTask(msgYn) {
    let taskId = $('#pTaskId').val();
    let apiUrl = '/rest/user/tasks/' + taskId;
    gfnShowLoadingBar();

    $.ajax({
        url: apiUrl,
        type: 'get',
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        $("#bTaskNm").html("<i class='far fa-fw fa-edit'></i> " + data.dataOne.taskNm);
        gTaskTypeCd = data.dataOne.taskTypeCd;
        fnChangeUpperNSubTaskDiv(); // 상위 / subTask 추가 관련 DIV 상태 조정
        $("#lblTaskTypeNm").html(data.dataOne.taskTypeNm);
        $('#taskNm').val(gfnUnescapeHTML(data.dataOne.taskNm));
        $('#taskOwnerMember').val(gfnUnescapeHTML(data.dataOne.empNm));
        $('#taskDetail').val(gfnUnescapeHTML(data.dataOne.taskDetail));
        $('#taskStateCd').val(data.dataOne.taskStateCd);
        fpTaskStartDt.setDate(gfnYmdFormat(data.dataOne.taskStartDt, "-"));
        fpTaskEndDt.setDate(gfnYmdFormat(data.dataOne.taskEndDt, "-"));
        $('#taskImportanceCd').val(data.dataOne.taskImportanceCd);
        $('#taskProgress').val(data.dataOne.taskProgress);
        let email = "<c:out value="${email}"/>";

        //로그인한 사용자와 소유자가 같으면 삭제 버튼 표시
        if(email == data.dataOne.taskOwnerMemberId) {
            $('#btnTaskDelete').show();
        }
        else {
            $('#btnTaskDelete').hide(); //삭제버튼 제거
            //상위업무 처리
            // if(data.dataOne.parentTaskId == '' || data.dataOne.parentTaskId == null) $('#parentTaskDiv').hide();
            // else {
            //     //기존 상위업무group 제거 후 표시용 버튼만 추가(css 유지위해)
            //     $('#btnParentAdd').hide();
            //     $("#parentTaskGroup").hide();
            //     let htmlData = '<button id="btnParentTask" type="button" class="btn btn-secondary"></button>';
            //     $("#parentTask").prepend(htmlData);
            // }
        }

        let parentTaskId = data.dataOne.parentTaskId;
        if(parentTaskId == '' || parentTaskId == null) {
            $('#parentTaskGroup').hide();
        }
        else {
            $('#parentTaskGroup').show();
            $('#pParentTaskId').val(parentTaskId);
            $('#btnParentTask').text(data.dataOne.parentTaskNm);
        }

        fnSetTaskOwnerEmp(data.dataOne);        // 소유자 셋팅
        fnSetInitReporterEmp(data.dataOne);     // 보고대상자 셋팅
        fnSetChecklist(data.dataOne.checklist); // 체크리스트 셋팅
        fnSetComment();
        fnCommentEmpSet();

        $('#fileList').empty();
        filesArr.length = 0;
        fileHeight = 0;
        for(let i = 0; i < data.dataOne.fileList.length; i++) {
            filesArr.push(data.dataOne.fileList[i]);
            fnSetFile(fileHeight, data.dataOne.fileList[i]);
        };

        if (msgYn == "Y") {
            gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_One, gDelay_Short);
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
        gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, gDelay_Long);
    }).always(function(msg) {
        gfnHideLoadingBar();
    });
}

// 조회 결과에 따라 상위 / 하위업무 추가 DIV 상태 셋팅
function fnChangeUpperNSubTaskDiv() {
    // 조회된 태스크가 서브태스크이면 하위 태스크 DIV를 숨긴다.
    if (gTaskTypeCd == "CM007CD003") {
        $("#childTaskDiv").hide();
        $("#divChildTaskTable").hide();
    }
    // 조회된 결과가 에픽이나 태스크이면 하위 태스크를 조회한다.
    else {
        $("#childTaskDiv").show();
        $("#divChildTaskTable").show();
        fnLoadChildTask();
    }

    console.log(gTaskTypeCd);
    // 조회된 태스크가 프로젝트이면 상위업무 추가 DIV를 숨긴다.
    if (gTaskTypeCd == "CM007CD001") {
        $("#parentTaskDiv").hide();
    }
    else {
        $("#parentTaskDiv").show();
    }
}

//업무상세 - 체크리스트 Set (조회 결과 셋팅)
function fnSetChecklist(checklist) {
    $('#checkList').empty();
    checkHeight = 0;

    for(let i = 0; i < checklist.length; i++) {
        let htmlData = '';
        htmlData += '<div class="row" id="checkRow'+ checkHeight + '">';
        htmlData += '<label id="checkLabel' + checkHeight + '" class="form-label col-sm-2 text-sm-end"></label>';
        htmlData += '<div id="checkDiv' + checkHeight + '" class="col-sm-9">'
        htmlData += '<div class="input-group mb-3">';
        htmlData += '<div class="input-group-text">';
        htmlData += '<input type="checkbox" id="taskCheckYn' + checkHeight + '">';
        htmlData += '</div>';
        htmlData += '<input type="text" id="taskCheck' + checkHeight + '" class="form-control" placeholder="To do" value="">';
        htmlData += '<button class="btn btn-secondary" type="button" onclick="fnDeleteCheckList(' + checkHeight + ')">';
        htmlData += '<i class="fas fa-times"></i>';
        htmlData += '</button>';
        htmlData += '</div>';
        htmlData += '</div>';
        htmlData += '</div>';

        $('#checkList').append(htmlData);

        if(checklist[i].checkYn == 'Y') $('#taskCheckYn'+checkHeight).attr("checked", true);
        else $('#taskCheckYn'+checkHeight).attr("checked", false);
        $('#taskCheck'+checkHeight).val(checklist[i].checkNm);

        checkHeight += 1;
    }
}

// 최초 조회결과 소유자 셋팅
function fnSetTaskOwnerEmp(data) {
    if (!data.taskOwnerMemberId || data.taskOwnerMemberId === null) {
        return;
    }

    let domainId = data.domainId;
    let companyCd = data.companyCd;
    let email = data.taskOwnerMemberId;
    let empNm = data.taskOwnerMemberNm;
    let buttonStyle = 'vimeo';
    let num = empOwnerHeight;
    let htmlData = '';
    htmlData += '<div class="btn-group me-2" id="empOwnerAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
    htmlData += '<button id="btnEmpOwner' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ empNm + '</button>';
    htmlData += '<input type="text" id="empOwnerEmail' + num + '" value="'+ email +'" hidden>';
    htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteTaskOwner(' + num + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
    htmlData += '</div>';

    $('#ownerEmpAddSpan').empty();
    $('#ownerEmpAddSpan').append(htmlData);

    empOwnerArr.length = 0;
    empOwnerArr.push({
        name: empNm,
        email: email,
        domainId: domainId,
        companyCd: companyCd
    });

    // empOwnerHeight += 1;
}

// 소유자 삭제
function fnDeleteTaskOwner(num) {
    for(let i = 0; i < empOwnerArr.length; i++) {
        let email = $('#empOwnerEmail'+num).val();
        if(empOwnerArr[i].email == email) {
            empOwnerArr.splice(i, 1);
        }
    }
    $("#empOwnerAddGroup" + num).remove();
}

// 최초 조회결과 보고대상자 셋팅
function fnSetInitReporterEmp(data) {
    if (!data.reportMemberId || data.reportMemberId === null) {
        return;
    }

    let domainId = data.domainId;
    let companyCd = data.companyCd;
    let email = data.reportMemberId;
    let empNm = data.reportMemberNm;
    let buttonStyle = 'facebook';
    let num = reportObjEmpHeight;
    let htmlData = '';
    htmlData += '<div class="btn-group me-2" id="reportObjEmpAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
    htmlData += '<button id="btnReportObjEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ empNm + '</button>';
    htmlData += '<input type="text" id="reportObjEmpAddEmail' + num + '" value="'+ email +'" hidden>';
    htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteReportObjEmpTask(' + num + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
    htmlData += '</div>';

    $('#reportObjEmpAddSpan').empty();
    $('#reportObjEmpAddSpan').append(htmlData);

    reportObjEmpArr.length = 0;
    reportObjEmpArr.push({
        name: empNm,
        email: email,
        domainId: domainId,
        companyCd: companyCd
    });

    //reportObjEmpHeight += 1; // 여러명을 추가할때는 필요함.
}

// 보고자 삭제
function fnDeleteReportObjEmpTask(num) {
    for(let i = 0; i < reportObjEmpArr.length; i++) {
        let email = $('#reportObjEmpAddEmail'+num).val();
        if(reportObjEmpArr[i].email == email) {
            reportObjEmpArr.splice(i, 1);
        }
    }
    $("#reportObjEmpAddGroup" + num).remove();
}

//하위업무 목록 조회
function fnLoadChildTask() {
    let taskId = $("#pTaskId").val();
    let apiUrl = '/rest/user/tasks/' + taskId + '/childs';

    $.ajax({
        url: apiUrl,
        type: 'get',
        // data: params,
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
                {data: 'taskNm'},
                {data: 'taskState'}
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

//하위업무 상세버튼 클릭시 이동
function fnChildTaskDetail(taskId) {
    let projectId = $("#pProjectId").val();
    let apiUrl = '/user/tasks/taskdetailform';
    let params = new Object();
    params.projectId = projectId;
    params.taskId = taskId;
    fnPostMove(apiUrl, params);
}

// TASK 저장
function fnUpdateTask() {
    if (!gfnCheckRequired($("#taskform"))) {
        return;
    }

    if(!empOwnerArr || empOwnerArr.length === 0) {
        gfnFailAlert("소유자를 선택해주세요.", gDelay_Medium);
        $("#btnOwnerEmpAdd_Modal").focus();
        return false;
    }

    let projectId = $("#pProjectId").val();
    let taskId = $('#pTaskId').val();
    let apiUrl = '/rest/user/tasks/' + taskId;
    let params = new Object();
    params.projectId = projectId;
    params.taskOwnerMemberId = empOwnerArr[0].email;    // 소유자 이메일
    params.taskNm = $("#taskNm").val();
    params.taskImportanceCd = $("#taskImportanceCd").val();
    params.taskDetail = $("#taskDetail").val();
    params.taskStartDt = gfnNoFormatDate($("#taskStartDt").val());
    params.taskEndDt = gfnNoFormatDate($("#taskEndDt").val());
    if($("#taskStartDt").val() != '' && $("#taskEndDt").val() != '' && $("#taskStartDt").val() > $("#taskEndDt").val()) {
        gfnFailAlert("시작일이 종료일보다 이전이어야 합니다.", gDelay_Long);
        return false;
    }
    // params.empNm = $("#taskOwnerMember").val();

    // 보고대상자 추가 - reportObjEmpArr에서 이메일만 추출하여 설정
    if(reportObjEmpArr && reportObjEmpArr.length > 0) {
        params.reportMemberId = reportObjEmpArr[0].email;
    }

    params.taskStateCd = $("#taskStateCd").val();
    params.taskProgress = $("#taskProgress").val();;

    if($("#pParentTaskId").val() == '') {
        params.childTaskAddYn = 'Y';
    }
    else {
        params.parentTaskId = $("#pParentTaskId").val();
        params.childTaskAddYn = 'N';
    }

    // //참여자
    // for(let i = 0; i < empArr.length; i++) {
    // 	params['empList[' + i +'].email'] = empArr[i].email;
    // 	params['empList[' + i +'].companyCd'] = empArr[i].companyCd;
    // 	params['empList[' + i +'].taskEmpCd'] = empArr[i].taskEmpCd;
    // }

    //새로 추가된 참여자
    // let diff = empArr.filter(item => {
    // 	return !empOrgArr.some(other => other.email === item.email)
    // });
    // for(let i = 0; i < diff.length; i++) {
    // 	params['empAddList[' + i +'].email'] = diff[i].email;
    // 	params['empAddList[' + i +'].companyCd'] = diff[i].companyCd;
    // 	params['empAddList[' + i +'].taskEmpCd'] = diff[i].taskEmpCd;
    // }

    //체크리스트
    let checkLen = $('#checkList').children().length;
    for(let i = 0; i < checkLen; i++) {
        let checkHeight = $('#checkList').children().eq(i).prop("id").substr(8);
        let checkYn = $("#taskCheckYn" + checkHeight).is(":checked");
        if(checkYn) params['checkList[' + i +'].checkYn'] = 'Y';
        else params['checkList[' + i +'].checkYn'] = 'N';
        params['checkList[' + i +'].checkNm'] = $("#taskCheck" + checkHeight).val();
        params['checkList[' + i +'].checkOrd'] = i;
    }

    //파일
    for(let i = 0; i < filesArr.length; i++) {
        params['fileList[' + i +'].fileNm'] = filesArr[i].fileNm;
        params['fileList[' + i +'].fileDispNm'] = filesArr[i].fileDispNm;
    }

    gfnShowLoadingBar();

    $.ajax({
        url: apiUrl,
        type: 'put',
        data: params,
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_Update, gDelay_Short);
        fnGetTask();
    }).fail(function(request, status, error) {
        gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, gDelay_Long);
    }).always(function(msg) {
        gfnHideLoadingBar();
    });
}

// TASK 삭제
function fnDeleteTask() {
    let taskId = $('#pTaskId').val();
    let apiUrl = '/rest/user/tasks/' + taskId;

    gfnShowLoadingBar();

    $.ajax({
        url: apiUrl,
        type: 'delete',
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_Delete, gDelay_Short);
        fnGoProjectDetail();
    }).fail(function(request, status, error) {
        gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, gDelay_Long);
    }).always(function(msg) {
        gfnHideLoadingBar();
    });
}

// 목록 클릭시 이동
function fnGoProjectDetail() {
    let projectId = $("#pProjectId").val();
    let apiUrl = '/user/projects/projectdetailform';
    let params = new Object();
    params.projectId = projectId;
    fnPostMove(apiUrl, params);
}

// 상위업무 버튼 클릭시 이동
function fnGoUpperTaskDetail() {
    let projectId = $("#pProjectId").val();
    let taskId = $("#pParentTaskId").val();
    let apiUrl = '/user/tasks/taskdetailform';
    let params = new Object();
    params.projectId = projectId;
    params.taskId = taskId;
    fnPostMove(apiUrl, params);
}

//체크리스트 추가
function fnAddCheckList(){
    let checkLen = $('#checkList').children().length;
    if(checkLen+1 > 20) {
        gfnFailAlert("체크리스트는 20개까지만 첨부할 수 있습니다.", gDelay_Long);
        return;
    }
    let htmlData = '';
    htmlData += '<div class="row" id="checkRow'+ checkHeight + '">';
    htmlData += '<label id="checkLabel' + checkHeight + '" class="form-label col-sm-2 text-sm-end"></label>';
    htmlData += '<div id="checkDiv' + checkHeight + '" class="col-sm-9">'
    htmlData += '<div class="input-group mb-3">';
    htmlData += '<div class="input-group-text">';
    htmlData += '<input type="text" id="taskDeleteYn' + checkHeight + '" value="N" hidden>';
    htmlData += '<input type="checkbox" id="taskCheckYn' + checkHeight + '">';
    htmlData += '</div>';
    htmlData += '<input type="text" id="taskCheck' + checkHeight + '" class="form-control" placeholder="To do" onkeypress="fnCheckEnter(event)">';
    htmlData += '<button class="btn btn-secondary" type="button" onclick="fnDeleteCheckList(' + checkHeight + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
    htmlData += '</div>';
    htmlData += '</div>';
    htmlData += '</div>';
    $('#checkList').append(htmlData);
    $('#taskCheck'+checkHeight).focus();

    checkHeight += 1;
}

//체크리스트 삭제
function fnDeleteCheckList(num) {
    $("#checkRow" + num).remove();
}

//체크리스트에서 엔터누르면 자동 추가
function fnCheckEnter(event) {
    if(event.keyCode == 13){
        fnAddCheckList();
    }
}

//댓글창 초기화
function fnClearComment() {
    $("#commentDiv").empty();
    $("#taskComment").val("");
    $("#taskCommentEmp").val("");
}

// 댓글 작성 대상 사용자 Set
function fnCommentEmpSet() {
    let projectId = $('#pProjectId').val();
    let apiUrl = '/rest/user/projects/emps/' + projectId;
    let params = new Object();
    params.start = 0;
    params.length = 1000;

    $.ajax({
        url: apiUrl,
        type: 'POST',
        data: params,
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        if (data.resultCode == "SUCCESS") {
            $("#taskCommentEmp").find("option").remove();
            $("#taskCommentEmp").append("<option value=''>전체</option>");

            toEmpList.length = 0;
            for(let i = 0; i < data.data.length; i++) {
                toEmpList.push({
                    email: data.data[i].email,
                    empNm: data.data[i].empNm,
                    companyCd: data.data[i].companyCd
                });

                if(data.data[i].email == $("#pEmail").val())
                    $("#taskCommentEmp").append("<option value='" + data.data[i].email + "'>" + data.data[i].empNm + " (나)</option>");
                else
                    $("#taskCommentEmp").append("<option value='" + data.data[i].email + "'>" + data.data[i].empNm + "</option>");
            }
        }
        else {
            gfnFailAlert(gCmmnProjectEmpNm + gCmmnEM_ServiceError, gDelay_Long);
        }
    }).fail(function(request, status, error) {
        gfnFailAlert(gCmmnProjectEmpNm + gCmmnEM_ServiceError, gDelay_Long);
    }).always(function(msg) {
        gfnHideLoadingBar();
    });
}

// 댓글 등록
function fnAddComment() {
    let params = new Object();
    let taskId = $("#pTaskId").val();
    params.commentContent = $("#taskComment").val();
    params.taskOwnerMemberId = $('#taskOwnerMemberId').val();

    let commentEmpInfo = toEmpList.filter(item => {
        if(item.email == $("#taskCommentEmp").val())
            return item;
    });

    // 댓글 대상
    if($("#taskCommentEmp").val()) {
        params['toEmpList[0].email'] = commentEmpInfo[0].email;
        params['toEmpList[0].companyCd'] = commentEmpInfo[0].companyCd;
    }

    $.ajax({
        type:'post',
        url:"/rest/user/tasks/" + taskId + "/comments",
        data: params,
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        gfnSuccessAlert("댓글이 등록되었습니다.",gDelay_Long);
        fnClearComment();
        fnSetComment();
    }).fail(function(request, status, error) {
        gfnFailAlert(error, gDelay_Long);
    });

}

//댓글 목록 조회
function fnSetComment() {
    let taskId = $("#pTaskId").val();

    $.ajax({
        url:"/rest/user/tasks/" + taskId + "/comments",
        type:'GET',
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        $('#commentDiv').empty();
        $.each(data, function(idx, item){
            let htmlData = '';
            htmlData += '<div class="row mb-3" id="commentGroup' + item.commentId +'">';
            htmlData += '<div class="col-sm-1"></div>'
            htmlData += '<div class="col-sm-1">' + item.empNm + '</div>';
            htmlData += '<div class="col-sm-7 ps-2">';
            let commentContent = item.commentContent.replaceAll("\n", "<br/>");
            htmlData += '<div class="text-dark" id="commentContentDiv' + item.commentId + '">';
            if(item.commentReceiverNm) htmlData += '<strong style="color:rgba(59,125,221);">[' + item.commentReceiverNm + '] </strong>' //댓글수신대상 존재하면 표시
            htmlData += commentContent + '</div>';
            htmlData += '<textarea id="commentContentText' + item.commentId + '" class="form-control" rows="2" style="display:none;">' + item.commentContent + '</textarea>';
            htmlData += '<div class="text-muted small mt-1">' + item.updateDt + '</div>';
            htmlData += '</div>';
            if($('#pEmail').val() == item.createUsr) { //'로그인한 사용자=댓글 작성자'라면 수정,삭제 가능
                htmlData += '<button id="btnCommentUpdate" style="width:100px; height:35px; margin:5px;" onclick="fnUpdateCommentYn(' + item.commentId + ')" class="btn btn-warning col-sm-1">수정</button>';
                htmlData += '<button id="btnCommentDelete" style="width:100px; height:35px; margin:5px;" onclick="fnDeleteComment(' + item.commentId + ')" class="btn btn-danger col-sm-1">삭제</button>';
            }
            htmlData += '</div>';
            $('#commentDiv').append(htmlData);
        });
    }).fail(function(request, status, error) {
        gfnFailAlert(error, gDelay_Long);
    });
}

//댓글 수정모드 변경
function fnUpdateCommentYn(commentId) {
    if(gCommentUpdateYn == 'Y') {
        $('#commentContentDiv'+commentId).hide();
        $('#commentContentText'+commentId).show();
        gCommentId = commentId;
        gCommentUpdateYn = 'N';
        return;
    }

    if(gCommentId != commentId) {
        //기존 댓글창 닫기
        $('#commentContentDiv'+gCommentId).show();
        $('#commentContentText'+gCommentId).hide();
        //새 댓글창 수정모드
        $('#commentContentDiv'+commentId).hide();
        $('#commentContentText'+commentId).show();
        gCommentId = commentId;
        return;
    }

    fnUpdateComment(commentId);
    gCommentUpdateYn = 'Y';
}

//댓글 수정
function fnUpdateComment(commentId) {
    let taskId = $("#pTaskId").val();
    let apiUrl = "/rest/user/tasks/" + taskId + "/comments/" + commentId;
    let params = new Object();
    params.commentContent = $('#commentContentText'+commentId).val();

    $.ajax({
        type:'put',
        url: apiUrl,
        data: params,
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        gfnSuccessAlert("댓글이 수정되었습니다.",gDelay_Long);
        $("#commentDiv").empty();
        fnSetComment();
    }).fail(function(request, status, error) {
        gfnFailAlert(error, gDelay_Long);
    });

}

//댓글 삭제
function fnDeleteComment(commentId) {
    let taskId = $("#pTaskId").val();
    let apiUrl = "/rest/user/tasks/" + taskId + "/comments/" + commentId;

    $.ajax({
        type:'delete',
        url: apiUrl,
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        gfnSuccessAlert("댓글이 삭제되었습니다.",5000);
        $("#commentDiv").empty();
        fnSetComment();
    }).fail(function(request, status, error) {
        gfnFailAlert(error, gDelay_Long);
    });

}

//첨부파일 업로드
function fnUploadFile(obj){
    var files = obj.files;

    //아무것도 선택 안하면 그냥 return
    if(files.length < 1) {
        return;
    }

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
        //url:'/rest/files/disk',
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
            filesArr.push(item);
            fnSetFile(fileHeight, item);
        });
        gfnSuccessAlert("파일이 추가되었습니다.",gDelay_Long);
        setTimeout(fnUpdateTask, gDelay_imd);
    }).fail(function(request, status, error) {
        gfnFailAlert(error, gDelay_Long);
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
    const fileTypes =  ['bmp' , 'hwp', 'jpg', 'pdf', 'png', 'xls', 'zip', 'pptx', 'xlsx', 'jpeg', 'doc', 'gif', 'csv', 'tif', 'txt', 'docx'];
    let fileType =  obj.name.split('.').pop().toLowerCase();

    let msg = '';
    if (obj.name.length > 100) {
        msg = "파일명이 100자 이상인 파일은 제외되었습니다.";
        gfnFailAlert(msg, gDelay_Long);
        return false;
    } else if (obj.size > (20 * 1024 * 1024)) {
        msg = "최대 파일 용량인 20MB를 초과한 파일은 제외되었습니다.";
        gfnFailAlert(msg, gDelay_Long);
        return false;
    } else if (obj.name.lastIndexOf('.') == -1) {
        msg = "확장자가 없는 파일은 제외되었습니다.";
        gfnFailAlert(msg, gDelay_Long);
        return false;
    } else if (!fileTypes.includes(fileType)) {
        msg = "첨부가 불가능한 파일은 제외되었습니다.";
        gfnFailAlert(msg, gDelay_Long);
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


// 여기


// ************************* 소유자 팝업 처리 **************************** //
// 소유자 변경 모달 오픈 버튼 클릭
function fnOpenOwnerEmp_Modal() {
    fnResetOwnerEmpAdd_Modal();
    fnInitOwnerEmpGrid_Modal();
}

// 소유자 변경용 사용자팝업 초기화
function fnResetOwnerEmpAdd_Modal() {
    $("#ownerEmpNm_Modal").val("");
    $('#ownerEmpAddTable_Modal').DataTable().rows('.selected').deselect();
}

//소유자 변경 모달의사용자목록 그리드 생성
function fnInitOwnerEmpGrid_Modal() {
    let projectId = $("#pProjectId").val();
    let apiUrl = '/rest/user/projects/emps/' + projectId;

    dtOwnerEmpGrid = $("#ownerEmpAddTable_Modal").DataTable({
        ajax: {
            url : apiUrl,
            type : "POST",
            dataSrc : "data",
            data : function (d) {
                d.empNm = $("#ownerEmpNm_Modal").val();
            }
        },
        autoWidth: false,
        columnDefs: [
            // targets: 컬럼 인덱스를 지정한다 (0부터 시작).
            // width: 원하는 너비를 픽셀(px) 또는 백분율(%)로 지정한다.
            { targets: 0, width: "100px" },    // companyNm
            { targets: 1, width: "100px" },    // companyNm
            // { targets: 2, width: "0px" },   // companyCd (hidden)
            { targets: 3, width: "120px" },    // empNm
            { targets: 4, width: "100px" },    // posNm
            { targets: 5, width: "150px" },    // deptNm (기존 width 재사용)
            { targets: 6, width: "200px" }     // email
        ],
        columns: [
            {data: 'domainId'},
            {data: 'companyNm'},
            {data: 'companyCd', visible: false},
            {data: 'empNm'},
            {data: 'posNm'},
            {data: 'deptNm', width : "150px"},
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

//사용자목록 재조회
function fnReselOwnerEmpGrid_Modal() {
    dtOwnerEmpGrid.ajax.reload();
}

// 모달에서 선택한 사용자를 소유자 항목에 셋팅
function fnSetTaskOwnerEmp_Modal() {
    let buttonStyle = 'vimeo';
    let len = $('#ownerEmpAddTable_Modal').DataTable().rows('.selected').data().length;
    if(len === 0) {
        gfnFailAlert("소유자를 선택해주세요.", gDelay_Medium);
        return;
    }

    $('#ownerEmpAddSpan').empty();
    empOwnerArr.length = 0;
    $('#ownerEmpAdd_Modal').modal('hide');

    let data = $('#ownerEmpAddTable_Modal').DataTable().rows('.selected').data()[0];
    let num = empOwnerHeight;
    let htmlData = '';
    htmlData += '<div class="btn-group me-2" id="empOwnerAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
    htmlData += '<button id="btnEmpOwner' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ data.empNm + '</button>';
    htmlData += '<input type="text" id="empOwnerEmail' + num + '" value="'+ data.email +'" hidden>';
    htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteTaskOwner(' + num + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
    htmlData += '</div>';

    $('#ownerEmpAddSpan').append(htmlData);

    empOwnerArr.push({
        email: data.email,
        domainId : data.domainId,
        companyCd: data.companyCd
    });

    //empOwnerHeight += 1;
    fnResetOwnerEmpAdd_Modal();
}
// ************************* 소유자 팝업 처리 끝 ************************** //

// ************************* 보고자 팝업 처리 **************************** //
// 보고자 변경 모달 오픈 버튼 클릭
function fnOpenReportObjEmp_Modal() {
    fnResetReportObjEmpAdd_Modal();
    fnInitReportObjEmpGrid_Modal();
}

// 보고자 변경용 사용자팝업 초기화
function fnResetReportObjEmpAdd_Modal() {
    $("#reportObjEmpNm_Modal").val("");
    $('#reportObjEmpAddTable_Modal').DataTable().rows('.selected').deselect();
}

//소유자 변경 모달의사용자목록 그리드 생성
function fnInitReportObjEmpGrid_Modal() {
    let projectId = $("#pProjectId").val();
    let apiUrl = '/rest/user/projects/emps/' + projectId;

    dtReportObjEmpGrid = $("#reportObjEmpAddTable_Modal").DataTable({
        ajax: {
            url : apiUrl,
            type : "POST",
            dataSrc : "data",
            data : function (d) {
                d.empNm = $("#reportObjEmpNm_Modal").val();
            }
        },
        autoWidth: false,
        columnDefs: [
            // targets: 컬럼 인덱스를 지정한다 (0부터 시작).
            // width: 원하는 너비를 픽셀(px) 또는 백분율(%)로 지정한다.
            { targets: 0, width: "100px" },    // companyNm
            { targets: 1, width: "100px" },    // companyNm
            // { targets: 2, width: "0px" },   // companyCd (hidden)
            { targets: 3, width: "120px" },    // empNm
            { targets: 4, width: "100px" },    // posNm
            { targets: 5, width: "150px" },    // deptNm (기존 width 재사용)
            { targets: 6, width: "200px" }     // email
        ],
        columns: [
            {data: 'domainId'},
            {data: 'companyNm'},
            {data: 'companyCd', visible: false},
            {data: 'empNm'},
            {data: 'posNm'},
            {data: 'deptNm', width : "150px"},
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

//사용자목록 재조회
function fnReselReportObjEmpGrid_Modal() {
    dtReportObjEmpGrid.ajax.reload();
}

// 모달에서 선택한 사용자를 보고자 항목에 셋팅
function fnSetTaskReportObjEmp_Modal() {
    let buttonStyle = 'facebook';
    let len = $('#reportObjEmpAddTable_Modal').DataTable().rows('.selected').data().length;
    if(len === 0) {
        gfnFailAlert("보고대상자를 선택해주세요.", gDelay_Medium);
        return;
    }

    $('#reportObjEmpAddSpan').empty();
    reportObjEmpArr.length = 0;
    $('#reportObjEmpAdd_Modal').modal('hide');

    let data = $('#reportObjEmpAddTable_Modal').DataTable().rows('.selected').data()[0];
    let num = reportObjEmpHeight;
    let htmlData = '';
    htmlData += '<div class="btn-group me-2" id="reportObjEmpAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
    htmlData += '<button id="btnReportObjEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ data.empNm + '</button>';
    htmlData += '<input type="text" id="reportObjEmpAddEmail' + num + '" value="'+ data.email +'" hidden>';
    htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteReportObjEmpTask(' + num + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
    htmlData += '</div>';

    $('#reportObjEmpAddSpan').append(htmlData);

    reportObjEmpArr.push({
        email: data.email,
        domainId : data.domainId,
        companyCd: data.companyCd
    });

    reportObjEmpHeight += 1;
    fnResetOwnerEmpAdd_Modal();
}
// ************************* 보고자 팝업 처리 끝 ************************** //

// ************************* 상위업무 추가 팝업 처리 ************************** //
function fnSetParentTask() {
    $('#parentTaskAddModal').modal('hide');

    let data = $('#parentTaskTable').DataTable().rows('.selected').data()[0];

    $('#parentTaskAddModal').modal('hide');
    $('#pParentTaskId').val(data.taskId);

    $('#parentTaskGroup').show();
    $('#btnParentTask').text(data.taskNm);

    $('#parentTaskState').val("");
    $('#parentTaskNm').val("");
}

//상위업무 삭제
function fnDeleteParentTask() {
    $('#parentTaskGroup').hide();
    $('#pParentTaskId').val('');
    $('#parentTaskTable').DataTable().row('.selected').deselect();
}

//상위업무 팝업의 업무목록 조회
function fnLoadParentTask() {
    let apiUrl = '/rest/user/tasks/subtasks/parents';

    // TASK 유형이 TASK 이면 EPIC 리스트를 조회
    if (gTaskTypeCd == "CM007CD002") {
        apiUrl = '/rest/user/tasks/parents';
    }
    // TASK 유형이 SUBTASK 이면 TASK 리스트를 조회
    else if (gTaskTypeCd == "CM007CD003") {
        apiUrl = '/rest/user/tasks/subtasks/parents';
    }
    else {
        return;
    }

    dtParents = $("#parentTaskTable").DataTable({
        ajax: {
            url : apiUrl,
            type : 'POST',
            dataSrc : "data",
            data : function (d) {
                d.projectId = $('#pProjectId').val();
                d.taskId = $('#pTaskId').val();
                d.taskState = $("#parentTaskState").val();
                d.taskNm = $("#parentTaskNm").val();
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
            {data: 'taskState', className: 'text-center'},
            {data: 'taskTypeNm', className: 'text-center'},
            {data: 'taskNm', className: 'text-center'},
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
        lengthChange : false,
        lengthMenu : [10, 50, 100, 500],
        select: true,
        loadBeforeSend: function(jqXHR) {
            jqXHR.setRequestHeader("AJAX", "true");
        },
    });
}

//상위업무목록 재조회
function fnReselParents() {
    dtParents.ajax.reload();
}
// ************************* 상위업무 추가 팝업 처리 끝************************** //

// ************************* 하위업무 추가 팝업 처리 *************************** //
// 하위업무 추가 팝업 호출
function fnOpenAddSubTaskModal() {
    // 모달 먼저 오픈
    $('#subTaskNewModal').modal('show');

    try {
        if (Array.isArray(empOwnerArr) && empOwnerArr.length > 0 && empOwnerArr[0]) {
            const owner = empOwnerArr[0];
            const empNm = owner.name || '';
            const email = owner.email || '';

            $('#newSubTaskOwnerMemberNm_Modal').val(empNm);
            $('#newSubTaskOwnerMemberId_Modal').val(email);
        } else {
            $('#newSubTaskOwnerMemberNm_Modal').val('');
            $('#newSubTaskOwnerMemberId_Modal').val('');
        }
    } catch (e) {
        // 예외 발생 시 안전하게 초기화
        $('#newSubTaskOwnerMemberNm_Modal').val('');
        $('#newSubTaskOwnerMemberId_Modal').val('');
    }

    try {
        if (Array.isArray(reportObjEmpArr) && reportObjEmpArr.length > 0 && reportObjEmpArr[0]) {
            const owner = reportObjEmpArr[0];
            const empNm = owner.name || '';
            const email = owner.email || '';

            $('#newSubTaskReportMemberNm_Modal').val(empNm);
            $('#newSubTaskReportMemberId_Modal').val(email);
        } else {
            $('#newSubTaskReportMemberNm_Modal').val('');
            $('#newSubTaskReportMemberId_Modal').val('');
        }
    } catch (e) {
        // 예외 발생 시 안전하게 초기화
        $('#newSubTaskReportMemberNm_Modal').val('');
        $('#newSubTaskReportMemberId_Modal').val('');
    }
}

function fnCloseAddSubTaskModal() {
    $('#subTaskNewModal').modal('hide');
}

// SubTask 등록
function fnAddSubTask() {
    if (!gfnCheckRequired($("#subTaskNewform"))) {
        return;
    }

    let projectId = $("#pProjectId").val();
    let taskId = $("#pTaskId").val();
    let taskOwnerMemberId = $("#newSubTaskOwnerMemberId_Modal").val();
    let taskReportMemberId = $("#newSubTaskReportMemberId_Modal").val();
    let params = new Object();

    // 현재 태스크가 에픽이면
    if (gTaskTypeCd == "CM007CD001") {
        params.taskTypeCd = "CM007CD002"; // 추가되는 태스크는 "태스크"
    }
    // 현재 태스크가 태스크면
    else if (gTaskTypeCd == "CM007CD002") {
        params.taskTypeCd = "CM007CD003"; // 추가되는 태스크는 "서브태스크"
    }
    else {
        return;
    }

    params.projectId = projectId;
    params.taskNm = $("#newSubTaskNm").val();
    params.taskStateCd = $("#subTaskStateCd").val();
    params.taskImportanceCd = "";
    params.taskDetail = "";
    params.taskStartDt = "";
    params.taskEndDt = "";
    params.taskOwnerMemberId = taskOwnerMemberId;
    params.reportMemberId = taskReportMemberId;
    params.taskProgress = "0";
    params.parentTaskId = taskId;
    params.childTaskAddYn = 'N';

    gfnShowLoadingBar();
    $.ajax({
        type:'post',
        url:'/rest/user/subtasks',
        data: params,
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_Insert, gDelay_Short);
        fnLoadChildTask();
        fnCloseAddSubTaskModal();
    }).fail(function(request, status, error) {
        gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, gDelay_Long);
    }).always(function(msg) {
        gfnHideLoadingBar();
    });
}
// ************************* 하위업무 추가 팝업 처리 끝 ************************** //

// ************************* 하위업무 추가 팝업의 소유자검색 팝업 처리 *************************** //
function fnOpenNewSubTaskOwnerMemberAdd_Modal() {
    $('#sutaskOwnerEmpAdd_Modal').modal('show');
}

function fnInitNewSubTaskOwnerMemberAdd_Modal() {
    fnResetSubtaskOwnerEmpAdd_Modal();
    fnInitSubtaskOwnerEmpGrid_Modal();
}

// 소유자 변경용 사용자팝업 초기화
function fnResetSubtaskOwnerEmpAdd_Modal() {
    $("#subtaskOwnerEmpNm_Modal").val("");
    $('#subtaskOwnerEmpAddTable_Modal').DataTable().rows('.selected').deselect();
}

//사용자목록 재조회
function fnReselSubtaskOwnerEmpGrid_Modal() {
    dtSubtaskOwnerEmpGrid.ajax.reload();
}

//소유자 변경 모달의사용자목록 그리드 생성
function fnInitSubtaskOwnerEmpGrid_Modal() {
    let projectId = $("#pProjectId").val();
    let apiUrl = '/rest/user/projects/emps/' + projectId;

    dtSubtaskOwnerEmpGrid = $("#subtaskOwnerEmpAddTable_Modal").DataTable({
        ajax: {
            url : apiUrl,
            type : "POST",
            dataSrc : "data",
            data : function (d) {
                d.empNm = $("#subtaskOwnerEmpNm_Modal").val();
            }
        },
        autoWidth: false,
        columnDefs: [
            // targets: 컬럼 인덱스를 지정한다 (0부터 시작).
            // width: 원하는 너비를 픽셀(px) 또는 백분율(%)로 지정한다.
            { targets: 0, width: "100px" },    // companyNm
            { targets: 1, width: "100px" },    // companyNm
            // { targets: 2, width: "0px" },   // companyCd (hidden)
            { targets: 3, width: "120px" },    // empNm
            { targets: 4, width: "100px" },    // posNm
            { targets: 5, width: "150px" },    // deptNm (기존 width 재사용)
            { targets: 6, width: "200px" }     // email
        ],
        columns: [
            {data: 'domainId'},
            {data: 'companyNm'},
            {data: 'companyCd', visible: false},
            {data: 'empNm'},
            {data: 'posNm'},
            {data: 'deptNm', width : "150px"},
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

//사용자목록 재조회
function fnReselOwnerEmpGrid_Modal() {
    dtSubtaskOwnerEmpGrid.ajax.reload();
}

// 모달에서 선택한 사용자를 소유자 항목에 셋팅
function fnSetSubTaskOwnerEmp_Modal() {
    let data = $('#subtaskOwnerEmpAddTable_Modal').DataTable().rows('.selected').data();
    if(data.length === 0) {
        gfnFailAlert("소유자를 선택해주세요.", gDelay_Medium);
        return;
    }

    let newSubtaskOwnerMemberId = data[0].email;
    let newSubtaskOwnerMemberNm = data[0].empNm;

    if (gSubtaskMemberFlag == "O") {
        $("#newSubTaskOwnerMemberNm_Modal").val(newSubtaskOwnerMemberNm);
        $("#newSubTaskOwnerMemberId_Modal").val(newSubtaskOwnerMemberId);
    }
    else if (gSubtaskMemberFlag == "R") {
        $("#newSubTaskReportMemberNm_Modal").val(newSubtaskOwnerMemberNm);
        $("#newSubTaskReportMemberId_Modal").val(newSubtaskOwnerMemberId);
    }

    fnResetSubtaskOwnerEmpAdd_Modal();
    $('#sutaskOwnerEmpAdd_Modal').modal('hide');
}
// ************************* 하위업무 추가 팝업의 소유자검색 팝업 처리 끝 ************************ //


































































//업무상세 - 참여자 Set
function fnSetTaskEmp(taskEmpList){
	for(let i = 0; i < taskEmpList.length; i++) {
		let num = empHeight+i;
		let htmlData = '';
		let buttonStyle = '';
		if(taskEmpList[i].taskEmpCd == 'CM004CD002') buttonStyle = 'vimeo';
		else if(taskEmpList[i].taskEmpCd == 'CM004CD003') buttonStyle = 'facebook'; 

	    htmlData += '<div class="btn-group me-2" id="empAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
	    htmlData += '<button id="btnEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ gfnUnescapeHTML(taskEmpList[i].empNm) + '</button>';
	    htmlData += '<input type="text" id="empAddEmail' + num + '" value="'+ taskEmpList[i].email +'" hidden>';
	    htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteEmpTask(' + num + ')">';
	    htmlData += '<i class="fas fa-times"></i>';
	    htmlData += '</button>';
	    htmlData += '</div>';
	    
	    $('#empAddSpan').append(htmlData);
	    empArr.push({
    		email: taskEmpList[i].email,
    		companyCd: taskEmpList[i].companyCd,
    		taskEmpCd: taskEmpList[i].taskEmpCd,
    		empNm: taskEmpList[i].empNm
    	});
	    empOrgArr.push({
    		email: taskEmpList[i].email,
    		companyCd: taskEmpList[i].companyCd,
    		taskEmpCd: taskEmpList[i].taskEmpCd
    	});
	}
}








//참여자 추가 modal 클릭
function fnLoadEmpModal() {
	$("#empCompanyCd option:eq(0)").prop("selected", true);
	fnResetEmpAdd();
	fnReselTree();
	fnLoadEmpList();
}

//참여자추가 팝업의 사용자목록 조회
function fnLoadEmpList() {
	let apiUrl = '/rest/user/employees';
	
	dtEmpList = $("#empAddTable").DataTable({
		ajax: {
			url : apiUrl,
			dataSrc : "data",
			data : function (d) {
				d.email = $('#taskOwnerMemberId').val();
				d.empNm = $("#empEmpNm").val();
				d.deptCd = gDeptCd;
				d.companyCd = $("#empCompanyCd").val();
		  }
		},
		columns: [
	        {data: 'companyNm'},
	        {data: 'companyCd', visible: false},
   			{data: 'empNm'},
   			{data: 'posNm'},
   			{data: 'deptNm', width : "150px"},
   			{data: 'email'},
       	],
       	processing: true,
		serverSide: true,
		ordering : false,
       	destroy: true,
       	responsive: true,
       	info: true,
		searching: false,
		scrollY: 380,
		scrollCollapse : false,
		paging : true,
		lengthChange : false,
		lengthMenu : [10, 50, 100, 500],
		select: {
			style: 'multi'
		},
		loadBeforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", "true");
		},
 	});
	gDeptCd = '';
}

//사용자목록 재조회
function fnReselEmpList() {
	dtEmpList.ajax.reload();
}

//참여자추가 팝업에서 선택한 사용자 화면에 Set
function fnSetEmpAdd(style) {
	$('#empAddModal').modal('hide');
	
	let buttonStyle = '';
	if(style == 0) buttonStyle = 'vimeo';
	else buttonStyle = 'facebook';

	let len = $('#empAddTable').DataTable().rows('.selected').data().length;
	
	for(let i = 0; i < len; i++) {
		let data = $('#empAddTable').DataTable().rows('.selected').data()[i];
	
		if(empArr.some(v => v.email === data.email)) {
			gfnFailAlert("이미 추가한 사용자입니다.", gDelay_Long);
			continue;
		}
		
		let num = empHeight+i;
		let htmlData = '';
	    htmlData += '<div class="btn-group me-2" id="empAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
	    htmlData += '<button id="btnEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ data.empNm + '</button>';
	    htmlData += '<input type="text" id="empAddEmail' + num + '" value="'+ data.email +'" hidden>';
	    htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteEmpTask(' + num + ')">';
	    htmlData += '<i class="fas fa-times"></i>';
	    htmlData += '</button>';
	    htmlData += '</div>';
	    
	    $('#empAddSpan').append(htmlData);
	    if(style == 0) {
	    	empArr.push({
	    		email: data.email,
	    		companyCd: data.companyCd,
	    		taskEmpCd: "CM004CD002",
	    		empNm: data.empNm
	    	});
	    }
		else {
			empArr.push({
	    		email: data.email,
	    		companyCd: data.companyCd,
	    		taskEmpCd: "CM004CD003",
	    		empNm: data.empNm
	    	});
		}
	    
	}
	
	empHeight += len;
	fnResetEmpAdd();
}

//참여자 추가 팝업의 부서트리 생성
function fnInitTree() {
	let apiUrl = "/rest/user/depts";
	let params = new Object();
	params.companyCd = $("#empCompanyCd").val();
	
	let deptList = new Array();
  	$.ajax({
		type:'get',
		url:apiUrl,
		data: params,
		dataType:'json',
		success: function(data) {
	        $.each(data, function(idx, item){
	        	if(item.parentDeptCd == '0') deptList[idx] = {id:item.deptCd, parent:'#', text:item.deptNm, icon:'common/common/images/company.png'};
	        	else deptList[idx] = {id:item.deptCd, parent:item.parentDeptCd, text:item.deptNm};
	        });
	        $('#treeDeptList').jstree({
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
	        		$('#treeDeptList').jstree(true).select_node($("#pDeptCd").val());
        	})
	        // 노드 선택시 발생하는 이벤트
	        .bind('select_node.jstree', function(event, data){
		        	$("#empEmpNm").val("");
		        	gDeptCd = data.instance.get_node(data.selected).id;
		          fnReselEmpList();
	        });
		},
		error:function (data) {
		}
	});
}

//부서트리 검색 초기화
function fnResetDeptSearch() {
	gDeptCd = '';
	$("#empDeptNm").val("");
	$("#treeDeptList").jstree("deselect_all");
	$("#treeDeptList").jstree(true).clear_search();
}

//회사 select box 변경
function fnChangeCompany() {
	fnResetEmpAdd();
	fnReselTree();
	fnReselEmpList();
}

//트리 재조회
function fnReselTree() {
	let apiUrl = "/rest/user/depts";
	let params = new Object();
	params.companyCd = $("#empCompanyCd").val();
	let deptList = new Array();
 	$.ajax({
		type:'get',
		url:apiUrl,
		data: params,
		dataType:'json',
		success: function(data) {
				$.each(data, function(idx, item){
	        	if(item.parentDeptCd == '0') deptList[idx] = {id:item.deptCd, parent:'#', text:item.deptNm, icon:'common/common/images/company.png'};
	        	else deptList[idx] = {id:item.deptCd, parent:item.parentDeptCd, text:item.deptNm};
	      });
	  		$('#treeDeptList').jstree(true).settings.core.data = deptList;
	  		$('#treeDeptList').jstree(true).refresh();
	  		$('#treeDeptList').bind("refresh.jstree", function(e,d) {
	  				$('#treeDeptList').jstree(true).select_node($("#pDeptCd").val());
	  		}.bind(this));
		}
	});
}

//사용자팝업 초기화
function fnResetEmpAdd() {
	$("#empEmpNm").val("");
	fnResetDeptSearch();
	$('#empAddTable').DataTable().rows('.selected').deselect();
}

//참여자 삭제
function fnDeleteEmpTask(num) {
	for(let i = 0; i < empArr.length; i++) {
		let email = $('#empAddEmail'+num).val();
		if(empArr[i].email == email) {
			empArr.splice(i, 1);
		}
	}
	$("#empAddGroup" + num).remove();
}

//라벨추가 팝업의 라벨목록 조회
// function fnLoadLabelList() {
// 	let apiUrl = '/rest/user/labels/me';
//
// 	dtLabels = $("#labelAddTable").DataTable({
// 		ajax: {
// 			url : apiUrl,
// 			dataSrc : "data",
// 			data : function (d) {
// 				d.labelNm = $("#labelNm").val();
// 		    }
// 		},
// 		columns: [
// 			{
// 				data : 'labelId',
// 				className: 'text-center',
// 				width : "30px",
// 				render: function (data, type, row, meta) {
// 			        return meta.row + meta.settings._iDisplayStart + 1;
// 			    }
// 			},
//            	{
//            		data: 'labelNm',
//            		className: 'text-center'
//            	},
//        	],
//        	processing: true,
// 		serverSide: true,
// 		ordering : false,
//        	destroy: true,
//        	responsive: true,
//        	info: true,
// 		searching: false,
// 		scrollY: 355,
// 		scrollCollapse : false,
// 		paging : true,
// 		lengthChange : true,
// 		lengthMenu : [10, 50, 100, 500],
// 		select: {
// 			style: 'multi'
// 		},
// 		loadBeforeSend: function(jqXHR) {
// 			jqXHR.setRequestHeader("AJAX", "true");
// 		}
//  	});
// }

//라벨목록 재조회
// function fnReselLabels() {
// 	dtLabels.ajax.reload();
// }


//라벨추가 팝업에서 선택한 라벨 화면에 Set
// function fnSetLabel() {
// 	$('#labelAddModal').modal('hide');
//
// 	let len = $('#labelAddTable').DataTable().rows('.selected').data().length;
//
// 	for(let i = 0; i < len; i++) {
// 		let data = $('#labelAddTable').DataTable().rows('.selected').data()[i];
//
// 		if(labelArr.some(v => v.labelId === data.labelId)) {
// 			gfnFailAlert("이미 추가된 라벨입니다.", gDelay_Long);
// 			continue;
// 		}
//
// 		let num = labelHeight+i;
// 		let htmlData = '';
// 	    htmlData += '<div class="btn-group me-2" id="labelAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
// 	    htmlData += '<button id="btnLabelAdd' + num + '" type="button" class="btn btn-secondary">'+ data.labelNm + '</button>';
// 	    htmlData += '<input type="text" id="labelId' + num + '" value="'+ data.labelId +'" hidden>';
// 	    htmlData += '<button class="btn btn-secondary" type="button" onclick="fnDeleteLabel(' + num + ')">';
// 	    htmlData += '<i class="fas fa-times"></i>';
// 	    htmlData += '</button>';
// 	    htmlData += '</div>';
//
// 	    $('#labelAddSpan').append(htmlData);
// 	    labelArr.push({
//     		labelId: data.labelId
//     	});
// 	}
//
// 	labelHeight += len;
//   	$('#labelAddTable').DataTable().rows('.selected').deselect();
//   	$("#labelNm").val("");
// }

//라벨 삭제
// function fnDeleteLabel(num) {
// 	for(let i = 0; i < labelArr.length; i++) {
// 		let labelId = $('#labelId'+num).val();
// 		if(labelArr[i].labelId == labelId) {
// 			labelArr.splice(i, 1);
// 		}
// 	}
// 	$("#labelAddGroup" + num).remove();
// }















</script>

</body>

</html>