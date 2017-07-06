//
//  Action.js
//  Playback Action
//
//  Created by Christopher Truman on 6/29/17.
//  Copyright © 2017 Christopher Truman. All rights reserved.
//

var Action = function() {};

Action.prototype = {
    
    run: function(arguments) {
        var video = document.getElementsByTagName('video')[0];
        arguments.completionFunction({"speed": video.playbackRate, "baseURI": document.baseURI})
    },
    
    finalize: function(arguments) {
        var speed = arguments["speed"]
        var video = document.getElementsByTagName('video')[0];
        video.playbackRate = speed;
    }
    
};
    
var ExtensionPreprocessingJS = new Action
