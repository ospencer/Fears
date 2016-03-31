if Meteor.isClient
  $ ->
    circles = $('.circle')
    circleActive = false
    old = {}
    transformsMatricies = []
    ttransform = ''

    $('.circle').on('click', ->
      $t = $(this)
      if circleActive is true

        $t.attr('active', 'false')
        $t.removeClass('active')
        $t.css('transform', ttransform)
        for circle, i in circles
          $.keyframe.define([{
            name: "reset#{i}"
            to:
              'transform': "matrix(1, 0, 0, 1, 0, 0)"
            from:
              'transform': transformsMatricies[i]
          }])
          $(circle).playKeyframe(
            name: "reset#{i}"
            duration: '1s'
            iterationCount: 1
            timingFunction: 'linear'
          )
          setTimeout(
            ->
              for circle, k in circles
                $(circle).playKeyframe(
                  name: "assumePosition#{k}"
                  duration: '1s'
                  iterationCount: 1
                  timingFunction: 'ease'
                )
            1*1000
          )
        circleActive = false
      else
        transformsMatricies = []
        ttransform = $t.css('transform')
        values = ttransform.match(/-?[\d\.]+/g)
        for circle, i in circles
          $c = $(circle)
          transformsMatricies.push $c.css('transform')
          transform = $c.css('transform')
          $c.resetKeyframe()
          $c.css('transform', transform)

        # $t.attr('style', "transform: translate(#{-values[4]}, #{-values[5]}), transition: transform 0.5s")
        $t.attr('style', '')
          # $(circle).css('-webkit-transform', 'matrix(1, 0, 0, 1, 0, 0)')
        # $new = $t.clone()
        # $new.attr('style', "top: #{$t.css('top')}; left: #{$t.css('left')}")
        # old.style = $t.attr('style')
        # old.top = $t.css('top')
        # old.left = $t.css('left')
        old.matrix = $t.css('-webkit-transform')
        # $t.attr('style', "top: #{old.top}; left: #{old.left}")
        circleActive = true
        # $('body').append($new)
        # $t.css('-webkit-transform', 'matrix(1, 0, 0, 1, 500, 500)')
        # $t.attr('style', $t.css('-webkit-transform'))
        $t.attr('active', 'true')
        setTimeout(
          ->
            $t.addClass('active')
          500
        )
    )
    # .hover(
    #   ->
    #     unless circleActive
    #       for circle, i in circles
    #         $(circle).pauseKeyframe()
    #   ->
    #     unless circleActive
    #       for circle, i in circles
    #         $(circle).resumeKeyframe()
    # )

    circles = $('.circle')
    distance = 200
    for circle, i in circles
      $.keyframe.define([{
        name: "rotate#{i}"
        from:
          'transform': "rotate(#{(360/circles.length * i)}deg)
                                translate(#{distance}px)
                                rotate(#{-(360/circles.length * i)}deg)"
        to:
          'transform': "rotate(#{(360/circles.length * i + 360)}deg)
                                translate(#{distance}px)
                                rotate(#{-(360/circles.length * i + 360)}deg)"
      }])
      $.keyframe.define([{
        name: "assumePosition#{i}"
        from:
          'transform': "matrix(1, 0, 0, 1, 0, 0)"
        to:
          'transform': "rotate(#{(360/circles.length * i + 360)}deg)
                                translate(#{distance}px)
                                rotate(#{-(360/circles.length * i + 360)}deg)"
      }])
      $(circle).playKeyframe(
        name: "assumePosition#{i}"
        duration: '2s'
        iterationCount: 1
        timingFunction: 'ease'
        complete: ->
          for circle, j in circles
            $(circle).playKeyframe(
              name: "rotate#{j}"
              duration: '120s'
              iterationCount: 'infinite'
              timingFunction: 'linear'
            )
      )

if Meteor.isServer
  Meteor.startup(->
    # code to run on server at startup
  )
