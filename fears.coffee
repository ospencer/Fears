if Meteor.isClient
  $ ->
    circles = $('.animated')
    circleActive = false
    resetting = false
    old = {}
    transformsMatricies = []
    ttransform = ''

    $('.animated').on('click', ->
      unless resetting
        $t = $(this)
        if circleActive is true

          $t.attr('active', 'false')
          $t.removeClass('active')
          $t.css('transform', ttransform)
          resetting = true
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
                  resetting = false
                  setTimeout(
                    ->
                      $t.addClass('clicked')
                    1*1000
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

          $t.attr('style', '')
          old.matrix = $t.css('-webkit-transform')
          circleActive = true
          $t.removeClass('clicked')
          $t.attr('active', 'true')
          setTimeout(
            ->
              $t.addClass('active')
            500
          )
    )

    $('#about').click(->
      $t = $(this)
      if $t.attr('active') is 'true'
        $t.attr('active', 'false')
        $t.removeClass('active')
      else
        $t.attr('active', 'true')
        setTimeout(
          ->
            $t.addClass('active')
          500
        )
    )

    circles = $('.animated')
    distance = 240
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
