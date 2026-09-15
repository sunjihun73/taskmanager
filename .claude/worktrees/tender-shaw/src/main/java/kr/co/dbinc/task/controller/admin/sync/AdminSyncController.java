package kr.co.dbinc.task.controller.admin.sync;

import jakarta.servlet.http.HttpSession;
import kr.co.dbinc.task.dto.SessionInfoVO;
import kr.co.dbinc.task.util.C;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/admin/syncs")
public class AdminSyncController
{
  @GetMapping(value = "/epsyncform")
  public ModelAndView epsyncform(HttpSession session)
  {
    log.debug("■ AdminSyncController.epsyncform");
    ModelAndView mav = new ModelAndView("/admin/sync/epSyncForm");
    SessionInfoVO sessionInfoVO = (SessionInfoVO)session.getAttribute(C.SESSION_INFO);
    mav.addObject("empNm", sessionInfoVO.getEmpNm());
    mav.addObject("deptNm", sessionInfoVO.getDeptNm());
    return mav;
  }
}
