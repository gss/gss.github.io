(->
  
  rootClassList = document.getElementsByTagName("html")[0].classList
  
  count = 0
  #console.time "FIRST LOAD"
  onSolved = ->
    count++
    if count is 2
      rootClassList.add "app-ready"
      rootClassList.remove "app-not-ready"
      #console.timeEnd "FIRST LOAD"
      document.body.removeEventListener "solved", onSolved

  document.body.addEventListener "solved", onSolved
  
)()