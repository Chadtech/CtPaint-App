module.exports = { 
    exceeded: function() {

        var lastVisit = localStorage.getItem("date last visit");
        var today = new Date().toISOString().slice(0,10);
        if (lastVisit === null) {
            localStorage.setItem("date of last visit", today);
            lastVisit = today;
        }

        var dayVisitsThisMonth = localStorage.getItem("day visits this month");
        if (dayVisitsThisMonth === null) {
            localStorage.setItem("day visits this month", 1);
            dayVisitsThisMonth = 1;
        }

        var thisMonth = today.slice(0, 7);
        var monthOfLastVisit = lastVisit.slice(0, 7);
        if (thisMonth !== monthOfLastVisit) {
            dayVisitsThisMonth = 0;
        }

        if (lastVisit !== today) {
            dayVisitsThisMonth = dayVisitsThisMonth + 1;
            localStorage.setItem("day visits this month", dayVisitsThisMonth);
        }

        return dayVisitsThisMonth > 4;

    }
}