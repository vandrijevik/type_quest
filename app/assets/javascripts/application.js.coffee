#
# This is *hackathon quality* code, written in a rush!
#
#= require jquery
#= require_tree .

$(document).ready () ->
  already_started = false
  get_started = (evt) ->
    return if already_started

    already_started = true
    evt?.preventDefault()
    evt?.stopPropagation()

    $iframe = $('iframe')
    $iframe.attr('src', $iframe.data('src'))

    $('#introduction').fadeOut(1500)

    play_audio('playing')

  $input = $('.grab-focus').focus()
  $(document).one 'keydown', get_started
  $(document).one 'click', get_started

Pusher.log = (message) ->
  window.console?.log?(message)
    
pusher = new Pusher('28cca3773da9545f97e6', encrypted: true)

channel = pusher.subscribe(currentUser)
channel.bind 'change_page', (data) ->
  return console.warn 'No URL?', data unless data.new_url?

  $old_iframe = $('iframe')
  $new_iframe = $old_iframe.clone().attr('src', data.new_url).css('left', '100%').appendTo('#content')
  
  $loader = $('.center-loader')
  $loader.fadeIn()

  $new_iframe.one('load', () ->
    $new_iframe.animate({'left': '0%' })
    $old_iframe.animate({ 'left': '-100%' }, () ->
      $old_iframe.remove()
      $loader.fadeOut()
    )
    $new_iframe[0].contentWindow.focus()
  )

channel.bind 'death', (data) ->
  $death_screen = $('#died')

  $death_screen.fadeIn()
  $death_screen.find('a').focus()

  play_audio('lose')

channel.bind 'win', (data) ->
  $death_screen = $('#win')

  $death_screen.fadeIn()
  $death_screen.find('a').focus()

  play_audio('win')

set_volume = (volume) ->
  $audio = $("#music");  
  $audio[0].volume = volume;

play_audio = (name, play_always = false) ->
  $audio = $("#music");
  $audio.find('source').attr("src", musicURLs[name]);

  return if $audio[0].paused and !play_always

  $audio[0].pause()
  $audio[0].load()
  $audio[0].play()
  $audio[0].oncanplaythrough = $audio[0].play();

set_volume(0.05)
play_audio('prelude', true)
set_volume(0.05)

# rogue - {"id":"DtTuBgq35K","type":"choice","url":"http://zam.zamimg.com/images/8/8/886863c510435e4f9e4c22d995975744.png","filename":"choice-RzupgpS2PziVarqE6Ew2ekYviRLVNSUb-default","height":230,"width":230}
# warrior - {"id":"3RLTrYt9iX","type":"choice","url":"http://zam.zamimg.com/images/c/f/cf8bfbed7b54de4882248840e6d33c25.png","filename":"choice-T7ny2bmHHK4XyEEdL9KPNNpbE8GVcmn3-default","height":230,"width":230}
# mage - {"id":"SDfqpjQ4eE","type":"choice","url":"http://zam.zamimg.com/images/a/7/a7e220d1944bbc0394685b6c4bc08d9d.png","filename":"choice-h8V5K8dLpxsid5v7syVHDwPxtksxjsxw-default","height":230,"width":230}