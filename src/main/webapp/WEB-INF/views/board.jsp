<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ page session="true" %>
<c:set var="loginId" value="${sessionScope.id}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'ID='+=loginId}"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>yongjunos</title>
    <link rel="stylesheet" href="<c:url value='/css/menu.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: "Noto Sans KR", sans-serif;
        }

        .container {
            width: 50%;
            margin: auto;
        }

        .writing-header {
            position: relative;
            margin: 20px 0 0 0;
            padding-bottom: 10px;
            border-bottom: 1px solid #323232;
        }

        input {
            width: 100%;
            height: 35px;
            margin: 5px 0px 10px 0px;
            border: 1px solid #e9e8e8;
            padding: 8px;
            background: #f8f8f8;
            outline-color: #e6e6e6;
        }

        textarea {
            width: 100%;
            background: #f8f8f8;
            margin: 5px 0px 10px 0px;
            border: 1px solid #e9e8e8;
            resize: none;
            padding: 8px;
            outline-color: #e6e6e6;
        }

        .frm {
            width: 100%;
        }

        .btn {
            background-color: rgb(236, 236, 236); /* Blue background */
            border: none; /* Remove borders */
            color: black; /* White text */
            padding: 6px 12px; /* Some padding */
            font-size: 16px; /* Set a font size */
            cursor: pointer; /* Mouse pointer on hover */
            border-radius: 5px;
        }

        .btn:hover {
            text-decoration: underline;
        }

        .comment-container {
            margin-top: 20px;
            border-top: 1px solid #ccc;
            padding-top: 20px;
        }

        #comment-form {
            margin-bottom: 20px;
        }

        #comment-form textarea {
            width: 100%;
            height: 80px;
            margin-bottom: 10px;
        }

        #commentList {
            border-top: 1px solid #eee;
        }

        .comment-item {
            border-bottom: 1px solid #eee;
            padding: 10px 0;
        }

        .nested-comment {
            margin-left: 30px;
            border-left: 2px solid #ddd;
            padding-left: 10px;
        }

        .comment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 5px;
        }

        .commenter {
            font-weight: bold;
        }

        .comment-date {
            font-size: 0.8em;
            color: #888;
        }

        .comment-body {
            margin-bottom: 5px;
        }

        .comment-actions {
            font-size: 0.9em;
        }

        .comment-actions a {
            margin-right: 10px;
            color: #4a4a4a;
            text-decoration: none;
        }

        .comment-actions a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div id="menu">
    <ul>
        <li id="logo">yongjunos</li>
        <li><a href="<c:url value='/'/>">Home</a></li>
        <li><a href="<c:url value='/board/list'/>">Board</a></li>
        <li><a href="<c:url value='${loginOutLink}'/>">${loginOut}</a></li>
        <li><a href="<c:url value='/register/add'/>">Sign in</a></li>
        <li><a href=""><i class="fa fa-search"></i></a></li>
    </ul>
</div>
<script>
    let msg = "${msg}";
    if (msg == "WRT_ERR") alert("게시물 등록에 실패하였습니다. 다시 시도해 주세요.");
    if (msg == "MOD_ERR") alert("게시물 수정에 실패하였습니다. 다시 시도해 주세요.");
</script>
<div class="container">
    <h2 class="writing-header">게시판 ${mode=="new" ? "글쓰기" : "읽기"}</h2>
    <form id="form" class="frm" action="" method="post">
        <input type="hidden" name="bno" value="${boardDto.bno}">

        <input name="title" type="text" value="${boardDto.title}"
               placeholder="  제목을 입력해 주세요." ${mode=="new" ? "" : "readonly='readonly'"}><br>
        <textarea name="content" rows="20"
                  placeholder=" 내용을 입력해 주세요." ${mode=="new" ? "" : "readonly='readonly'"}>${boardDto.content}</textarea><br>

        <c:if test="${mode eq 'new'}">
            <button type="button" id="writeBtn" class="btn btn-write"><i class="fa fa-pencil"></i> 등록</button>
        </c:if>
        <c:if test="${mode ne 'new'}">
            <button type="button" id="writeNewBtn" class="btn btn-write"><i class="fa fa-pencil"></i> 글쓰기</button>
        </c:if>
        <c:if test="${boardDto.writer eq loginId}">
            <button type="button" id="modifyBtn" class="btn btn-modify"><i class="fa fa-edit"></i> 수정</button>
            <button type="button" id="removeBtn" class="btn btn-remove"><i class="fa fa-trash"></i> 삭제</button>
        </c:if>
        <button type="button" id="listBtn" class="btn btn-list"><i class="fa fa-bars"></i> 목록</button>
    </form>

    <div class="comment-container">
        <h3>댓글</h3>
        <div id="comment-form">
            <textarea name="comment" placeholder="댓글을 입력해 주세요."></textarea>
            <button id="sendComment" class="btn">댓글 작성</button>
        </div>
        <div id="commentList"></div>
    </div>
</div>
<script>
    $(document).ready(function () {
        let formCheck = function () {
            let form = document.getElementById("form");
            if (form.title.value == "") {
                alert("제목을 입력해 주세요.");
                form.title.focus();
                return false;
            }

            if (form.content.value == "") {
                alert("내용을 입력해 주세요.");
                form.content.focus();
                return false;
            }
            return true;
        }

        $("#writeNewBtn").on("click", function () {
            location.href = "<c:url value='/board/write'/>";
        });

        $("#writeBtn").on("click", function () {
            let form = $("#form");
            form.attr("action", "<c:url value='/board/write'/>");
            form.attr("method", "post");

            if (formCheck())
                form.submit();
        });

        $("#modifyBtn").on("click", function () {
            let form = $("#form");
            let isReadonly = $("input[name=title]").attr('readonly');

            // 1. 읽기 상태이면, 수정 상태로 변경
            if (isReadonly == 'readonly') {
                $(".writing-header").html("게시판 수정");
                $("input[name=title]").attr('readonly', false);
                $("textarea").attr('readonly', false);
                $("#modifyBtn").html("<i class='fa fa-pencil'></i> 등록");
                return;
            }

            // 2. 수정 상태이면, 수정된 내용을 서버로 전송
            form.attr("action", "<c:url value='/board/modify${searchCondition.queryString}'/>");
            form.attr("method", "post");
            if (formCheck())
                form.submit();
        });

        $("#removeBtn").on("click", function () {
            if (!confirm("정말로 삭제하시겠습니까?")) return;

            let form = $("#form");
            form.attr("action", "<c:url value='/board/remove${searchCondition.queryString}'/>");
            form.attr("method", "post");
            form.submit();
        });

        $("#listBtn").on("click", function () {
            location.href = "<c:url value='/board/list${searchCondition.queryString}'/>";
        });
    });
</script>

<script>
    $(document).ready(function () {
        // ... 기존 게시글 관련 스크립트 유지 ...

        // 댓글 기능
        let bno = ${boardDto.bno};

        let showList = function (bno) {
            $.ajax({
                type: 'GET',
                url: '/ch4/comments?bno=' + bno,
                success: function (result) {
                    $("#commentList").html(toHtml(result));
                },
                error: function () {
                    alert("댓글 목록을 가져오는데 실패했습니다.")
                }
            });
        }

        $("#sendComment").click(function () {
            let comment = $("textarea[name=comment]").val();
            let pcno = $("#comment-form").data("pcno") || 0;  // 부모 댓글 번호, 없으면 0

            if (comment.trim() == '') {
                alert("댓글을 입력해주세요.");
                $("textarea[name=comment]").focus()
                return;
            }

            $.ajax({
                type: 'POST',
                url: '/ch4/comments?bno=' + bno,
                headers: {"content-type": "application/json"},
                data: JSON.stringify({bno: bno, pcno: pcno, comment: comment}),
                success: function (result) {
                    alert("댓글이 등록되었습니다.");
                    showList(bno);
                    $("textarea[name=comment]").val('');
                    $("#comment-form").data("pcno", 0);  // 폼 초기화
                },
                error: function () {
                    alert("댓글 등록에 실패했습니다.")
                }
            });
        });

        $("#commentList").on("click", ".delBtn", function () {
            let cno = $(this).closest(".comment-item").data("cno");
            let bno = $(this).closest(".comment-item").data("bno");

            $.ajax({
                type: 'DELETE',
                url: '/ch4/comments/' + cno + '?bno=' + bno,
                success: function (result) {
                    alert("댓글이 삭제되었습니다.");
                    showList(bno);
                },
                error: function () {
                    alert("댓글 삭제에 실패했습니다.")
                }
            });
        });

        $("#commentList").on("click", ".replyBtn", function () {
            let cno = $(this).closest(".comment-item").data("cno");
            $("#comment-form").data("pcno", cno);
            $("textarea[name=comment]").focus().val("@" + $(this).siblings(".commenter").text() + " ");
        });


        $("#commentList").on("click", ".modBtn", function () {
            let cno = $(this).closest(".comment-item").data("cno");
            let comment = prompt("수정할 내용을 입력하세요.");

            console.log("Sending PATCH request:", {cno: cno, comment: comment});

            $.ajax({
                type: 'PATCH',
                url: '/ch4/comments/' + cno,
                headers: {"content-type": "application/json"},
                data: JSON.stringify({cno: cno, comment: comment}),
                success: function (result) {
                    console.log("PATCH request successful:", result);
                    showList(bno);
                },
                error: function (xhr, status, error) {
                    console.error("PATCH request failed:", status, error);
                    alert("댓글 수정에 실패했습니다.");
                }
            });
        });

        let toHtml = function (comments) {
            let tmp = "";

            comments.forEach(function (comment) {
                tmp += '<div class="comment-item ' + (comment.pcno !== 0 ? 'nested-comment' : '') + '" data-cno="' + comment.cno + '" data-bno="' + comment.bno + '" data-pcno="' + comment.pcno + '">';
                tmp += '    <div class="comment-header">';
                tmp += '        <span class="commenter">' + comment.commenter + '</span>';
                tmp += '        <span class="comment-date">' + formatDate(comment.up_date) + '</span>';
                tmp += '    </div>';
                tmp += '    <div class="comment-body">' + comment.comment + '</div>';
                tmp += '    <div class="comment-actions">';
                tmp += '        <a href="#" class="replyBtn">답글</a>';
                if (comment.commenter === "${loginId}") {
                    tmp += '        <a href="#" class="modBtn">수정</a>';
                    tmp += '        <a href="#" class="delBtn">삭제</a>';
                }
                tmp += '    </div>';
                tmp += '</div>';
            })
            return tmp;
        }

        function formatDate(dateString) {
            let date = new Date(dateString);
            return date.toLocaleString();
        }

        // 페이지 로드 시 댓글 목록 표시
        showList(bno);
    });
</script>
</body>
</html>