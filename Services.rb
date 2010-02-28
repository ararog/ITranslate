#
#  Services.rb
#  ITranslate
#
#  Created by ROGERIO ARAUJO on 07/09/09.
#  Copyright (c) 2009 BMobile. All rights reserved.
#

require 'rubygems'
require 'json'

require 'osx/cocoa'
require 'open-uri'
require 'erb'
include ERB::Util
  
class Services < OSX::NSObject
	include OSX

	def translate(pboard, sourceLang, targetLang)
		types = pboard.types()             
		pboardString = nil
		if types.include?(NSStringPboardType) then
			pboardString = pboard.stringForType(NSStringPboardType)
			
			if pboardString == nil
				NSAlert::alertWithMessageText_defaultButton_alternateButton_otherButton_informativeTextWithFormat_(
					"Warning!", "Ok", nil, nil, "Please select a text!").runModal()
				return	
			end
			
			pboardString = url_encode(pboardString)
			url = 'http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=' + pboardString + '&langpair=' + sourceLang + '%7C' + targetLang
			begin
				buffer = open(url, "Referer" => "faces.eti.br").read
				result = JSON.parse(buffer)
			rescue
				NSAlert::alertWithMessageText_defaultButton_alternateButton_otherButton_informativeTextWithFormat_(
					"Warning!", "Ok", nil, nil, "Error while calling google translator!").runModal()
				return	
			end						
			
			if result and result['responseStatus'] == 200		
				pboard.declareTypes_owner([NSStringPboardType], nil)		
				retorno = pboard.setString_forType_(result['responseData']['translatedText'], NSStringPboardType)
				if ! retorno
					puts "Error while replacing PasteBoard data!"
				end
			end		
		end
		return 
	end
	
	def portugueseToEnglish_userData_error(pboard, data, error)
		translate(pboard, "pt", "en")
	end
	objc_method :portugueseToEnglish_userData_error, 'v@:@**'

	def englishToPortuguese_userData_error(pboard, data, error)
		translate(pboard, "en", "pt")
	end
	objc_method :englishToPortuguese_userData_error, 'v@:@**'

	def englishToSpanish_userData_error(pboard, data, error)
		translate(pboard, "en", "es")
	end
	objc_method :englishToSpanish_userData_error, 'v@:@**'
end
