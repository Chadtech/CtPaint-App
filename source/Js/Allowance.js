module.exports = {
    exceeded: function() {
        var lastVisit = localStorage.getItem("date of last visit");
        var today = new Date().toISOString().slice(0, 10);
        localStorage.setItem("date of last visit", today);
        if (typeof lastVisit === "undefined") {
            lastVisit = today;
        }

        var dayVisitsThisMonth = Number(
            localStorage.getItem("day visits this month")
        );

        var thisMonth = today.slice(0, 7);
        var monthOfLastVisit = lastVisit.slice(0, 7);
        if (thisMonth !== monthOfLastVisit) {
            dayVisitsThisMonth = 0;
        }

        if (lastVisit !== today) {
            dayVisitsThisMonth = dayVisitsThisMonth + 1;
        }

        localStorage.setItem("day visits this month", dayVisitsThisMonth);

        return dayVisitsThisMonth > 4;
    }
};
