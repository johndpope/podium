var questionCount = 0;
var activeInterview = { title: "Can't Connect to Server", questions: ["No Interviews have been loaded, check your connection."] };
var interviews = "";

var buttonList = ["job","pres","school"];
var activeButton = "";

//timer
var stInterview;
var stQuestion;
var Now;
var interviewTimer;


/**
 * Notification that the UI is about to transition to a new screen.
 * Perform custom prescreen-transition logic here.
 * @param {String} currentScreenId 
 * @param {String} targetScreenId 
 * @returns {boolean} true to continue transtion; false to halt transition
 */
phoneui.prePageTransition = function (currentScreenId, targetScreenId) {
    // add custom pre-transition code here
    // return false to terminate transition
    return true;
}

/**
 * Notification that the UI has transitioned to a new screen.
 * 
 * @param {String} newScreenId 
 */
phoneui.postPageTransition = function (newScreenId) {

}

/**
 * Notification that the page's HTML/CSS/JS is about to be loaded.
 * Perform custom logic here, f.e. you can cancel request to the server.
 * @param {String} targetScreenId 
 * @returns {boolean} true to continue loading; false to halt loading
 */
phoneui.prePageLoad = function (targetScreenId) {
    // add custom pre-load code here
    // return false to terminate page loading, this cancels transition to page as well
    return true;
}

/**
 * Notification that device orientation has changed. 
 * 
 * @param {String} newOrientation 
 */
phoneui.postOrientationChange = function (newOrientation) {

}

/**
 * Called when document is loaded.
 */
phoneui.documentReadyHandler = function () {
    $("#m1-autismSees-questionArea").animate({ height: 0, }, 800);
    Parse.initialize("akQJpMYert30j76vXgGsnWRYRd88BsSCIWAqNKMB", "SER4SybPsX1Dq88yxdUqHzAplYwAdXB4rO9iCSnA");
    pullInterviewData();

    //hide the timers untill there is something to do with them
    $("#m1-autismSees-OverallQuestionTimeTime").hide();
    $("#m1-autismSees-").hide();
}
function nextQuestion() {
    questionCount++;
    $("#m1-autismSees-html2").html("");
    loadQuestion(activeInterview, questionCount);
    alert("xx");
     sendToApp("ios-log", "asda");
}

function firstQuestion() {
    stInterview = setTimeStart();
    stQuestion = setTimeStart();
    interviewTimer = window.setInterval(function () { updateTime() }, 1000);

    var intCount = $('#m1-autismSees-list2 >.m1-selected').index();
    activeInterview = interviews[intCount];
    activeButton = activeInterview.id;
    loadQuestion(activeInterview, questionCount);
}
function loadQuestion(interview, counter) {
    stQuestion = setTimeStart();
    if (counter < interview.questions.length) {
        var qText = interview.questions[counter];
        phoneui.gotoMultiPagePage('m1-autismSees-multiPage1', 'SET_PAGE', 'm1-autismSees-question', phoneui.transitions.slideLeft);

        words = qText.split(" ");
        var html = "";
        for (var i = 0; i < words.length; i++) {
            html += "<span style='opacity: 0'>" + words[i] + " </span>";
        }
        $("#m1-autismSees-html2").html(html);
        $("#m1-autismSees-html2").children().each(function (i) {
            return $(this).delay(i * 200).fadeTo(1500,1);
        });
    } else {
        questionCount = 0;
        phoneui.gotoMultiPagePage('m1-autismSees-multiPage1', 'SET_PAGE', 'm1-autismSees-start', phoneui.transitions.slideRight);
        $("#" + activeButton + ">label").css("color", "lightgray");
        clearInterval(interviewTimer);
        clearTime();
    }
}

//timer functions disabled
function updateTime() {
//    var d = new Date();
//    var n = d.getTime();
//    $("#m1-autismSees-OverallTime").text("interview timer: "+(Math.round((n-stInterview)/1000)).toString());
//    $("#m1-autismSees-QuestionTime").text("question timer: "+(Math.round((n-stQuestion)/1000)).toString());
}
function setTimeStart(){
//    var d = new Date();
//    return d.getTime();
}
function clearTime() {
//    $("#m1-autismSees-OverallTime").text((0).toString() + " seconds");
//    $("#m1-autismSees-QuestionTime").text((0).toString() + " seconds");
}

function pullInterviewData() {
    var iPresentWell_Data = Parse.Object.extend("iPresentWell_Data");
    var query = new Parse.Query(iPresentWell_Data);
    query.get("IWUt7oXZsA", {
        success: function (iPresentWell_Data) {
            interviews = iPresentWell_Data.get("interviews");
            buildInterviewList(interviews);
        },
        error: function (object, error) {
            alert("check internet connection");
        }
    });
}
function buildInterviewList(newInterviews) {
    // Array of items to fill SL
    var items = ["First", "Second", "Third"];
    // Selected item index
    var selItemIndex = 0;
    // Store old items (will remove them later)
    var olditems = $('#m1-autismSees-list2').children();
    // First of old items is our template
    var templ = $(olditems[0]);

    // Do for each data item
    for (var i = 0 ; i < newInterviews.length ; i++) {
        // Clone template
        var clone = templ.clone();
        // Set correct value for "first" class
        clone[(-5 == 0) ? "addClass" : "removeClass"](m1Design.css('first'));
        // Set correct value for "last" class
        clone[(-5 == (items.length - 1)) ? "addClass" : "removeClass"](m1Design.css('last'));
        // Process selected item
        clone[(i == selItemIndex) ? "addClass" : "removeClass"](m1Design.css('selected'));
        clone.attr('data-val', "val" + i);
        clone.attr("id",newInterviews[i].id);
        // Set text label
        clone.find('label').text(newInterviews[i].title);
        // We're done, add element to list item

        clone.appendTo(templ.parent());
    }
    olditems.remove();

    var panelHt = newInterviews.length * 84;
    $('#m1-autismSees-panel1-scroller').attr('data-layout-content-height', panelHt);
    phoneui.preprocessDOM(phoneui.getCurrentPageId());
    phoneui.forceLayout();
}