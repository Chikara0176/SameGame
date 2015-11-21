window.app =
  define:
    x_axis : 5
    y_axis : 5
    num : 2
    first : [@y_axis]
    delarray : []
    cparray : []
    opacity: []
    round: 0
    color: ['#000', '#0ff', '#ff0', '#f0f', '#f00', '#0f0', '#bb0', '#f50', '#940', '#069', '#39d']

  #画面の生成
  initialize: ->
    @createBlock()
    @addColor()
    @bindBlock()
    @opacity()

  createBlock: ->
    @define.cparray = []
    @define.first = []
    @define.delarray = []

    for y in [0...@define.y_axis]
      @define.first[y] = new Array @define.x_axis
      $('#stage').append "<div class='line'></div>"
      for x in [0...@define.x_axis]
        innum  = _.random 1, @define.num
        @define.first[y][x] = innum
        $('#stage > .line:last-child').append """<div id="#{y}_#{x}" class="block" data-y="#{y}" data-x="#{x}" data-num="#{innum}">#{@define.first[y][x]}</div>"""
      @define.cparray = $.extend(true, [], @define.first)
    $('.block').css 'width':'50px','height':'50px', 'margin':'1px', 'float':'left'

  #数字の色付け
  addColor: ->
    for y in [0...@define.y_axis]
      for x in [0...@define.x_axis]
        $("##{y}_#{x}").css 'background-color': @define.color[Number $("##{y}_#{x}").html()]

  #ボタンが押されたら
  bindBlock: ->
    self = @
    $('.block').bind 'click', ->
      delarray = self.define.delarray
      cparray = self.define.cparray
      x = parseInt $(@).attr 'data-x'
      y = parseInt $(@).attr 'data-y'
      check = parseInt $(@).text()
      self.search y, x, check, cparray, self.define.delarray
      if delarray.length is 1
        cparray[y][x] = check
        $("##{y}_#{x}").text "#{check}"
      self.del(delarray,cparray)
      self.addColor()
      self.score self.define.delarray.length
      self.define.delarray = []
      self.resetopacity()
      app.define.opacity = []
      evt = $.Event('mouseover')
      $("##{y}_#{x}").trigger evt
      self.fincheck cparray

  #隣接する数字の探索
  search: (y,x,check,cparray,pushArray) ->
    return if y < 0 or y >= @define.y_axis or x < 0 or x >= @define.x_axis
    return if cparray[y][x] isnt check
    return if cparray[y][x] is 0
    pushArray.push x: x, y: y
    cparray[y][x] = 0
    @search y-1, x, check, cparray, pushArray
    @search y+1, x, check, cparray, pushArray
    @search y, x-1, check, cparray, pushArray
    @search y, x+1, check, cparray, pushArray
    return

  #削除メソッド
  del: (delarray,cparray) ->
    if delarray.length is 0
      return
    #縦に詰める
    for x in [0...@define.x_axis]
      for y in [0...@define.y_axis]
        if cparray[y][x] is 0
          ypos = y - 1
          while ypos >= 0
            if cparray[ypos][x] != 0
              cparray[ypos+1][x] = cparray[ypos][x]
              cparray[ypos][x] = 0
            ypos--
    #横に詰める
    fixy = @define.y_axis-1
    j = 0
    while j < 10
      for x in [0...@define.x_axis-1]
        if cparray[fixy][x] is 0
          xpos = x + 1
          ypos = @define.y_axis - 1
          while ypos >= 0
            cparray[ypos][x] = cparray[ypos][xpos]
            cparray[ypos][xpos] = 0
            ypos--
      j++
    # htmlに反映
    for cpx,i  in cparray
      for cpy,j in cpx
        $("##{i}_#{j}").text "#{cpy}"

  # 終了判定
  fincheck: (cparray) ->
    for x in [0...@define.x_axis]
      for y in [0...@define.y_axis]
        check = cparray[y][x]
        continue if cparray[y][x] is 0

        if x+1 < @define.x_axis
          return if cparray[y][x+1] is check
        if x-1 >=0
          return if cparray[y][x-1] is check
        if y+1 < @define.y_axis
          return if cparray[y+1][x] is check
        if y-1 >= 0
          return if cparray[y-1][x] is check
    score = Number $('#score').text()
    if cparray[@define.y_axis-1][0] is 0
      @bonus()
      alert "clear!#{score}"
    else
      alert "failure!#{score}"

  bonus: ->
    score = Number $('#score').text()
    score = score + (@define.num/2 + 1)
    console.log  "bonus=#{score}"

  resetopacity: ->
    for i in [0...@define.x_axis]
      for j in [0...@define.y_axis]
        $("##{j}_#{i}").css 'opacity':'1'

  opacity: ->
    console.log "opacity"
    self = @
    $('.block').hover (->
      check = Number $(@).html()
      y = Number $(@).attr('data-y')
      x = Number $(@).attr('data-x')
      cparray = $.extend true, [], app.define.cparray
      app.search y, x, check, cparray, self.define.opacity
      return if self.define.opacity is 0
      for i in app.define.opacity
        $("##{[i.y]}_#{[i.x]}").css 'opacity':'0.2'
    ), ->
      for i in app.define.opacity
        $("##{[i.y]}_#{[i.x]}").css 'opacity':'1'
      app.define.opacity = []

  score: (deletelength)->
    return if deletelength <= 1
    score = Number $('#score').text()
    score = score + ((deletelength * 10) *  (deletelength/10+1))
    score = Math.round score
    $('#score').text "#{score}"

  scorereset: ->
    $('#score').text("0")

  record: ->
    @define.round++
    score = Number $('#score').text()
    return if score is 0
    $('div.record').append """<p>#{@define.round}回目のスコア：<span class="record">#{score}</span>"""

  highscorecheck: ->
    score = Number $('#score').text()
    highscore = Number $('#highscore').text()
    highscore = score if score >= highscore
    $('#highscore').text("#{highscore}")

$ ->
  $('.block').element
  console.log "mainstart"
  app.initialize()

  $('.reset').bind 'click', ->
    $('#stage > *').remove()
    app.highscorecheck()
    app.record()
    app.initialize()
    app.scorereset()
