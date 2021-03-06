# Controller.rb
# ChrUpd
#
# Created by Julien Blanchard on 04/12/09.
# Copyright 2009 MIKROS IMAGE. All rights reserved.

require 'net/http'

class Controller
	attr_writer :text_view
	attr_accessor :progress
	attr_writer :run_b
	attr_writer :window
	
	def awakeFromNib()
		@text_view.insertText("Click the Update button to update Chromium.\n")
		@build_url = "build.chromium.org"
		
		# who am I ? :)
		@whoami = %x(whoami).gsub(/\n/,'')
		
		# Get latest release number
		Net::HTTP.start(@build_url) { |http|
			@latest = http.get("/buildbot/snapshots/chromium-rel-mac/LATEST")
		}
	end
	
	def updateChromium(sender)
		@progress.startAnimation(nil)
		
		# Download latest chromium
		system("curl http://#{@build_url}/buildbot/snapshots/chromium-rel-mac/#{@latest.body}/chrome-mac.zip -o /Users/#{@whoami}/chrome-mac.zip")
		@text_view.insertText("\nSuccesfully updated Chromium to revision #{@latest.body}, you can run it by clicking Run Chromium.\n")
		
		# Unzip and copy and remove temp files
		system("cd /Users/#{@whoami} && unzip -qq chrome-mac.zip && cd chrome-mac && cp -fR Chromium.app /Applications && cd .. && rm -rf chrome*")
		
		@progress.stopAnimation(nil)
		@run_b.setTitle('Restart Chromium')
	end
	
	def runChromium(sender)
		system("open /Applications/Chromium.app")
		exit()
	end
	
end

#Controller.new.delegate = self
#Controller.run

