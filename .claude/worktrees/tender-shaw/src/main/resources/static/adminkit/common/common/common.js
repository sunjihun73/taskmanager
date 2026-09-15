'use strict';
const gBuildNo = "20260320";

// text-area 높이 조절
function gfnTextAreaResize(obj) {
    obj.style.height = '1px';
    obj.style.height = (12 + obj.scrollHeight) + 'px';
}

function gfnDaysToMilliseconds(days) {
    return days * 24 * 60 * 60 * 1000;
}