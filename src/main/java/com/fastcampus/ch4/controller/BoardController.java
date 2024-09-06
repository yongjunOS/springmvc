package com.fastcampus.ch4.controller;

import com.fastcampus.ch4.domain.BoardDto;
import com.fastcampus.ch4.domain.PageHandler;
import com.fastcampus.ch4.domain.SearchCondition;
import com.fastcampus.ch4.service.BoardService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

@Controller
@RequestMapping("/board")
public class BoardController {

    private static final Logger logger = LoggerFactory.getLogger(BoardController.class);

    @Autowired
    BoardService boardService;

    @PostMapping("/modify")
    public String modify(BoardDto boardDto, SearchCondition sc, RedirectAttributes rattr, Model m, HttpSession session) {
        String writer = (String)session.getAttribute("id");
        boardDto.setWriter(writer);

        logger.info("Modifying board: {}", boardDto);

        try {
            if (boardService.modify(boardDto)!= 1)
                throw new Exception("Modify failed.");

            rattr.addFlashAttribute("msg", "MOD_OK");
            return "redirect:/board/list"+sc.getQueryString();
        } catch (Exception e) {
            logger.error("Error modifying board", e);
            m.addAttribute(boardDto);
            m.addAttribute("msg", "MOD_ERR");
            return "board";
        }
    }

    @GetMapping("/write")
    public String write(Model m) {
        logger.info("Accessed write page");
        m.addAttribute("mode", "new");
        return "board";
    }

    @PostMapping("/write")
    public String write(BoardDto boardDto, RedirectAttributes rattr, Model m, HttpSession session) {
        String writer = (String)session.getAttribute("id");
        boardDto.setWriter(writer);

        logger.info("Writing new board: {}", boardDto);

        try {
            if (boardService.write(boardDto) != 1)
                throw new Exception("Write failed.");

            rattr.addFlashAttribute("msg", "WRT_OK");
            return "redirect:/board/list";
        } catch (Exception e) {
            logger.error("Error writing new board", e);
            m.addAttribute(boardDto);
            m.addAttribute("mode", "new");
            m.addAttribute("msg", "WRT_ERR");
            return "board";
        }
    }

    @GetMapping("/read")
    public String read(Integer bno, SearchCondition sc, RedirectAttributes rattr, Model m) {
        logger.info("Reading board with bno: {}", bno);
        try {
            BoardDto boardDto = boardService.read(bno);
            m.addAttribute(boardDto);
            logger.info("Board read successfully: {}", boardDto);
        } catch (Exception e) {
            logger.error("Error reading board with bno: " + bno, e);
            rattr.addFlashAttribute("msg", "READ_ERR");
            return "redirect:/board/list"+sc.getQueryString();
        }

        return "board";
    }

    @PostMapping("/remove")
    public String remove(Integer bno, SearchCondition sc, RedirectAttributes rattr, HttpSession session) {
        String writer = (String)session.getAttribute("id");
        String msg = "DEL_OK";

        logger.info("Removing board with bno: {}, writer: {}", bno, writer);

        try {
            if(boardService.remove(bno, writer)!=1)
                throw new Exception("Delete failed.");
            logger.info("Board removed successfully");
        } catch (Exception e) {
            logger.error("Error removing board with bno: " + bno, e);
            msg = "DEL_ERR";
        }

        rattr.addFlashAttribute("msg", msg);
        return "redirect:/board/list"+sc.getQueryString();
    }
    @GetMapping("/list")
    public String list(Model m, SearchCondition sc, HttpServletRequest request) {
        if(!loginCheck(request)) {
            logger.info("User not logged in. Redirecting to login page.");
            return "redirect:/login/login?toURL="+request.getRequestURL();
        }

        try {
            int totalCnt = boardService.getSearchResultCnt(sc);
            m.addAttribute("totalCnt", totalCnt);

            PageHandler pageHandler = new PageHandler(totalCnt, sc);

            List<BoardDto> list = boardService.getSearchResultPage(sc);
            m.addAttribute("list", list);
            m.addAttribute("ph", pageHandler);

            Instant startOfToday = LocalDate.now().atStartOfDay(ZoneId.systemDefault()).toInstant();
            m.addAttribute("startOfToday", startOfToday.toEpochMilli());

            logger.info("Board list retrieved successfully. Total count: {}", totalCnt);
        } catch (Exception e) {
            logger.error("Error retrieving board list", e);
            m.addAttribute("msg", "LIST_ERR");
            m.addAttribute("totalCnt", 0);
        }

        return "boardList";
    }

    private boolean loginCheck(HttpServletRequest request) {
        // 1. 세션을 얻어서(false는 session이 없어도 새로 생성하지 않는다. 반환값 null)
        HttpSession session = request.getSession(false);
        // 2. 세션에 id가 있는지 확인, 있으면 true를 반환
        return session!=null && session.getAttribute("id")!=null;
    }
}