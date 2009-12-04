# Controller.rb
# ChrUpd
#
# Created by Julien Blanchard on 04/12/09.
# Copyright 2009 MIKROS IMAGE. All rights reserved.

require 'net/http'
require 'fileutils'

class Controller
	attr_writer :text_view
	attr_accessor :progress
	
	def awakeFromNib()
		@text_view.insertText("Click the Update button to update Chromium.\n")
		#@progress = NSProgressIndicator.new
		@build_url = "build.chromium.org"
		@whoami = %x(whoami).gsub(/\n/,'')
		
		Net::HTTP.start(@build_url) { |http|
			@latest = http.get("/buildbot/snapshots/chromium-rel-mac/LATEST")
  	}
	end
	
	def updateChromium(sender)
		@progress.startAnimation(nil)
		
		# Download latest chromium
		system("wget http://#{@build_url}/buildbot/snapshots/chromium-rel-mac/#{@latest.body}/chrome-mac.zip -O /Users/#{@whoami}/chrome-mac.zip")
		@text_view.insertText("\nSuccesfully updated Chromium to revision #{@latest.body}, you can run it by clicking Run Chromium.\n")
		
		# Unzip and copy and remove temp files
		system("cd /Users/#{@whoami} && unzip -qq chrome-mac.zip && cd chrome-mac && cp -fR Chromium.app /Applications && cd .. && rm -rf chrome*")
		
		@progress.stopAnimation(nil)
	end
	
	def runChromium(sender)
		system("open /Applications/Chromium.app")
		exit()
	end
	
end


