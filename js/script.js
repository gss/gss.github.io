(function() {
  var count, onSolved, rootClassList;
  rootClassList = document.getElementsByTagName("html")[0].classList;
  count = 0;
  onSolved = function() {
    count++;
    if (count === 2) {
      rootClassList.add("app-ready");
      rootClassList.remove("app-not-ready");
      return document.body.removeEventListener("solved", onSolved);
    }
  };
  return document.body.addEventListener("solved", onSolved);
})();
