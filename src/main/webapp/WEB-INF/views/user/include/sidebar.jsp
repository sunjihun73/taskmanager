<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav id="sidebar" class="sidebar js-sidebar">
	<div class="sidebar-content js-simplebar">
		<a class="sidebar-brand" href="/user/dashboards/dashboardform">
			<span class="sidebar-brand-text align-middle">
				C.O. Task Manager
<!-- 				<sup><small class="badge bg-primary text-uppercase">Pro</small></sup> -->
			</span>
			<svg class="sidebar-brand-icon align-middle" width="32px" height="32px" viewBox="0 0 24 24" fill="none" stroke="#FFFFFF" stroke-width="1.5"
				stroke-linecap="square" stroke-linejoin="miter" color="#FFFFFF" style="margin-left: -3px">
				<path d="M12 4L20 8.00004L12 12L4 8.00004L12 4Z"></path>
				<path d="M20 12L12 16L4 12"></path>
				<path d="M20 16L12 20L4 16"></path>
			</svg>
		</a>

		<div class="sidebar-user">
			<div class="d-flex justify-content-center">
				<div class="flex-shrink-0">
					<img src="/adminkit/img/avatars/user.png" class="avatar img-fluid rounded me-1" alt="Charles Hall" />
				</div>
				<div class="flex-grow-1 ps-2">
					<div class="sidebar-user-title"><c:out value="${empNm}"/></div>
<!--					<a class="sidebar-user-title dropdown-toggle" href="#" data-bs-toggle="dropdown"><c:out value="${empNm}"/></a> -->
<!--					<div class="dropdown-menu dropdown-menu-start">
<!-- 						<a class="dropdown-item" href="pages-profile.html"><i class="align-middle me-1" data-feather="user"></i> Profile</a> -->
<!-- 						<a class="dropdown-item" href="#"><i class="align-middle me-1" data-feather="pie-chart"></i> Analytics</a> -->
<!-- 						<div class="dropdown-divider"></div> -->
<!-- 						<a class="dropdown-item" href="pages-settings.html"><i class="align-middle me-1" data-feather="settings"></i> Settings & Privacy</a> -->
<!--						<a class="dropdown-item" href="https://docs.google.com/document/d/e/2PACX-1vQ6WGf5MAOEhZDA1-z6accOQvSO2IBKup4MP1PkCGTgzbuBUHUEajj88OGGtBDFgB_j5XziPnHQjnMy/pub" target="_blank"><i class="align-middle me-1" data-feather="help-circle"></i> Help Center</a> -->
<!--						<div class="dropdown-divider"></div> -->
<!--						<c:forEach var="item" items="${empAuthorities}" varStatus="status"> -->
<!--							<c:if test="${item.authorityName == 'ROLE_ADMIN'}"> -->
<!--								<a id="adminDiv" class="dropdown-item" href="/page/admtaskmng/usermngform"><i class="align-middle me-1" data-feather="user"></i> Admin</a> -->
<!--							</c:if>	-->
<!--						</c:forEach> -->
<!--						<a class="dropdown-item" href="/auth/taskmng/ssologout"><i class="align-middle me-1" data-feather="log-out"></i> Log out</a> -->
<!--					</div> -->

					<div class="sidebar-user-subtitle"><c:out value="${deptNm}"/></div>
				</div>
			</div>
		</div>

		<ul class="sidebar-nav">
			<li class="sidebar-header">
				Task Manager Menus
			</li>
			
			<li class="sidebar-item" id="dashboard">
				<a class="sidebar-link" href="/user/dashboards/dashboardform">
					<i class="align-middle" data-feather="grid"></i> <span class="align-middle">대시보드</span>
				</a>
			</li>

			<li class="sidebar-item" id="tasks">
				<a class="sidebar-link" href="/user/tasks/tasksform">
					<i class="align-middle" data-feather="file"></i> <span class="align-middle">태스크</span>
				</a>
			</li>

            <li class="sidebar-item" id="projectManage">
                <a data-bs-target="#projectSide" data-bs-toggle="collapse" class="sidebar-link collapsed">
                    <i class="align-middle" data-feather="folder"></i> <span class="align-middle">프로젝트</span>
                </a>
                <ul id="projectSide" class="sidebar-dropdown list-unstyled collapse " data-bs-parent="#sidebar">
                    <li class="sidebar-item" id="projectaddform"><a class="sidebar-link" href="/user/projects/projectaddform">프로젝트등록</a></li>
                    <li class="sidebar-item" id="projectsform"><a class="sidebar-link" href="/user/projects/projectsform">프로젝트목록</a></li>
                </ul>
            </li>

<%--            <li class="sidebar-item" id="taskManage">--%>
<%--				<a data-bs-target="#taskSide" data-bs-toggle="collapse" class="sidebar-link collapsed">--%>
<%--					<i class="align-middle" data-feather="file"></i> <span class="align-middle">태스크관리</span>--%>
<%--				</a>--%>
<%--				<ul id="taskSide" class="sidebar-dropdown list-unstyled collapse " data-bs-parent="#sidebar">--%>
<%--					<li class="sidebar-item" id="taskaddform"><a class="sidebar-link" href="/user/tasks/taskaddform">태스크등록</a></li>--%>
<%--					<li class="sidebar-item" id="tasksform"><a class="sidebar-link" href="/user/tasks/tasksform">태스크목록</a></li>--%>
<%--					<li class="sidebar-item" id="calendarform"><a class="sidebar-link" href="/user/tasks/calendarform">캘린더</a></li>--%>
<%--					<li class="sidebar-item" id="statisticsform"><a class="sidebar-link" href="/user/tasks/statisticsform">태스크통계</a></li>--%>
<%--				</ul>--%>
<%--			</li>--%>



<%--			<li class="sidebar-item" id="labelManage">--%>
<%--				<a data-bs-target="#labelSide" data-bs-toggle="collapse" class="sidebar-link">--%>
<%--					<i class="align-middle" data-feather="bookmark"></i> <span class="align-middle">라벨관리</span>--%>
<%--				</a>--%>
<%--				<ul id="labelSide" class="sidebar-dropdown list-unstyled collapse " data-bs-parent="#sidebar">--%>
<%--					<li class="sidebar-item" id="labels"><a class="sidebar-link" href="/user/labels/labelsform">라벨 목록/등록</a></li>--%>
<%--				</ul>--%>
<%--			</li>--%>
			<li class="sidebar-item" id="reportTaskManage">
				<a data-bs-target="#reportTaskSide" data-bs-toggle="collapse" class="sidebar-link">
					<i class="align-middle" data-feather="list"></i> <span class="align-middle">일일업무보고</span>
				</a>
				<ul id="reportTaskSide" class="sidebar-dropdown list-unstyled collapse " data-bs-parent="#sidebar">
					<li class="sidebar-item" id="reportTaskAdd"><a class="sidebar-link" href="/user/reporttasks/reporttaskaddform">일일업무보고작성</a></li>
					<li class="sidebar-item" id="tempReportTasks"><a class="sidebar-link" href="/user/reporttasks/tempreporttasksform">임시저장목록</a></li>
					<li class="sidebar-item" id="sendReportTasks"><a class="sidebar-link" href="/user/reporttasks/sendreporttasksform">보고목록</a></li>
					<li class="sidebar-item" id="recvReportTasks"><a class="sidebar-link" href="/user/reporttasks/recvreporttasksform">수신목록</a></li>
				</ul>
			</li>			
		</ul>
	</div>
</nav>