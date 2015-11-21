// Generated by CoffeeScript 1.9.3
(function() {
  window.app = {
    define: {
      x_axis: 10,
      y_axis: 10,
      num: 4,
      first: [this.y_axis],
      delarray: [],
      cparray: []
    },
    initialize: function() {
      var innum, k, l, ref, ref1, results, x, y;
      console.log("initstart");
      app.define.cparray = [];
      app.define.first = [];
      app.define.delarray = [];
      console.log(app.define.cparray);
      console.log(app.define.first);
      console.log(app.define.delarray);
      results = [];
      for (y = k = 0, ref = app.define.y_axis; 0 <= ref ? k < ref : k > ref; y = 0 <= ref ? ++k : --k) {
        app.define.first[y] = new Array(app.define.x_axis);
        for (x = l = 0, ref1 = app.define.x_axis; 0 <= ref1 ? l < ref1 : l > ref1; x = 0 <= ref1 ? ++l : --l) {
          innum = _.random(1, app.define.num);
          app.define.first[y][x] = innum;
          $('#stage').append("<button id=\"" + y + "_" + x + "\" class=\"block\" data-y=\"" + y + "\" data-x=\"" + x + "\" data-num=\"" + innum + "\">" + app.define.first[y][x] + "</button>");
          $('.block').css({
            'width': '50px',
            'margin': '5px',
            'float': 'left'
          });
        }
        $('#stage').append("<br><br>");
        results.push(app.define.cparray = $.extend(true, [], app.define.first));
      }
      return results;
    },
    addcolor: function() {
      var k, ref, results, x, y;
      console.log("addcolorstart");
      results = [];
      for (y = k = 0, ref = app.define.y_axis; 0 <= ref ? k < ref : k > ref; y = 0 <= ref ? ++k : --k) {
        results.push((function() {
          var l, ref1, results1;
          results1 = [];
          for (x = l = 0, ref1 = app.define.x_axis; 0 <= ref1 ? l < ref1 : l > ref1; x = 0 <= ref1 ? ++l : --l) {
            switch ($("#" + y + "_" + x).html()) {
              case '0':
                results1.push($("#" + y + "_" + x).css({
                  'background-color': "#000"
                }));
                break;
              case '1':
                results1.push($("#" + y + "_" + x).css({
                  'background-color': '#0ff'
                }));
                break;
              case '2':
                results1.push($("#" + y + "_" + x).css({
                  'background-color': '#ff0'
                }));
                break;
              case '3':
                results1.push($("#" + y + "_" + x).css({
                  'background-color': '#f0f'
                }));
                break;
              case '4':
                results1.push($("#" + y + "_" + x).css({
                  'background-color': '#f00'
                }));
                break;
              case '5':
                results1.push($("#" + y + "_" + x).css({
                  'background-color': '#0f0'
                }));
                break;
              default:
                results1.push($("#" + y + "_" + x).css({
                  'background-color': '#fff'
                }));
            }
          }
          return results1;
        })());
      }
      return results;
    },
    "do": function() {
      var cpx, cpy, del, fincheck, fixy, i, j, k, l, len, len1, m, n, o, ref, ref1, ref2, search, x, xpos, y, ypos;
      console.log("dostart");
      app.initialize();
      app.addcolor();
      $('.block').bind('click', function() {
        var check, cparray, delarray, x, y;
        delarray = app.define.delarray;
        cparray = app.define.cparray;
        console.log(cparray);
        x = parseInt($(this).attr('data-x'));
        y = parseInt($(this).attr('data-y'));
        check = parseInt($(this).text());
        search(y, x, check, cparray);
        if (delarray.length === 1) {
          cparray[y][x] = check;
          $("#" + y + "_" + x).text("" + check);
        }
        del(delarray, cparray);
        app.addcolor();
        fincheck(cparray);
        return app.define.delarray = [];
      });
      search = function(y, x, check, cparray) {
        if (y < 0 || y >= app.define.y_axis || x < 0 || x >= app.define.x_axis) {
          if (cparray[y][x] !== check) {
            return;
          }
          if (cparray[y][x] === 0) {
            return;
          }
          cparray[y][x] = 0;
          app.define.delarray.push({
            x: x,
            y: y
          });
          search(y - 1, x, check, cparray);
          search(y + 1, x, check, cparray);
          search(y, x - 1, check, cparray);
          search(y, x + 1, check, cparray);
        }
      };
      del = function(delarray, cparray) {
        if (delarray.length === 0) {

        }
      };
      for (x = k = 0, ref = app.define.x_axis; 0 <= ref ? k < ref : k > ref; x = 0 <= ref ? ++k : --k) {
        for (y = l = 0, ref1 = app.define.y_axis; 0 <= ref1 ? l < ref1 : l > ref1; y = 0 <= ref1 ? ++l : --l) {
          if (cparray[y][x] === 0) {
            ypos = y - 1;
            while (ypos >= 0) {
              if (cparray[ypos][x] !== 0) {
                cparray[ypos + 1][x] = cparray[ypos][x];
                cparray[ypos][x] = 0;
                ypos--;
              }
            }
          }
        }
      }
      fixy = app.define.y_axis - 1;
      j = 0;
      while (j < 10) {
        for (x = m = 0, ref2 = app.define.x_axis - 1; 0 <= ref2 ? m < ref2 : m > ref2; x = 0 <= ref2 ? ++m : --m) {
          if (cparray[fixy][x] === 0) {
            xpos = x + 1;
            ypos = app.define.y_axis - 1;
            while (ypos >= 0) {
              cparray[ypos][x] = cparray[ypos][xpos];
              cparray[ypos][xpos] = 0;
              ypos--;
            }
            j++;
          }
        }
      }
      for (i = n = 0, len = cparray.length; n < len; i = ++n) {
        cpx = cparray[i];
        for (j = o = 0, len1 = cpx.length; o < len1; j = ++o) {
          cpy = cpx[j];
          $("#" + i + "_" + j).text("" + cpy);
        }
      }
      return fincheck = function(cparray) {
        var check, p, q, ref3, ref4;
        console.log(cparray);
        for (x = p = 0, ref3 = app.define.x_axis; 0 <= ref3 ? p < ref3 : p > ref3; x = 0 <= ref3 ? ++p : --p) {
          for (y = q = 0, ref4 = app.define.y_axis; 0 <= ref4 ? q < ref4 : q > ref4; y = 0 <= ref4 ? ++q : --q) {
            check = cparray[x][y];
            if (cparray[x][y] === 0) {
              continue;
            }
            if (x + 1 < app.define.x_axis) {
              if (cparray[x + 1][y] === check) {
                return;
              }
            }
            if (x - 1 >= 0) {
              if (cparray[x - 1][y] === check) {
                return;
              }
            }
            if (y + 1 < app.define.y_axis) {
              if (cparray[x][y + 1] === check) {
                return;
              }
            }
            if (y - 1 >= 0) {
              if (cparray[x][y - 1] === check) {
                return;
              }
            }
          }
          if (cparray[app.define.y_axis - 1][0] === 0) {
            alert("clear");
          } else {
            alert("failure");
          }
        }
      };
    }
  };

  $(function() {
    app["do"]();
    return $('.reset').bind('click', function() {
      $('#stage > *').remove();
      return app["do"]();
    });
  });

}).call(this);