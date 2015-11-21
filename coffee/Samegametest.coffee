window.app =
  define:
    x_axis : 10
    y_axis : 10
    num : 4
    first : [@y_axis]
    delarray : []
    cparray : []

  initialize: ->
#画面の生成
    console.log "initstart"
    app.define.cparray = []
    app.define.first = []
    app.define.delarray = []
    console.log app.define.cparray
    console.log app.define.first
    console.log app.define.delarray

    for y in [0...app.define.y_axis]
      app.define.first[y] = new Array app.define.x_axis
      for x in [0...app.define.x_axis]
        innum  = _.random 1, app.define.num
        app.define.first[y][x] = innum
        $('#stage').append("""<button id="#{y}_#{x}" class="block" data-y="#{y}" data-x="#{x}" data-num="#{innum}">#{app.define.first[y][x]}</button>""")
        $('.block').css 'width':'50px', 'margin':'5px', 'float':'left'
      $('#stage').append("<br><br>")
      app.define.cparray = $.extend(true, [], app.define.first)

#数字の色付け
  addcolor: ->
    console.log "addcolorstart"
    for y in [0...app.define.y_axis]
      for x in [0...app.define.x_axis]
        switch $("##{y}_#{x}").html()
          when '0' then $("##{y}_#{x}").css 'background-color':"#000"
          when '1' then $("##{y}_#{x}").css 'background-color':'#0ff'
          when '2' then $("##{y}_#{x}").css 'background-color':'#ff0'
          when '3' then $("##{y}_#{x}").css 'background-color':'#f0f'
          when '4' then $("##{y}_#{x}").css 'background-color':'#f00'
          when '5' then $("##{y}_#{x}").css 'background-color':'#0f0'
          else $("##{y}_#{x}").css 'background-color':'#fff'

  do: ->
    console.log "dostart"
    app.initialize()
    app.addcolor()
    #ボタンが押されたら
    $('.block').bind 'click', ->
      delarray = app.define.delarray
      cparray = app.define.cparray
      console.log cparray
      x = parseInt($(@).attr 'data-x')
      y = parseInt($(@).attr 'data-y')
      check = parseInt($(@).text())
      search(y,x,check,cparray)
      if delarray.length is 1
        cparray[y][x] = check
        $("##{y}_#{x}").text("#{check}")
      del(delarray,cparray)
      app.addcolor()
      fincheck(cparray)
      app.define.delarray = []
    #隣接する数字の探索
    search = (y,x,check,cparray) ->
      return if y < 0 or y >= app.define.y_axis or x < 0 or x >= app.define.x_axis
        return if cparray[y][x] isnt check
        return if cparray[y][x] is 0
        cparray[y][x] = 0
        app.define.delarray.push x: x, y: y
        search(y-1,x,check,cparray)
        search(y+1,x,check,cparray)
        search(y,x-1,check,cparray)
        search(y,x+1,check,cparray)
        return
    #削除メソッド
    del = (delarray,cparray) ->
      if delarray.length is 0
        return
    #縦に詰める
    for x in [0...app.define.x_axis]
      for y in [0...app.define.y_axis]
        if cparray[y][x] is 0
          ypos = y - 1
          while ypos >= 0
            if cparray[ypos][x] != 0
              cparray[ypos+1][x] = cparray[ypos][x]
              cparray[ypos][x] = 0
              ypos--
    #横に詰める
    fixy = app.define.y_axis-1
    j = 0
    while j < 10
      for x in [0...app.define.x_axis-1]
        if cparray[fixy][x] is 0
          xpos = x + 1
          ypos = app.define.y_axis - 1
          while ypos >= 0
            cparray[ypos][x] = cparray[ypos][xpos]
            cparray[ypos][xpos] = 0
            ypos--
          j++
    # htmlに反映
    for cpx,i  in cparray
      for cpy,j in cpx
        $("##{i}_#{j}").text("#{cpy}")
    # 終了判定
    fincheck = (cparray) ->
      console.log cparray
      for x in [0...app.define.x_axis]
        for y in [0...app.define.y_axis]
          check = cparray[x][y]
          continue if cparray[x][y] is 0
          if x+1 < app.define.x_axis
            return if cparray[x+1][y] is check
          if x-1 >=0
            return if cparray[x-1][y] is check
          if y+1 < app.define.y_axis
            return if cparray[x][y+1] is check
          if y-1 >= 0
            return if cparray[x][y-1] is check
        if cparray[app.define.y_axis-1][0] is 0
          alert "clear"
        else
          alert "failure"
$ ->
  app.do()

  $('.reset').bind 'click', ->
    $('#stage > *').remove()
    app.do()
